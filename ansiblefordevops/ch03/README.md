# Chapter 3 — Ad-Hoc Commands

## Key ideas

- Ad-hoc commands (`ansible <group> -a "..."` / `-m <module> -a "..."`) are
  for one-off tasks and exploration; playbooks (later chapters) are for
  anything you want repeatable and idempotent.
- Ansible runs ad-hoc commands **in parallel** across matched hosts by
  default (forks); `-f 1` forces serial, deterministic-order execution.
- `-b` (`--become`) = sudo. `-K` (`--ask-become-pass`) if the remote user
  needs a password for it.
- `--limit <pattern>` narrows a group command down to one host (exact
  string, `*` wildcard, or `~regex`) — handy for a one-off fix, but if
  you reach for the same `--limit` repeatedly, put those hosts in their
  own inventory group instead.
- Prefer Ansible's typed modules (`dnf`, `service`, `user`, ...) over raw
  shell commands: modules are idempotent and report `changed`/`ok`
  accurately; raw commands (`-a "..."`) always report `CHANGED` because
  Ansible has no way to know if they actually changed anything.
- Filtering command output (`grep`, pipes) requires `-m shell` — the
  default `command` module doesn't invoke a shell, so pipes/redirects
  are passed through literally instead of being interpreted.

## Deviation from the book

Same reasoning as [Chapter 2](../ch02/README.md): VirtualBox doesn't work
reliably on this Apple Silicon Mac, so the book's 3-VM topology (2 app
servers + 1 db server, defined with `config.vm.define` + VirtualBox +
static `192.168.56.x` private-network IPs) is rebuilt here with Vagrant's
**Docker provider**, reusing the sshd-enabled Rocky Linux 8 image built in
Chapter 2 (see that chapter's README for why: no sshd in the base CI image,
`openssh-clients` needed for `scp`, systemd needs `--privileged
--cgroupns=host` + tmpfs mounts).

Differences that follow from that:

- **No static private-network IPs** — Docker containers don't get one the
  way a VirtualBox VM with `:private_network` does. Each container's sshd
  is instead published to a host port (`vagrant up` assigned 2200/2201/2202
  for app2/app1/db), and `hosts.ini` points at `127.0.0.1:<port>` per host
  instead of a `192.168.56.x` address.
- Used `app1`/`app2`/`db` as inventory *hostnames* instead of raw IPs —
  closer to how you'd actually name hosts in a real inventory, but it
  means the `db` group and the `db` host share a name, which Ansible
  warns about (`Found both group and host with same name: db`). Harmless
  here, but the book's IP-based naming avoids the collision entirely —
  worth remembering for real inventories.
- `df -h` / `free -m` / `date` come back **near-identical across all
  three hosts**, since Docker containers on the same Mac share the host
  kernel's clock and a common disk pool — unlike the book's separate
  VirtualBox VMs, which have their own virtual disks and slightly
  independent clocks.

## Environment

```ini
# hosts.ini
[app]
app1 ansible_host=127.0.0.1 ansible_port=2201
app2 ansible_host=127.0.0.1 ansible_port=2200

[db]
db ansible_host=127.0.0.1 ansible_port=2202

[multi:children]
app
db

[multi:vars]
ansible_user=root
ansible_ssh_private_key_file=./.vagrant_insecure_key
```

```ini
# ansible.cfg
[defaults]
inventory = hosts.ini
host_key_checking = False
```

## Commands run

### Parallel nature

```bash
$ ansible multi -a "hostname"
app2 | CHANGED | rc=0 >> orc-app2.test
app1 | CHANGED | rc=0 >> orc-app1.test
db   | CHANGED | rc=0 >> orc-db.test

$ ansible multi -a "hostname"        # order shuffles run to run
db | CHANGED | ...
app1 | CHANGED | ...
app2 | CHANGED | ...

$ ansible multi -a "hostname" -f 1   # forced serial -> deterministic, inventory order
app1 | CHANGED | ...
app2 | CHANGED | ...
db   | CHANGED | ...
```

### Environment checks

`df -h`, `free -m`, `date` all ran cleanly across the three hosts (see
deviation note above on why the numbers are nearly identical here).

