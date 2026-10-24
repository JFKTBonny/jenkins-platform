#!/usr/bin/env bash
# Lock down JENKINS_HOME file permissions (package install).
# Usage: JENKINS_HOME=/var/lib/jenkins ./scripts/harden-permissions.sh
set -euo pipefail

JENKINS_HOME="${JENKINS_HOME:-/var/lib/jenkins}"

if [[ ! -d "$JENKINS_HOME" ]]; then
  echo "JENKINS_HOME not found: $JENKINS_HOME" >&2
  exit 1
fi

sudo chown -R jenkins:jenkins "$JENKINS_HOME"
sudo chmod 750 "$JENKINS_HOME"
sudo chmod 700 "$JENKINS_HOME/secrets"
sudo find "$JENKINS_HOME/secrets" -type f -exec chmod 600 {} +

echo "Permissions hardened for $JENKINS_HOME"
