# Tip 2 — Don't Repeat Yourself

> Chapter 1 — The Vim Way · *Practical Vim* (Drew Neil)

**One-liner:** Use compound commands like `A` (append at end of line) so the dot command needs only a single motion to repeat — the ideal "one keystroke to move, one to execute."

**Practice file:** [`../practice/tip-02-dont-repeat-yourself/2_foo_bar.js`](../practice/tip-02-dont-repeat-yourself/2_foo_bar.js) — append a `;` to each line. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `$` | Normal | Move to end of line |
| `a` | Normal → Insert | Append **after** the cursor |
| `A` | Normal → Insert | Append at **end of line** (= `$a` in one keystroke) |
| `j` | Normal | Move down one line |
| `.` | Normal | Repeat the last change |

## How it works

The task: append `;` to the end of every line. The naive way is a motion **plus** a change each time — `$a;<Esc>` — repeated on each line.

`.` can replay the `a;<Esc>` change, so you might do `j$.` per line. But `j$` is *two* keystrokes of positioning just to set up the dot. That's the smell this tip removes.

`A` is a **compound command**: it rolls `$a` into one key. It jumps to the end of the line and enters Insert mode regardless of where the cursor currently sits. So the change `A;<Esc>` no longer cares about cursor column — only that you're on the right line. Now repeating needs a single motion: `j.`.

## Example

Starting buffer (`2_foo_bar.js`):

```
var foo = 1
var bar = 'a'
var foobar = foo + bar
```

Keystrokes:

```
A;<Esc>   var foo = 1;
j.        var bar = 'a';
j.        var foobar = foo + bar;
```

One keystroke to move (`j`), one to execute (`.`). That's as good as it gets.

## Why it matters / when to reach for it

This is the first appearance of the **dot formula** (formalized in Tip 6): make your change repeatable, then advance with a single motion and press `.`. Choosing `A` over `$a` isn't about saving one keystroke once — it's about freeing `.` from any dependence on cursor position, so repetition collapses to `j.` `j.` `j.`.

Watch for compound commands generally — Vim has a handful (see "Two for the Price of One", Tip 12) that squash a motion + insert into one key: `A`=`$a`, `I`=`^i`, `o`=append line below, `O`=append line above, `s`=`cl`, `S`=`cc`, `C`=`c$`.

## Gotchas

- `a` vs `A`: lowercase appends after the cursor's current spot; uppercase always goes to end of line. Using `a` here would reintroduce the need to position the cursor first.
- `j.` `j.` is great for a handful of lines. For fifty consecutive lines it becomes tedious — reach for `:normal` across a range instead (Tip 30).

## Related

- Tip 1 — Meet the Dot Command
- Tip 6 — Meet the Dot Formula
- Tip 12 — Combine and Conquer (compound commands)
- Tip 30 — Run Normal Mode Commands Across a Range (for many lines)
