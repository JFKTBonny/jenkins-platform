# 11. Security Best Practices

## Checklist

| Area | Practice | Where in this repo |
|---|---|---|
| Access | No sign-up, no anonymous access | `casc/jenkins.yaml` |
| Authorization | Matrix permissions; *Administer* for few people | `casc/jenkins.yaml` |
| Network | HTTPS via Nginx, Jenkins bound to localhost | `nginx/`, `docker-compose.yml` |
| Firewall | Only 22, 80, 443 (+50000 from agent subnet) | `scripts/firewall.sh` |
| Controller | 0 executors | `casc/jenkins.yaml` |
| CSRF / agent security | Enabled | `casc/jenkins.yaml` |
| API tokens | No legacy tokens | `casc/security.yaml` |
| Secrets | Credentials store, folder-scoped, single-quoted `sh` | `casc/credentials.yaml`, `examples/Jenkinsfile.secrets-quiet` |
| Scripts | Sandbox on; privileged code only in trusted library | `jenkins-shared-lib` |
| PRs from forks | Trust only Admin/Write users; no secrets on PRs | `examples/Jenkinsfile.secure-pr` |
| Agents | Ephemeral, non-root, no Docker socket | `agents/`, `examples/Jenkinsfile.k8s-agent` |
| Plugins | Minimal set, patched quickly | `controller/plugins.txt` |
| Auditing | Audit trail log | `casc/unclassified.yaml` |
| Backups | Encrypted | `scripts/backup.sh` |
| File permissions | `secrets/` 700/600 (package install) | `scripts/harden-permissions.sh` |

## Secrets in pipelines

```groovy
// WRONG: Groovy interpolates the secret into the command string
sh "curl -H 'Authorization: Bearer ${TOKEN}' https://api.example.com"

// RIGHT: single quotes, the shell expands the variable
sh 'curl -s -H "Authorization: Bearer $TOKEN" https://api.example.com'
```

- Scope credentials to a **folder**, not Global, when only one team needs them.
- Never `echo` secrets or write them into the workspace.
- Prefer short-lived tokens (cloud OIDC, Vault).
- Rotate credentials when someone with access leaves.

## Script approval

Reject signatures like these under **Manage Jenkins → In-process Script Approval**:

```text
staticMethod jenkins.model.Jenkins getInstance
method hudson.model.ItemGroup getAllItems
method java.lang.Runtime exec java.lang.String
staticMethod org.codehaus.groovy.runtime.DefaultGroovyMethods execute java.lang.String
```

The Script Console (`/script`) has full system access; keep the *Administer* group tiny.

## Build authorization

Builds run as `SYSTEM` by default. `controller/casc/security.yaml` contains a commented block that makes builds run as the triggering user (Authorize Project plugin). Read the comment there before enabling it: webhook-triggered builds need a service account.

## Plugin hygiene

```bash
./scripts/cli.sh list-plugins | grep -e ')$'     # plugins with updates
./scripts/cli.sh install-plugin git credentials -restart
```

- Use the LTS line and update regularly.
- Watch the red security banner in **Manage Jenkins**.
- Follow jenkins.io/security/advisories.
- Remove unused plugins.

## Self-check

```bash
make check
```

| Check | Expected |
|---|---|
| Anonymous API access | 401/403 |
| HTTP | 301 redirect to HTTPS |
| Port 8080 from outside | Not reachable |
| Port 50000 | Closed, or limited to agent subnet |
| CSRF crumb issuer | Enabled |
| Built-in node executors | 0 |

Also review manually: security warnings banner, script approvals, plugin updates.
