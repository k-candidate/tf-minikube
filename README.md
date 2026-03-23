# tf-minikube

This repository provisions a local Minikube Kubernetes cluster with Terraform and then installs shared cluster components on top of it.

The layout is designed so we can add more files later for other components such as monitoring, logging, or ingress-related extras without turning the repository into one giant Terraform file.

## Repository layout

- `providers.tf`: Terraform version, provider requirements, and provider configuration
- `cluster.tf`: Minikube cluster resource
- `argocd.tf`: Argo CD namespace and Helm release
- `variables.tf`: input variables and defaults
- `outputs.tf`: useful outputs after apply

## Providers used

This repository currently uses:
- `scott-the-programmer/minikube` to create the Minikube cluster
- `hashicorp/kubernetes` to manage Kubernetes resources such as the Argo CD namespace
- `hashicorp/helm` to install Helm charts into the cluster

## What Terraform creates

### Minikube

Terraform creates one `minikube_cluster` resource.

By default it uses:
- Minikube profile name `terraform-provider-minikube`
- Kubernetes `v1.32.0`
- the `docker` driver
- `bridge` CNI
- `1` node
- `2` CPUs per node
- `4096` MB of memory per node
- these Minikube addons:
  - `default-storageclass`
  - `ingress`
  - `storage-provisioner`

Those defaults are meant to be simple for local development on Linux.
If you need a different driver later, override `minikube_driver` and `minikube_vm`.
If you need a larger local cluster, override `minikube_nodes`, `minikube_cpus`, and `minikube_memory`.

### Argo CD

Terraform then creates:
- the `argocd` namespace
- an `argocd` Helm release using the official Argo Helm chart
- optionally, a root Argo CD `Application` that bootstraps the `gitops-apps` repo

The chart version is pinned with `argocd_chart_version` so the repo stays predictable and repeatable.
This repository currently defaults to Argo CD Helm chart `9.4.15`.

## Prerequisites

Install locally before using this repo:
- Terraform
- Minikube
- Docker
- kubectl
- Helm

The Minikube provider also expects the Minikube binary to be available on your machine.

## Commands

### Initialize Terraform

```bash
terraform init
```

### Review the plan

```bash
terraform plan
```

### Create the cluster and install Argo CD

```bash
terraform apply
```

If you want to size the cluster explicitly:

```bash
terraform apply   -var='minikube_nodes=2'   -var='minikube_cpus=2'   -var='minikube_memory=4096'
```

### Check the Minikube profile managed by Terraform

Because Terraform uses a non-default Minikube profile, use:

```bash
minikube profile list
minikube status -p terraform-provider-minikube
```

### Check the cluster

If GitOps bootstrap is enabled, Terraform also creates the root Argo CD application automatically.
That means you do not need to run a separate manual `kubectl apply` for the bootstrap manifest.


```bash
kubectl get nodes
kubectl get pods -n argocd
helm list -n argocd
```

### Access Argo CD locally

Port-forward the Argo CD server:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then open:

```text
https://127.0.0.1:8080
```

### Get the initial Argo CD admin password

```bash
kubectl get secret argocd-initial-admin-secret -n argocd   -o jsonpath='{.data.password}' | base64 -d && echo
```

The default username is:

```text
admin
```

### Optional GitOps bootstrap

GitOps bootstrap is controlled by:
- `gitops_bootstrap_enabled`

Default:
- `true`

If you want a cluster with Argo CD installed but not yet bootstrapped to the GitOps repo, use:

```bash
terraform apply -var='gitops_bootstrap_enabled=false'
```

### Re-apply after changes

```bash
terraform apply -auto-approve
```

Use that after changing Terraform files to reconcile the existing cluster and Argo CD installation.

### Destroy everything

```bash
terraform destroy
```

## Customizing the setup

Common variables you can override:

```bash
terraform apply   -var='minikube_driver=docker'   -var='minikube_vm=false'   -var='minikube_nodes=1'   -var='minikube_cpus=2'   -var='minikube_memory=4096'   -var='argocd_chart_version=9.4.15'
```

If you later want to use a VM-based driver, you will usually set both:
- `minikube_driver`
- `minikube_vm`

## How to extend this repo later

When we add more cluster-level components, the idea is to keep one concern per file.
For example:
- `monitoring.tf`
- `logging.tf`
- `cert-manager.tf`
- `external-dns.tf`

That keeps the repo easy to read and easy to explore.

## Versioning guidance

There are three kinds of versions to keep in mind here:
- Terraform provider versions in `providers.tf`
- Kubernetes version in `variables.tf`
- Helm chart versions such as `argocd_chart_version`

Typical rule:
- bump provider versions deliberately and re-run `terraform init -upgrade`
- bump the Kubernetes version when you want a newer Minikube cluster version
- bump chart versions when you intentionally want to upgrade that installed component
