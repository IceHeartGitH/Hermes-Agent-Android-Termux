---
name: nanobot-tmux
description: Use when controlling interactive tmux sessions on Termux/Linux for CLIs, long-running agents, REPLs, or pane output capture.
version: 0.1.0
author: HKUDS/nanobot / adapted for Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [termux, tmux, terminal, agents]
    related_skills: []
    source: https://github.com/HKUDS/nanobot/tree/main/nanobot/skills/tmux
    upstream_commit: 6a1a45d07a6d
---

# Nanobot tmux for Hermes Agent

Adapted from HKUDS/nanobot `tmux` skill for Hermes Agent on Termux/Linux.

## Runtime dependency

Requires the `tmux` command. On Termux, install it with:

```bash
pkg install -y tmux
```

## When to use

Use this when a process needs a real interactive terminal/pane:

- interactive CLI agents such as Hermes/Codex/Claude/OpenCode;
- Python/Node shells or REPLs;
- long-lived terminal sessions you want to attach to manually;
- sending keystrokes and capturing pane output.

Prefer Hermes `terminal(background=true)` + `process` for non-interactive bounded jobs. Use tmux only when a real TTY/pane is needed.

## Termux socket convention

```bash
SOCKET_DIR="${TMPDIR:-/tmp}/hermes-tmux-sockets"
mkdir -p "$SOCKET_DIR"
SOCKET="$SOCKET_DIR/hermes.sock"
SESSION="hermes-agent-1"
```

## Start a session

```bash
tmux -S "$SOCKET" new-session -d -s "$SESSION" -x 120 -y 40
tmux -S "$SOCKET" send-keys -t "$SESSION":0.0 -l -- 'cd "$HOME" && hermes'
tmux -S "$SOCKET" send-keys -t "$SESSION":0.0 Enter
```

## Inspect / send / capture

```bash
tmux -S "$SOCKET" list-sessions
tmux -S "$SOCKET" capture-pane -p -J -t "$SESSION":0.0 -S -200
tmux -S "$SOCKET" send-keys -t "$SESSION":0.0 -l -- 'your text here'
tmux -S "$SOCKET" send-keys -t "$SESSION":0.0 Enter
```

For control keys:

```bash
tmux -S "$SOCKET" send-keys -t "$SESSION":0.0 C-c
```

## Attach / detach

```bash
tmux -S "$SOCKET" attach -t "$SESSION"
```

Detach manually with `Ctrl+b d`.

## Cleanup

```bash
tmux -S "$SOCKET" kill-session -t "$SESSION"
tmux -S "$SOCKET" kill-server
```

## Pitfalls

- Always quote paths on Android shared storage.
- Use `send-keys -l -- "$text"` for literal user text.
- Do not use tmux when Hermes background process tracking is enough.
- For spawned Hermes sessions, avoid editing the same git worktree from multiple agents unless using separate branches/worktrees.

Original upstream is preserved in `references/original-SKILL.md`.
