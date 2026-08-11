# Tip 31 — Repeat the Last Ex Command

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** `.` won't replay command-line changes — use `@:` to repeat the last Ex command (then `@@` for subsequent repeats), and reverse with `u` or, for navigation commands, `<C-o>`.

**Practice file:** none — practise with the buffer list: open a few files, `:bnext`, then `@:` `@:`.

## Commands

| Keys | Effect |
| --- | --- |
| `@:` | Repeat the last Ex command (`:h @:`) |
| `@@` | Repeat again (after the first `@:`) |
| `u` | Undo — reverses text-editing Ex commands (`:d`, `:s`, `:normal`, …) |
| `<C-o>` | Go back in the jump list — reverses navigation Ex commands (`:bnext`, `:next`, `:cnext`, `:tnext`) |
| `:bnext` / `:bprevious` | Step forward / backward through the buffer list |

## How it works

The dot command repeats the last **Normal-mode** change, but it **won't replay Ex commands** run from the command line. For those, press `@:` — it repeats the most recently executed command line.

Why `@:`? The `:` register always holds the last command line (`:h quote_:`), and `@{register}` executes a register's contents as keystrokes (the same mechanism as running a macro, Tip 64). So `@:` = "run the `:` register." After the first `@:`, you can use the shorthand `@@` to repeat.

**Classic use — walking the buffer list:** with a dozen buffers open, type `:bnext` once, then tap `@:` (then `@@`) to step through them all.

## Example

```
:bnext     go to the next buffer
@:         repeat → next buffer
@@         repeat again → next buffer
...
```

## Reversing — `u` vs `<C-o>`

Repeating is easy; reversing depends on the command's nature (remember *act, repeat, reverse*, Tip 4):

- **Text-editing Ex commands** (`:delete`, `:substitute`, `:normal`, etc.) → reverse with **`u`** (undo).
- **Navigation Ex commands** (`:bnext`, `:next`, `:cnext`, `:tnext`) → **don't** reverse with the opposite command. If you `@:`-ed past your target and then ran `:bprevious`, a further `@:` would now go *backward* — confusing, because `@:` always repeats the *last* command. Instead use **`<C-o>`**, which steps back through the jump list (each `:bnext` adds a jump-list record; Tip 55). Then resume forward with `@:`.

## Why it matters / when to reach for it

`@:` is the "dot command for the command line." Any Ex command you'd otherwise retype — stepping through buffers, quickfix entries (`:cnext`), tags (`:tnext`), or re-running a `:move`/`:substitute` on a new selection — becomes a single keystroke to repeat. Pair it with `<C-o>` for navigation or `u` for edits and you can repeat confidently and back out cleanly.

## Gotchas

- `@:` repeats the **exact** last command line, including its range. Re-running `:'<,'>m$` on a *new* selection works because `'<,'>` re-resolves to the current selection.
- For navigation, opposite commands corrupt the "repeat" direction — prefer `<C-o>` to reverse.
- `@@` only works *after* an initial `@:` (it repeats the last `@`-executed register).

## Related

- Tip 4 — Act, Repeat, Reverse
- Tip 30 — Run Normal Mode Commands Across a Range (`:normal`)
- Tip 36 — Track Open Files with the Buffer List (`:bnext`)
- Tip 55 — Traverse the Jump List (`<C-o>`)
- Tip 64 — Record and Execute a Macro (`@{register}`)
