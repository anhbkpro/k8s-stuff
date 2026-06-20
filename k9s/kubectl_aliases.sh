# ─── kubectl ──────────────────────────────────────────────────────────────────
alias k='kubectl'
alias kx='kubectl config use-context'       # switch context
alias kns='kubectl config set-context --current --namespace'  # switch namespace

# get
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpw='kubectl get pods -w'            # watch
alias kgpa='kubectl get pods -A'            # all namespaces
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgn='kubectl get nodes'
alias kgi='kubectl get ingress'
alias kgcm='kubectl get configmap'
alias kgsec='kubectl get secret'
alias kghpa='kubectl get hpa'
alias kgpv='kubectl get pv'
alias kgpvc='kubectl get pvc'
alias kgsa='kubectl get serviceaccount'
alias kgcj='kubectl get cronjob'
alias kgj='kubectl get job'

# describe
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'
alias kdd='kubectl describe deploy'
alias kdn='kubectl describe node'

# logs
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klp='kubectl logs -f --previous'

# exec
alias ke='kubectl exec -it'

# apply / delete
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'

# context / namespace
alias kctx='kubectl config get-contexts'
alias kcurrent='kubectl config current-context'
alias kns-list='kubectl get namespaces'

# top
alias ktop='kubectl top pods'
alias ktopn='kubectl top nodes'

# quick pod shell
ksh() { kubectl exec -it "$1" -- /bin/sh; }
kbash() { kubectl exec -it "$1" -- /bin/bash; }

# tail logs by label selector
klabel() { kubectl logs -f -l "$1" --all-containers=true; }

# port-forward shorthand: kpf <pod> <local>:<remote>
alias kpf='kubectl port-forward'

# restart a deployment
krestart() { kubectl rollout restart deploy/"$1"; }

# watch rollout status
kroll() { kubectl rollout status deploy/"$1"; }

# ─── istioctl ─────────────────────────────────────────────────────────────────
alias ictl='istioctl'
alias iproxy='istioctl proxy-status'
alias ianalyze='istioctl analyze'
alias idashboard='istioctl dashboard'
alias ikiali='istioctl dashboard kiali'
alias ijaeger='istioctl dashboard jaeger'
alias igrafana='istioctl dashboard grafana'

# ─── helm ─────────────────────────────────────────────────────────────────────
alias h='helm'
alias hls='helm list'
alias hlsa='helm list -A'
alias hup='helm upgrade --install'
alias hrm='helm uninstall'
alias hvals='helm get values'
alias hdiff='helm diff upgrade'         # requires helm-diff plugin

# ─── terraform ────────────────────────────────────────────────────────────────
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfda='terraform destroy -auto-approve'
alias tfo='terraform output'
alias tfs='terraform state'
alias tfsl='terraform state list'
alias tfws='terraform workspace'
alias tfwsl='terraform workspace list'
alias tfwss='terraform workspace select'

# ─── docker ───────────────────────────────────────────────────────────────────
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlf='docker logs -f'
alias drm='docker rm'
alias drmi='docker rmi'
alias dprune='docker system prune -f'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
