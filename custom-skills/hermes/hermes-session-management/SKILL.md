---
name: hermes-session-management
description: Manage Hermes Agent session history from CLI, including finding current sessions, resuming by ID, renaming, deleting old sessions, and verifying what remains.
---

# Hermes Session Management

Use this skill when the user asks about Hermes sessions, wants to switch/resume a previous session, asks which session they are in, wants old sessions deleted, or wants session history cleaned up.

## Core principles

- Treat the live Hermes session store as authoritative. Use `hermes sessions list` before destructive actions.
- Do not assume which session should be kept when deletion is involved. Ask a targeted clarification if there is any ambiguity between the active CLI session, a referenced session ID, and a previous session.
- In Bulgarian CLI conversations, keep the response direct and practical: show the exact session IDs affected and the verification result.
- Prefer exact full session IDs. If the user gives a prefix such as `20260717_212814_20e61`, check the list and identify the full ID, e.g. `20260717_212814_20e61a`, before using it.
- Deleting sessions is destructive. Confirm the intended keeper first, then execute with the CLI's explicit delete command and verify.

## Discovery workflow

Check available session commands and current history:

```sh
hermes sessions --help
hermes sessions list
```

If resuming/switching is the goal, explain that an agent inside a running CLI chat cannot literally replace the current process with another session, but the user can exit and run:

```sh
hermes --resume <session_id>
```

or, if supported by the installed Hermes version:

```sh
hermes -c
hermes -c "session title"
```

## Rename-session workflow

When the user asks whether the current session can be renamed, or directly asks to rename this/current session:

1. Check the live command surface and current session list:

```sh
hermes sessions --help
hermes sessions list
hermes sessions rename --help
```

2. Identify the current session ID from `hermes sessions list` and show the current title. In an active CLI session, the current chat is usually the `just now` row; if its title/workspace are shown as `—`, treat that as an untitled current session when the user asks to rename “this session”.
3. If the user already provided the new title, do not ask for confirmation; use the title exactly as given. Ask for the desired new title only if it is missing.
4. Rename with the installed CLI syntax shown by `hermes sessions rename --help`; current syntax is:

```sh
hermes sessions rename <session_id> "New Title"
```

5. Verify with `hermes sessions list` and report the old title (or `—`/untitled), new title, and session ID.

Do not guess a title. If the user suggests a title in Bulgarian, use it exactly unless it contains obvious typos they ask you to correct. Keep the final response brief: done, title, ID, and verification.

## Delete-all-old-sessions workflow

When the user says to delete old sessions and keep “this/current” session:

1. Clarify which session to keep if multiple plausible IDs exist.
2. Run `hermes sessions list` and identify all sessions except the keeper.
3. Check delete syntax if needed:

```sh
hermes sessions delete --help
```

4. Delete each non-keeper with explicit yes:

```sh
hermes sessions delete --yes <old_session_id>
```

5. Verify:

```sh
hermes sessions list
```

6. Report exactly:
   - deleted session IDs,
   - remaining session ID,
   - that verification was performed.

## Cleanup of update/smoke-test sessions

When Hermes update, launcher, or mirror verification created extra one-shot sessions, clean only the obvious service sessions:

1. List both homes when the user has venv/global installs:

```sh
hermes sessions list
hermes-global sessions list
```

2. Identify candidates by all of these signals before deleting:
   - untitled or generic title,
   - workspace/source path is a Hermes source directory such as `~/.hermes-venv/hermes-agent` or `~/.hermes/hermes-agent`,
   - exactly 2 messages or otherwise tiny message count,
   - first user message is a smoke prompt such as `Reply exactly: ...`, `*_LAUNCHER_OK`, `*_SMOKE_OK`, `*_CRYPTO_FIX_OK`, etc.
3. Do not delete real task sessions even if they were created during the same maintenance window. A titled session with many messages/tool calls is user work, not junk.
4. Back up both venv and global session stores before destructive cleanup (`state.db`, `state.db-wal`, `state.db-shm`, and `sessions/` when present).
5. Delete with the matching launcher for the home that owns the session:

```sh
hermes sessions delete --yes <venv_session_id>
hermes-global sessions delete --yes <global_session_id>
```

6. Verify both the visible list and the SQLite rows/messages are gone when possible. Report deleted IDs and remaining real sessions.

## Pitfalls

- Do not delete the session the user meant to keep because a previous referenced ID was mistaken for the active session.
- Do not rely on a shortened prefix unless `hermes sessions list` shows the unique full ID.
- Do not delete update-window sessions by timestamp alone; inspect title/message count/snippets and keep real user work sessions.
- Do not promise that a resumed/deleted session state changes the currently running CLI process; use `hermes --resume <id>` for a new invocation.
- `hermes sessions list` may visually truncate long titles in the table. If the rename command reports success, treat the command output as the exact new title and use the list only as verification that the session row changed.
- Avoid long explanations when the user asks for a cleanup action; act, verify, and summarize.

## References

- `references/delete-old-sessions-keep-active.md` — condensed example of deleting all old sessions while keeping the active CLI session.