# Implementation Checklist

Run this checklist during actual development, stage by stage.

## Before Writing Code

- [ ] Re-read the four root docs if this is a new session.
- [ ] Confirm task type is implementation (not analysis-only).
- [ ] Verify the feature branch is based on latest `origin/dev`.
- [ ] Confirm no unrelated dirty changes are in the workspace.

## During Development

For every module you touch:

- [ ] Read existing code before modifying.
- [ ] Check related call sites, state flows, and config references.
- [ ] If old logic is clearly dead and unused, remove it.
- [ ] If old logic is buggy and fixing it does not break other features, fix it.
- [ ] Keep entry files thin; prefer sinking logic into dedicated modules.
- [ ] Use semantic file/module names; avoid `misc`, `temp`, `new`, `helper2`.

## Stage Self-Check (repeat per stage)

- [ ] All files in this stage are modified.
- [ ] Data flow, state flow, log flow, and UI flow are consistent.
- [ ] No design gaps, logic defects, or boundary issues.
- [ ] No garbled or replacement characters in Chinese text.
- [ ] Relevant unit/integration tests pass.
- [ ] If a stage check fails, do not proceed to the next stage.

## Structural Changes

If you add, remove, or rename files:

- [ ] Update `项目文件结构说明.md`.
- [ ] Update `项目完整链路说明.md` if the change affects flows.
- [ ] Update `项目开发规范.md` if the change affects architecture boundaries.

## Configuration Changes

If you add or modify a config item:

- [ ] Default value set.
- [ ] Normalization/validation in place.
- [ ] Import/export handling updated.
- [ ] State restore handling updated.
- [ ] UI visibility and binding updated.
- [ ] Placed in the correct domain.
- [ ] Documented in root docs.

## Flow/Node Changes

If you add or modify a process step/node:

- [ ] Shared definition updated.
- [ ] Backend registry/executor mapping updated.
- [ ] Frontend dynamic rendering updated.
- [ ] Auto-run inclusion checked.
- [ ] Manual skip, wait, completion, and failure recovery checked.
- [ ] State flow, rollback flow, and log flow are complete.
- [ ] Tests added or migrated.