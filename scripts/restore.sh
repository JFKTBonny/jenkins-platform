#!/usr/bin/env bash
# Restore jenkins_home from an encrypted backup.
# Usage: ./scripts/restore.sh backups/jenkins_YYYY-MM-DD_HHMM.tar.gz.gpg
set -euo pipefail

backup="${1:?usage: restore.sh backups/jenkins_YYYY-MM-DD_HHMM.tar.gz.gpg}"
workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

gpg --output "$workdir/restore.tar.gz" --decrypt "$backup"

docker compose stop jenkins

docker run --rm \
  -v jenkins_home:/data \
  -v "$workdir":/backup:ro \
  alpine sh -c "find /data -mindepth 1 -delete && tar xzf /backup/restore.tar.gz -C /data"

docker compose start jenkins

echo "Restored from $backup"
