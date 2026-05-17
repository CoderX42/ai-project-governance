# Merge Checklist

Run this checklist only when the user explicitly authorizes merging their own PR.

## Pre-Merge Verification

1. Fetch latest remote state:
   ```bash
   git fetch origin
   ```

2. Inspect the PR:
   ```bash
   gh pr view <PR_NUMBER> --json number,title,baseRefName,headRefName,state,isDraft,mergeable,mergeStateStatus,url
   ```

3. Check behind/ahead against default branch:
   ```bash
   git log --oneline HEAD..origin/dev
   ```

## Must Pass Before Merge

- [ ] PR base branch is the default dev branch (e.g., `dev`), never `master`/`main`.
- [ ] PR is `OPEN`, not `DRAFT`.
- [ ] Local feature branch has absorbed latest `origin/dev`.
- [ ] No unresolved blocking issues in PR comments.
- [ ] User explicitly authorized merge.

## Merge Execution

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

If you do not want to delete the branch, omit `--delete-branch`.

## Post-Merge Verification

1. Verify PR state:
   ```bash
   gh pr view <PR_NUMBER> --json number,state,mergedAt,mergedBy,baseRefName,url,mergeCommit
   ```

2. Update local default branch:
   ```bash
   git fetch origin
   git switch dev
   git pull --ff-only origin dev
   git rev-parse HEAD origin/dev
   git log --oneline -1
   ```

## Must Pass After Merge

- [ ] PR `state` is `MERGED`.
- [ ] `baseRefName` is the default dev branch.
- [ ] `mergeCommit.oid` exists.
- [ ] `git rev-parse HEAD origin/dev` shows identical commits.
- [ ] Local default branch latest commit is the merge commit or a later one.

If local dirty changes prevent switching or fast-forwarding, tell the user:
"远端 PR 已合并，但本地 dev 尚未更新" — do not claim local is done when it is not.

## Restrictions

- Only merge your own PRs.
- Never merge a feature branch directly into `master`/`main`.
- Never merge without explicit user authorization.