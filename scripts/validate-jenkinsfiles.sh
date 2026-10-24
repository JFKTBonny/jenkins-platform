#!/usr/bin/env bash
# Validate every examples/Jenkinsfile.* with the Jenkins declarative linter.
# Reads JENKINS_URL, JENKINS_USER_ID, JENKINS_API_TOKEN from .env
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

fail=0
for f in examples/Jenkinsfile.*; do
  # Scripted pipelines cannot be checked by the declarative linter
  if grep -q '^node' "$f"; then
    echo "SKIP  $f (scripted)"
    continue
  fi
  result=$(curl -s -X POST -u "$JENKINS_USER_ID:$JENKINS_API_TOKEN" \
    -F "jenkinsfile=<$f" \
    "${JENKINS_URL%/}/pipeline-model-converter/validate")
  if echo "$result" | grep -q "successfully validated"; then
    echo "OK    $f"
  else
    echo "FAIL  $f"
    echo "$result"
    fail=1
  fi
done
exit "$fail"
