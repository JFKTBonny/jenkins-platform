# 5. Multibranch Pipelines and Webhooks

## Create a Multibranch job

1. **New Item → Multibranch Pipeline**
2. **Branch Sources → GitHub**: repo URL, credentials `github-creds`
3. **Discover pull requests from forks → Trust**: `From users with Admin or Write permission`
4. Save. Jenkins scans the repo and creates a job per branch/PR that contains a `Jenkinsfile`.

## GitHub webhook

Repo **Settings → Webhooks → Add webhook**:

```text
Payload URL:   https://jenkins.example.com/github-webhook/
Content type:  application/json
Events:        Just the push event (add Pull requests if needed)
```

The URL must end with `/github-webhook/` and Jenkins must be reachable from GitHub.

## Branch-specific behavior

See `examples/Jenkinsfile.multibranch` and `examples/Jenkinsfile.secure-pr`.
