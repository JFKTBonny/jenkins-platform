# 10. Best Practices and Troubleshooting

## Best practices

- Keep pipelines in Git as a `Jenkinsfile`, not built up through UI clicks.
- Run no builds on the controller (executors = 0).
- Never hardcode secrets. Use the Credentials store.
- Use `H` in cron so jobs don't all start at the same minute.
- Set timeouts and log rotation on every pipeline.
- Pin plugin versions and test updates on staging first.
- Use shared libraries instead of copy-pasting logic.
- Use Docker/Kubernetes agents for reproducible builds.

## Troubleshooting

| Problem | Fix |
|---|---|
| `sh: docker: not found` | Install Docker on the agent, or use a Docker agent image. |
| Permission denied on Docker socket | `sudo usermod -aG docker jenkins`, then restart Jenkins. |
| `No such DSL method` | The required plugin is missing. Add it to `plugins.txt` and rebuild. |
| Script approval errors | Approve under **Manage Jenkins → In-process Script Approval**, or move the code to the trusted shared library. |
| Webhook not triggering | Payload URL must end with `/github-webhook/`; Jenkins must be reachable from GitHub. |
| Build stuck "waiting for executor" | Agent offline or label mismatch. Check **Manage Jenkins → Nodes**. |
| Jenkins won't start after a JCasC change | `make logs` shows the invalid key. Fix the YAML, `make build && make up`. |
| agent1 offline | Wrong `AGENT_SECRET`, or Jenkins not running. Check `docker logs agent1`. |
