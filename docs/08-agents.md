# 8. Agents

The controller has **0 executors**, so every build needs an agent.

## Local Docker agent (agent1)

`agent1` is defined in `controller/casc/jenkins.yaml` with label `linux`.

1. Start Jenkins: `make up`
2. Open **Manage Jenkins → Nodes → agent1** and copy the secret
3. Put it in `.env` as `AGENT_SECRET`
4. Start the agent: `make agents`

The agent joins the `jenkins-net` Docker network and connects to `http://jenkins:8080`.

> The `jenkins/inbound-agent` image has no Docker CLI. For `agent { docker {...} }` pipelines, build a custom agent image with Docker installed, or use Kubernetes agents.

## Remote agent on another machine

1. Uncomment the `50000:50000` port in `docker-compose.yml`
2. Allow only the agent subnet: `AGENT_SUBNET=10.0.0.0/24 ./scripts/firewall.sh`
3. Run on the agent machine:

```bash
docker run -d --name agent2 --restart unless-stopped \
  -e JENKINS_URL=https://jenkins.example.com \
  -e JENKINS_AGENT_NAME=agent2 \
  -e JENKINS_SECRET=YOUR_AGENT_SECRET \
  -e JENKINS_AGENT_WORKDIR=/home/jenkins/agent \
  -e JENKINS_TUNNEL=jenkins.example.com:50000 \
  jenkins/inbound-agent:latest-jdk21
```

## Kubernetes agents

Install the Kubernetes plugin (already in `plugins.txt`), configure a cloud under **Manage Jenkins → Clouds**, then use `examples/Jenkinsfile.k8s-agent` with `agents/k8s/pod-template.yaml`.

## Security rules

- Prefer ephemeral agents (Docker/Kubernetes).
- Never mount `/var/run/docker.sock` into builds: it is equivalent to root on the host.
- Separate trusted and untrusted work with labels (`trusted`, `untrusted`).
