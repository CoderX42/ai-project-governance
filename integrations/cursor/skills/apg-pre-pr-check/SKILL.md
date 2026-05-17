---
name: apg-pre-pr-check
description: >-
  PR 前全面检查。验证 git 卫生、文档同步、diff 质量、测试结果，
  并生成 PR 标题和正文草稿。
  使用场景：用户提到 "ready to PR"、"prepare PR"、"check before PR"、
  "可以提 PR 了"、"帮我检查一下再提交"。
disable-model-invocation: false
---

# /apg-pre-pr-check

Run before the user says "create PR" or "push and open PR".

## 动作定义

### Step 1: Git 卫生检查

执行并检查以下命令：

```bash
git status --short
git diff --check
```

确认：
- `git status --short` 只显示本次任务相关文件
- `git diff --check` 无空白错误
- 无冲突标记（`<<<<<<<`, `=======`, `>>>>>>>`）
- 无临时调试代码、无关格式化或构建产物
- 提交信息用中文描述真实改动（不是 "update"/"fix"/"AI 修改"）
- 当前分支不是 `dev`/`develop` 和不是 `master`/`main`

### Step 2: 文档同步检查

如果文件有新增/删除/重命名：
- 确认 `docs/项目文件结构说明.md` 已更新

如果功能链路有变化：
- 确认 `docs/项目完整链路说明.md` 已更新

如果架构边界有变化：
- 确认 `docs/项目开发规范.md` 已更新

### Step 3: Diff 审查

执行 `git diff origin/dev...HEAD`（或等效的默认分支）。

确认：
- 每行改动都是有意的
- 无泄漏 secrets、credentials 或本地路径
- 修改的中文文件无乱码

### Step 4: 测试与静态检查

执行项目的测试命令（`{{TEST_COMMAND}}`），如果失败则修复后再继续，除非用户明确放弃。

### Step 5: 生成 PR 草稿

基于实际 diff 生成：

**标题**：直接描述结果，不是 Git 动作描述

**正文**：
```markdown
## 本次改动
- ...

## 风险与影响
- ...

## 测试情况
- 未运行测试，请开发者自行验证
```

## 输出格式

```
Action: /apg-prepr
Status: <pass / blocked / needs-user-input>
Git Hygiene: <pass / fail>
Doc Sync: <pass / fail>
Diff: <pass / fail>
Test: <pass / fail (not run)>
Next: <create PR / fix issues first>
```

## 参考

完整检查清单：`../checklists/pre-pr.md`