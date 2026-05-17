---
name: apg-merge-check
description: >-
  授权合并 PR。验证 PR 状态、分支目标、代码审查结果，执行合并后验证结果。
  使用场景：用户提到 "merge now"、"can I merge"、"ready to merge"、
  "合并吧"、"可以合并了"。
  注意：只有用户明确授权时才执行合并。
disable-model-invocation: false
---

# /apg-merge-check

Run only when the user explicitly asks to merge their own PR.

## 动作定义

### Step 1: 预合并验证

执行：

```bash
gh pr view <PR_NUMBER> --json number,title,baseRefName,headRefName,state,isDraft,mergeable,mergeStateStatus,url
git fetch origin
git log --oneline HEAD..origin/dev
```

确认：
- PR 目标分支是默认开发分支（如 dev），不是 `master`/`main`
- PR 状态是 `OPEN`，不是 `DRAFT`
- 本地功能分支已吸收最新 `origin/dev`
- PR 无尚未处理的 blocking 评论
- 用户已明确授权合并

### Step 2: 执行合并

```bash
gh pr merge <PR_NUMBER> --merge --delete-branch
```

如果用户不想删除源分支，去掉 `--delete-branch`。

### Step 3: 合并后验证

执行：

```bash
gh pr view <PR_NUMBER> --json number,state,mergedAt,mergedBy,baseRefName,url,mergeCommit
git fetch origin
git switch dev
git pull --ff-only origin dev
git rev-parse HEAD origin/dev
git log --oneline -1
```

确认：
- `state` 是 `MERGED`
- `baseRefName` 是默认开发分支
- `mergeCommit.oid` 存在
- `git rev-parse HEAD origin/dev` 输出相同提交
- 本地 `dev` 最新提交是该 PR 的合并提交

如果本地有脏改动导致无法切回或快进：
必须如实告知用户："远端 PR 已合并，但本地 dev 尚未更新"，
不能声称本地也已完成。

## 限制

- 只合并自己的 PR
- 不得将任何功能分支直接合并到 `master`/`main`
- 不得在未获得用户明确授权时合并

## 输出格式

```
Action: /apg-merge
Status: <pass / blocked / needs-user-input>
PR: <#NUMBER> merged into <base>
Merge Commit: <hash>
Next: <next action or end>
```

## 参考

完整检查清单：`../checklists/merge.md`