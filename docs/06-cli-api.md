# 6. CLI and REST API

Create an API token: click your user → **Security → API Token → Add new token**, then put it in `.env` as `JENKINS_API_TOKEN`.

## CLI (wrapper script)

```bash
./scripts/cli.sh list-jobs
./scripts/cli.sh build my-job -s -v
./scripts/cli.sh build my-job -p VERSION=1.2.3 -p ENV=dev
./scripts/cli.sh console my-job
./scripts/cli.sh list-plugins | grep -e ')$'
./scripts/cli.sh install-plugin docker-workflow -restart
./scripts/cli.sh safe-restart
```

## REST API (curl)

```bash
JENKINS=https://jenkins.example.com
AUTH=admin:your_api_token

# Trigger a build
curl -X POST -u $AUTH "$JENKINS/job/my-job/build"

# Trigger with parameters
curl -X POST -u $AUTH "$JENKINS/job/my-job/buildWithParameters?VERSION=1.2.3&ENV=dev"

# Last build status
curl -s -u $AUTH "$JENKINS/job/my-job/lastBuild/api/json?tree=result,number,building"

# Console output of last build
curl -s -u $AUTH "$JENKINS/job/my-job/lastBuild/consoleText"

# List all jobs
curl -s -u $AUTH "$JENKINS/api/json?tree=jobs[name,color]"
```

## Validate Jenkinsfiles

```bash
make validate
```

Single file:

```bash
curl -X POST -u admin:your_api_token \
  -F "jenkinsfile=<Jenkinsfile" \
  https://jenkins.example.com/pipeline-model-converter/validate
```
