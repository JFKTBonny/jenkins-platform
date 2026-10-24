#!/usr/bin/env bash
# Quick external security self-check. Reads JENKINS_URL, JENKINS_USER_ID, JENKINS_API_TOKEN from .env
set -uo pipefail

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

: "${JENKINS_URL:?set JENKINS_URL}"
url="${JENKINS_URL%/}"
host="$(echo "$url" | sed -E 's#^https?://([^/:]+).*#\1#')"
auth="${JENKINS_USER_ID:-}:${JENKINS_API_TOKEN:-}"

pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; }
skip() { echo "SKIP  $1"; }

# 1. Anonymous users get nothing
code=$(curl -s -o /dev/null -w '%{http_code}' "$url/api/json")
if [[ "$code" == "403" || "$code" == "401" ]]; then
  pass "Anonymous API access denied ($code)"
else
  fail "Anonymous API access returned $code (expected 401/403)"
fi

# 2. HTTP redirects to HTTPS
loc=$(curl -s -o /dev/null -w '%{redirect_url}' "http://$host/")
if [[ "$loc" == https://* ]]; then
  pass "HTTP redirects to HTTPS"
else
  fail "HTTP does not redirect to HTTPS (got: '${loc:-none}')"
fi

# 3. Port 8080 not exposed publicly
if timeout 3 bash -c "</dev/tcp/$host/8080" 2>/dev/null; then
  fail "Port 8080 is reachable on $host (bind Jenkins to 127.0.0.1)"
else
  pass "Port 8080 not reachable on $host"
fi

# 4. Agent port 50000
if timeout 3 bash -c "</dev/tcp/$host/50000" 2>/dev/null; then
  echo "WARN  Port 50000 is reachable on $host - make sure the firewall limits it to agent IPs"
else
  pass "Port 50000 not reachable on $host"
fi

if [[ -z "${JENKINS_USER_ID:-}" || -z "${JENKINS_API_TOKEN:-}" ]]; then
  skip "Authenticated checks (set JENKINS_USER_ID and JENKINS_API_TOKEN)"
  exit 0
fi

# 5. CSRF protection enabled
code=$(curl -s -o /dev/null -w '%{http_code}' -u "$auth" "$url/crumbIssuer/api/json")
if [[ "$code" == "200" ]]; then
  pass "CSRF crumb issuer enabled"
else
  fail "CSRF crumb issuer returned $code"
fi

# 6. Controller has 0 executors
execs=$(curl -s -u "$auth" "$url/computer/(built-in)/api/json?tree=numExecutors" | sed -E 's/.*"numExecutors":([0-9]+).*/\1/')
if [[ "$execs" == "0" ]]; then
  pass "Built-in node has 0 executors"
else
  fail "Built-in node has ${execs:-unknown} executors (expected 0)"
fi

# 7. Jenkins version (check it against https://www.jenkins.io/security/advisories/)
ver=$(curl -s -I -u "$auth" "$url/" | grep -i '^x-jenkins:' | awk '{print $2}' | tr -d '\r')
echo "INFO  Jenkins version: ${ver:-unknown} - compare with the latest LTS and security advisories"

echo "INFO  Also review manually: Manage Jenkins warnings banner, In-process Script Approval, plugin updates"
