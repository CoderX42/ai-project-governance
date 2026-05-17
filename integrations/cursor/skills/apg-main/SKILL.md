---
name: apg-main
description: >-
  AI 开发治理主入口。自动加载并始终生效，提供 7 个动作的快捷引用。
  使用场景：用户提到 initialize governance、set up project rules、create CLAUDE.md。
  7 个可用动作：
  /apg-init         — 初始化项目治理文档
  /apg-intake       — 开始新任务，分析影响范围和分阶段开发清单
  /apg-req          — 从原始想法引导填写结构化需求文档
  /apg-prepr        — PR 前检查 diff、文档同步、测试
  /apg-merge        — 授权合并 PR，验证结果
  /apg-propose      — 创建结构化变更提案
  /apg-help         — 查看当前进度和下一步建议
disable-model-invocation: false
---

# AI Project Governance (apg-main)

AI 开发治理主入口。始终自动加载，提供全局规则约束。

## 可用动作

| Skill | 触发场景 |
|-------|----------|
| `/apg-init` | "init governance", "set up project rules" |
| `/apg-intake` | "start new task", "what should I do next" |
| `/apg-req` | "new idea", "需求分析", "我有一个想法" |
| `/apg-prepr` | "ready to PR", "check before PR" |
| `/apg-merge` | "merge now", "can I merge" |
| `/apg-propose` | "propose 新功能", "创建提案" |
| `/apg-help` | "下一步是什么", "当前进度" |

## 核心规则

- 开发前必须阅读 5 份根文档（CLAUDE.md 已在本次会话自动加载）
- 不能猜，必须基于真实命令输出
- 先做需求分析，再进入开发（除非用户只要求分析）
- 文档必须同步更新
- 乱码是阻塞问题

## 输出格式

每个动作完成后输出状态块：

```
Action: <action-name>
Status: <pass / blocked / needs-user-input>
Next: <one-line next step>
```