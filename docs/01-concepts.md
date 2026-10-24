# 1. Core Concepts

| Term | Meaning |
|---|---|
| **Controller** | The main Jenkins server. Hosts the UI, stores config and schedules builds. |
| **Agent (node)** | A machine or container that runs build steps. |
| **Executor** | A slot on an agent that runs one build at a time. |
| **Job / Project** | A configured task: Freestyle, Pipeline, Multibranch. |
| **Pipeline** | A build process defined as code in a `Jenkinsfile`. |
| **Stage / Step** | A stage is a logical phase (Build, Test). A step is a single command inside it. |
| **Plugin** | An extension. Most Jenkins features come from plugins. |
| **Credentials** | Secrets stored by Jenkins and injected into builds safely. |

## How it fits together in this repo

```text
GitHub push ──webhook──> Nginx (HTTPS) ──> Controller (0 executors, JCasC)
                                              │
                                              ├──> agent1 (Docker inbound agent)
                                              └──> Kubernetes pods (optional)
```
