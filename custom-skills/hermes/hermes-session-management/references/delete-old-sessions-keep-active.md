# Delete old Hermes sessions while keeping the active CLI session

Session pattern captured from a Bulgarian Termux/Hermes CLI cleanup request.

## Trigger

The user first referenced an older session prefix:

```text
промени на 20260717_212814_20e61
```

The full matching session ID was:

```text
20260717_212814_20e61a
```

Later the user asked:

```text
Изтрий всички стари сесии да остане само тази
```

Because “тази” could mean the referenced old session or the currently active CLI session, the correct move was to clarify which one should remain.

## Correct workflow

1. Ask which session should remain when ambiguous.
2. The user chose: current active CLI session.
3. List sessions:

```sh
hermes sessions list
```

Observed shape:

```text
ID
20260717_225321_9a5a28   # active/current session to keep
20260717_212814_20e61a   # old session
20260717_195055_372361   # older session
```

4. Confirm delete command shape:

```sh
hermes sessions delete --help
```

The command accepts:

```sh
hermes sessions delete --yes <session_id>
```

5. Delete only non-keeper sessions:

```sh
hermes sessions delete --yes 20260717_212814_20e61a
hermes sessions delete --yes 20260717_195055_372361
```

6. Verify:

```sh
hermes sessions list
```

Expected remaining session:

```text
20260717_225321_9a5a28
```

## Reporting style in Bulgarian

Keep it short:

```text
Готово.

Изтрих старите сесии:
<ids>

Остана само текущата активна CLI сесия:
<id>

Проверено с:
hermes sessions list
```

## Lesson

For destructive session cleanup, clarification is required when the user uses “this/current/тази” after recently discussing another session ID. Keep the current active session only if they explicitly choose it.