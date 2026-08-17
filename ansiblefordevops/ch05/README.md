# Chapter 5 — Ansible Playbooks: Beyond the Basics

Dense, mechanics-focused chapter — mostly small self-contained concepts
rather than one big app stack, so nearly all of it was run for real on a
single Docker+sshd Rocky Linux 8 VM (same pattern as ch02–ch04). One file
per topic, matching the book's own section breakdown.

## Environment

Same Docker-provider setup as previous chapters (VirtualBox unreliable on
this Apple Silicon Mac) — see [ch02](../ch02/README.md) for the full
reasoning. Single host, `washington` inventory group (named to match the
book's own host/group-vars example), `ch05.test` hostname.

## `handlers.yml` — multi-notify + chained handlers

```bash
$ ansible-playbook handlers.yml
...
RUNNING HANDLER [restart chronyd] ***
changed: [ch05]
RUNNING HANDLER [restart crond] ***
changed: [ch05]
```

One task notified `restart chronyd` and `restart crond` together (a
`notify:` list); `restart chronyd` also has its own `notify: restart
crond`. Both fired once, at the end of the play, in handler-definition
order — exactly the "handlers can chain to other handlers" behavior the
book describes.

## `environment.yml` — per-task and global env vars

```bash
$ ansible-playbook environment.yml
...
"msg": "The variable is value_from_playbook"
...
"msg": ["https_proxy=https://example-proxy:443/", "http_proxy=http://example-proxy:80/"]
```

**Deviation**: the book sets a task's environment from a dict variable
with bare `environment: proxy_vars`. On this Ansible version (2.15) that
silently no-ops (`[WARNING]: could not parse environment value, skipping:
['proxy_vars']` — the get_url task then hit `127.0.0.1` directly instead
of routing through the fake proxy). Needed explicit Jinja templating,
`environment: "{{ proxy_vars }}"`, to actually apply it — confirmed by
watching the `get_url` task's error message change from *connection
refused* (hit `127.0.0.1` directly) to *name or service not known*
(actually tried to resolve `example-proxy`, proving the env var reached
the task).

## `variables.yml` — precedence, magic vars, list/dict access

```bash
$ ansible-playbook variables.yml
...
"msg": "admin_user resolves to 'jane' (host_vars 'jane' beats group_vars 'john')"
"msg": "Magic hostvars lookup from 'inside' the play: jane"
"msg": "cdn_host (inventory group var) = washington.static.example.com"
"msg": "groups = {'all': ['ch05'], 'ungrouped': [], 'washington': ['ch05']}"
"msg": "List access: foo_list[0]=one, foo_list|first=one"
"msg": "IPv4 via dot syntax: 172.17.0.7, via bracket syntax: 172.17.0.7"
```

Set up `group_vars/washington.yml` (`admin_user: john`) and
`host_vars/ch05.yml` (`admin_user: jane`) exactly as the book's
automatically-loaded directory convention describes — the host-level
value correctly won, matching the documented precedence order. The IP
(`172.17.0.7`) is a Docker bridge address rather than the book's
VirtualBox `10.0.2.15` — expected given the environment, not a real
deviation.

## `vault-demo.yml` + `vars/api_key.yml` — Ansible Vault

```bash
$ ansible-playbook vault-demo.yml                          # plaintext — works
"echo_result.stdout": "l9bTqfB1bXTQiDaJMqgPJ1VdeFLfId98"

$ ansible-vault encrypt vars/api_key.yml --vault-password-file .vault_pass.txt
$ ansible-playbook vault-demo.yml                          # no password — fails
ERROR! Attempting to decrypt but no vault secrets found

$ ansible-playbook vault-demo.yml --vault-password-file .vault_pass.txt
"echo_result.stdout": "l9bTqfB1bXTQiDaJMqgPJ1VdeFLfId98"   # works again
```

`vars/api_key.yml` is genuinely vault-encrypted in this repo right now
(`$ANSIBLE_VAULT;1.1;AES256` header) — used `--vault-password-file`
instead of the book's interactive `--ask-vault-pass` so the whole demo
could run non-interactively. `.vault_pass.txt` is gitignored — same rule
as the SSH private keys in earlier chapters: never commit a secret, even
a throwaway demo one.

## `conditionals.yml` — `when`, `changed_when`, `failed_when`, `ignore_errors`

```bash
$ ansible-playbook conditionals.yml
...
"msg": "software_version 4.6.1 is major version 4"     # Python .split() in a Jinja expression
skipping: [ch05]                                          # when: false correctly skips
...
"noisy_command failed=True, but the play continued"       # ignore_errors: yes
```

`changed_when`/`failed_when` demoed with a fake "Composer-style" no-op
detector and a `crontab -l` call where `failed_when: rc not in [0, 1]`
treats "no crontab yet" (`rc=1`) as success rather than failure — the
same shape as the book's Jenkins-CLI `failed_when` example.

## `delegation.yml` — `delegate_to`, `local_action`, `wait_for`

```bash
$ ansible-playbook delegation.yml
changed: [ch05 -> 127.0.0.1]      # delegate_to: 127.0.0.1
changed: [ch05 -> localhost]      # local_action shorthand
ok: [ch05 -> localhost]           # wait_for confirmed the SSH port is open
```

The `host -> delegate` arrow in the output is Ansible's own signal that
delegation worked — both forms landed on the controller, not `ch05`.

## `tags-demo.yml` — `--tags` / `--skip-tags`

```bash
$ ansible-playbook tags-demo.yml --tags "notifications,foo"
# ran only the 2 tagged tasks

$ ansible-playbook tags-demo.yml --skip-tags "notifications"
# ran 'foo' + the untagged task, skipped the notifications/say task
```

## `blocks.yml` — `block`/`rescue`/`always`

```bash
$ ansible-playbook blocks.yml
...
TASK [This will fail.] ***
fatal: [ch05]: FAILED! ...
TASK [This will only run in case of an error in the block.] ***
ok: [ch05] => {"msg": "There was an error in the block."}
TASK [This will always run, no matter what.] ***
ok: [ch05] => {"msg": "This always executes."}
PLAY RECAP ***
ch05 : ok=4 changed=0 ... rescued=1 ignored=0
```

`rescued=1` in the recap is the tell — the block's 3rd task never ran
(skipped once the block failed), `rescue` caught it, `always` ran
regardless, exactly the exception-handling shape the book describes.
