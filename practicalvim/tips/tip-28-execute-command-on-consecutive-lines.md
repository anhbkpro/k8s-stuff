# Tip 28 — Execute a Command on One or More Consecutive Lines

> Chapter 5 — Command-Line Mode · *Practical Vim* (Drew Neil)

**One-liner:** Most Ex commands accept a `[range]` — `:{start},{end}` — where each address is a line number, `.`/`$`/`%`, a mark, a visual selection (`'<,'>`), or a `/pattern/`, optionally with a `+n`/`-n` offset.

**Practice file:** [`../practice/tip-28-execute-command-on-consecutive-lines/practical-vim.html`](../practice/tip-28-execute-command-on-consecutive-lines/practical-vim.html) — try `:%p`, `:2,4p`, `:.,$p`, `:/<html>/,/<\/html>/p`. Use `:p` (print, harmless) to see the range; swap in `:d`/`:s` for real edits. Reset with `u` or `:e!`.

## Range addressing

| Symbol | Address |
| --- | --- |
| `1` | First line of the file |
| `$` | Last line of the file |
| `0` | Virtual line *above* line 1 (for `:copy`/`:move` to top) |
| `.` | The current line |
| `'m` | Line containing mark `m` |
| `'<` / `'>` | Start / end of the last visual selection |
| `%` | The entire file (shorthand for `1,$`) |

A range is `:{start},{end}` where both ends are addresses. After it runs, the cursor lands on the last line of the range.

## How it works

An Ex command consisting of only a number is treated as an address and moves the cursor there: `:3` jumps to line 3. Combine address + command in one go: `:3p` prints line 3; `:3d` deletes it (Normal-mode equivalent `3G` then `dd` — so the Ex form can be quicker and needs no cursor move).

**By number:** `:2,5p` prints lines 2–5. `:$` is the last line.

**By `.` and `%`:** `.` = current line, so `:.,$p` = here to end of file. `%` = whole file, so `:%p` = `:1,$p`. The classic pairing is `:%s/Practical/Pragmatic/` — substitute across every line.

**By visual selection:** select lines (`2G` then `VG`), press `:`, and Vim prepopulates `:'<,'>`. `'<`/`'>` are marks for the selection's first/last line; they **persist after leaving Visual mode**, so `:'<,'>p` from Normal mode acts on the most recent selection.

**By pattern:** `:/<html>/,/<\/html>/p` runs from the line matching `/<html>/` to the line matching `/<\/html>/`. More robust than `:2,5` — it tracks the whole element however many lines it spans.

**Offsets:** add `+n`/`-n` to any address (default `n=1`). `:/<html>/+1,/<\/html>/-1p` targets the lines *inside* the tags but not the tags themselves. `:.,.+3` = current line plus the next three.

## Example

```
:%p                        print the whole file
:2,4p                      print lines 2–4
:.,$p                      from cursor line to end
:/<html>/+1,/<\/html>/-1p  inside the <html> element, excluding the tags
```

## Why it matters / when to reach for it

Ranges are what make Ex commands "strike far and wide": one command edits many lines, anywhere, without navigating there. Mixing numbers, `.`, marks, patterns, and offsets makes the target precise **and** robust — pattern-based ranges survive edits that line numbers wouldn't.

## Gotchas

- **`[range]` is always contiguous.** For non-adjacent lines use `:global` (Ch. 15).
- **Line `0`** doesn't exist but is valid as the `{address}` in `:copy`/`:move` to place lines at the very top (Tip 29).
- `:p`/`:print` just echoes lines — perfect for *previewing* which lines a range covers before running a destructive command.
- `:'<,'>` always refers to the *last* selection's marks, even from Normal mode.
- Escape `/` inside a pattern range (`<\/html>`).

## Related

- Tip 27 — Meet Vim's Command Line
- Tip 29 — Duplicate or Move Lines Using `:t` and `:m` (uses `0` address)
- Tip 30 — Run Normal Mode Commands Across a Range (`:normal`)
- Tip 53 — Marks (`'m`, `'<`, `'>`)
- Chapter 14 — Substitution (`:%s`); Chapter 15 — Global Commands (non-contiguous)
