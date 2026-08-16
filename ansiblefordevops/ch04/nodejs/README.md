# Node.js App Server — Chapter 4 real-world playbook (hands-on)

Book's first "real-world" playbook: Rocky Linux + EPEL/Remi repos + npm +
`forever` (process manager) + a tiny Express app, all in one playbook run.

## Deviations from the book

Same environment reasoning as ch01–ch03: VirtualBox doesn't work reliably
on Apple Silicon, so this runs on the Docker+sshd+systemd Rocky Linux 8
image built in Chapter 2, via a dedicated single-machine Vagrantfile
(`d.ports = ["8080:80"]` maps the app's port 80 to `localhost:8080` on
the Mac, since there's no VirtualBox private network here).

Two real, unplanned issues came up running the book's playbook verbatim
— both fixed, not glossed over:

1. **`firewalld` isn't installed** in this minimal CI-oriented base image
   (same finding as Chapter 3's db-server section). The book's "stop
   firewalld" task assumes a fuller Rocky Linux install. Added
   `ignore_errors: yes` to that one task rather than removing it — it's
   a real thing the book does, it's genuinely a no-op on this image, and
   `ignore_errors` documents that honestly instead of silently deleting
   the task.
2. **EPEL's `npm` installs Node.js v10.24.0** (last touched years ago),
   but `npm install -g forever` always pulls forever's *current*
   dependency tree from the registry. That tree now includes
   `@so-ric/colorspace`, which uses numeric-literal-separator syntax
   (`0.003_130_8`) — valid in Node 12+, a hard `SyntaxError` on Node 10.
   First run failed exactly there. Verified `forever@1.0.0` installs
   cleanly against Node 10 (its dependency tree predates the syntax),
   pinned it in the playbook (`version: "1.0.0"`), and the full run
   succeeded. This is a real books-age-vs-package-registries problem:
   the playbook is correct as written, the *ecosystem* underneath it
   moved on.

## Commands run

```bash
$ ansible-playbook playbook.yml
...
TASK [Start example Node.js app.] ***********************************
changed: [nodejs]
PLAY RECAP *************************************************************
nodejs : ok=12   changed=1   unreachable=0   failed=0   skipped=0   ignored=1

$ curl http://localhost:8080/
Hello World!

$ ansible-playbook playbook.yml     # re-run — idempotence check
...
TASK [Start example Node.js app.] ***********************************
skipping: [nodejs]      # forever_list already shows the app running
PLAY RECAP *************************************************************
nodejs : ok=11   changed=0   unreachable=0   failed=0   skipped=1   ignored=1
```

The `skipping` on the second run is the book's `when:
forever_list.stdout.find(node_apps_location + '/app/app.js') == -1`
guard working exactly as designed: `register` captured `forever list`'s
output on this run, and since the app's path is already in that output,
the start task correctly refuses to launch a second copy.

## Files

- `Vagrantfile` / `Dockerfile` / `.vagrant_insecure_key(.pub)` —
  single-machine Docker+sshd VM, same pattern as ch02/ch03.
- `playbook.yml` — the book's playbook, with the two deviations above.
- `app/app.js`, `app/package.json` — the book's example Express app,
  copied verbatim.