### Module-based install (chrony)

```bash
$ ansible multi -b -m dnf -a "name=chrony state=present"
db   | CHANGED => Installed: ... chrony-4.5-2.el8_10.aarch64
app1 | CHANGED => Installed: ... chrony-4.5-2.el8_10.aarch64
app2 | FAILED!  => Failed to download metadata for repo 'baseos': ... Cannot download, all mirrors were already tried without success
```

`app2` hit a transient dnf-mirror timeout on the first run — a real lesson
ad-hoc commands don't hide: no automatic retry, and three containers
hammering the same mirror at once is exactly the kind of thing that
occasionally times out. Just re-ran the same command:

```bash
$ ansible multi -b -m dnf -a "name=chrony state=present"   # re-run
app1 | SUCCESS => "msg": "Nothing to do"     # already installed, no-op
db   | SUCCESS => "msg": "Nothing to do"     # already installed, no-op
app2 | CHANGED  => Installed: ... chrony-4.5-2.el8_10.aarch64   # catches up
```

That's idempotence working exactly as intended even after a partial
failure: hosts that already converged stay untouched, the one that didn't
just does the install on the next pass.

```bash
$ ansible multi -b -m service -a "name=chronyd state=started enabled=yes"
# all three: changed=true, enabled=true, state=started

$ ansible multi -b -a "chronyc tracking"
# Stratum 0, "Not synchronised" on all three
```

`chronyc tracking` shows **not synchronised** on all three, unlike the
book's real VMs — these containers can't reach real NTP servers over the
network the way a normal Vagrant/VirtualBox VM can. The install/enable
steps themselves are the point here and worked identically to the book.

### Configure the application servers (Django via pip)

```bash
$ ansible app -b -m dnf -a "name=python3-pip state=present"
$ ansible app -b -m pip -a "executable=pip3 name=django<4 state=present"
$ ansible app -a "python3 -m django --version"
app1 | CHANGED | rc=0 >> 3.2.25
app2 | CHANGED | rc=0 >> 3.2.25
```

### Configure the database server (MariaDB)

```bash
$ ansible db -b -m dnf -a "name=mariadb-server state=present"
$ ansible db -b -m service -a "name=mariadb state=started enabled=yes"
$ ansible db -b -m dnf -a "name=python3-PyMySQL state=present"
$ ansible db -b -m mysql_user -a "name=django host=% password=12345 priv=*.*:ALL state=present"
db | CHANGED => "msg": "User added"
```

Skipped the book's `firewalld` zone/source/port setup for this chapter —
`firewalld` needs real netfilter/D-Bus access that's unreliable inside a
plain Docker container even with `--privileged`, and it's not central to
the ad-hoc-commands lesson this chapter is teaching. Worth revisiting for
real once a chapter is specifically about server security (Ch.11 in this
book) on a real VM.

### Make changes to just one server (`--limit`)

```bash
$ ansible app -b -a "service chronyd restart" --limit "app1"    # exact name
$ ansible app -b -a "service chronyd restart" --limit "*1"      # wildcard
$ ansible app -b -a "service chronyd restart" --limit ~".*1"    # regex
```

All three patterns correctly hit only `app1`, matching the book (which
uses IP-suffix patterns like `*.4` — same mechanism, adapted since these
hosts are named rather than IP-addressed).

### Manage users and groups

```bash
$ ansible app -b -m group -a "name=admin state=present"
$ ansible app -b -m user -a "name=johndoe group=admin createhome=yes"
$ ansible app -a "id johndoe"                                    # verify
$ ansible app -b -m user -a "name=johndoe state=absent remove=yes"  # cleanup
```

### Manage packages (cross-platform `package` module)

```bash
$ ansible app -b -m package -a "name=git state=present"
# pulls in git + perl toolchain — real Rocky package, not a stub
```

### Manage files and directories

