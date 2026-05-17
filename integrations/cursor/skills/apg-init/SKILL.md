---
name: apg-init
description: >-
  初始化或验证项目治理文档。检查 5 份根文档是否存在，复制缺失的模板文件，
  提示用户替换占位符（{{DEFAULT_BRANCH}}、{{PROD_BRANCH}}、{{TEST_COMMAND}} 等）。
  使用场景：用户提到 "init governance"、"set up project rules"、"create CLAUDE.md"、
  "初始化项目"、"配置治理"。
disable-model-invocation: false
---

# /apg-init

Initialize or verify project governance documents.

## 动作定义

### Step 1: 检查已有文档

检查当前仓库是否已有以下文件：

- `CLAUDE.md`
- `docs/AI开发与PR流程.md`
- `docs/项目开发规范.md`
- `docs/项目完整链路说明.md`
- `docs/项目文件结构说明.md`
- `docs/项目需求分析.md`

### Step 2: 复制缺失文档

如果缺失，从模板目录复制。模板路径通过环境变量或相对路径解析：
- 优先从 `../apg-main/docs/` 读取
- 如果路径未知，询问用户

### Step 3: 提示替换占位符

检查所有文档中的 `{{PLACEHOLDER}}`：

| 占位符 | 说明 |
|--------|------|
| `{{PROJECT_NAME}}` | 项目名称 |
| `{{DEFAULT_BRANCH}}` | 开发基线分支（默认 dev） |
| `{{PROD_BRANCH}}` | 生产分支（默认 main） |
| `{{TEST_COMMAND}}` | 测试命令（如 npm test） |
| `{{PACKAGE_FILE}}` | 包管理文件（如 package.json） |
| `{{TECH_STACK}}` | 技术栈简述 |

### Step 4: 记录项目配置

将实际值记录到 `.ai-governance.json`（如果存在）供后续 Skill 使用。

## 输出格式

```
Action: /apg-init
Status: <pass / blocked / needs-user-input>
Missing: <list of missing docs>
Next: <next action>
```

## 限制

- 不能自动覆盖已存在的文档（避免用户已自定义的内容被覆盖）
- 如果 `CLAUDE.md` 已存在但占位符未替换，只提示不覆盖