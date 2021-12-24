# Kubernetes on Digital Ocean Ansible Playbook

Build a Kubernetes cluster using Ansible with kubeadm. It supports only *Ubuntu 20.04* (for now)

System requirements:

  - Control plane and workers must have passwordless SSH access

# Usage

Add the IPs of your servers in `hosts.ini`. Then run the `cluster.yaml` playbook:
```sh
$ ansible-playbook cluster.yaml
``` 

Verify cluster is fully running using kubectl:

```sh

$ kubectl get nodes
NAME      STATUS    AGE       VERSION
control1   Ready     22m       v1.22.4
worker1     Ready     20m       v1.22.4

```

# What it does

- creates a sudoless `ubuntu` user on all nodes.
- installs Docker on all nodes
- sets up Docker to use systemd driver (to make it usable as container engine for Kubernetes)
- installs and configures kubeadm,kubelet on all nodes
- installs kubectl on control_plane node
- inits cluster with kubeadm on control_plane
- installs flannel networking on cluster
- joins the nodes in the cluster

<!-- # Resetting the environment

Finally, reset all kubeadm installed state using `reset-cluster.yaml` playbook:

```sh
$ ansible-playbook reset-cluster.yaml
``` -->