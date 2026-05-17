# Proposal Generation Checklist

Run `/governance-propose` when the user says "propose 新功能", "创建提案", or similar.

## Phase 1: Parse and Prepare

- [ ] Extract the change name from user's request
- [ ] Sanitize to kebab-case (spaces/special chars removed, Chinese converted)
- [ ] Confirm the artifact directory does not already exist
- [ ] Choose milestone count (3 for small, 4-5 for medium/large changes)

## Phase 2: Create Artifact Directory

- [ ] Create `governance/artifacts/<change-name>/`
- [ ] Create `governance/artifacts/<change-name>/specs/`

## Phase 3: Generate proposal.md

Include:
- [ ] **背景**：为什么现在要做这件事
- [ ] **动机**：不做会怎样，现状的痛苦点
- [ ] **目标**：用一行话说清楚"做成什么样"
- [ ] **范围**：这次包含什么，不包含什么

## Phase 4: Generate specs/index.md

- [ ] Feature table with P0 / P1 / P2 column
  - P0: 必须有，没它整个事情不成立
  - P1: 重要 but 可以后续补
  - P2: 最好有 but 可以砍
- [ ] Each P0 item has concrete acceptance criteria
- [ ] Links to related existing modules in current project

## Phase 5: Generate specs/scenarios.md

- [ ] 3-5 user stories in format:
  > **作为** [角色]，**我想要** [功能]，**以便** [价值]
- [ ] Happy path + at least one edge/failure case per story
- [ ] Note environment constraints (mobile, offline, etc.)

## Phase 6: Generate design.md

- [ ] **技术方案**：使用的语言、框架、库
- [ ] **模块边界**：列出每个 affected module 及职责
- [ ] **数据流**：新增/修改的数据流动方向
- [ ] **API 契约**：如有新增接口，说明请求/响应结构
- [ ] **共享影响**：是否影响 shared definitions、configs、registries

## Phase 7: Generate tasks.md

- [ ] 3-5 milestones, each named and emoji-tagged (🔄/✅/⬜)
- [ ] Each milestone has 2-4 concrete tasks
- [ ] First in-progress milestone is marked 🔄
- [ ] Tasks are ordered: done items first, next action first in pending
- [ ] Last milestone always includes: Pre-PR check, PR creation, merge (if authorized)

## Phase 8: Verify and Report

- [ ] Confirm all 5 files exist in the artifact folder
- [ ] Verify no garbled text in Chinese content
- [ ] Output completion block with artifact path

## Output Format

```
Action: /governance-propose
Status: pass
Next: 建议进入 /governance-help 开始执行，或 /task-intake 进入开发阶段
Artifacts: governance/artifacts/<change-name>/
```