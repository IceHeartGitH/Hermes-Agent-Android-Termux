# Custom skills pack

This folder contains a public-safe optional Hermes Agent custom skills pack for Android Termux.

Counts:

```text
total skills: 194
total files:  1900
```

The pack is sanitized for public distribution. It excludes credentials, sessions, state databases, memories/user profiles, cron outputs, private local paths, and personal workflow references.

Install examples:

```sh
bash scripts/install-custom-skills.sh --list
bash scripts/install-custom-skills.sh --all
bash scripts/install-custom-skills.sh --category omh
bash scripts/install-custom-skills.sh --category productivity
```

Verify:

```sh
bash scripts/verify-custom-skills.sh
```
