# AI Project Governance

> 你的 AI 写代码越来越失控了？这个项目用一套文档 + Skill 模板，把 AI 开发拉回可控轨道。

## 核心痛点

- AI 擅自改代码、不读文档、猜着写
- PR 里混入调试代码、无关改动
- 改完结构不更新文档，一个月后谁也看不懂
- 不同 IDE（Cursor/Claude/Codex）规则不互通

## 一键解决

复制 5 份文档 → 替换占位符 → AI 自动遵守开发规范

## 支持 9 个 IDE/Agent

为软件开发项目提供一套结构化、可复用的 AI 开发约束体系，覆盖需求分析、代码开发、PR 流程、文档同步和合并审查等全链路。


| 工具 | 适配方式 | 目录 |
|---|---|---|
| Cursor | Skill (`SKILL.md` + checklists) | [`integrations/cursor/`](integrations/cursor/) |
| Claude Code | `CLAUDE.md` 指令 | [`integrations/claude-code/`](integrations/claude-code/) |
| Trae | 复用 Cursor Skill | [`integrations/trae/`](integrations/trae/) |
| Codex / OpenAI Agents | Instructions | [`integrations/codex/`](integrations/codex/) |
| OpenClaw | Skill 或 Prompt | [`integrations/openclaw/`](integrations/openclaw/) |
| Gemini CLI | Custom Instructions | [`integrations/gemini-cli/`](integrations/gemini-cli/) |
| Antigravity | Skill 或 Knowledge Base | [`integrations/antigravity/`](integrations/antigravity/) |
| Hermes | Prompt Templates | [`integrations/hermes/`](integrations/hermes/) |
| 通用 / 其他 | 纯 Prompt 模板 | [`integrations/generic/`](integrations/generic/) |

## 里程碑

- [x] **阶段一**：Cursor Skill 完整适配
- [ ] **阶段二**：Claude Code + Trae 适配
- [ ] **阶段三**：OpenClaw、Hermes、Gemini CLI、Antigravity 等后续工具适配

## 快速开始

### 1. 复制通用规则到项目根目录

```bash
cp -r docs/* /path/to/your/project/
```

### 2. 替换占位符

打开 `docs/CLAUDE.md` 和各份 `.md` 文件，替换以下占位符：

| 占位符 | 示例值 | 说明 |
|---|---|---|
| `{{PROJECT_NAME}}` | `MyApp` | 项目名称 |
| `{{DEFAULT_BRANCH}}` | `dev` | 日常开发基线分支 |
| `{{PROD_BRANCH}}` | `master` | 生产分支 |
| `{{TEST_COMMAND}}` | `npm test` | 测试命令 |
| `{{PACKAGE_FILE}}` | `package.json` | 包管理文件 |
| `{{TECH_STACK}}` | `React + Node.js` | 技术栈简述 |

### 3. 安装 IDE 适配

根据你使用的工具，参考对应 `integrations/<tool>/` 目录的安装说明。

## 目录结构

```
.
├── docs/                          # 通用治理规则（IDE 无关）
│   ├── CLAUDE.md                  # AI 总规则
│   ├── AI开发与PR流程.md           # PR 流程与分支规范
│   ├── 项目开发规范.md             # 开发规范与自检清单
│   ├── 项目完整链路说明.md          # 业务链路文档
│   └── 项目文件结构说明.md          # 文件结构与职责索引
├── integrations/                  # IDE / Agent 适配
│   ├── cursor/
│   │   └── skills/
│   │       └── ai-project-governance/
│   │           ├── SKILL.md
│   │           └── checklists/
│   ├── claude-code/
│   ├── codex/
│   ├── openclaw/
│   ├── gemini-cli/
│   ├── antigravity/
│   ├── hermes/
│   ├── trae/
│   └── generic/
└── hooks/
    └── README.md                  # Hook 设计说明
```

## 治理规则分层

| 层级 | 载体 | 作用 |
|---|---|---|
| 总章程 | `CLAUDE.md` | 永久生效的核心规则 |
| 细则 | 4 份根文档 | 详细流程、架构、链路、文件结构 |
| 流程化 | Skill / Prompt | 可调用、可复用的工作流入口 |
| 硬拦截 | Hook | 强制执行关键检查点（可选） |

## 核心原则

1. **不能猜**：所有结论必须基于真实命令输出、真实 diff、真实代码上下文。
2. **先读文档再动代码**：每次开发前必须重新阅读 5 份根文档。
3. **按阶段推进**：环境确认 → 对齐基线 → 开发 → 再同步 → 发 PR → 授权后合并。
4. **文档必须同步**：结构变更、链路变更、规范变更都要更新对应根文档。
5. **乱码视为阻塞**：中文文档、日志、注释、UI 文案必须做乱码审查。
6. **最终回执完整**：做了什么、是否同步、是否测过、是否有风险，必须说清楚。

## 添加新的 IDE / Agent 支持

欢迎为其他工具添加适配。参考以下模式：

1. 在 `integrations/` 下创建 `<tool-name>/` 目录。
2. 放置该工具原生格式的 skill / prompt / instruction 文件。
3. 写一份 `README.md` 说明安装和使用方式。
4. 如果格式与 Cursor Skill 兼容，可直接复用 `../cursor/skills/ai-project-governance/` 的内容。

## License

MIT