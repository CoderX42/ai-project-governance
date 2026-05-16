# OpenClaw Integration

OpenClaw typically uses prompt-based or skill-based configuration.

## Option A: Skill Format (if supported)

If OpenClaw supports skill directories similar to Cursor:

1. Copy the Cursor `SKILL.md` and `checklists/` into OpenClaw's skills directory.
2. Adjust frontmatter if OpenClaw uses a different schema.

## Option B: Prompt Injection

If OpenClaw uses system prompts or custom instructions:

Copy the contents of `../generic/prompts.md` into OpenClaw's system prompt or custom instruction field.

## Option C: Project-Level Rules

Place the docs from `../../docs/` into your project root. OpenClaw will read `CLAUDE.md` automatically if it follows the same convention as other agents.