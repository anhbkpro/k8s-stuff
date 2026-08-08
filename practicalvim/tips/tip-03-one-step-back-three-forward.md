# Tip 3 — Take One Step Back, Then Three Forward

> Chapter 1 — The Vim Way · *Practical Vim* (Drew Neil)

**One-liner:** Pad each `+` with spaces using `s␣+␣<Esc>` (a repeatable change) and hop between targets with `f+` then `;` — so the whole edit becomes `;.` `;.` `;.`.

**Practice file:** [`../practice/tip-03-one-step-back-three-forward/3_concat.js`](../practice/tip-03-one-step-back-three-forward/3_concat.js) — pad every `+` with a space on each side. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `f{char}` | Normal | Jump forward to the next occurrence of `{char}` on the line |
| `;` | Normal | Repeat the last `f`/`t` character search |
| `s` | Normal → Insert | Delete char under cursor **and** enter Insert mode (= `cl`) |
| `.` | Normal | Repeat the last change |

## How it works

Goal: turn `"method("+argument1+","+argument2+")"` into `... ( " + argument1 + ...`, i.e. surround each `+` with a space on both sides.

The idiom is `s␣+␣<Esc>`, read as **one step back, three steps forward**:

- `s` deletes the `+` under the cursor and drops into Insert mode (that's the "step back" — you remove the char).
- You then type ` + ` (space, plus, space) — the "three forward" — replacing the single `+` with a padded one.
- `<Esc>` returns to Normal mode.

Two things make this fast:

1. **The change is repeatable.** Because `s␣+␣<Esc>` is self-contained, `.` replays the whole dance anywhere the cursor sits on a `+`.
2. **The motion is repeatable.** `f+` jumps to the first `+`; after that, `;` repeats that character search to reach the next `+` — no need to retype `f+`.

Combine them: `;` moves to the next target, `.` repeats the change. So after the first edit, `;.` finishes each remaining `+`.

## Example

Starting line (`3_concat.js`):

```
var foo = "method("+argument1+","+argument2+")";
```

Keystrokes:

```
f+          cursor jumps to the first +
s␣+␣<Esc>   ..."method(" + argument1+...
;.          ..."method(" + argument1 + ","+...
;.          ..."method(" + argument1 + "," + argument2+...
;.          ..."method(" + argument1 + "," + argument2 + ")";
```

Result:

```
var foo = "method(" + argument1 + "," + argument2 + ")";
```

## Why it matters / when to reach for it

This is the dot formula (Tip 6) taken one level further: both halves — the *change* and the *motion* — are made repeatable. When you can pair a repeatable change (`.`) with a repeatable motion (`;`), a scattered edit across a line collapses into a rhythm of `;.` `;.`.

Reach for this whenever you're making the *same small edit* at several spots that share a landmark character (`+`, `,`, `=`, etc.): `f{char}` finds the landmark, `s` (or `c`) makes the repeatable change.

## Gotchas

- `s` = `cl`: it removes one character. If you need to replace a longer span, use `c` with a motion/text object instead.
- `;` repeats the last `f`/`t`/`F`/`T` search *and its direction*. Use `,` to repeat it in the opposite direction. Overshoot with `;`? `,` steps back.
- The cursor just needs to land *on* a `+` for `.` to work — that's why `f+`/`;` (which land exactly on the char) pair so cleanly with this change.

## Related

- Tip 1 — Meet the Dot Command
- Tip 2 — Don't Repeat Yourself
- Tip 6 — Meet the Dot Formula
- Tip 49 — Find by Character (`f`, `t`, `;`, `,`)
