# When LIST is a Lie in Kubernetes

Setup notes + a worked example showing why the RBAC `list` verb on Secrets is
**not** a security boundary. Based on [antitree's post](https://www.antitree.com/2020/11/when-list-is-a-lie-in-kubernetes/)
and reproduced locally on docker-desktop.

## TL;DR

Granting `list` (or `watch`) on Secrets is equivalent to granting `get`. A LIST
response contains the full object including the base64-encoded secret values, so
anyone who can `list` secrets can read every secret in the namespace — even when
`get` is explicitly denied. `kubectl` prints a client-side "Forbidden" error on a
direct GET, but it already holds the data. Never use `list` as the barrier.

## Setup: krew + view-secret

`view-secret` is a krew plugin, so install the plugin manager first.

```bash
# 1. Install krew (macOS via Homebrew)
brew install krew

# 2. Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# 3. Install the plugin
kubectl krew install view-secret

# 4. Verify
kubectl view-secret --help
```

Usage:

```bash
kubectl view-secret <secret-name>          # single key: auto-decoded
kubectl view-secret <secret-name> <key>    # specific key
kubectl view-secret <secret-name> --all    # every key
```

## Background

Kubernetes Roles grant access via verbs: `get`, `list`, `watch`, `create`,
`update`, etc.

- `GET` retrieves a single object: `kubectl get secret mysecret`
- `LIST` retrieves all objects of a type: `kubectl get secrets`

For most resources this distinction is meaningful. For **Secrets it is not** — a
LIST pulls down every secret's data inline. From the
[Kubernetes docs](https://kubernetes.io/docs/concepts/configuration/secret/#information-security-for-secrets):

> "watch and list requests for secrets within a namespace are extremely powerful
> capabilities and should be avoided, since listing secrets allows the clients to
> inspect the values of all secrets that are in that namespace. The ability to
> watch and list all secrets in a cluster should be reserved for only the most
> privileged, system-level components."

## Worked example

### 1. RBAC that *looks* safe — list, no get

`rbac-list-bypass.yaml`:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: poc-list-bypass
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["list", "watch"]      # deliberately no "get"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: poc-list-bypass
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: poc-list-bypass
subjects:
- kind: ServiceAccount
  name: poc-list-bypass-sa
  namespace: default
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: poc-list-bypass-sa
  namespace: default
```

The secret to protect (`ultra-secret-string.yaml`):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ultra-secret-string
data:
  mysecret: a3ViZXJuZXRlcyBMSVNUIHZlcmIgaXMgYSBsaWU=
```

Apply both:

```bash
kubectl apply -f rbac-list-bypass.yaml
kubectl apply -f ultra-secret-string.yaml
```

### 2. Grab the SA token (simulating a compromised pod)

```bash
export TOKEN=$(kubectl view-secret poc-list-bypass-sa-token-xxxxx token)

# Confirm the identity behind the token. kubectl auth whoami is built in
# (k8s 1.26+); the whoami krew plugin works on older clusters too.
kubectl auth whoami --token=$TOKEN
# ATTRIBUTE   VALUE
# Username    system:serviceaccount:default:poc-list-bypass-sa
# Groups      [system:serviceaccounts system:serviceaccounts:default ...]

kubectl whoami --token=$TOKEN   # krew plugin, same result on older clusters
# system:serviceaccount:default:poc-list-bypass-sa
```

Here `poc-list-bypass-sa-token-xxxxx` is a `kubernetes.io/service-account-token`
secret — it has **three** keys (`token`, `ca.crt`, `namespace`, so `DATA=3`), and
`view-secret ... token` extracts the `token` key (the JWT an attacker wants to
replay).

#### Heads up: this step is different on Kubernetes 1.24+

The blog is from 2020 (pre-1.24), when creating a ServiceAccount auto-generated a
companion `*-token-xxxxx` Secret. **Since 1.24 that stopped** — SA tokens are no
longer auto-created as Secrets, so on a modern cluster (e.g. docker-desktop)
`kubectl get secrets` shows no `poc-list-bypass-sa-token-*` entry and this exact
step can't be reproduced.

Mint a token on demand instead (no Secret involved):

```bash
kubectl create token poc-list-bypass-sa   # prints the JWT directly
```

Or, to recreate the old-style token Secret and follow the post verbatim:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: poc-list-bypass-sa-token
  annotations:
    kubernetes.io/service-account.name: poc-list-bypass-sa
type: kubernetes.io/service-account-token
```

After `kubectl apply`, the controller populates `token`/`ca.crt`/`namespace`, then
`kubectl view-secret poc-list-bypass-sa-token token` returns the JWT.

#### Why `view-secret <secret> token` behaved oddly on the Opaque secret

The key argument only means something when the secret actually has that key. A
`service-account-token` secret has a `token` key; the `ultra-secret-string`
Opaque secret has a single key `mysecret` and no `token`. When a secret holds
just one key, `view-secret` ignores the requested key and shows the only one
present:

```bash
$ kubectl view-secret ultra-secret-string token
Viewing only available key: mysecret     # 'token' silently disregarded
kubernetes LIST verb is a lie
```

### 3. GET is denied...

```bash
kubectl get secret ultra-secret-string --token=$TOKEN
# Error from server (Forbidden): secrets "ultra-secret-string" is forbidden:
# User "system:serviceaccount:default:poc-list-bypass-sa" cannot get resource
# "secrets" in API group "" in the namespace "default"
```

### 4. ...but LIST hands over the data anyway

```bash
kubectl get secret --token=$TOKEN -o json | \
  jq -r '.items[] | select(.metadata.name=="ultra-secret-string") | .data["mysecret"]' | \
  base64 -d
# kubernetes LIST verb is a lie
```

The `get` denial is cosmetic — the value arrived in the LIST response.

## Local reproduction (docker-desktop)

Confirmed the mechanics end-to-end on docker-desktop, cluster-admin context:

```bash
$ kubectl get secret
NAME                  TYPE     DATA   AGE
ultra-secret-string   Opaque   1      25m

$ kubectl get secret ultra-secret-string -o yaml
apiVersion: v1
data:
  mysecret: a3ViZXJuZXRlcyBMSVNUIHZlcmIgaXMgYSBsaWU=
kind: Secret
metadata:
  name: ultra-secret-string
  namespace: default
type: Opaque

# Manual decode
$ echo "a3ViZXJuZXRlcyBMSVNUIHZlcmIgaXMgYSBsaWU=" | base64 -d
kubernetes LIST verb is a lie

# Same thing via the plugin
$ kubectl view-secret ultra-secret-string
Viewing only available key: mysecret
kubernetes LIST verb is a lie
```

## Audit your cluster

Find every ClusterRole that grants `list` on secrets **without** `get` — i.e.
roles built on the false assumption that list-only restricts secret access:

```bash
kubectl get clusterroles -o json | \
  jq -r '.items[] | select(.rules[] |
    select((.resources | index("secrets"))
    and (.verbs | index("list"))
    and (.verbs | index("get") | not))) |
    .metadata.name'
```

This pattern is common in Helm charts and default service templates, so expect
hits. Also worth checking namespaced `Role`s:

```bash
kubectl get roles -A -o json | \
  jq -r '.items[] | select(.rules[]? |
    select((.resources | index("secrets"))
    and (.verbs | (index("list") or index("watch")))
    and (.verbs | index("get") | not))) |
    "\(.metadata.namespace)/\(.metadata.name)"'
```

## What to do instead

Do not rely on `list`/`watch` on Secrets as an access-control boundary. To give
partial/read-only cluster access safely:

- Do not grant `list` or `watch` on `secrets` to non-system principals.
- If a workload needs a specific secret, grant `get` on that named resource via
  `resourceNames`, not blanket list access.
- Reserve cluster-wide list/watch on secrets for privileged system components.
- Consider an external secrets store (Vault, cloud secret managers) so secret
  material never lives in the API as list-readable objects.

---
_Source: [antitree — When LIST is a Lie in Kubernetes](https://www.antitree.com/2020/11/when-list-is-a-lie-in-kubernetes/) (Nov 2020)._
