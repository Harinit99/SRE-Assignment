# SRE Assignment: Metrics App

## Objective

Deploy a containerized app using Helm, ArgoCD, and KIND, and debug the /counter endpoint.

---

## Setup Instructions

### 1. Create KIND Cluster & Install ArgoCD

```bash
./bootstrap.sh
```

Port forward ArgoCD:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 2. Login to ArgoCD

Default credentials:
- user: admin
- password: get from:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 3. App URL

Set `/etc/hosts`:
```
127.0.0.1 local.metrics-app.io
```

Access the app:
```
curl http://local.metrics-app.io/counter
```

## Behavior Observed

Ran:
```bash
for i in $(seq 0 20); do curl http://localhost:8080/counter; done
```

Observed consistent increment:
```
Counter value: 1
Counter value: 2
...
```

## Issue Diagnosis

If values reset or lag, check pod logs:
```bash
kubectl logs -l app=metrics-app
```

## Root Cause Analysis

App may use local in-memory state. If restarted, the counter resets.

### Possible Fix:
Use a persistent backend (like Redis) if required to retain counter across restarts.

## Notes

- Secrets passed via Kubernetes secret (base64 encoded).
- Helm used for templating and config.
- ArgoCD manages GitOps deployment.
- Ingress exposes app via NGINX at custom host.

