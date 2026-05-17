---
name: ai-project-governance
description: >-
  Enforce AI development governance across projects by reading root docs,
  validating workflow stages, and checking PR readiness. Use when the user
  asks to initialize project governance, start a new task with proper
  analysis, prepare for PR, review before merge, or mentions project rules,
  development workflow, PR checklist, or governance setup.
disable-model-invocation: true
---

# AI Project Governance

Enforce structured AI development workflows through root documentation,
stage-gated checklists, and pre-flight validation.

## Quick Start

This skill provides four actions. Invoke them by name when the user says
something matching the trigger.

| Action | Trigger |
|--------|---------|
| `/project-init` | "init governance", "set up project rules", "create CLAUDE.md" |
| `/task-intake` | "start new task", "analyze this feature", "what should I do next" |
| `/pre-pr-check` | "ready to PR", "prepare PR", "check before PR" |
| `/merge-check` | "merge now", "can I merge", "ready to merge" |
| `/requirements-analysis` | "new idea", "new feature", "我有一个想法", "需求分析", "帮我梳理需求" |
| `/governance-propose` | "propose 新功能", "创建提案", "生成规范文件夹" |
| `/governance-help` | "下一步是什么", "当前进度", "governance help", "引导我" |

## Action: /project-init

Initialize or verify project governance documents.

1. Check if the current repo already has:
   - `CLAUDE.md`
   - `AI开发与PR流程.md`
   - `项目开发规范.md`
   - `项目完整链路说明.md`
   - `项目文件结构说明.md`
2. If any are missing, copy from the template at
   `ai-governance-template/` (ask the user for the template path if unknown).
3. Prompt the user to replace `TODO` placeholders and variable tokens such as
   `{{DEFAULT_BRANCH}}`, `{{PROD_BRANCH}}`, `{{TEST_COMMAND}}`.
4. Record the project's actual values for later use:
   - default branch
   - production branch
   - test command
   - package manager file

## Action: /task-intake

Run before any new development or analysis task.

1. Read the repo's `CLAUDE.md` first. If it does not exist, warn the user and
   fall back to `/project-init`.
2. Read the other four root docs.
3. Determine task type from the user's wording:
   - **Analysis only**: words like "analyze", "review", "explain", "what is",
     "how does" → output analysis only, do not modify code or create commits.
   - **Implementation**: words like "implement", "develop", "fix", "add",
     "create", "build" → proceed to the development checklist below.
4. For implementation tasks, produce:
   - **Demand understanding**: one-paragraph summary of the real goal.
   - **Impact trace**: which modules, files, and data flows are affected.
   - **Development checklist**: stage-by-stage plan with owner files.
   - **Self-check items**: what to verify after each stage.

Reference the checklists in [checklists/intake.md](checklists/intake.md) for
the full template.

## Action: /pre-pr-check

Run before the user says "create PR" or "push and open PR".

1. Run the checks in [checklists/pre-pr.md](checklists/pre-pr.md).
2. Confirm `git status --short` shows only task-related files.
3. Confirm `git diff --check` has no whitespace errors.
4. If structural files were added/removed/renamed, verify
   `项目文件结构说明.md` is updated.
5. If functional flows changed, verify `项目完整链路说明.md` is updated.
6. Generate a PR title and body draft based on real diff content.

## Action: /merge-check

Run only when the user explicitly asks to merge their own PR.

1. Run the checks in [checklists/merge.md](checklists/merge.md).
2. Verify PR base branch is the project's default dev branch, never the
   production branch.
3. Verify the local feature branch has absorbed latest `origin/dev`.
4. Verify PR state is `OPEN` and not `DRAFT`.
5. After `gh pr merge`, verify:
   - PR state becomes `MERGED`
   - Local default branch fast-forwards to the merge commit
6. Report merge commit hash and verification result.

## Action: /requirements-analysis

Run when the user has a new idea, wants to clarify a new feature, or says
"我有一个想法".

1. Check if `docs/项目需求分析.md` already exists:
   - If yes: read it, identify which sections are incomplete or contain TODOs
   - If no: create it from the template at `docs/项目需求分析.md`
