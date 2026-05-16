# Trae Integration

Trae uses the same Skill format as Cursor.

## Installation

Copy the Cursor skill directory into your Trae skills folder:

```bash
mkdir -p ~/.trae/skills
cp -r ../cursor/skills/ai-project-governance ~/.trae/skills/
```

Or if Trae reads from `~/.cursor/skills/`, it should already be available.

## Usage

Same as Cursor: invoke `/project-init`, `/task-intake`, `/pre-pr-check`, or `/merge-check`.