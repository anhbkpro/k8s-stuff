# Chapter 1 — Getting Started with Ansible

## Key ideas

- **Snowflake servers**: hand-configured, undocumented servers that can't be
  recreated reliably. Shell scripts help but don't handle every edge case.
- **Idempotence**: running an operation once or a thousand times produces the
  same result. Most Ansible *modules* are idempotent (a second run reports
  no change). Raw shell commands (`-a "..."`) are **not** — Ansible has no
  way to know if they changed anything, so they always report `CHANGED`.
  Saw this directly below: `ping` module → `SUCCESS`/`changed: false`,
  but the raw `vm_stat` command → `CHANGED` every time.
- Ansible needs no agent on managed hosts — it pushes changes over SSH.

## Setup

Installed via `pip3 install --user ansible` (already present:
`ansible [core 2.15.13]`). The pip user bin dir
(`~/Library/Python/3.9/bin`) was already wired into `~/.zshrc`.

## Deviation from the book

The book's examples target a spare remote server reached over SSH
(`www.example.com`, `-u [username]`). I don't have one set up yet — that
comes in Chapter 2 with Vagrant — so `hosts.ini` points at `localhost` via
`ansible_connection=local` instead, which skips SSH entirely and runs
commands directly on this Mac. Revisit with a real SSH target once Ch.2's
Vagrant box exists, to also exercise the passwordless-SSH assumption the
book calls out.

## Commands run

```ini
# hosts.ini
[example]
localhost ansible_connection=local
```

```bash
$ ansible -i hosts.ini example -m ping
localhost | SUCCESS => {
    "ansible_facts": { "discovered_interpreter_python": "/usr/bin/python3" },
    "changed": false,
    "ping": "pong"
}
```

The book's second example is `free -h` (Linux memory stats), which doesn't
exist on macOS — swapped in `vm_stat`, the macOS equivalent, since ad-hoc
raw commands aren't portable across OSes (part of why real modules exist):

```bash
$ ansible -i hosts.ini example -a "vm_stat"
localhost | CHANGED | rc=0 >>
Mach Virtual Memory Statistics: (page size of 16384 bytes)
Pages free: ...
```

Also got a Python-interpreter-discovery warning (Ansible auto-detected
`/usr/bin/python3`) — worth pinning explicitly later via
`ansible_python_interpreter` in inventory once this grows beyond one host.
