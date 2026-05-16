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