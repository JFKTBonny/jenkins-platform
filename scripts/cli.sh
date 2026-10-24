#!/usr/bin/env bash
# Jenkins CLI wrapper. Reads JENKINS_URL, JENKINS_USER_ID, JENKINS_API_TOKEN from .env
# Examples:
#   ./scripts/cli.sh list-jobs
#   ./scripts/cli.sh build my-job -s -v
#   ./scripts/cli.sh build my-job -p VERSION=1.2.3 -p ENV=dev
#   ./scripts/cli.sh console my-job
#   ./scripts/cli.sh list-plugins | grep -e ')$'      # plugins with updates
#   ./scripts/cli.sh install-plugin git credentials -restart
#   ./scripts/cli.sh safe-restart
set -euo pipefail

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

: "${JENKINS_URL:?set JENKINS_URL}"
: "${JENKINS_USER_ID:?set JENKINS_USER_ID}"
: "${JENKINS_API_TOKEN:?set JENKINS_API_TOKEN}"
export JENKINS_USER_ID JENKINS_API_TOKEN

jar=".cache/jenkins-cli.jar"
if [[ ! -f "$jar" ]]; then
  mkdir -p .cache
  curl -fsSL -o "$jar" "${JENKINS_URL%/}/jnlpJars/jenkins-cli.jar"
fi

exec java -jar "$jar" -s "$JENKINS_URL" -http "$@"
