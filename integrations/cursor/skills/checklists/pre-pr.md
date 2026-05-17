# Pre-PR Checklist

Run this checklist before creating or updating a pull request.

## Git Hygiene

- [ ] `git status --short` shows only files related to this task.
- [ ] `git diff --check` reports no whitespace errors.
- [ ] No conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) remain.
- [ ] No temporary debug code, unrelated formatting, or build artifacts.
- [ ] Commit messages describe real changes in Chinese; no `update`/`fix`/`AI修改`.
- [ ] Current branch is not `dev`/`develop` and not `master`/`main`.

## Doc Sync Check

- [ ] If files were added/removed/renamed: `项目文件结构说明.md` is updated.
- [ ] If functional flows changed: `项目完整链路说明.md` is updated.
- [ ] If architecture boundaries or rules changed: `项目开发规范.md` is updated.
- [ ] If PR process or branch rules changed: `AI开发与PR流程.md` is updated.

## Diff Review

- [ ] Run `git diff origin/dev...HEAD` (or equivalent default branch).
- [ ] Verify every changed line is intentional.
- [ ] Verify no secrets, credentials, or local paths leaked.
- [ ] Verify no garbled Chinese text in modified files.

## Test & Static Check

- [ ] Run the project's test command (e.g., `npm test`, `pytest`).
- [ ] If tests fail, fix before PR unless user explicitly waives.
- [ ] Run basic syntax checks (e.g., `node --check`, `tsc --noEmit`).

## PR Draft

Generate a PR title and body based on actual diff:

**Title**: direct description of the result, not a Git action.

**Body**:
```markdown
## 本次改动
- ...

## 风险与影响
- ...

## 测试情况
- ...
```

- [ ] Title is in natural Chinese, not robot template.
- [ ] Body is based on real changes, no exaggeration.
- [ ] If tests were not run, explicitly state "未运行测试，请开发者自行验证".