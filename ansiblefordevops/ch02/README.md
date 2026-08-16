# Chapter 2 — Local Infrastructure Development: Ansible and Vagrant

## Key ideas

- Local VMs make infrastructure testing safe and fast: no downtime risk,
  `vagrant destroy` + `vagrant up` rebuilds from scratch in minutes.
- Vagrant provisions VMs automatically on first `vagrant up` (or explicitly
  via `vagrant provision`), handing off to whatever provisioner is
  configured — Ansible among others.
- `become: yes` in a playbook = "use sudo for these tasks" (root privileges).
- Re-running the same playbook (`vagrant provision`) is the book's proof of
  idempotence: the first run shows `changed=2` (chrony installed + started),
  the second shows `changed=0` (nothing left to do) — confirmed below.

## Deviation from the book

The book uses **VirtualBox** + a `geerlingguy/rockylinux8` box. VirtualBox's
Apple Silicon (arm64) support is still an unstable developer preview, so
that combination isn't reliable on this machine. Used **Vagrant's Docker
provider** instead, built on top of
[`geerlingguy/docker-rockylinux8-ansible`](https://hub.docker.com/r/geerlingguy/docker-rockylinux8-ansible)
— a real Rocky Linux 8 image with systemd as PID 1, maintained by the book's
own author for exactly this kind of Ansible testing. Runs natively on arm64,
no hypervisor to install.

Two things needed extra work beyond a plain `docker run`, both because
**Vagrant provisioners always go through an SSH-based communicator**,
regardless of provider — a container alone doesn't give you that for free:

1. **No sshd in the base image** (it's built for `docker exec`-based CI, not
   SSH). Extended it in `Dockerfile`: install `openssh-server` +
   `openssh-clients` (the latter for `scp`, which Vagrant needs to upload
   the playbook — omitting it fails with *"SSH server on the guest doesn't
   support SCP"*), enable `sshd`, and trust a throwaway keypair
   (`.vagrant_insecure_key`, generated locally, gitignored — never commit
   private keys, even throwaway ones for a local container).
2. **systemd needs real cgroup/tmpfs access** to boot cleanly in a
   container: `--privileged --cgroupns=host` plus tmpfs mounts for
   `/tmp` and `/run`, and bind-mounting `/sys/fs/cgroup`. Verified this
   combination with a plain `docker run` probe (`systemctl is-system-running`
   → `running`) before wiring it into the Vagrantfile.

Also used **`ansible_local`** instead of the book's `ansible` provisioner —
this container image already ships Ansible (again, built for CI use), so
running it from inside the guest avoids installing Ansible twice for no
reason. The book's variant (`ansible.playbook = "..."`, running from the
host over SSH) is what you'd use against a real remote/VirtualBox VM.

## Files

- `Dockerfile` — Rocky Linux 8 + systemd + sshd, built locally by Vagrant
  (`d.build_dir = "."`).
- `Vagrantfile` — Docker provider config + the `ansible_local` provisioner
  block, mirroring the book's `config.vm.provision "ansible" do |ansible| ... end`.
- `playbook.yml` — identical to the book's: installs and starts `chrony`.
- `.vagrant_insecure_key(.pub)` — throwaway SSH keypair for this container;
  private half is gitignored.

## Commands run

```bash
$ vagrant up
...
==> default: Machine booted and ready!
==> default: Running provisioner: ansible_local...
PLAY RECAP *********************************************************************
default : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ vagrant provision   # re-run — proves idempotence
PLAY RECAP *********************************************************************
default : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ vagrant ssh -c "rpm -q chrony && systemctl is-enabled chronyd && systemctl is-active chronyd"
chrony-4.5-2.el8_10.aarch64
enabled
active
```

## Cleanup

`vagrant destroy -f` removes the container (and, since it was built
locally, `--rmi` or a manual `docker rmi` clears the built image too).
`vagrant up` rebuilds everything from scratch.
