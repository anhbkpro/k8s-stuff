# Tip 1 — Meet the Dot Command

> Chapter 1 — The Vim Way · *Practical Vim* (Drew Neil)

**One-liner:** `.` repeats the last change — the most versatile command in Vim, and the foundation for everything that follows.

**Practice file:** [`../practice/tip-01-meet-the-dot-command/0_mechanics.txt`](../practice/tip-01-meet-the-dot-command/0_mechanics.txt) — open it in Vim and try the keystrokes below. Reset edits with `u`, or reload the pristine copy with `:e!`.

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `.` | Normal | Repeat the last *change* |
| `x` | Normal | Delete the character under the cursor (a change) |
| `dd` | Normal | Delete the current line (a change) |
| `>G` | Normal | Indent from the current line to end of file (a change) |
| `u` | Normal | Undo (to reset while experimenting) |

## How it works

Vim's docs define `.` as simply "repeat last change" (`:h .`). The power is in how broad *"a change"* is: it can act on a single character, a whole line, or the entire file. Whatever your last change was, `.` replays it.

A change is anything that modifies the buffer:

- A Normal-mode edit like `x`, `dd`, or `>G`.
- A whole trip through Insert mode — from `i` (or `a`, `o`, `c...`) until you hit `<Esc>`. Vim records **every keystroke** you typed and `.` replays the lot.

That last point is what makes `.` a "micro macro": one keystroke can replay an entire word or phrase you just inserted.

## Example

Given this buffer:

```
Line one
Line two
Line three
Line four
```

**Character-wise** — `x` deletes one char, `.` repeats it:

```
{start}   Line one
x         ine one
.         ne one
..        one
```

**Line-wise** — after `dd`, `.` deletes another whole line:

```
{start}   Line one / Line two / Line three / Line four
dd        Line two / Line three / Line four
.         Line three / Line four
```

**File-wise** — after `>G`, `.` re-applies the indent from wherever the cursor now is (here we move down with `j` first):

```
>G        indent lines 1→4
j         cursor to line 2
.         indent lines 2→4 again
```

Restore the buffer any time with a few presses of `u`.

## Why it matters / when to reach for it

`.` turns a change you *just made* into a one-keystroke verb. Instead of re-typing the same edit, you move to the next spot and press `.`. This is the seed of the "dot formula" (Tip 6): one keystroke to move, one to execute. Almost every efficiency gain in the book builds on making your changes *repeatable* so that `.` does more work.

## Gotchas

- `.` repeats the **last change**, not the last *motion* or command. Moving the cursor (e.g. `w`, `j`) is not a change and won't be repeated.
- Moving around *inside* Insert mode (arrow keys, clicking) resets what `.` will replay — see the caveat "Moving Around in Insert Mode Resets the Change" (referenced with Tip 9). Type your insert as one clean sequence if you want `.` to replay it whole.
- Design your changes to be self-contained. A change that depends on exact cursor position replays more predictably than a sloppy one.

## Related

- Tip 2 — Don't Repeat Yourself
- Tip 6 — Meet the Dot Formula (the "ideal editing formula")
- Chapter 11 — Macros (the "full-size" version of the dot command's micro-macro idea)
