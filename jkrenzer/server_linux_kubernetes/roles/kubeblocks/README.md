# kubeblocks (Ansible role)

Installs/updates **KubeBlocks**, enables addons (e.g. PostgreSQL), creates **PostgreSQL clusters**, and
optionally provisions **logical databases + users** inside those clusters. Also supports uninstall.

## Requirements
- Ansible collections:
  ```yaml
  # collections/requirements.yml
  collections:
    - name: kubernetes.core
