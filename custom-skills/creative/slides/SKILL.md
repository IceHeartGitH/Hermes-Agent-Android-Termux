---
name: slides
description: Use when create strategic HTML presentations with Chart.js, design tokens, responsive layouts, copywriting formulas, and contextual slide strategies.
version: 0.1.0
author: Next Level Builder / adapted for Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [ui, ux, design]
    related_skills: [design]
    source: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
    local_category: UI/UX
---

# Slides

## Hermes Notes

- Source: `nextlevelbuilder/ui-ux-pro-max-skill original skill: slides/SKILL.md`.
- Local category: UI/UX.
- Use this as a Hermes Agent UI/UX workflow skill. The upstream body below is adapted to remove upstream-specific path/runtime assumptions.
- Original full file is stored at `references/original-SKILL.md`.
- Do not run upstream npm/bun/playwright installers automatically on Termux. Treat CLI scripts and browser tooling as optional, explicit setup steps.

## Upstream Skill Body

# Slides

Strategic HTML presentation design with data visualization.

## When to Use

- Marketing presentations and pitch decks
- Data-driven slides with Chart.js
- Strategic slide design with layout patterns
- Copywriting-optimized presentation content

## Subcommands

| Subcommand | Description | Reference |
|------------|-------------|-----------|
| `create` | Create strategic presentation slides | `references/create.md` |

## References (Knowledge Base)

| Topic | File |
|-------|------|
| Layout Patterns | `references/layout-patterns.md` |
| HTML Template | `references/html-template.md` |
| Copywriting Formulas | `references/copywriting-formulas.md` |
| Slide Strategies | `references/slide-strategies.md` |

## Routing

1. Parse subcommand from `$ARGUMENTS` (first word)
2. Load corresponding `references/{subcommand}.md`
3. Execute with remaining arguments
