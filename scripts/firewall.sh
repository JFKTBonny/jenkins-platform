#!/usr/bin/env bash
# Host firewall: allow SSH, HTTP (redirect) and HTTPS only.
# Optional: AGENT_SUBNET=10.0.0.0/24 ./scripts/firewall.sh  -> also allow agents on port 50000
set -euo pipefail

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

if [[ -n "${AGENT_SUBNET:-}" ]]; then
  sudo ufw allow from "$AGENT_SUBNET" to any port 50000 proto tcp
  echo "Allowed inbound agents from $AGENT_SUBNET on port 50000"
fi

sudo ufw --force enable
sudo ufw status verbose
