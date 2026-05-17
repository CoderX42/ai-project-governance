---
name: apg-task-intake
description: >-
  开始新任务前的分析动作。读取根文档，理解需求，输出影响范围和分阶段开发清单。
  使用场景：用户提到 "start new task"、"analyze this feature"、"what should I do next"、
  "帮我分析这个功能"、"开始开发"。
  注意：如果用户只要求分析（"先分析"、"只分析"），输出分析后不进入开发阶段。
disable-model-invocation: false
---

# /apg-task-intake

Run before any new development or analysis task.

## 动作定义

### Step 1: 读取根文档

必须读取（如果缺失则警告并 fallback 到 /apg-init）：

1. `CLAUDE.md`
2. `docs/AI开发与PR流程.md`
3. `docs/项目开发规范.md`
4. `docs/项目完整链路说明.md`
5. `docs/项目文件结构说明.md`
6. `docs/项目需求分析.md`（如果存在且任务涉及新功能）

### Step 2: 判断任务类型

- **Analysis only**：用户用了 "analyze"、"review"、"explain"、"what is"、"how does" 等词
  → 只输出分析，不得修改代码或创建提交
- **Implementation**：用户用了 "implement"、"develop"、"fix"、"add"、"create"、"build" 等词
  → 继续 Step 3 输出开发清单

### Step 3: 需求理解

如果 `docs/项目需求分析.md` 存在，基于其 P0 功能定义理解真实目标。

输出：
- **真实目标**：一句话描述要解决什么问题
- **影响范围**：按层（共享定义/后端/前端/测试/文档）列出可能改动的文件

### Step 4: 分阶段开发清单

每个阶段包含：
- 阶段名称和目标
- 负责的文件列表
- 阶段完成后的自检项（参考 `../checklists/intake.md`）

### Step 5: 等待确认

输出开发清单后，等待用户说"确认"再进入开发阶段。

## 输出格式

```
Action: /apg-intake
Status: <complete / analysis-only / blocked / needs-user-input>
Type: <analysis-only / implementation>
Next: <确认后进入开发 / 等待分析指令>
```

## 参考

完整模板：`../checklists/intake.md`