2. Determine if this is a **new project** or an **enhancement to an existing project**:
   - If existing project: read the five root docs to understand current architecture
     before filling sections
   - If new project: focus on Sections 1-4 and skip architecture cross-check
3. Guide the user through each incomplete section, section by section:
   - Clarify vague descriptions with targeted questions
   - Help prioritize features into P0 / P1 / P2
   - Define acceptance criteria for each P0 feature
   - Identify open questions and risks, record in Section 8
4. After all sections are complete, cross-check with existing docs if applicable:
   - Compare with `项目完整链路说明.md` for flow conflicts
   - Compare with `项目文件结构说明.md` for structural conflicts
   - Flag conflicts in Section 8 of the requirements doc
5. Save the completed `docs/项目需求分析.md`
6. Recommend next step:
   - If P0 is clear and no blocking open questions: "建议进入 /task-intake，从 P0 开始实现"
   - If open questions remain: list them as blocks before proceeding

Reference [checklists/requirements.md](checklists/requirements.md) for the full
step-by-step guide.

## Action: /governance-propose

Create a structured change proposal with full artifact folder under
`governance/artifacts/<change-name>/`.

**Trigger**: user says "propose 新功能", "创建提案", or similar.

1. **Parse the change name** from the user's request. Sanitize to
   kebab-case (e.g. "添加深色模式" → `add-dark-mode`).
2. **Create the artifact directory** at `governance/artifacts/<change-name>/`.
3. **Generate files**:
   - `proposal.md` — why this change, background, goals
   - `specs/index.md` — feature requirements with P0/P1/P2 prioritization
   - `specs/scenarios.md` — user stories and usage scenarios
   - `design.md` — technical approach, module boundaries, data flows
   - `tasks.md` — 3-5 milestone stages; each stage has a checklist; use
     🔄 for in-progress, ✅ for complete, ⬜ for not started

   Example `tasks.md` structure:

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

4. **Confirm** the directory has all 5 files before reporting completion.
5. **Offer next step**: "建议进入 /governance-help 开始执行，或 /task-intake 进入开发阶段。"

Reference [checklists/propose.md](checklists/propose.md) for the full checklist.

## Action: /governance-help

Show real-time guidance: current milestone, pending check items, and the
next action to take.

**Trigger**: user says "下一步是什么", "当前进度", "governance help", or similar.

1. **Scan** `governance/artifacts/*/tasks.md` for in-progress changes (🔄).
2. **For each in-progress change**, output:
   - Change name and artifact path
   - Current milestone with emoji and completion ratio (e.g. `🔄 2/4`)
   - All pending (unchecked) tasks in the current milestone
   - The first pending task marked as **← 建议下一步**
3. **If no in-progress changes exist**, output:
   - List of all existing changes with their top-level milestone status
   - Prompt to run `/governance-propose` to start a new change

**Output format**:

   ```markdown
   ## 正在进行：add-dark-mode

   路径：`governance/artifacts/add-dark-mode/`

   Milestone 2: 核心实现 [🔄 2/4]
   - [x] Task 2.1: 注册 API 端点
   - [x] Task 2.2: 编写数据模型
   - [ ] Task 2.3: 实现业务逻辑 ← **建议下一步**
   - [ ] Task 2.4: 单元测试

   建议：完成 Task 2.3 后运行 /pre-pr-check 验证
   ```

Reference [checklists/track.md](checklists/track.md) for the full checklist.

## Output Format

For every action, end with a concise status block:

```
Action: <action-name>
Status: <pass / blocked / needs-user-input>
Next: <one-line next step>
```

## Rules

- Never guess branch names, file paths, or test commands. Read the root docs
  or ask the user.
- Never proceed to code changes during `/task-intake` if the user asked for
  analysis only.
- Never merge a PR without explicit user authorization.
- If a root doc is missing, stop and recommend `/project-init` first.
- Never proceed to implementation if `/requirements-analysis` has not been
  run and open questions remain. Flag blocks and ask the user to resolve
  them before continuing.