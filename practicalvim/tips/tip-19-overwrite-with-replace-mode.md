# Tip 19 — Overwrite Existing Text with Replace Mode

> Chapter 3 — Insert Mode · *Practical Vim* (Drew Neil)

**One-liner:** Replace mode (`R`) is like Insert mode but it **overwrites** existing characters instead of pushing them right; `gR` (Virtual Replace) handles tabs sanely, and `r`/`gr` overwrite a single character.

**Practice file:** [`../practice/tip-19-overwrite-with-replace-mode/replace.txt`](../practice/tip-19-overwrite-with-replace-mode/replace.txt) — merge the two sentences into one by overwriting `. B` with `, b`. Reset with `u` or `:e!`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `R` | Normal → Replace | Enter Replace mode: typing overwrites existing text |
| `gR` | Normal → Virtual Replace | Replace mode that treats tabs as spaces (fewer surprises) |
| `r{char}` | Normal | Overwrite **one** character, then back to Normal |
| `gr{char}` | Normal | Virtual single-shot overwrite of one character |
| `<Esc>` | Replace → Normal | Leave Replace mode |
| `<Insert>` | Insert ↔ Replace | Toggle between the two (if your keyboard has the key) |

## How it works

In Insert mode, characters you type are *inserted* and existing text shifts right. In **Replace mode** they *overwrite* the characters under the cursor — the line length doesn't grow. Enter it from Normal mode with `R`, type your replacement, and press `<Esc>` to finish.

## Example

Starting `replace.txt`:

```
Typing in Insert mode extends the line. But in Replace mode
the line length doesn't change.
```

Goal: join the two sentences — change `. B` to `, b`.

```
f.        jump to the period
R,b<Esc>  Replace mode overwrites ". B" with ", b"
```

Result:

```
Typing in Insert mode extends the line, but in Replace mode
the line length doesn't change.
```

Typing `, b` overwrote the existing `. B` character-for-character.

## Virtual Replace mode (`gR`) — the tab problem

A tab is **one** character in the file but expands onscreen to several columns (`tabstop`, default 8). In plain Replace mode, overwriting a tab replaces all eight columns with your one character — the line appears to shrink drastically.

**Virtual Replace mode (`gR`)** works on *screen real estate* rather than file characters. On an 8-column tab you can type up to seven characters (each inserted in front of the tab) before the eighth finally replaces the tab stop. This produces far fewer surprises, so Neil recommends **preferring `gR` over `R`** whenever possible.

## Single-shot: `r` and `gr`

To overwrite just one character without a full mode switch, use `r{char}` — e.g. `ra` turns the character under the cursor into `a` and stays in Normal mode. `gr{char}` is the virtual variant. (`:h r`.) These are among the most-used Normal-mode commands for quick single-character fixes.

## Gotchas

- Plain `R` + tabs = length surprises; reach for `gR` when tabs are in play.
- Replace mode keeps overwriting until `<Esc>` — easy to clobber more than intended past the end of your replacement.
- `r{char}` is a one-shot and repeatable with `.`; great for fixing a single typo'd character.
- `<Insert>` toggling depends on your keyboard/terminal actually sending the key.

## Related

- Tip 13 — Make Corrections Instantly from Insert Mode
- Tip 14 — Get Back to Normal Mode
- Tip 17 — Insert Unusual Characters by Character Code (tab/`expandtab` interplay)
