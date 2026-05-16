# Generic Prompt Templates

Copy and paste these prompts into any AI coding assistant that does not support native skill/command formats (e.g., custom GPTs, ChatGPT, Gemini, etc.).

---

## Prompt 1: Project Onboarding

```
You are an AI software development assistant working on a real codebase.

Before doing anything, read these files from the project root:
- CLAUDE.md
- AI开发与PR流程.md
- 项目开发规范.md
- 项目完整链路说明.md
- 项目文件结构说明.md

Do not rely on memory from previous sessions. Read them now.

Then confirm:
1. What is the default development branch?
2. What is the production branch?
3. What is the test command?
4. Are there any current uncommitted changes?
```

---

## Prompt 2: Task Intake

```
I want you to help me with a new task.

First, determine if this is analysis-only or implementation:
- Analysis-only: I say words like "analyze", "review", "explain", "what is", "how does"
- Implementation: I say words like "implement", "develop", "fix", "add", "create", "build"

If analysis-only: output analysis only. Do NOT modify files.
If implementation: produce a development plan with:
1. Demand understanding (real goal)
2. Impact trace (affected modules/files)
3. Stage-by-stage checklist
4. Self-check items per stage
```

---

## Prompt 3: Pre-PR Check

```
Before I create a PR, run these checks:

1. git status --short (only task-related files?)
2. git diff --check (no whitespace errors?)
3. git diff origin/DEFAULT_BRANCH...HEAD (all changes intentional?)
4. If files were added/removed/renamed: is 项目文件结构说明.md updated?
5. If flows changed: is 项目完整链路说明.md updated?
6. Run the test command. Did tests pass?
7. Check all modified Chinese files for garbled text.

Then generate a PR title and body in natural Chinese based on the actual diff.
```

---

## Prompt 4: Merge Check

```
I want to merge my PR. Before doing so, verify:

1. PR base branch is the default dev branch (NOT master/main).
2. PR is open and not draft.
3. Feature branch includes latest origin/dev.
4. No unresolved blocking issues.
5. I have explicitly authorized merge.

After merge, verify:
- PR state is MERGED
- mergeCommit exists
- Local dev branch fast-forwards to the merge commit

Only merge my own PRs. Never merge into master/main directly.
```

---

## Prompt 5: Development Stage Self-Check

```
After completing each development stage, ask yourself:

1. Are all files in this stage modified?
2. Are data/state/log/UI flows consistent?
3. Any design gaps, logic defects, or boundary issues?
4. Any garbled Chinese text?
5. Do relevant tests pass?

If any answer is no, fix it before proceeding to the next stage.
```