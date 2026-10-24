#!/usr/bin/env bash
# Encrypted backup of the jenkins_home Docker volume into ./backups
# secrets/master.key and secrets/hudson.util.Secret decrypt every credential:
# keep backups as protected as the server itself.
set -euo pipefail

mkdir -p backups
name="jenkins_$(date +%F_%H%M).tar.gz"

docker run --rm \
  -v jenkins_home:/data:ro \
  -v "$(pwd)/backups":/backup \
  alpine tar czf "/backup/$name" -C /data .

gpg --symmetric --cipher-algo AES256 "backups/$name"
rm "backups/$name"

echo "Encrypted backup: backups/${name}.gpg"
