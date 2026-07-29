# Custom skills pack

This folder contains a public-safe optional Hermes Agent custom skills pack for Android Termux.

Counts:

```text
total skills: 187
total files:  1916
DESIGN.md entries: 74
```

The pack is sanitized for public distribution. It excludes credentials, sessions, state databases, memories/user profiles, cron outputs, private local paths, and personal workflow references.

## OpenSEO no-API skills

This pack includes four OpenSEO-derived workflow skills adapted for Hermes fallback use without DataForSEO/MCP:

- `openseo-seo-project-setup`
- `openseo-seo-coach`
- `openseo-review-web-content`
- `openseo-deslop`

## Install examples

Run these commands from the repository checkout, not from your home directory:

```sh
cd ~/Hermes-Agent-Android-Termux
bash scripts/install-custom-skills.sh --list
bash scripts/install-custom-skills.sh --all
bash scripts/install-custom-skills.sh --category omh
bash scripts/install-custom-skills.sh --category productivity
```

Verify:

```sh
cd ~/Hermes-Agent-Android-Termux
bash scripts/verify-custom-skills.sh
```
