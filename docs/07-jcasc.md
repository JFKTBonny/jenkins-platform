# 7. Configuration as Code (JCasC)

All controller configuration lives in `controller/casc/`. JCasC loads every YAML file in that folder at startup (`CASC_JENKINS_CONFIG=/var/jenkins_casc`).

| File | Root key | Contains |
|---|---|---|
| `jenkins.yaml` | `jenkins:` | Executors, CSRF, agent security, login, permissions, agent1 node |
| `security.yaml` | `security:` | API token policy, build authorization (commented) |
| `credentials.yaml` | `credentials:` | Docker Hub and GitHub credentials from `.env` |
| `unclassified.yaml` | `unclassified:` | Jenkins URL, shared library, audit trail |

**Rule:** each root key appears in exactly one file, to avoid merge conflicts.

## Change config

```bash
# edit controller/casc/*.yaml
make build
make up
```

Or reload without rebuilding: **Manage Jenkins → Configuration as Code → Reload existing configuration** (only picks up files already in the image).

## Export current config

**Manage Jenkins → Configuration as Code → View Configuration**. Useful for finding the YAML keys of a setting you changed in the UI.

## Secrets

`${VAR}` values are read from the container environment (`.env`). Never commit real values.

## Plugins

Listed in `controller/plugins.txt`, installed at image build time by `jenkins-plugin-cli`. Pin versions with `plugin-id:version` once you are stable.
