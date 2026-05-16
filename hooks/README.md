# Cursor Hook 设计说明

## Hook 与 Skill 的区别

| | Skill | Hook |
|---|---|---|
| 触发方式 | 用户显式调用（如 `/task-intake`）或 AI 根据上下文自动加载 | 在特定事件发生时自动触发 |
| 作用范围 | 提供流程化指导和知识注入 | 做硬性拦截、自动检查或状态提醒 |
| 灵活性 | 可复用、可跨项目共享 | 通常绑定到单个项目或全局配置 |
| 维护成本 | 低 | 较高（需要配置和维护触发规则） |

**建议**：先用 Skill 建立流程，只有当需要"硬拦截"时才加 Hook。

## 建议配置的关键 Hook 点

### 1. 改代码前：检查是否已读规范文档

目标：防止 AI 在未读 CLAUDE.md 的情况下直接改代码。

实现思路：
- 在 AI 首次响应当前会话时，检查工作区是否存在 `CLAUDE.md`。
- 如果存在且本次会话尚未确认已读，先提示阅读，再进入后续操作。

注意：Cursor 当前不原生支持"首次响应前 Hook"，但可以通过 Skill 的 `disable-model-invocation: false`（自动加载）近似实现。

### 2. 发 PR 前：自动检查分支与 diff

目标：在创建 PR 前自动拦截常见错误。

检查项：
- 当前分支是否为功能分支（不是 `dev`/`master`）。
- `git diff --check` 是否通过。
- 是否有未提交的改动。
- 如果新增/删除了文件，是否同步更新了 `项目文件结构说明.md`。

### 3. 提交前：检查文档联动

目标：防止改了结构却不更新文档。

检查项：
- 如果 `git diff --name-status` 中有新增/删除/重命名，检查 `项目文件结构说明.md` 是否有对应更新。
- 如果修改了核心流程文件，检查 `项目完整链路说明.md` 是否同步。

## 示例 hooks.json 配置片段

以下是一个参考配置，用于说明 Hook 可以做什么。实际安装方式取决于 Cursor 的版本和 Hook 支持状态。

```json
{
  "hooks": [
    {
      "name": "pre-code-check",
      "trigger": "before_first_response",
      "condition": "file_exists('CLAUDE.md')",
      "action": "prompt: 请先阅读 CLAUDE.md 和四份根目录规范文档，确认后再继续。"
    },
    {
      "name": "pre-pr-branch-check",
      "trigger": "before_pr_create",
      "condition": "current_branch in ['dev', 'master', 'main']",
      "action": "block: 当前分支是默认分支，不能直接从默认分支发 PR。请先从最新 dev 切出功能分支。"
    },
    {
      "name": "pre-pr-diff-check",
      "trigger": "before_pr_create",
      "condition": "shell('git diff --check') exit_code != 0",
      "action": "block: git diff --check 未通过，请修复空白错误后再发 PR。"
    },
    {
      "name": "pre-commit-doc-sync",
      "trigger": "before_commit",
      "condition": "git_status_has_renames_and_not(file_changed('项目文件结构说明.md'))",
      "action": "warn: 检测到文件重命名/新增/删除，但 项目文件结构说明.md 未同步更新。"
    }
  ]
}
```

## 安装建议

1. **最小可用**：先不使用 Hook，只依赖 Skill + 文档模板。这套组合已经能覆盖 80% 的治理需求。
2. **逐步增强**：当团队反复出现某类问题时（如总是忘改文件结构说明），再针对该问题加 Hook。
3. **避免过度**：Hook 配置过多会增加维护成本和误拦截概率。每个 Hook 都要有明确的"拦截什么错误"和"放行什么正常情况"。

## 与 Skill 的配合

| 场景 | 推荐方案 |
|---|---|
| 新项目初始化 | `/project-init` Skill |
| 日常开发前 | `/task-intake` Skill |
| 准备发 PR 时 | `/pre-pr-check` Skill |
| 准备合并时 | `/merge-check` Skill |
| 反复出现的特定错误 | 加对应的 Hook |

**核心原则**：文档是规则本体，Skill 是流程入口，Hook 是硬性兜底。优先把规则写清楚，再考虑要不要加自动化拦截。