```bash
$ ansible multi -m stat -a "path=/etc/hosts"
$ ansible multi -m copy -a "src=/etc/hosts dest=/tmp/hosts"
$ ansible multi -b -m fetch -a "src=/tmp/hosts dest=/tmp/ch03-fetch"
# lands at /tmp/ch03-fetch/<hostname>/tmp/hosts per host, as documented
$ ansible multi -m file -a "src=/tmp/hosts dest=/tmp/hosts-link state=link"
$ ansible multi -m file -a "dest=/tmp/test mode=644 state=directory"
$ ansible multi -m file -a "dest=/tmp/test state=absent"
```

One real mistake worth keeping in the log: first tried `copy` with
`src=/etc/hostname`. That failed — `copy`'s `src` is a path **on the
control machine** (this Mac), not the remote host, and macOS has no
`/etc/hostname`. Switched to `/etc/hosts`, which exists on macOS and is
also the book's own example.

### Run operations in the background (async jobs)

Used `sleep 15` instead of the book's `dnf -y update` — a full OS update
inside a minimal container is slow and not the point; the async/poll
mechanics are identical either way.

```bash
$ ansible multi -b -B 3600 -P 0 -a "sleep 15"
# returns immediately with an ansible_job_id per host, "finished": 0

$ ansible app1 -b -m async_status -a "jid=j323118075296.10124"
# after waiting: "finished": 1, "rc": 0, "delta": "0:00:15.003430"
```

### Check log files

```bash
$ ansible multi -b -a "test -f /var/log/messages"   # FAILED — file doesn't exist
$ ansible multi -a "rpm -q rsyslog"                  # FAILED — not installed
```

This minimal CI image doesn't run `rsyslog`, so there's no
`/var/log/messages` — only the systemd journal. Substituted `journalctl`
for the same lesson (raw command output, and the `command`-vs-`shell`
module distinction for pipes):

```bash
$ ansible multi -b -a "journalctl -n 5 --no-pager"      # works fine, no pipe
$ ansible multi -b -m shell -a "journalctl --no-pager | grep -c chronyd"
db | 73   app2 | 68   app1 | 81
```

### Manage cron jobs

```bash
$ ansible multi -b -m dnf -a "name=cronie state=present"
$ ansible multi -b -m service -a "name=crond state=started enabled=yes"
$ ansible multi -b -m cron -a "name='daily-cron-all-servers' hour=4 job='/path/to/daily-script.sh'"
$ ansible multi -b -a "crontab -l"
#Ansible: daily-cron-all-servers
* 4 * * * /path/to/daily-script.sh
$ ansible multi -b -m cron -a "name='daily-cron-all-servers' state=absent"
```

Rocky's cron package is `cronie`, not preinstalled — added it first (the
book's Vagrant boxes likely have it already). Everything else, including
the `#Ansible: <name>` marker comment, matched the book exactly.

### Deploy a version-controlled application

Used a small real public repo (`octocat/Hello-World` — GitHub's own tiny
canonical demo repo) in place of the book's fictitious
`git://example.com/path/to/repo.git`, and wrote a real one-line
`update.sh` since the demo repo has no `scripts/` directory or deploy
script of its own:

```bash
$ ansible app -b -m git -a "repo=https://github.com/octocat/Hello-World.git dest=/opt/myapp version=master"
$ ansible app -m file -a "dest=/opt/myapp/scripts state=directory"
$ ansible app -b -m copy -a "src=./update.sh dest=/opt/myapp/scripts/update.sh mode=0755"
$ ansible app -b -a "/opt/myapp/scripts/update.sh"
app1 | CHANGED | rc=0 >> Deploying 7fd1a60 at Sun Aug 16 05:43:57 UTC 2026
app2 | CHANGED | rc=0 >> Deploying 7fd1a60 at Sun Aug 16 05:43:57 UTC 2026
```

### Ansible's SSH connection history

Conceptual section, no hands-on needed: Ansible moved from `paramiko`
(pure-Python SSH2) to native OpenSSH as the default once `ControlPersist`
support was common (Ansible 1.3+), and `pipelining=True` under
`[ssh_connection]` in `ansible.cfg` speeds things up further by sending
module code over the open connection instead of copy → run → delete.
Not enabled in this project's `ansible.cfg` — worth turning on once a
later chapter's exercises are slow enough for the difference to matter.
