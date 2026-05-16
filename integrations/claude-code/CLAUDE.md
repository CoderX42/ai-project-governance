# AI Project Governance for Claude Code

You are an AI assistant operating inside Claude Code. You must follow this governance framework when working on any software project.

## Before Every Task

1. Read the project's root governance documents:
   - `CLAUDE.md`
   - `AI开发与PR流程.md`
   - `项目开发规范.md`
   - `项目完整链路说明.md`
   - `项目文件结构说明.md`

   Do NOT rely on memory from previous sessions.

2. Determine task type:
   - **Analysis only** (keywords: analyze, review, explain, what is, how does): output analysis only. Do NOT modify code or create commits.
   - **Implementation** (keywords: implement, develop, fix, add, create, build): proceed with the full development workflow.

## Core Hard Rules

1. Never guess. All conclusions must be based on real command output, real diff, real code context.
2. Default development baseline branch is `{{DEFAULT_BRANCH}}` (e.g., `dev`). Never use `{{PROD_BRANCH}}` (e.g., `master`) as the daily development base.
3. Read docs before writing code. If the user says "just analyze", do not write code.
4. Stage-by-stage execution: environment check → sync origin/dev → develop → re-sync origin/dev → create PR → merge only with explicit authorization.
5. Docs must stay in sync: any structural, flow, or rule change requires updating the corresponding root doc.
6. Garbled text is a blocker: all Chinese docs, logs, comments, and UI text must be checked for encoding issues.
7. Final report must include: what changed, whether tests ran, commit/push status, and any remaining risks.

## PR Workflow

### Phase 1: Environment Check

Run before any work:
```bash
gh --version
gh auth status
git status --short --branch
git remote -v
git branch --show-current
git fetch origin
```

### Phase 2: Sync Baseline

New task:
```bash
git switch {{DEFAULT_BRANCH}}
git pull --ff-only origin {{DEFAULT_BRANCH}}
git switch -c <feature-branch>
```

Continuing existing branch:
```bash
git fetch origin
git rev-list --left-right --count origin/{{DEFAULT_BRANCH}}...HEAD
git log --oneline HEAD..origin/{{DEFAULT_BRANCH}}
```

### Phase 3: Develop

- Read code context before modifying.
- Check related state flows, configs, and callbacks.
- Remove dead code instead of keeping compatibility layers.
- Keep entry files thin; sink logic into dedicated modules.
- Use semantic filenames; avoid `misc.js`, `temp.js`, `new.js`.

### Phase 4: Pre-PR Sync

Mandatory before creating a PR:
```bash
git fetch origin
git log --oneline HEAD..origin/{{DEFAULT_BRANCH}}
```

If origin has new commits, rebase:
```bash
git rebase origin/{{DEFAULT_BRANCH}}
```

### Phase 5: Commit & Push

```bash
git status --short
git diff --stat origin/{{DEFAULT_BRANCH}}...HEAD
git diff origin/{{DEFAULT_BRANCH}}...HEAD
```

Requirements:
- Only task-related changes in the PR.
- No debug code, unrelated formatting, or build artifacts.
- Commit messages describe real changes in natural Chinese.
- Current branch is NOT `{{DEFAULT_BRANCH}}` or `{{PROD_BRANCH}}`.

### Phase 6: Create PR

PR must target `{{DEFAULT_BRANCH}}`:
```bash
gh pr create --base {{DEFAULT_BRANCH}} --head <feature-branch> --title "<PR title>" --body-file <body-file>
```

PR body template:
```markdown
## 本次改动
- ...

## 风险与影响
- ...

## 测试情况
- ...
```

### Phase 7: Merge (only with explicit authorization)

Pre-merge verification:
```bash
gh pr view <PR_NUMBER> --json number,title,baseRefName,headRefName,state,isDraft,mergeable,mergeStateStatus,url
git fetch origin
git log --oneline HEAD..origin/{{DEFAULT_BRANCH}}
```

Merge:
```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

Post-merge verification:
```bash
gh pr view <PR_NUMBER> --json number,state,mergedAt,mergedBy,baseRefName,url,mergeCommit
git fetch origin
git switch {{DEFAULT_BRANCH}}
git pull --ff-only origin {{DEFAULT_BRANCH}}
git rev-parse HEAD origin/{{DEFAULT_BRANCH}}
```

## Final Report Format

After completing any task, report:
1. What actions were taken.
2. Whether the branch is synced with latest `origin/{{DEFAULT_BRANCH}}`.
3. Whether a PR was created/updated, with number and link.
4. Whether tests were run (or explicit reminder to the user).
5. Whether merge was performed, with verification status.
6. Any remaining risks or unfinished items.

Do NOT reply with just "done".