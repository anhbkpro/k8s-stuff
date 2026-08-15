# Tip 47 — Distinguish Between Real Lines and Display Lines

> Chapter 8 — Navigate Inside Files with Motions · *Practical Vim* (Drew Neil)

**One-liner:** `j`/`k`/`0`/`$` move by **real** lines (the actual lines in the file); prefix with `g` (`gj`/`gk`/`g0`/`g$`) to move by **display** lines when text is wrapped.

**Practice file:** none — enable `:set wrap number`, make a very long line, and compare `j` vs `gj`.

## Commands

| Command | Move cursor |
| --- | --- |
| `j` / `k` | Down / up one **real** line |
| `gj` / `gk` | Down / up one **display** line |
| `0` | First character of the **real** line |
| `g0` | First character of the **display** line |
| `^` / `g^` | First non-blank of real / display line |
| `$` / `g$` | End of real / display line |

Pattern: `j`, `k`, `0`, `^`, `$` act on real lines; **prefix `g`** to act on display lines.

## How it works

Vim distinguishes a **real line** (one line in the file) from a **display line** (one row on screen). With `wrap` on (the default), a real line longer than the window wraps onto several display lines — so one file line occupies multiple screen rows.

Easiest way to see it: `:set number`. Numbered rows are real-line starts; wrapped continuation rows have **no** number. A buffer with 3 real lines might occupy 9 display lines.

This matters because the motions differ. `k` moves up one *real* line — potentially jumping over several wrapped rows — whereas `gk` moves up one *display* line (the visible row above). If your target is the wrapped row just above the cursor, `gk` lands there; `k` overshoots to the previous real line.

## Example

Long wrapped paragraph, cursor mid-line, target is the visible row directly above:

```
gk    up one display line  → lands on the row you see above
k     up one real line     → jumps to the previous file line (overshoots)
```

## Why it matters / when to reach for it

Coming from editors that only know display lines, Vim's default (`j`/`k` = real lines) can feel surprising when navigating wrapped prose. Use `gj`/`gk` for visual, row-by-row movement in wrapped text; use plain `j`/`k` for structural, file-line movement (and they cover more ground per keystroke over wrapped text). Same logic for `g0`/`g$` to reach the start/end of a *visible* row vs the whole line.

## Remap sidebar

To make `j`/`k` follow display lines by default (swapping the roles):

```vim
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
```

Neil cautions against this if you use Vim on many machines — better to internalize the defaults. A common middle ground is to remap only "when there's no count" so `5j` still uses real lines.

## Gotchas

- Default `j`/`k` = real lines; wrapped prose can make them "skip" visually — that's `gj`/`gk`'s job.
- `0`/`^`/`$` likewise target the whole real line; `g0`/`g^`/`g$` target the display row.
- If you turn `wrap` off, real and display lines coincide and the `g` variants don't differ.
- Relative line numbers (`relativenumber`) count **real** lines — useful for `{count}j/k`.

## Related

- Tip 46 — Keep Your Fingers on the Home Row (`j`/`k`)
- Tip 48 — Move Word-Wise
- Tip 21 / 28 — line-wise operations
