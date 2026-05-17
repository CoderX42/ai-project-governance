# Milestone Tracking Checklist

Run `/governance-help` when the user says "下一步是什么", "当前进度", "governance help", or similar.

## Phase 1: Scan for In-Progress Changes

- [ ] List all directories under `governance/artifacts/`
- [ ] For each directory, read `tasks.md`
- [ ] Classify each change by top-most incomplete milestone emoji:
  - 🔄 → in-progress
  - ✅ → completed (archive or skip)
  - ⬜ → not started yet

## Phase 2: For Each In-Progress Change

- [ ] Identify the current (first 🔄) milestone
- [ ] Count total tasks and completed tasks in that milestone
- [ ] List all unchecked tasks in current milestone
- [ ] Mark the first unchecked task as **← 建议下一步**

## Phase 3: Build Output

For each in-progress change, output:

```markdown
## 正在进行：<change-name>

路径：`governance/artifacts/<change-name>/`

Milestone N: [名称] [🔄 X/Y]
- [x] Task N.X: ...
- [ ] Task N.Y: ... ← **建议下一步**
- [ ] Task N.Z: ...
```

After all in-progress changes, output a one-line suggestion:
> 建议：[next specific action]

## Phase 4: Handle Empty State

If no in-progress changes exist:
- [ ] List all archived/completed changes (✅)
- [ ] List all not-started changes (⬜)
- [ ] Prompt: "没有正在进行中的变更。运行 /governance-propose 创建新提案。"

## Phase 5: Optional — Advance Milestone

If user says "Task X 完成" or marks something done:
- [ ] Locate the task in the correct `tasks.md`
- [ ] Change `- [ ]` to `- [x]`
- [ ] Check if all tasks in current milestone are done:
  - If yes: update milestone emoji from 🔄 to ✅
  - If next milestone exists: set it to 🔄
- [ ] Re-run guidance output

## Output Format

```
Action: /governance-help
Status: pass
Next: [specific next task]
```

If no changes exist:

```
Action: /governance-help
Status: pass
Next: 运行 /governance-propose 创建新提案
```