# Tip 44 — Save Files to Nonexistent Directories

> Chapter 7 — Open Files and Save Them to Disk · *Practical Vim* (Drew Neil)

**One-liner:** Vim lets you edit a buffer whose path has missing directories, but `:write` then fails with `E212` — fix it by creating the dirs first: `:!mkdir -p %:h`.

**Practice file:** none — try it: `:edit madeup/dir/new.txt`, add text, `:write` (see the error), then `:!mkdir -p %:h` and `:write` again. (Delete `madeup/` afterward.)

## Commands

| Command | Effect |
| --- | --- |
| `:edit {file}` | Open (or create a new buffer for) a filepath |
| `<C-g>` | Echo the current file's name and status |
| `:write` | Write the buffer to its file |
| `:!mkdir -p %:h` | Shell out to create the buffer's directory (and parents) |

## How it works

`:edit {file}` on a path that doesn't exist yet just creates a **new empty buffer** (press `<C-g>` and it's labeled "new file"). `:write` then creates the file. Fine — *unless the directories in the path don't exist either*:

```
:edit madeup/dir/doesnotexist.yet
:write
"madeup/dir/doesnotexist.yet" E212: Can't open file for writing
```

Here `madeup/dir` doesn't exist, so the buffer is labeled "new DIRECTORY" and `:write` can't create the file — Vim doesn't make intermediate directories for you.

**The fix** — create them with the external `mkdir`:

```
:!mkdir -p %:h
:write
```

- `%:h` = the active buffer's directory (`%` = its path, `:h` strips the filename — Tip 41).
- `-p` makes `mkdir` create all missing intermediate directories (and not error if they exist).

## Example

```
:edit src/newmodule/utils/helpers.js   (none of these dirs exist)
{type some code}
:write                                  → E212
:!mkdir -p %:h                          create src/newmodule/utils
:write                                  now succeeds
```

## Why it matters / when to reach for it

Common when scaffolding: you type a full path for a brand-new file in a not-yet-created folder, edit happily, then hit `E212` on save. `:!mkdir -p %:h` resolves it in place without leaving Vim or retyping the path. Some people wrap this in an autocommand/plugin (e.g. auto-mkdir on save), but the one-liner is worth knowing.

## Gotchas

- `E212` here means "the directory doesn't exist," not a permission problem (that's Tip 45).
- `%:h` depends on the buffer already having the intended path — which it does, since `:edit` set it.
- `mkdir -p` is a Unix shell command; on Windows the equivalent differs.
- After `:!mkdir`, remember the actual `:write` — creating the dir doesn't save the buffer.

## Related

- Tip 41 — Open a File by Its Filepath (`%`, `%:h`)
- Tip 35 — Run Commands in the Shell (`:!`)
- Tip 45 — Save a File as the Super User (the *permission* case)
