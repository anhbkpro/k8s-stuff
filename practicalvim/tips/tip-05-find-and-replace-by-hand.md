# Tip 5 — Find and Replace by Hand

> Chapter 1 — The Vim Way · *Practical Vim* (Drew Neil)

**One-liner:** When a blind `:substitute` would hit false matches, search with `*`, make the change once with `cw`, then vet each match yourself with `n` (skip) and `.` (change).

**Practice file:** [`../practice/tip-05-find-and-replace-by-hand/1_copy_content.txt`](../practice/tip-05-find-and-replace-by-hand/1_copy_content.txt) — change the "content" that means *copy* to `copy`, but leave the "content" that means *happy* alone. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Does |
| --- | --- | --- |
| `*` | Normal | Search for the whole word under the cursor |
| `n` | Normal | Jump to the next match of that search |
| `N` | Normal | Jump to the previous match |
| `cw` | Normal → Insert | Delete to end of word and enter Insert mode (= `ce`) |
| `.` | Normal | Repeat the last change |
| `:set hls` | Command | Turn on search-match highlighting (if not already on) |

## How it works

The excerpt uses the word "content" on every line, but it's a **heteronym**: sometimes it means *copy* (con-**tent**), sometimes *happy* (**con**-tent). A blind `:%s/content/copy/g` would wreck "If you are content with this" → "If you are copy with this." So you need to judge each match by eye.

The technique fits the chapter's theme — a repeatable change plus a repeatable motion — but adds human judgment between repeats:

1. **Search without typing:** put the cursor on "content" and press `*`. Vim searches for the whole word, jumps to the next match, and highlights all occurrences (enable with `:set hls` if you see none — Tip 80).
2. **Make the change once:** `cw` deletes to the end of the word and enters Insert mode; type `copy` and `<Esc>`. The whole `cwcopy<Esc>` is one change, so `.` can replay it.
3. **Vet and repeat:** `n` advances to the next match. Look at it. If it should change, press `.`. If not, just press `n` again to skip. Rinse and repeat.

## Example

Starting buffer (`1_copy_content.txt`), cursor on "content" in line 1:

```
...We're waiting for content before the site can go live...
...If you are content with this, let's go ahead with it...
...We'll launch as soon as we have the content...
```

Keystrokes:

```
*             search "content"; cursor jumps to next match (line 2)
              — but line 2 is the "happy" meaning, so DON'T change it
n             advance to next match (line 3)
cwcopy<Esc>   ...we have the copy...
n             wrap back to line 1's match
.             ...waiting for copy before...
```

Result: lines 1 and 3 become "copy"; line 2's "content" is left untouched.

## Why it matters / when to reach for it

This is the manual, safer cousin of find-and-replace. Reach for it when the search term is ambiguous, or when you simply want to *see* each match before committing. `n.` (or `n` to skip, `.` to apply) gives you find-and-replace with a per-match veto — no regex gymnastics needed to exclude the false positives.

If it turns out every match *should* change, you may as well have used `:%s/content/copy/g`. And `:substitute` has its own confirm flag (`/gc`) for eyeballing matches — see Tip 89. This tip is the keystroke-driven alternative.

## Gotchas

- `*` matches the **whole word** (adds `\<...\>` boundaries). Use `g*` to match the word as a substring too.
- `*` also *moves* the cursor to the next match immediately. So the first thing to inspect after `*` is the match it jumped to, not the one you started on. `*NN`/`n` lets you cycle.
- `cw` behaves like `ce` (up to the end of the word, not into the next word's whitespace) — a deliberate Vim quirk. Start with the cursor on the *first* letter so the whole word is replaced.
- No highlighting? `:set hls` (see Tip 80). Clear the highlight afterward with `:noh`.

## Related

- Tip 1 — Meet the Dot Command
- Tip 4 — Act, Repeat, Reverse (`n`/`N`)
- Tip 6 — Meet the Dot Formula
- Tip 80 — Highlight Search Matches (`hlsearch`)
- Tip 89 — Eyeball Each Substitution (`:s///gc`)
