---
name: ui-skills-root
description: "Use when starting UI-related work and selecting the smallest useful local UI skill set for the task inside Hermes Agent, without using the upstream npx router."
version: 0.1.0
author: Julien Thibeaut / adapted for Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [ui, ux, design, frontend]
    related_skills: [ui-ux-pro-max, design, design-md, design-system]
    source: https://github.com/ibelick/ui-skills
    source_commit: ae74b58
    local_category: UI Skills
---

# UI Skills Root

## Hermes Notes

- Source: `ibelick/ui-skills` original skill `ui-skills-root/SKILL.md`, commit `ae74b58`.
- Local category: UI Skills / Creative.
- Use this as a Hermes Agent UI/design workflow skill.
- Original upstream file is preserved unchanged at `references/original-SKILL.md`.
- Do not run the upstream Node-based CLI router or npm install commands automatically on Termux. The useful instructions are embedded locally in this Hermes skill.
- If a step mentions optional external tooling, ask before installing or running it.

## Upstream Skill Body, Hermes-adapted

# UI Skills Root

You are the routing layer for UI Skills.

Use it when an agent in Codex, AI editor, or AI coding agents has a clear UI goal.

If the goal is unclear, ask one short question.

If the goal is clear, choose the right category, load the smallest useful skill context, then implement.

## Protocol

1. decide if the task is UI-related
2. if not, return `no skill needed`
3. identify the likely category
4. inspect that category with the CLI
5. select the smallest useful skill set
6. load only selected skill(s)
7. implement using that context

## CLI

## Selection Rules

Prefer 1 skill.

Use 2 only when the task needs two clear angles.

Use 3 only for broad review, redesign, or multi-surface work.

Never use more than 3.

Route by topic, then stack, then specificity.

Prefer specific skills over broad skills.

Prefer framework-specific skills when the stack is obvious.

For quick cleanup, prefer the most specific craft, visual, or layout skill available.

If unsure, inspect categories and pick the safest narrow skill.

