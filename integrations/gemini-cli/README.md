# Gemini CLI Integration

Gemini CLI uses `.gemini/settings.json` or inline system instructions.

## Setup

### Method 1: Project-Level Rules

Place the docs from `../../docs/` into your project root. Gemini CLI often auto-reads `CLAUDE.md` if present.

### Method 2: Custom Instructions

Copy the relevant sections from `../generic/prompts.md` into Gemini CLI's custom instruction field:

```bash
gemini config set system.instruction "$(cat ../generic/prompts.md)"
```

Or create a `.gemini/instructions.md` file in your project root with the prompt content.

### Method 3: Inline At Session Start

At the beginning of each Gemini CLI session, paste the **Project Onboarding** prompt from `../generic/prompts.md`.