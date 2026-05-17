---
name: apg-requirements-analysis
description: >-
  从原始想法引导填写结构化需求文档。覆盖想法概述、背景动机、用户场景、
  P0/P1/P2 功能优先级、非功能性需求、边界排除、成功标准、开放风险。
  使用场景：用户提到 "new idea"、"new feature"、"我有一个想法"、"需求分析"、
  "帮我梳理需求"、"帮我想想"。
disable-model-invocation: false
---

# /apg-requirements-analysis

Run when the user has a new idea, wants to clarify a new feature, or says "我有一个想法".

## 动作定义

### Step 1: 检测上下文

1. 判断是新项目还是已有项目新增功能
2. 如果是已有项目：先读取 5 份根文档了解架构
3. 检查 `docs/项目需求分析.md` 是否存在：
   - 存在：读取，识别哪些章节未完成或含 TODO
   - 不存在：从模板创建，从第一节开始

### Step 2: 逐节引导

按顺序引导用户填写以下章节（参考 `../checklists/requirements.md`）：

1. **想法概述**：让用户自由描述，AI 提炼核心
2. **背景与动机**：追问"为什么现在做"和"不做会怎样"
3. **目标用户与场景**：谁用、在什么场景、核心体验
4. **功能需求**：引导 P0/P1/P2 优先级划分，为每个 P0 定义验收条件
5. **非功能性需求**：性能、安全、兼容性、国际化等
6. **边界与排除**：明确本次不做什么
7. **成功标准**：功能验收条件 + 质量验收条件
8. **开放问题与风险**：列出不确定项和已知风险
9. **相关资源**：原型、设计稿、竞品分析等

### Step 3: 交叉检查（仅已有项目）

如果是为已有项目新增功能，与现有文档交叉检查：
- 与 `项目完整链路说明.md` 比对：是否有流程冲突
- 与 `项目文件结构说明.md` 比对：是否有结构冲突
- 发现冲突时记录在第 8 节（开放问题与风险）

### Step 4: 保存与推荐

保存 `docs/项目需求分析.md`，然后：
- 如果 P0 清晰且无阻塞问题：推荐"进入 /apg-intake，从 P0 开始实现"
- 如果仍有开放问题：列出作为 blocks，先解决再继续

## 输出格式

```
Action: /apg-req
Status: <complete / blocked / needs-user-input>
Next: <next step or recommendation>
Blocks: <list of open questions preventing implementation>
```

## 参考

完整步骤清单：`../checklists/requirements.md`