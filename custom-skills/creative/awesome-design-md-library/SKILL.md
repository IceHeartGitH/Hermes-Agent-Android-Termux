---
name: awesome-design-md-library
description: Use automatically when a task involves DESIGN.md, design tokens, design systems, visual style references, brand-inspired UI, landing/page/app/dashboard styling, UI/UX visual direction, style matching, design audit, or combining named brand styles such as Linear, Stripe, Apple, Tesla, Vercel, Notion, Airbnb, Nike, Shopify, Supabase, Cursor, or similar. Browse/read the local awesome-design-md library and use it with design-md to select, synthesize, adapt, or validate project-specific design direction.
version: 0.1.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [design, design-md, design-system, ui, ux, brand-library]
    related_skills: [design-md, ui-ux-pro-max, design-system, brand, taste-skill, popular-web-designs]
---

# Awesome DESIGN.md Library

## Overview

This skill connects Hermes Agent to the local `VoltAgent/awesome-design-md` reference library. The library is not a skill pack; it is a curated set of real `DESIGN.md` files that describe brand visual systems, tokens, typography, layout rules, components, responsive behavior, and do/don't guidelines.

Use it with the `design-md` skill when generating project-specific `DESIGN.md` files, designing landing pages, auditing visual consistency, or combining several brand styles into a new design direction.

## Local Paths

Installed working DESIGN.md library:

```text
~/.hermes-venv/skill-libraries/awesome-design-md
```

Each brand/style lives at:

```text
~/.hermes-venv/skill-libraries/awesome-design-md/<brand>/DESIGN.md
```

Repository bundled copy before installation:

```text
custom-skills-library/awesome-design-md/<brand>/DESIGN.md
```

Current source commit:

```text
664b3e7
```

Current count:

```text
74 DESIGN.md files
```

## Automatic Trigger Behavior

This skill should be considered automatically when the user asks for any of these, even if they do not mention `awesome-design-md-library` by name:

- `DESIGN.md`, design tokens, design system, brand/style guide, visual identity spec;
- landing page, product page, dashboard, app screen, README/gallery, presentation, or UI mockup with a named visual style;
- “in the style of ...”, “като Linear/Stripe/Apple/Tesla/Vercel/Notion”, “premium”, “developer SaaS”, “dark technical”, “minimal”, “luxury”, “automotive”, “fintech”, “e-commerce”, or similar style direction;
- UI redesign, style audit, visual consistency check, spacing/typography/color polish;
- combining several brand styles into a new project-specific direction.

Default behavior when triggered:

1. If the user names one or more brands, look up and read those exact local `DESIGN.md` files.
2. If the user gives only a vibe/industry, run the lookup helper to choose 2-4 matching references.
3. Use `design-md` rules when producing a formal `DESIGN.md`.
4. Do not ask whether to use the library unless the user explicitly wants a different source; use it as background automatically.
5. State which references were used in the final answer.

## When to Use

Use this skill when the user asks directly or indirectly to:

- create a `DESIGN.md` inspired by one or more known brands;
- build a landing page, app screen, dashboard, README visual style, or UI mockup in a named style;
- compare an existing page against a brand design language;
- choose good reference styles for a project;
- combine references, e.g. `Linear + Stripe`, `Apple + Tesla`, `Notion + Vercel`;
- browse available DESIGN.md examples;
- adapt a brand visual system without copying the brand identity verbatim.

Do not use this as an active skill library import. The upstream repository has no `SKILL.md` files.

## Workflow

1. Resolve references.
   - If the user names brands, read those exact files from `~/.hermes-venv/skill-libraries/awesome-design-md/<brand>/DESIGN.md`.
   - If the user gives a vibe but no brand, search the library using `scripts/lookup.py` and choose 2-4 close references.
   - Completion: selected reference names and paths are known.

2. Read only the needed files.
   - Use `read_file` for exact `DESIGN.md` paths.
   - For several candidates, use `scripts/lookup.py` to narrow down.
   - Completion: you have enough concrete tokens/rules to proceed.

3. Synthesize, do not clone blindly.
   - Preserve useful design language: spacing, typography rhythm, surfaces, components, hierarchy, motion cues.
   - Avoid copying protected brand marks, logos, product names, or trademark-specific identity as if it belonged to the user's project.
   - Completion: output is project-specific, not a pasted brand clone.

4. Use `design-md` rules for formal outputs.
   - For a project `DESIGN.md`, follow Google DESIGN.md structure: YAML tokens plus markdown rationale.
   - Quote hex values and negative dimensions.
   - Use token references like `{colors.primary}` in component definitions.
   - Completion: file has valid frontmatter, sensible sections, and project-specific rationale.

5. Validate when practical.
   - If Node/npx is available and the user wants validation, run: `npx -y @google/design.md lint DESIGN.md`.
   - On Termux, do not install heavy tooling just to lint unless the user asks; perform structural checks manually if needed.
   - Completion: errors are fixed or clearly reported.

## Lookup Commands

List all reference names:

```bash
python ~/.hermes-venv/skills/creative/awesome-design-md-library/scripts/lookup.py --list
```

Search references by vibe/industry:

```bash
python ~/.hermes-venv/skills/creative/awesome-design-md-library/scripts/lookup.py "premium dark automotive"
python ~/.hermes-venv/skills/creative/awesome-design-md-library/scripts/lookup.py "developer dark terminal"
python ~/.hermes-venv/skills/creative/awesome-design-md-library/scripts/lookup.py "warm productivity minimal"
```

Get exact paths:

```bash
python ~/.hermes-venv/skills/creative/awesome-design-md-library/scripts/lookup.py --path "linear stripe"
```

## Good Reference Combos

- Premium product landing: `apple` + `tesla` + `stripe`.
- Developer SaaS: `vercel` + `linear.app` + `supabase`.
- AI platform: `claude` + `mistral.ai` + `together.ai`.
- Local/service business: `apple` + `airbnb` + `intercom`.
- E-commerce: `shopify` + `nike` + `airbnb`.
- Documentation/product docs: `mintlify` + `ollama` + `replicate`.
- Dark technical dashboard: `cursor` + `warp` + `sentry`.
- Luxury automotive/product: `bmw` + `bugatti` + `tesla`.

## Common Pitfalls

1. Treating this as a SKILL.md repository. It is not; it is a DESIGN.md reference library.
2. Copying a brand identity too literally. Use inspiration and system mechanics, not trademarks.
3. Loading too many references. Two or three strong sources beat ten vague ones.
4. Ignoring the target project. Always adapt tokens/components to the user's brand, audience, and content.
5. Running Node/npx validation automatically on Termux when a manual structural check is enough.

## Verification Checklist

- [ ] Selected reference names and file paths are stated.
- [ ] Source DESIGN.md files were read before producing a design claim.
- [ ] Output is adapted to the user's project, not a brand clone.
- [ ] If creating `DESIGN.md`, it has YAML frontmatter plus markdown rationale.
- [ ] If files were written, paths are reported and validation/manual checks are summarized.
