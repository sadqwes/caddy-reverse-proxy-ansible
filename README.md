# Caddy Reverse Proxy Ansible

[![CI](https://img.shields.io/github/actions/workflow/status/sadqwes/caddy-reverse-proxy-ansible/ci.yaml?branch=main&label=CI)](https://github.com/sadqwes/caddy-reverse-proxy-ansible/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Ansible](https://img.shields.io/badge/ansible-ready-EE0000?logo=ansible&logoColor=white)](./playbook.yml)

Infrastructure repository for provisioning a small Linux server for the companion [caddy-reverse-proxy-automation](https://github.com/sadqwes/caddy-reverse-proxy-automation) project.

This repository prepares a host for:

- Caddy reverse proxy deployment
- GitHub Actions self-hosted runner installation
- SSH key-based access
- Basic filesystem layout used by the proxy deployment workflow

## Why This Project

I wanted the Caddy proxy repository and the server provisioning logic to live separately:

- `caddy-reverse-proxy-automation` manages proxy config and deployment workflow
- `caddy-reverse-proxy-ansible` provisions the target server itself

That split makes both repositories easier to explain, maintain, and show in a portfolio.

## What It Configures

- Installs base packages
- Installs and starts Caddy
- Creates directories used by Caddy and the GitHub runner
- Adds an SSH public key for root access
- Hardens SSH for key-based authentication
- Downloads and configures a self-hosted GitHub Actions runner

## Minimal Server Requirements

Tested baseline for a lightweight setup:

- Linux server, for example Ubuntu
- 1 vCPU
- 1 GB RAM
- 1 GB swap

This is a practical minimum for a small reverse proxy node and self-hosted runner. Higher load or more services may require more resources.

## Project Structure

```text
.github/workflows/
  ci.yaml
group_vars/
  all.example.yml
inventory/
  hosts.example.yml
roles/
  caddy-node/
    defaults/main.yml
    tasks/main.yml
    tasks/system.yml
    tasks/ssh.yml
    tasks/runner.yml
playbook.yml
Makefile
```

## Provisioning Flow

```text
inventory + group_vars
        |
        v
playbook.yml
        |
        v
role: caddy-node
        |
        +--> system packages + Caddy
        +--> SSH access hardening
        +--> GitHub Actions runner setup
```

## Quick Start

1. Copy the example files:

```bash
cp inventory/hosts.example.yml inventory/hosts.yml
cp group_vars/all.example.yml group_vars/all.yml
```

2. Edit the values in:

- `inventory/hosts.yml`
- `group_vars/all.yml`

3. Run a syntax check:

```bash
make syntax-check
```

4. Provision the server:

```bash
make provision
```

## Example Variables

`inventory/hosts.example.yml`

```yaml
all:
  hosts:
    caddy-1:
      ansible_host: 203.0.113.10
      ansible_user: root
      ansible_ssh_private_key_file: ~/.ssh/id_rsa_example
```

`group_vars/all.example.yml`

```yaml
ssh_public_key: "ssh-ed25519 AAAA... user@example.com"

runner:
  repo_url: "https://github.com/your-user/your-repo"
  token: "REPLACE_WITH_GITHUB_RUNNER_REGISTRATION_TOKEN"
  name: "caddy-node-1"
```

## Commands

```bash
ansible-galaxy collection install -r collections/requirements.yml
make syntax-check
make provision
```

## Dependencies

This playbook uses the following Ansible collection:

- `ansible.posix`

## Security Notes

- Real inventory and group variables are intentionally ignored by Git
- Do not commit real IP addresses, SSH keys, or GitHub runner tokens
- Use short-lived runner registration tokens
- Review SSH settings before applying on a remote server

## Limitations

- The playbook assumes a Debian/Ubuntu-style system with `apt`
- The runner setup is designed for a single self-hosted runner on one node
- Paths such as `/opt/actions-runner` and `/var/log/caddy` are intentionally opinionated
- This repository does not yet cover firewall rules, fail2ban, or full server hardening
