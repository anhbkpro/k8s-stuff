# Chapter 4 — Ansible Playbooks

## Key ideas

- Playbooks are lists of **plays**, each running a set of **tasks**
  against a group of hosts — the shift from one-off ad-hoc commands to
  repeatable, version-controlled configuration.
- Any shell script converts almost directly into a playbook using the
  `command` module for each line — but the real payoff comes from
  swapping in typed modules (`dnf`, `service`, ...) for idempotence.
- `pre_tasks` run before the main `tasks`; `handlers` run once, at the
  **end** of a play, only if a task that `notify`-ed them actually
  changed something (and didn't fail). Ansible stops the whole playbook
  on a failed task by default and skips pending handlers unless you pass
  `--force-handlers`.
- `ansible-playbook` scoping: `--limit <group-or-host>` narrows which
  hosts a run touches (playbook can say `hosts: all` and still be
  limited from the command line); `--list-hosts` previews who's affected
  without running anything; `--check` is a dry run — tasks are evaluated
  but nothing executes.
- `--user`/`-u`, `--become`/`-b`, `--become-user`, `--ask-become-pass`/`-K`
  control which remote account tasks run as and how privilege escalation
  happens — same idea as ad-hoc `-b`/`-K`, just at the playbook level.
- `register` captures a task's result into a variable for later tasks to
  read; `changed_when` overrides Ansible's own guess at whether a task
  changed anything (useful for read-only commands like `forever list`,
  which should never report `changed`).
- `command` is the default/preferred module for arbitrary commands;
  `shell` is only needed for pipes/redirects/shell built-ins; `script`
  and `raw` are rare escape hatches, not everyday tools.
- `template` (Jinja2, `.j2` files) renders variables into config files
  server-side; `lineinfile` surgically ensures one line exists/matches
  in an existing file, without touching the rest of it.

## Three real-world playbooks

The book builds three complete server playbooks. Given the scope (this
chapter alone is ~35 book pages), only the first was actually stood up
and run — see [`nodejs/`](nodejs/README.md) for the full hands-on log.
The other two are written into this repo exactly as the book has them,
runnable as-is against a real Ubuntu box, with a walkthrough of what each
task does below instead of an actual run — they mostly exercise the same
concepts (`template`, `handlers`, `pre_tasks`, `become_user`) at a much
higher setup cost (a whole new Ubuntu+sshd Docker image, Composer, Drush,
PHP 8.2, Solr-from-source — each its own source of arm64/container
surprises, on top of everything already proven out in ch01–ch03).

### [`nodejs/`](nodejs/README.md) — Rocky Linux + Node.js (hands-on, run for real)

EPEL + Remi repos → `npm` → `forever` (process manager) → copies a tiny
Express app → installs its dependencies → starts it, guarded by
`register`/`when` so re-running the playbook doesn't start a second
copy. Full run log, deviations, and a real `curl` against the running
app are in that folder's README.

### [`drupal/`](drupal/playbook.yml) — Ubuntu LAMP + Drupal (written, not run)

The most feature-dense of the three:

1. **`pre_tasks`**: refresh the apt cache (`cache_valid_time` avoids
   re-running `apt update` on every single playbook run — only if it's
   been over an hour).
2. **`handlers`**: one `restart apache` handler, `notify`-ed by four
   different tasks below (module enable, vhost template, site
   enable/disable, php.ini edit). All four could fail independently;
   Apache only restarts once, at the end, and only if something actually
   changed.
3. Installs Apache/MySQL/PHP 8.2 + extensions from the `ondrej/php` PPA
   (needed since Ubuntu's own repos lag behind current PHP).
4. **`apache2_module`** enables `mod_rewrite` (Drupal requires clean
   URLs) — the idempotent equivalent of `a2enmod rewrite`.
5. **`template`** renders [`templates/drupal.test.conf.j2`](drupal/templates/drupal.test.conf.j2)
   into an Apache vhost, substituting `{{ domain }}` and
   `{{ drupal_core_path }}` from [`vars.yml`](drupal/vars.yml).
6. `a2ensite`/`a2dissite` via `command`, made idempotent with
   `creates=`/`removes=` (skip the command if that file already
   exists/is already gone) — since there's no dedicated Ansible module
   for enabling Apache sites.
7. **`lineinfile`** tunes `opcache.memory_consumption` in place, without
   managing PHP's whole config file as a template.
8. **`mysql_db`**/**`mysql_user`** create the Drupal database and a
   scoped user for it.
9. Installs Composer (download → run installer → move into place, each
   step gated by `creates=` for idempotence), then uses Ansible's
   `composer` module to `create-project drupal/recommended-project` and
   `require drush/drush` — both guarded by a `stat` check
   (`drupal_composer_json`) so they only run once, on first install, not
   every subsequent playbook run.
10. Everything Composer/Drush touches runs as `become_user: www-data` —
    root-owned files under Apache's docroot would break the web server's
    ability to read/write them.
11. `drush si` (site-install) actually installs Drupal against the
    database, gated by `creates=.../settings.php` (that file only exists
    after a real install).

Run for real with `ansible-playbook playbook.yml` against a fresh Ubuntu
LTS host, then visit `http://drupal.test/` (point that hostname at the
box first) — admin/admin per the book's `drush si` args.

### [`solr/`](solr/playbook.yml) — Ubuntu + Apache Solr (written, not run)

Shorter and more linear:

1. `apt` installs `openjdk-11-jdk` — Solr's only real dependency.
2. **`get_url`** downloads the Solr tarball with a `checksum` so a
   corrupted/tampered download fails the play instead of silently
   installing something wrong.
3. **`unarchive`** with `remote_src: true` expands the *already-downloaded*
   tarball on the remote host (as opposed to the default, which expands a
   local file and pushes it over) — Solr's own installer script needs
   the original `.tgz` to still be present, so this couldn't be
   collapsed into one `get_url`-into-`unarchive` step the way the module
   docs would normally suggest.
4. Solr's own `install_solr_service.sh` (from inside the extracted
   archive) does the actual service setup — `command`, gated by
   `creates={{ solr_dir }}/bin/solr` for idempotence, since there's no
   dedicated Ansible module for Solr installation.
5. `service` starts and enables it.

Run for real with `ansible-playbook playbook.yml`, then visit
`http://solr.test:8983/solr`.
