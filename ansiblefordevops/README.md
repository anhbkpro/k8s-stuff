# Ansible for DevOps — Practice Log

Working through *Ansible for DevOps* (Jeff Geerling), one chapter at a time.
Each chapter gets its own `chNN/` folder with the actual playbooks,
inventories, and roles built while following along — not just notes.

## How I use this

- Read a chapter, build its playbook/inventory/roles in `chNN/`.
- Run it for real (Vagrant, Docker, or a local VM) and capture any
  gotchas in `chNN/README.md` — command sequences, errors hit, fixes.
- If something's reusable across chapters (a role, a base inventory),
  pull it up to a shared spot once a second chapter needs it — don't
  pre-build shared structure before it's needed.
- Update the progress list below as chapters are completed.

## Progress

- [x] Ch 01 — [Getting Started with Ansible](ch01/README.md)
- [x] Ch 02 — [Local Infrastructure Development: Ansible and Vagrant](ch02/README.md)
- [x] Ch 03 — [Ad-Hoc Commands](ch03/README.md)
- [x] Ch 04 — [Ansible Playbooks](ch04/README.md)
- [x] Ch 05 — [Ansible Playbooks - Beyond the Basics](ch05/README.md)

---

Sourced from *Ansible for DevOps* in `technical-books/devops/`.
