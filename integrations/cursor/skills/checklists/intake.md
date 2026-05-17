# Task Intake Checklist

Run this checklist at the start of every new task.

## Phase 1: Read Root Docs

- [ ] `CLAUDE.md` exists and is readable
- [ ] `AI开发与PR流程.md` exists and is readable
- [ ] `项目开发规范.md` exists and is readable
- [ ] `项目完整链路说明.md` exists and is readable
- [ ] `项目文件结构说明.md` exists and is readable
- [ ] `项目需求分析.md` exists and is readable (if task involves new features)

If any doc is missing, stop and run `/project-init`.

## Phase 2: Determine Task Type

**Analysis only** (no code changes):
- [ ] User used words: analyze, review, explain, what is, how does
- [ ] Output: analysis, trace, recommendations only
- [ ] Do not create, modify, or commit files

**Implementation** (code changes allowed):
- [ ] User used words: implement, develop, fix, add, create, build
- [ ] Proceed to Phase 3

## Phase 3: Demand Understanding

Answer these before proposing any code:

1. What is the real goal of this task? (If `项目需求分析.md` exists, base understanding on its P0 features and acceptance criteria)
2. Which existing modules/files are directly involved?
3. Are there upstream dependencies or downstream consumers?
4. Does this change any shared definitions, configuration schemas, or APIs?
5. Are there modes/switches that alter behavior when on vs off?
6. Does this task introduce new requirements not covered in `项目需求分析.md`? If so, flag the gap before proceeding.

## Phase 4: Impact Trace

List every file that will likely change, grouped by layer:

| Layer | Files | Why |
|-------|-------|-----|
| Shared definition | | |
| Backend / Service | | |
| Frontend / UI | | |
| Tests | | |
| Docs | | |

## Phase 5: Development Checklist

Draft stage-by-stage plan. Each stage must have:

- [ ] Stage N: <what to do>
  - Owner files: <list>
  - Self-check after stage:
    - [ ] related code changed
    - [ ] data/state/UI flows consistent
    - [ ] no design gaps or boundary issues
    - [ ] no garbled text in modified files
    - [ ] relevant tests pass or are added

## Phase 6: Final Review Items

Before marking the task complete:

- [ ] All stages passed self-check
- [ ] Global review: no stray changes in diff
- [ ] Root docs updated if structure or flow changed
- [ ] Garbled-text check passed for all touched files
- [ ] Test command run (or user explicitly waived)
- [ ] Final report includes: what changed, tests run, commit/push status, risks