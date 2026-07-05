# Ch5: VirtualService applied but traffic still hits v1 AND v2

**Date:** 2026-07-05
**Symptom:** Applied `ch5/catalog-vs-v1-mesh.yaml` (mesh VS pinning catalog to subset v1), but `curl` loop through the ingress gateway still returned mixed v1/v2 responses (some with `imageUrl`, some without). No errors — just as if the VS didn't exist.

## Root cause

**webapp pod had no istio-proxy sidecar.**

A VirtualService with `gateways: [mesh]` is enforced by the **client's** sidecar (webapp → catalog hop). No sidecar on webapp = rule never evaluated. webapp called catalog through the plain Kubernetes Service, which round-robins across all endpoints — v1 and v2 alike.

The tell:

```bash
kubectl get pod -n istioinaction -l app=webapp \
  -o jsonpath='{.items[*].spec.containers[*].name}'
# output: webapp          ← only 1 container, should be: webapp istio-proxy
```

Secondary tell: `istioctl proxy-config routes deploy/webapp ...` failed with
`failure running port forward process ... EOF` — there's no proxy to query.

## Fix

```bash
kubectl label namespace istioinaction istio-injection=enabled
kubectl rollout restart deploy -n istioinaction
kubectl get pods -n istioinaction   # all pods must be 2/2
```

**Gotcha:** sidecars are injected only at pod *creation*. Labeling the
namespace does nothing to existing pods — the rollout restart is mandatory.

## Debug checklist for "VS has no effect" (in order)

1. **Namespace of the VS.** Manifests without `metadata.namespace` land in
   the kubectl context's default namespace. Short `hosts:` (e.g. `catalog`)
   expand relative to the **VS's** namespace — a VS in `default` targets
   `catalog.default.svc`, which nobody calls. Check: `kubectl get vs -A`.
   (Was fine this time, but it's the #1 cause in general.)

2. **DestinationRule exists** for any `subset:` referenced. Missing DR
   usually shows as 503s rather than mixed traffic.
   Check: `kubectl get dr -n istioinaction`.

3. **Client has a sidecar** (this incident). Mesh routing runs in the
   caller's proxy. Check container names on the *client* pod, not the server.

4. **Route actually programmed in the proxy:**

   ```bash
   istioctl proxy-config routes deploy/webapp -n istioinaction --name 80 -o json | grep -A2 subset
   # expect: "cluster": "outbound|80|v1|catalog.istioinaction.svc.cluster.local"
   ```

## Key mental model

- `gateways: [mesh]` = all sidecars, evaluated **client-side**. Not an ingress rule.
- The k8s Service's own load balancing is bypassed only when a sidecar
  intercepts the call. No sidecar → plain round-robin.
- Mixed responses with no errors ≈ routing rule not applied at all
  (namespace, missing sidecar). 503s ≈ rule applied but broken
  (missing DR/subset, no healthy endpoints).
