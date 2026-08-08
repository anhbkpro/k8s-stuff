# Tip 4 — Act, Repeat, Reverse

> Chapter 1 — The Vim Way · *Practical Vim* (Drew Neil)

**One-liner:** For every action Vim lets you repeat with one key, it also gives you a one-key way to reverse it — so you can fire fast and back out cleanly when you overshoot.

**Practice file:** none of its own — this tip is conceptual. Drill the reverses on the earlier files ([`0_mechanics.txt`](../practice/tip-01-meet-the-dot-command/0_mechanics.txt), [`3_concat.js`](../practice/tip-03-one-step-back-three-forward/3_concat.js)) by deliberately over-repeating and stepping back.

## The core idea

Optimal editing = make **both** the motion and the change repeatable, then *act, repeat, repeat…*. But repeating is fast and easy to overdo — an extra `.` or a double-tapped `;` and you've gone too far. Vim's answer: every repeatable action has a paired **reverse**. Knowing where reverse gear is lets you commit to fast repetition without fear.

Note that repetition isn't only `.`. Different actions have different "repeat" keys:

- `.` repeats the last **change**.
- `;` repeats the last `f`/`t` **character search**.
- `n` repeats the last `/` or `?` **document search**.
- `&` repeats the last **`:substitute`**.
- `@:` repeats the last **Ex command** (Tip 31).
- `@x` replays **macro** `x` (Tip 64).

## Repeatable actions and how to reverse them

| Intent | Act | Repeat | Reverse |
| --- | --- | --- | --- |
| Make a change | `{edit}` | `.` | `u` |
| Scan line for next character | `f{char}` / `t{char}` | `;` | `,` |
| Scan line for previous character | `F{char}` / `T{char}` | `;` | `,` |
| Scan document for next match | `/pattern<CR>` | `n` | `N` |
| Scan document for previous match | `?pattern<CR>` | `n` | `N` |
| Perform substitution | `:s/target/replacement` | `&` | `u` |
| Execute a sequence of changes | `qx{changes}q` | `@x` | `u` |

*(Table 1 in the book, p. 9.)*

## Why it matters / when to reach for it

This tip reframes the earlier dot-formula examples into a general principle. When you're rattling out `j.j.j.` or `;.;.;.`, you *will* occasionally overshoot. Because the reverse is always one key away, the right instinct is: keep repeating fast, and when you go one too far, tap the reverse (`u`, `,`, or `N`) — don't slow down or retype.

The `,` reverse for `f`/`t` is especially handy: fly forward with `;`, and when you blow past the target, `,` nudges back one match.

## Gotchas

- `;` vs `,`: `;` repeats an `f`/`t` search in its **original** direction; `,` repeats it in the **opposite** direction. This holds even for backward searches — after `F{char}`, `;` keeps going backward and `,` goes forward.
- `n` vs `N`: direction is relative to the search command. After `?pattern` (backward search), `n` continues backward and `N` reverses to forward.
- Most reverses are just `u` (undo). As the book quips: no wonder the `u` key is so worn out.

## Related

- Tip 1 — Meet the Dot Command (`.` / `u`)
- Tip 3 — Take One Step Back, Then Three Forward (`f`/`;`)
- Tip 31 — Repeat the Last Ex Command (`@:`)
- Tip 49 — Find by Character (`f`, `t`, `;`, `,`)
- Tip 64 — Record and Execute a Macro (`@x`)
- Tip 92 — Repeat the Previous Substitute Command (`&`)
