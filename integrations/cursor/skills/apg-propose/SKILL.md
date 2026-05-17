---
name: apg-propose
description: >-
  创建结构化变更提案。在 governance/artifacts/<change-name>/ 下生成完整提案文件夹，
  包含 proposal.md、specs/、design.md、tasks.md。
  使用场景：用户提到 "propose 新功能"、"创建提案"、"生成规范文件夹"、
  "我想做这个功能，先写个提案"。
disable-model-invocation: false
---

# /apg-propose

Create a structured change proposal with full artifact folder under `governance/artifacts/<change-name>/`.

## 动作定义

### Step 1: 解析变更名称

从用户请求中提取变更名称，转换为 kebab-case（如"添加深色模式" → `add-dark-mode`）。

确认 `governance/artifacts/<change-name>/` 尚不存在。

### Step 2: 创建目录结构

```
governance/artifacts/<change-name>/
├── proposal.md
├── specs/
│   ├── index.md
│   └── scenarios.md
├── design.md
└── tasks.md
```

### Step 3: 生成 proposal.md

包含：
- **背景**：为什么现在要做
- **动机**：不做会怎样，现状的痛苦点
- **目标**：一行话说清楚"做成什么样"
- **范围**：本次包含什么，不包含什么

### Step 4: 生成 specs/index.md

功能表，包含 P0/P1/P2 优先级：
- P0：必须有，没它整个事情不成立
- P1：重要 but 可后续补
- P2：最好有 but 可砍

每个 P0 项有具体验收条件。

### Step 5: 生成 specs/scenarios.md

3-5 个用户故事，格式：
> **作为** [角色]，**我想要** [功能]，**以便** [价值]

每个故事包含正常路径 + 至少一个边界/失败场景。

### Step 6: 生成 design.md

包含：
- **技术方案**：语言、框架、库
- **模块边界**：每个受影响模块及职责
- **数据流**：新增/修改的数据流方向
- **API 契约**：新增接口的请求/响应结构
- **共享影响**：是否影响 shared definitions、configs、registries

### Step 7: 生成 tasks.md

3-5 个里程碑，每个里程碑：
- 有名称和 emoji 标签（🔄 进行中 / ✅ 完成 / ⬜ 未开始）
- 包含 2-4 个具体任务
- 第一个进行中的里程碑标记 🔄
- 最后一个里程碑包含：Pre-PR 检查、PR 创建、合并（如果授权）

示例格式：

```markdown
## Milestone 1: 需求确认 ✅
- [x] Task 1.1: 对齐变更目标

## Milestone 2: 核心实现 🔄
- [x] Task 2.1: 注册 API 端点
- [ ] Task 2.2: 实现业务逻辑 ← **建议下一步**
- [ ] Task 2.3: 单元测试

## Milestone 3: PR 与合并 ⬜
- [ ] Task 3.1: Pre-PR 检查
- [ ] Task 3.2: 创建 PR
```

### Step 8: 验证与报告

确认目录下 5 个文件全部生成，无乱码。

## 输出格式

```
Action: /apg-propose
Status: pass
Artifacts: governance/artifacts/<change-name>/
Next: 建议进入 /apg-help 开始执行，或 /apg-intake 进入开发阶段
```

## 参考

完整检查清单：`../checklists/propose.md`