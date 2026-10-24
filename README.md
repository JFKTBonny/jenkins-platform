# Jenkins Platform

Jenkins controller as code: Docker image, JCasC configuration, security hardening, helper scripts, pipeline examples and documentation.

Reusable pipeline code lives in the companion repo **jenkins-shared-lib**.

## Quick start

```bash
cp .env.example .env        # fill in real values
make build
make up
make logs                   # wait for "Jenkins is fully up and running"
```

Then:

1. Log in as `admin` with `ADMIN_PASSWORD` from `.env`.
2. Open **Manage Jenkins → Nodes → agent1**, copy the secret into `.env` as `AGENT_SECRET`.
3. Start the agent: `make agents`.
4. Set up HTTPS: follow the header of `nginx/jenkins.conf`, then run `./scripts/firewall.sh`.
5. Create an API token (your user → Security → API Token) and put it in `.env` as `JENKINS_API_TOKEN`.
6. Run the security self-check: `make check`.

## Before first use, replace

| Placeholder | Files |
|---|---|
| `jenkins.example.com` | `.env`, `nginx/jenkins.conf` |
| `your-org/jenkins-shared-lib` | `controller/casc/unclassified.yaml` |
| All `change-me` values | `.env` |

## Layout

| Path | Purpose |
|---|---|
| `controller/` | Dockerfile, plugins, JCasC config |
| `agents/` | Local Docker agent, Kubernetes pod template |
| `nginx/` | HTTPS reverse proxy |
| `scripts/` | Install, firewall, hardening, backup/restore, CLI, validation, self-check |
| `examples/` | Copy-paste Jenkinsfiles |
| `docs/` | Reference documentation (start with `docs/01-concepts.md`) |
| `.github/workflows/` | CI: YAML lint, shellcheck, image build |

## Make targets

```bash
make help
```

| Target | Action |
|---|---|
| `build` / `up` / `down` / `restart` / `logs` | Controller lifecycle |
| `agents` / `agents-down` | Local agent |
| `backup` / `restore FILE=...` | Encrypted backups |
| `validate` | Lint `examples/Jenkinsfile.*` against Jenkins |
| `check` | Security self-check |

## Rules

- Never commit `.env` or backups.
- Change Jenkins config in `controller/casc/`, not in the UI.
- Shared pipeline code goes in `jenkins-shared-lib` (admin-only repo).
- Protect `main`: require PRs, 1 approval and the `Validate` check.

## Push to GitHub

```bash
chmod +x scripts/*.sh
git init -b main
git add .
git commit -m "Initial Jenkins platform"
gh repo create your-org/jenkins-platform --private --source=. --push
```
