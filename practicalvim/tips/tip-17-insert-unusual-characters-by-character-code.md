# Tip 17 — Insert Unusual Characters by Character Code

> Chapter 3 — Insert Mode · *Practical Vim* (Drew Neil)

**One-liner:** From Insert mode, `<C-v>{code}` inserts any character by its numeric code — decimal (`<C-v>065`), hex Unicode (`<C-v>u00bf`) — and `ga` reports the code of the character under the cursor.

**Practice file:** none — try in any buffer: `<C-v>065` for "A", `<C-v>u00bf` for "¿", then put the cursor on a char and press `ga`.

## Commands

| Keys | Mode | Effect |
| --- | --- | --- |
| `<C-v>{123}` | Insert | Insert character by 3-digit **decimal** code |
| `<C-v>u{1234}` | Insert | Insert character by 4-digit **hexadecimal** (Unicode BMP) code |
| `<C-v>{nondigit}` | Insert | Insert the next non-digit key **literally** |
| `<C-k>{c1}{c2}` | Insert | Insert character from a **digraph** (see Tip 18) |
| `ga` | Normal | Show code of the character under the cursor (decimal + hex) |

## How it works

If you know a character's numeric code, `<C-v>{code}` inserts it from Insert mode — no need for it to exist on the keyboard.

- **Decimal:** Vim expects **three digits**. Uppercase "A" is code 65, so type `<C-v>065` (pad with a leading zero).
- **Hex / Unicode:** for codes beyond three digits, use `<C-v>u{1234}` — note the leading `u`, then a 4-digit hex code covering the Unicode Basic Multilingual Plane (up to 65,535 chars). The inverted question mark "¿" is `00bf`, so `<C-v>u00bf`. (`:h i_CTRL-V_digit`.)
- **Look up a code:** put the cursor on a character in your buffer and press `ga` — Vim prints its decimal and hex codes at the bottom (`:h ga`). Only works for characters already in the document; otherwise consult a Unicode table.

**Literal insert:** if `<C-v>` is followed by a **non-digit** key, that key is inserted literally. The classic use: `<C-v><Tab>` inserts a real tab even when `expandtab` would otherwise turn `<Tab>` into spaces.

## Reference — inserting unusual characters (Table 3)

| Keystrokes | Effect |
| --- | --- |
| `<C-v>{123}` | Insert character by decimal code |
| `<C-v>u{1234}` | Insert character by hexadecimal code |
| `<C-v>{nondigit}` | Insert nondigit literally |
| `<C-k>{char1}{char2}` | Insert character from a digraph |

## Why it matters / when to reach for it

Handy for symbols, accented letters, and typographic marks (—, ©, ¿, ½) without OS input tricks, and for forcing a literal tab regardless of `expandtab`. `ga` is the quick way to discover a code you can then reuse. If codes are hard to remember, the friendlier alternative is digraphs (Tip 18).

## Gotchas

- **Decimal needs padding to 3 digits** (`065`, not `65`) or Vim may interpret fewer digits ambiguously. Hex uses the `u` prefix and 4 digits.
- `<C-v>` is also the Visual-block trigger in Normal mode — here we mean its Insert-mode role.
- Beyond the BMP, Vim also supports `<C-v>U{12345678}` (capital `U`, 8-digit hex) for full Unicode.
- Terminal/font must actually support the glyph to display it correctly.

## Related

- Tip 16 — Do Back-of-the-Envelope Calculations in Place
- Tip 18 — Insert Unusual Characters by Digraph (`<C-k>`)
