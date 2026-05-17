---
name: apg-help
description: >-
  查看当前进行中的变更进度，显示当前里程碑、待完成任务和建议的下一步操作。
  使用场景：用户提到 "下一步是什么"、"当前进度"、"governance help"、
  "引导我"、"现在该做什么"。
disable-model-invocation: false
---

# /apg-help

Show real-time guidance: current milestone, pending check items, and the next action to take.

## 动作定义

### Step 1: 扫描进行中的变更

遍历 `governance/artifacts/*/tasks.md`，按最上方的未完成里程碑 emoji 分类：
- 🔄 → 进行中
- ✅ → 已完成（可归档或跳过）
- ⬜ → 尚未开始

### Step 2: 对每个进行中的变更

输出：

```markdown
## 正在进行：<change-name>

路径：`governance/artifacts/<change-name>/`

Milestone N: [名称] [🔄 X/Y]
- [x] Task N.X: ...
- [ ] Task N.Y: ... ← **建议下一步**
- [ ] Task N.Z: ...
```

### Step 3: 生成建议

所有进行中变更输出完后，给出一行建议：
> 建议：[具体的下一个操作]

### Step 4: 空状态处理

如果没有进行中的变更：
- 列出所有已完成变更（✅）
- 列出所有未开始变更（⬜）
- 提示："没有正在进行中的变更。运行 /apg-propose 创建新提案。"

### Step 5: 可选 — 推进里程碑

如果用户说"Task X 完成"或标记某项完成：
1. 在正确的 `tasks.md` 中将 `- [ ]` 改为 `- [x]`
2. 检查当前里程碑所有任务是否完成：
   - 如果完成：将里程碑 emoji 从 🔄 改为 ✅
   - 如果有下一个里程碑：将其设为 🔄
3. 重新输出引导

## 输出格式

```
Action: /apg-help
Status: pass
Next: [specific next task]
```

如果没有变更存在：

```
Action: /apg-help
Status: pass
Next: 运行 /apg-propose 创建新提案
```

## 参考

完整检查清单：`../checklists/track.md`