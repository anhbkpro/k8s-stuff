# Tip 50 — Search to Navigate

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** `/{pattern}<CR>` is a motion — jump anywhere (any length, across lines) by typing just enough characters to be unique, repeat with `n`/`N`, and even feed it to an operator like `d/pattern<CR>`.

**Practice file:** [`../practice/tip-50-search-to-navigate/search-haiku.txt`](../practice/tip-50-search-to-navigate/search-haiku.txt) — jump to "takes" with the fewest keystrokes (`/tak<CR>`). Reset with `u` or `:e!`.

## Commands

| Command | Effect |
| --- | --- |
| `/{pattern}<CR>` | Search **forward** to `{pattern}` |
| `?{pattern}<CR>` | Search **backward** |
| `n` / `N` | Repeat search same / reverse direction |
| `d/{pattern}<CR>` | Delete from cursor up to the match (operator + search motion) |

## How it works

Character search (`f`/`t`, Tip 49) is fast but limited: one character, current line only. The **search command** removes both limits — any-length pattern, anywhere in the file.

Type only enough to be unique. To reach "takes":

```
/ta<CR>    two hits ("target", "takes")
/tak<CR>   one hit → lands on "takes"
```

In a big document this covers huge distances in a few keystrokes. Overshoot or land wrong? `n` jumps to the next match, `N` back — *act, repeat, reverse* (Tip 4) again.

This also rescues the common-character problem from Tip 49: `fe` is useless (too many e's), but searching a short *string* like `/er` narrows drastically — only a fraction of e's are followed by r. You can often reach any word by searching its first few characters.

## Operate with a search motion — the power move

Search works in **Operator-Pending** mode too. To delete "takes time but eventually " from:

```
This phrase takes time but eventually gets to the point.
```

The Visual way (with an off-by-one to fix):

```
v /ge<CR> h d    select up to "gets", back up one, delete
```

The direct way:

```
d/ge<CR>         delete from cursor up to (not including) "gets"
```

`/` is an **exclusive** motion (`:h exclusive`) — the cursor lands on the `g` of "gets" but that character is *excluded* from the delete. Staying out of Visual mode saves keystrokes (cf. Tip 23). `d{motion}` + search is a genuine power move.

## Why it matters / when to reach for it

Search is the most economical long-range motion in Vim — and because it's a motion, it doubles as an operator target (`d/`, `c/`, `y/`, `v/`). Think of "type the first few unique characters of where I want to go" as your default jump.

## Gotchas

- `/` is **exclusive**: the match character itself isn't included in an operator's range — add `/e` offset or adjust if you need it (Tip 83).
- `hlsearch` highlights *all* matches — noisy when navigating by short strings (off by default); `incsearch` (Tip 81) previews as you type and is very useful here.
- Patterns are regex — special chars (`.`, `*`, `[`) may need escaping (Tips 72–78).
- `n`/`N` direction is relative to `/` vs `?`.

## Related

- Tip 49 — Find by Character (single-char, in-line)
- Tip 23 — Prefer Operators to Visual Commands (why `d/` beats `v…d`)
- Tip 79–84 — The search command in depth (`incsearch`, offsets)
- Tip 4 — Act, Repeat, Reverse (`n`/`N`)
