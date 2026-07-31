# Custom skills pack

This folder contains a public-safe optional Hermes Agent custom skills pack for Android Termux.

Counts:

```text
total skills: 192
total files:  1923
DESIGN.md entries: 74
Google SEO/GEO criteria files: 387
```

The pack is sanitized for public distribution. It excludes credentials, sessions, state databases, memories/user profiles, cron outputs, private local paths, and personal workflow references.

## Google SEO/GEO inspection skills

This pack includes three full criteria-bank inspection skills plus a bundled Google SEO/GEO criteria library with 387 professional inspection-ready Markdown criteria:

- `google-seo-site-inspector` — SEO-only inspection using 201 SEO criteria.
- `google-geo-site-inspector` — GEO/AI-only inspection using 186 GEO criteria.
- `google-seo-geo-site-inspector` — combined SEO + GEO inspection using all 387 criteria.

Install only this inspection pack:

```sh
cd ~/Hermes-Agent-Android-Termux
bash scripts/install-custom-skills.sh --seo-geo
```

The criteria bank installs to:

```text
${HERMES_HOME:-$HOME/.hermes-venv}/skill-libraries/google-seo-geo-criteria-bank
```

## OpenSEO no-API skills

This pack includes four OpenSEO-derived workflow skills adapted for Hermes fallback use without DataForSEO/MCP:

- `openseo-seo-project-setup`
- `openseo-seo-coach`
- `openseo-review-web-content`
- `openseo-deslop`

## Nanobot lightweight skills

This pack includes two lightweight HKUDS/nanobot-derived skills adapted for Termux/Hermes:

- `nanobot-tmux`
- `nanobot-weather`

`nanobot-tmux` requires the Termux `tmux` package when used.

## Install examples

Run these commands from the repository checkout, not from your home directory:

```sh
cd ~/Hermes-Agent-Android-Termux
bash scripts/install-custom-skills.sh --list
bash scripts/install-custom-skills.sh --seo-geo
bash scripts/install-custom-skills.sh --all
bash scripts/install-custom-skills.sh --category omh
bash scripts/install-custom-skills.sh --category productivity
```

Verify:

```sh
cd ~/Hermes-Agent-Android-Termux
bash scripts/verify-custom-skills.sh
```
