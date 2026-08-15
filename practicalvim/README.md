# Practical Vim — Learning Log

Working through *Practical Vim: Edit Text at the Speed of Thought* (Drew Neil), one or a few tips at a time. Each tip gets its own file in [`tips/`](./tips/). This README is the index and progress tracker.

**Progress:** 45 / 121 tips documented. ✅ Chapters 1–7 complete.

## How I use this

- Learn a tip (or a few) from the book.
- Copy [`_TEMPLATE.md`](./tips/_TEMPLATE.md) to `tips/tip-NN-slug.md`, or just ask Claude to write it up.
- The book's sample file(s) for that tip get copied into [`practice/tip-NN-slug/`](./practice/) so I can try the keystrokes on the real text. (Sourced from the book's code at `technical-books/tools/code`.)
- Fill in the keystrokes, what they do, and a real example I tried.
- Check the box below and bump the progress count.

Reset a practice file after experimenting: press `u` to undo, or `:e!` to reload the pristine copy from disk.

Legend: `[x]` done · `[ ]` not yet.

---

## Chapter 1 — The Vim Way

- [x] Tip 1 — [Meet the Dot Command](./tips/tip-01-meet-the-dot-command.md)
- [x] Tip 2 — [Don't Repeat Yourself](./tips/tip-02-dont-repeat-yourself.md)
- [x] Tip 3 — [Take One Step Back, Then Three Forward](./tips/tip-03-one-step-back-three-forward.md)
- [x] Tip 4 — [Act, Repeat, Reverse](./tips/tip-04-act-repeat-reverse.md)
- [x] Tip 5 — [Find and Replace by Hand](./tips/tip-05-find-and-replace-by-hand.md)
- [x] Tip 6 — [Meet the Dot Formula](./tips/tip-06-meet-the-dot-formula.md)

## Part I — Modes

### Chapter 2 — Normal Mode

- [x] Tip 7 — [Pause with Your Brush Off the Page](./tips/tip-07-pause-with-your-brush-off-the-page.md)
- [x] Tip 8 — [Chunk Your Undos](./tips/tip-08-chunk-your-undos.md)
- [x] Tip 9 — [Compose Repeatable Changes](./tips/tip-09-compose-repeatable-changes.md)
- [x] Tip 10 — [Use Counts to Do Simple Arithmetic](./tips/tip-10-use-counts-to-do-simple-arithmetic.md)
- [x] Tip 11 — [Don't Count If You Can Repeat](./tips/tip-11-dont-count-if-you-can-repeat.md)
- [x] Tip 12 — [Combine and Conquer](./tips/tip-12-combine-and-conquer.md)

### Chapter 3 — Insert Mode

- [x] Tip 13 — [Make Corrections Instantly from Insert Mode](./tips/tip-13-make-corrections-instantly-from-insert-mode.md)
- [x] Tip 14 — [Get Back to Normal Mode](./tips/tip-14-get-back-to-normal-mode.md)
- [x] Tip 15 — [Paste from a Register Without Leaving Insert Mode](./tips/tip-15-paste-from-register-in-insert-mode.md)
- [x] Tip 16 — [Do Back-of-the-Envelope Calculations in Place](./tips/tip-16-back-of-the-envelope-calculations.md)
- [x] Tip 17 — [Insert Unusual Characters by Character Code](./tips/tip-17-insert-unusual-characters-by-character-code.md)
- [x] Tip 18 — [Insert Unusual Characters by Digraph](./tips/tip-18-insert-unusual-characters-by-digraph.md)
- [x] Tip 19 — [Overwrite Existing Text with Replace Mode](./tips/tip-19-overwrite-with-replace-mode.md)

### Chapter 4 — Visual Mode

- [x] Tip 20 — [Grok Visual Mode](./tips/tip-20-grok-visual-mode.md)
- [x] Tip 21 — [Define a Visual Selection](./tips/tip-21-define-a-visual-selection.md)
- [x] Tip 22 — [Repeat Line-Wise Visual Commands](./tips/tip-22-repeat-line-wise-visual-commands.md)
- [x] Tip 23 — [Prefer Operators to Visual Commands Where Possible](./tips/tip-23-prefer-operators-to-visual-commands.md)
- [x] Tip 24 — [Edit Tabular Data with Visual-Block Mode](./tips/tip-24-edit-tabular-data-with-visual-block.md)
- [x] Tip 25 — [Change Columns of Text](./tips/tip-25-change-columns-of-text.md)
- [x] Tip 26 — [Append After a Ragged Visual Block](./tips/tip-26-append-after-a-ragged-visual-block.md)

### Chapter 5 — Command-Line Mode

- [x] Tip 27 — [Meet Vim's Command Line](./tips/tip-27-meet-vims-command-line.md)
- [x] Tip 28 — [Execute a Command on One or More Consecutive Lines](./tips/tip-28-execute-command-on-consecutive-lines.md)
- [x] Tip 29 — [Duplicate or Move Lines Using `:t` and `:m` Commands](./tips/tip-29-duplicate-or-move-lines.md)
- [x] Tip 30 — [Run Normal Mode Commands Across a Range](./tips/tip-30-run-normal-commands-across-a-range.md)
- [x] Tip 31 — [Repeat the Last Ex Command](./tips/tip-31-repeat-the-last-ex-command.md)
- [x] Tip 32 — [Tab-Complete Your Ex Commands](./tips/tip-32-tab-complete-your-ex-commands.md)
- [x] Tip 33 — [Insert the Current Word at the Command Prompt](./tips/tip-33-insert-current-word-at-command-prompt.md)
- [x] Tip 34 — [Recall Commands from History](./tips/tip-34-recall-commands-from-history.md)
- [x] Tip 35 — [Run Commands in the Shell](./tips/tip-35-run-commands-in-the-shell.md)

## Part II — Files

### Chapter 6 — Manage Multiple Files

- [x] Tip 36 — [Track Open Files with the Buffer List](./tips/tip-36-track-open-files-with-buffer-list.md)
- [x] Tip 37 — [Group Buffers into a Collection with the Argument List](./tips/tip-37-argument-list.md)
- [x] Tip 38 — [Manage Hidden Files](./tips/tip-38-manage-hidden-files.md)
- [x] Tip 39 — [Divide Your Workspace into Split Windows](./tips/tip-39-divide-workspace-into-split-windows.md)
- [x] Tip 40 — [Organize Your Window Layouts with Tab Pages](./tips/tip-40-organize-window-layouts-with-tab-pages.md)

### Chapter 7 — Open Files and Save Them to Disk

- [x] Tip 41 — [Open a File by Its Filepath Using `:edit`](./tips/tip-41-open-file-by-filepath.md)
- [x] Tip 42 — [Open a File by Its Filename Using `:find`](./tips/tip-42-open-file-by-filename.md)
- [x] Tip 43 — [Explore the File System with netrw](./tips/tip-43-explore-filesystem-with-netrw.md)
- [x] Tip 44 — [Save Files to Nonexistent Directories](./tips/tip-44-save-files-to-nonexistent-directories.md)
- [x] Tip 45 — [Save a File as the Super User](./tips/tip-45-save-a-file-as-the-super-user.md)

## Part III — Getting Around Faster

### Chapter 8 — Navigate Inside Files with Motions

- [ ] Tip 46 — Keep Your Fingers on the Home Row
- [ ] Tip 47 — Distinguish Between Real Lines and Display Lines
- [ ] Tip 48 — Move Word-Wise
- [ ] Tip 49 — Find by Character
- [ ] Tip 50 — Search to Navigate
- [ ] Tip 51 — Trace Your Selection with Precision Text Objects
- [ ] Tip 52 — Delete Around, or Change Inside
- [ ] Tip 53 — Mark Your Place and Snap Back to It
- [ ] Tip 54 — Jump Between Matching Parentheses

### Chapter 9 — Navigate Between Files with Jumps

- [ ] Tip 55 — Traverse the Jump List
- [ ] Tip 56 — Traverse the Change List
- [ ] Tip 57 — Jump to the Filename Under the Cursor
- [ ] Tip 58 — Snap Between Files Using Global Marks

## Part IV — Registers

### Chapter 10 — Copy and Paste

- [ ] Tip 59 — Delete, Yank, and Put with Vim's Unnamed Register
- [ ] Tip 60 — Grok Vim's Registers
- [ ] Tip 61 — Replace a Visual Selection with a Register
- [ ] Tip 62 — Paste from a Register
- [ ] Tip 63 — Interact with the System Clipboard

### Chapter 11 — Macros

- [ ] Tip 64 — Record and Execute a Macro
- [ ] Tip 65 — Normalize, Strike, Abort
- [ ] Tip 66 — Play Back with a Count
- [ ] Tip 67 — Repeat a Change on Contiguous Lines
- [ ] Tip 68 — Append Commands to a Macro
- [ ] Tip 69 — Act Upon a Collection of Files
- [ ] Tip 70 — Evaluate an Iterator to Number Items in a List
- [ ] Tip 71 — Edit the Contents of a Macro

## Part V — Patterns

### Chapter 12 — Matching Patterns and Literals

- [ ] Tip 72 — Tune the Case Sensitivity of Search Patterns
- [ ] Tip 73 — Use the `\v` Pattern Switch for Regex Searches
- [ ] Tip 74 — Use the `\V` Literal Switch for Verbatim Searches
- [ ] Tip 75 — Use Parentheses to Capture Submatches
- [ ] Tip 76 — Stake the Boundaries of a Word
- [ ] Tip 77 — Stake the Boundaries of a Match
- [ ] Tip 78 — Escape Problem Characters

### Chapter 13 — Search

- [ ] Tip 79 — Meet the Search Command
- [ ] Tip 80 — Highlight Search Matches
- [ ] Tip 81 — Preview the First Match Before Execution
- [ ] Tip 82 — Count the Matches for the Current Pattern
- [ ] Tip 83 — Offset the Cursor to the End of a Search Match
- [ ] Tip 84 — Operate on a Complete Search Match
- [ ] Tip 85 — Create Complex Patterns by Iterating upon Search History
- [ ] Tip 86 — Search for the Current Visual Selection

### Chapter 14 — Substitution

- [ ] Tip 87 — Meet the Substitute Command
- [ ] Tip 88 — Find and Replace Every Match in a File
- [ ] Tip 89 — Eyeball Each Substitution
- [ ] Tip 90 — Reuse the Last Search Pattern
- [ ] Tip 91 — Replace with the Contents of a Register
- [ ] Tip 92 — Repeat the Previous Substitute Command
- [ ] Tip 93 — Rearrange CSV Fields Using Submatches
- [ ] Tip 94 — Perform Arithmetic on the Replacement
- [ ] Tip 95 — Swap Two or More Words
- [ ] Tip 96 — Find and Replace Across Multiple Files

### Chapter 15 — Global Commands

- [ ] Tip 97 — Meet the Global Command
- [ ] Tip 98 — Delete Lines Containing a Pattern
- [ ] Tip 99 — Collect TODO Items in a Register
- [ ] Tip 100 — Alphabetize the Properties of Each Rule in a CSS File

## Part VI — Tools

### Chapter 16 — Index and Navigate Source Code with ctags

- [ ] Tip 101 — Meet ctags
- [ ] Tip 102 — Configure Vim to Work with ctags
- [ ] Tip 103 — Navigate Keyword Definitions with Vim's Tag Navigation Commands

### Chapter 17 — Compile Code and Navigate Errors with the Quickfix List

- [ ] Tip 104 — Compile Code Without Leaving Vim
- [ ] Tip 105 — Browse the Quickfix List
- [ ] Tip 106 — Recall Results from a Previous Quickfix List
- [ ] Tip 107 — Customize the External Compiler

### Chapter 18 — Search Project-Wide with grep, vimgrep, and Others

- [ ] Tip 108 — Call grep Without Leaving Vim
- [ ] Tip 109 — Customize the grep Program
- [ ] Tip 110 — Grep with Vim's Internal Search Engine

### Chapter 19 — Dial X for Autocompletion

- [ ] Tip 111 — Meet Vim's Keyword Autocompletion
- [ ] Tip 112 — Work with the Autocomplete Pop-Up Menu
- [ ] Tip 113 — Understand the Source of Keywords
- [ ] Tip 114 — Autocomplete Words from the Dictionary
- [ ] Tip 115 — Autocomplete Entire Lines
- [ ] Tip 116 — Autocomplete Filenames
- [ ] Tip 117 — Autocomplete with Context Awareness

### Chapter 20 — Find and Fix Typos with Vim's Spell Checker

- [ ] Tip 118 — Spell Check Your Work
- [ ] Tip 119 — Use Alternate Spelling Dictionaries
- [ ] Tip 120 — Add Words to the Spell File
- [ ] Tip 121 — Fix Spelling Errors from Insert Mode
