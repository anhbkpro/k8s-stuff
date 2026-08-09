# Tip 22 — Repeat Line-Wise Visual Commands

> Chapter 4 — Visual Mode · *Practical Vim* (Drew Neil)

**One-liner:** After running a command on a Visual selection you drop back to Normal mode with the selection cleared — but `.` repeats it on an equivalent range, so `Vj>` then `.` re-indents without reselecting.

**Practice file:** [`../practice/tip-22-repeat-line-wise-visual-commands/fibonacci-malformed.py`](../practice/tip-22-repeat-line-wise-visual-commands/fibonacci-malformed.py) — indent the two lines under `while` by two more levels. First run `:set shiftwidth=4 softtabstop=4 expandtab`. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `V` | Normal → Visual | Line-wise Visual mode |
| `>` | Visual | Indent the selected lines one level |
| `<` | Visual | Dedent the selected lines one level |
| `.` | Normal | Repeat the last change on an equivalent range |
| `gv` | Normal → Visual | Reselect the last selection (the *worse* option here) |
| `2>` | Visual | Indent two levels in one blow (count alternative) |

## How it works

When you execute a command from Visual mode, Vim runs it, drops you back to Normal mode, and **clears the selection**. So how do you apply another command to the same range?

Two options:

1. `gv` to reselect, then repeat the command manually — but reselect-and-redo should "raise alarm bells": it's exactly the kind of repetition the dot command exists for.
2. Just press `.`. When `.` repeats a Visual-mode command, it acts on **the same amount of text** as the last visual selection. For line-wise selections that's intuitive and works in your favor.

## Example

The two lines under `while` need two more indent levels. Prep once:

```
:set shiftwidth=4 softtabstop=4 expandtab
```

Then:

```
Vj    line-wise select the two lines
>     indent one level (drops back to Normal, selection cleared)
.     repeat → indent the same two lines one more level
```

`>` only indents once before returning to Normal; `.` re-applies it to the equivalent range.

## Why `.` over a count here

You could count and hit it in one blow with `2>` from Visual mode. Neil prefers `.` because it gives **instant visual feedback**: indent, see it, `.` again if needed, or `u` if you overshoot. That's the *act, repeat, reverse* rhythm (Tips 4, 11) — no need to pre-count how many levels.

## Gotchas

- `.` repeats on **the same-sized range** as the last visual selection, anchored at the cursor — clean for line-wise, but **surprising for character-wise selections** (the setup for Tip 23, where operators are preferable).
- The `>`/`<` indent commands depend on `shiftwidth`; get `shiftwidth`/`softtabstop`/`expandtab` right or the indentation won't match the file's style.
- `gv` + repeat works but is the anti-pattern here — prefer `.`.

## Related

- Tip 4 — Act, Repeat, Reverse
- Tip 11 — Don't Count If You Can Repeat (`.` vs `2>`)
- Tip 21 — Define a Visual Selection (`gv`)
- Tip 23 — Prefer Operators to Visual Commands Where Possible (character-wise caveat)
