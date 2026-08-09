# Tip 23 — Prefer Operators to Visual Commands Where Possible

> Chapter 4 — Visual Mode · *Practical Vim* (Drew Neil)

**One-liner:** A repeated Visual-mode command acts on the *same-sized* range, which breaks when word lengths differ — so for repetitive edits use a Normal-mode operator (`gUit`) instead of a Visual command (`vitU`) so `.` repeats something useful.

**Practice file:** [`../practice/tip-23-prefer-operators-to-visual-commands/list-of-links.html`](../practice/tip-23-prefer-operators-to-visual-commands/list-of-links.html) — uppercase the text inside each `<a>` tag. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `vit` | Normal → Visual | Visually select **inside the tag** (text object `it`) |
| `U` | Visual | Uppercase the selection (`:h v_U`) |
| `gU{motion}` | Normal | Uppercase over a motion (`:h gU`) — the operator form |
| `gUit` | Normal | Uppercase inside the tag in one operator+motion command |
| `j.` | Normal | Next line, then repeat the change |

## How it works

Goal: SHOUT the text inside each `<a>` tag.

**Visual approach — `vitU`:** `vit` selects inside the tag, `U` uppercases it. Fine for the first line. But repeating with `j.` misbehaves: when `.` repeats a *Visual* command it re-applies to the **same amount of text** as the last selection (`:h visual-repeat`). The first change hit a 3-letter word ("one"), so:

- line 2 "two" (also 3 letters) → works by luck
- line 3 "three" (5 letters) → only "THRee" gets uppercased 😖

**Operator approach — `gUit`:** the Normal-mode equivalent of `U` is the operator `gU{motion}`. `gUit` = operator `gU` + text-object motion `it`. Now `.` repeats the *whole operator+motion*, which re-evaluates `it` on each line — so it correctly uppercases words of any length.

## Example

```
gUit   <a href="#">ONE</a>     (uppercase inside the tag)
j.     <a href="#">TWO</a>     (repeat: re-runs gU on inner tag)
j.     <a href="#">THREE</a>   (works — "three" fully uppercased)
```

Contrast the Visual version, which leaves `THRee`.

## Why it matters / when to reach for it

Both `vitU` and `gUit` are four keystrokes, but the semantics differ:

- `vitU` = **two commands** (select, then transform) → `.` remembers a fixed-size selection.
- `gUit` = **one command** = operator + motion → `.` re-runs the motion each time.

**General rule:** for a *repetitive* set of changes, prefer Normal-mode operators over their Visual-mode equivalents, so the dot command repeats something useful.

Visual mode isn't banned — it's great for **one-off** changes, and for selecting a range whose structure is hard to express as a precise motion. Just don't build a repeatable workflow on it.

## Gotchas

- The trap is specific to **character-wise** repeats (fixed character count). Line-wise Visual repeats (Tip 22) are usually fine.
- Operators that have Visual equivalents: `U`→`gU`, `u`→`gu`, `~`→`g~`, `>`→`>`, `d`→`d`, etc. Reach for the operator form when repeating.
- `it`/`at` are tag text objects (Tip 51) — `it` is *inner* (contents only), `at` includes the tags.

## Related

- Tip 20 — Grok Visual Mode
- Tip 22 — Repeat Line-Wise Visual Commands (where Visual repeat *does* work)
- Tip 12 — Combine and Conquer (operator + motion)
- Tip 51 — Precision Text Objects (`it`, `at`)
