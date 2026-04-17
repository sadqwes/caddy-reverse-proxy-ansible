# Contributing

Thanks for checking out this repository.

## Local workflow

1. Copy `inventory/hosts.example.yml` to `inventory/hosts.yml`
2. Copy `group_vars/all.example.yml` to `group_vars/all.yml`
3. Fill in your server details and runner token
4. Run `make syntax-check`
5. Run `make provision`

## Guidelines

- Do not commit real IP addresses, SSH private key paths, runner tokens, or production secrets
- Keep examples sanitized
- Prefer small, focused pull requests
- Update `README.md` when setup flow or variables change

## Scope

This project is intentionally focused on provisioning a small Linux host for the companion Caddy reverse proxy repository.
