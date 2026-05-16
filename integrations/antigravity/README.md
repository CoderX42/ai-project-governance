# Antigravity Integration

Antigravity supports agent skills and MCP integrations.

## Setup

### Method 1: Skill Format

If Antigravity supports the Cursor-style skill format:

1. Copy the Cursor skill:
   ```bash
   cp -r ../cursor/skills/ai-project-governance ~/.antigravity/skills/
   ```
2. Adjust `SKILL.md` frontmatter if Antigravity uses different metadata keys.

### Method 2: Project Rules

Place the docs from `../../docs/` into your project root. Antigravity should read `CLAUDE.md` as project-level instructions.

### Method 3: Knowledge Base

If Antigravity has a knowledge base or memory system:

1. Add the core rules from `../../docs/CLAUDE.md` as persistent project knowledge.
2. Add the checklists from `../cursor/skills/ai-project-governance/checklists/` as reusable workflow references.