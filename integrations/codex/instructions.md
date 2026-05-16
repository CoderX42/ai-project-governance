# AI Project Governance for Codex / OpenAI Agents

Use these instructions when configuring Codex or other OpenAI agent tools to work on software projects.

## Project Onboarding

At the start of every session, read these root documents from the project repository:

1. `CLAUDE.md` — AI collaboration constitution
2. `AI开发与PR流程.md` — PR workflow and branching rules
3. `项目开发规范.md` — Development standards and architecture boundaries
4. `项目完整链路说明.md` — Full functional flow documentation
5. `项目文件结构说明.md` — File structure and responsibility index

Do not rely on memory from prior sessions. Re-read these documents every time.

## Task Classification

Determine the user's intent before acting:

- **Analysis tasks** (analyze, review, explain): produce written analysis only. Do not modify files.
- **Implementation tasks** (implement, fix, add, create): execute the full development workflow below.

## Development Workflow

### 1. Environment Check

Run these commands and verify output:
```bash
gh auth status
git status --short --branch
git branch --show-current
git fetch origin
```

Stop and report if `gh` is not logged in or the workspace has uncommitted changes.

### 2. Branch Baseline

For new tasks:
```bash
git switch {{DEFAULT_BRANCH}}
git pull --ff-only origin {{DEFAULT_BRANCH}}
git switch -c feature/<name>
```

For continuing tasks, check divergence:
```bash
git fetch origin
git log --oneline HEAD..origin/{{DEFAULT_BRANCH}}
```

### 3. Development Rules

- Read existing code before modifying anything.
- Check all related call sites, state flows, config references, and callback chains.
- Remove dead code rather than keeping compatibility shims.
- Keep entry files thin; move logic to dedicated modules.
- Use semantic filenames. Never create `misc.js`, `temp.py`, `new.ts`, `helper2.js`.

### 4. Pre-PR Requirements

Before creating a PR, you MUST:

1. Re-sync with `origin/{{DEFAULT_BRANCH}}`:
   ```bash
   git fetch origin
   git rebase origin/{{DEFAULT_BRANCH}}
   ```

2. Review diff scope:
   ```bash
   git diff --stat origin/{{DEFAULT_BRANCH}}...HEAD
   git diff origin/{{DEFAULT_BRANCH}}...HEAD
   ```

3. Ensure no whitespace errors:
   ```bash
   git diff --check
   ```

4. Update docs if structure changed:
   - File added/removed/renamed -> update `项目文件结构说明.md`
   - Flow changed -> update `项目完整链路说明.md`
   - Architecture rule changed -> update `项目开发规范.md`

5. Run tests or explicitly state they were skipped.

### 5. PR Creation

Target branch MUST be `{{DEFAULT_BRANCH}}`, never `{{PROD_BRANCH}}`.

PR title: describe the result, not the action. (e.g., "fix(auth): correct JWT expiry check" not "fix bug")

PR body (in Chinese, natural tone, no robot templates):
```markdown
## 本次改动
- ...

## 风险与影响
- ...

## 测试情况
- ...
```

### 6. Merge Rules

Only merge when ALL of these are true:
- User explicitly authorized merge.
- PR targets `{{DEFAULT_BRANCH}}`.
- PR is open and not draft.
- Feature branch includes latest `origin/{{DEFAULT_BRANCH}}`.
- No unresolved blocking issues.

After merge, verify:
```bash
gh pr view <PR_NUMBER> --json state,mergedAt,mergeCommit
git fetch origin
git switch {{DEFAULT_BRANCH}}
git pull --ff-only origin {{DEFAULT_BRANCH}}
git rev-parse HEAD origin/{{DEFAULT_BRANCH}}
```

## Encoding / Language Rules

- All Chinese text in docs, comments, logs, and UI strings must be checked for garbled characters.
- If garbled text is found, the task is NOT complete.
- Do NOT bulk-rewrite Chinese files without confirming the encoding first.

## Final Report

Always end with:
1. What was changed.
2. Test results or explicit waiver.
3. Commit/push/PR status.
4. Any risks or unfinished items.