#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ========== Config ==========
# Domains you want to allow (both A and AAAA will be resolved)
ALLOWED_DOMAINS=(
  # VS Code Marketplace & CDNs
  marketplace.visualstudio.com
  gallery.vsassets.io
  gallerycdn.vsassets.io
  az764295.vo.msecnd.net
  vscode.blob.core.windows.net
  update.code.visualstudio.com
  code.visualstudio.com
  vscode.download.prss.microsoft.com
  vscode.cdn.azure.cn

  # Package registries
  registry.npmjs.org # npm
  pypi.org # pip
  files.pythonhosted.org # pip wheels

  # Anthropic/Claude Code
  api.anthropic.com
  sentry.io
  statsig.anthropic.com
  statsig.com

  # OpenAI
  api.openai.com

  # Context7 MCP
  mcp.context7.com
  context7.com

  # Tooling
  taskfile.dev
  docs.astral.sh
  tamagui.dev
  expo.dev
  reactnative.dev
  typescriptlang.org

  # Coding and refactoring resources
  refactoring.guru
  martinfowler.com

)

# Whether to pull GitHub CIDRs (web/api/git) into an ipset (requires jq)
FETCH_GITHUB_CIDRS=true

# Names for ipsets and chains
IPSET_V4="allowed_ipv4"
IPSET_V6="allowed_ipv6"
IPSET_NETS="allowed_nets"       # for CIDR ranges (IPv4)
IPSET_NETS6="allowed_nets_v6"   # for CIDR ranges (IPv6)
EGRESS_CHAIN="EGRESS"

# ========== Helpers ==========
ensure_ipset() {
  local name="$1" type="$2" family="${3:-}"
  if ! ipset list -n 2>/dev/null | grep -qx "$name"; then
    if [[ "$family" == "inet6" ]]; then
      ipset create "$name" "$type" family inet6 timeout 0
    else
      ipset create "$name" "$type" timeout 0
    fi
  fi
}

flush_ipset() {
  local name="$1"
  ipset flush "$name" || true
}

add_ip_to_ipset() {
  local set_name="$1" ip="$2"
  ipset add "$set_name" "$ip" -exist || true
}

resolver_ips() {
  local resolvers=()
  if getent hosts 127.0.0.11 >/dev/null 2>&1; then
    resolvers+=(127.0.0.11)
  fi
  while read -r ns; do
    [[ -n "$ns" ]] && resolvers+=("$ns")
  done < <(awk '/^nameserver/ {print $2}' /etc/resolv.conf | sed 's/#.*//')
  printf "%s\n" "${resolvers[@]}" | awk 'NF' | sort -u
}

default_gateway_v4() {
  ip route show default 2>/dev/null | awk '/default/ {print $3; exit}'
}

default_gateway_v6() {
  ip -6 route show default 2>/dev/null | awk '/default/ {print $3; exit}'
}

host_subnet_v4() {
  local gw; gw="$(default_gateway_v4 || true)"
  [[ -n "$gw" ]] && echo "${gw%.*}.0/24" || true
}

# ========== Start ==========
echo "[firewall] Initializing…"

# --- Auditing helpers (snapshot + diff) ---
SNAP_DIR="/tmp/fw-audit-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$SNAP_DIR"

snapshot() {
  local label="$1"
  iptables-save > "$SNAP_DIR/iptables.${label}.raw" || true
  ip6tables-save > "$SNAP_DIR/ip6tables.${label}.raw" 2>/dev/null || true
  ipset save > "$SNAP_DIR/ipset.${label}.raw" 2>/dev/null || true

  iptables -L -n -v --line-numbers > "$SNAP_DIR/iptables.${label}.list" || true
  ip6tables -L -n -v --line-numbers > "$SNAP_DIR/ip6tables.${label}.list" 2>/dev/null || true
  iptables -t nat -L -n -v --line-numbers > "$SNAP_DIR/nat.${label}.list" 2>/dev/null || true
  iptables -t mangle -L -n -v --line-numbers > "$SNAP_DIR/mangle.${label}.list" 2>/dev/null || true

  for f in "$SNAP_DIR"/*.${label}.raw; do
    [ -f "$f" ] || continue
    grep -vE '^(#|COMMIT$)' "$f" > "${f%.raw}.clean" || true
  done
}

show_diff() {
  echo "[firewall] ===== Diff (iptables v4) ====="
  diff -u "$SNAP_DIR/iptables.before.clean" "$SNAP_DIR/iptables.after.clean" || true
  if [ -f "$SNAP_DIR/ip6tables.before.clean" ]; then
    echo "[firewall] ===== Diff (ip6tables v6) ====="
    diff -u "$SNAP_DIR/ip6tables.before.clean" "$SNAP_DIR/ip6tables.after.clean" || true
  fi
  if [ -f "$SNAP_DIR/ipset.before.clean" ]; then
    echo "[firewall] ===== Diff (ipset) ====="
    diff -u "$SNAP_DIR/ipset.before.clean" "$SNAP_DIR/ipset.after.clean" || true
  fi
  echo "[firewall] Snapshots and listings saved under: $SNAP_DIR"
}

echo "[firewall] Capturing baseline firewall state…"
snapshot before

cleanup_and_diff() {
  echo "[firewall] Capturing post-change firewall state…"
  snapshot after
  show_diff
}
trap cleanup_and_diff EXIT
# --- End auditing helpers ---

# Create/flush ipsets
ensure_ipset "$IPSET_V4"   hash:ip
ensure_ipset "$IPSET_V6"   hash:ip inet6
ensure_ipset "$IPSET_NETS" hash:net
ensure_ipset "$IPSET_NETS6" hash:net inet6

flush_ipset "$IPSET_V4"
flush_ipset "$IPSET_V6"
flush_ipset "$IPSET_NETS"
flush_ipset "$IPSET_NETS6"

# Populate GitHub CIDRs (optional)
if $FETCH_GITHUB_CIDRS; then
  echo "[firewall] Fetching GitHub meta CIDRs…"
  gh_json="$(curl -fsSL https://api.github.com/meta || true)"
  if [[ -n "${gh_json:-}" ]] && command -v jq >/dev/null 2>&1; then
    mapfile -t cidrs < <(echo "$gh_json" | jq -r '[.web[], .api[], .git[]] | unique[]' 2>/dev/null)
    for cidr in "${cidrs[@]}"; do
      [[ "$cidr" == */* ]] || { echo "[firewall] WARN: skipping non-CIDR: $cidr"; continue; }
      if [[ "$cidr" == *:* ]]; then
        ipset add "$IPSET_NETS6" "$cidr" -exist || true
      else
        ipset add "$IPSET_NETS" "$cidr" -exist || true
      fi
    done
    echo "[firewall] Added ${#cidrs[@]} GitHub CIDRs."
  else
    echo "[firewall] WARN: Could not fetch/parse GitHub CIDRs; skipping."
  fi
fi

# Resolve and add A/AAAA for each allowed domain
echo "[firewall] Resolving allowed domains…"
for domain in "${ALLOWED_DOMAINS[@]}"; do
  echo "  - $domain"
  while read -r ip4; do
    [[ -z "$ip4" ]] && continue
    if [[ "$ip4" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
      add_ip_to_ipset "$IPSET_V4" "$ip4"
    fi
  done < <(getent ahostsv4 "$domain" | awk '{print $1}' | sort -u)
  while read -r ip6; do
    [[ -z "$ip6" ]] && continue
    if [[ "$ip6" =~ : ]]; then
      add_ip_to_ipset "$IPSET_V6" "$ip6"
    fi
  done < <(getent ahostsv6 "$domain" | awk '{print $1}' | sort -u)
done

HOST_SUBNET_V4="$(host_subnet_v4 || true)"
GATEWAY_V6="$(default_gateway_v6 || true)"

echo "[firewall] Host IPv4 subnet: ${HOST_SUBNET_V4:-<none>}"
echo "[firewall] Default gateway v6: ${GATEWAY_V6:-<none>}"

# ========== iptables (IPv4) ==========
iptables -N "$EGRESS_CHAIN" 2>/dev/null || true
iptables -F "$EGRESS_CHAIN" || true

iptables -A "$EGRESS_CHAIN" -o lo -j ACCEPT
iptables -A "$EGRESS_CHAIN" -m state --state ESTABLISHED,RELATED -j ACCEPT

while read -r dnsip; do
  [[ -z "$dnsip" ]] && continue
  if [[ "$dnsip" =~ : ]]; then
    :
  else
    iptables -A "$EGRESS_CHAIN" -p udp -d "$dnsip" --dport 53 -j ACCEPT
    iptables -A "$EGRESS_CHAIN" -p tcp -d "$dnsip" --dport 53 -j ACCEPT
  fi
done < <(resolver_ips)

if [[ -n "${HOST_SUBNET_V4:-}" ]]; then
  iptables -A "$EGRESS_CHAIN" -d "$HOST_SUBNET_V4" -j ACCEPT
fi

iptables -A "$EGRESS_CHAIN" -m set --match-set "$IPSET_NETS" dst -j ACCEPT
iptables -A "$EGRESS_CHAIN" -m set --match-set "$IPSET_V4" dst -j ACCEPT
iptables -A "$EGRESS_CHAIN" -j DROP

iptables -D OUTPUT -j "$EGRESS_CHAIN" 2>/dev/null || true
iptables -I OUTPUT 1 -j "$EGRESS_CHAIN"

iptables -C INPUT -i lo -j ACCEPT 2>/dev/null || iptables -A INPUT -i lo -j ACCEPT
iptables -C INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ========== ip6tables (IPv6) ==========
if command -v ip6tables >/dev/null 2>&1; then
  ip6tables -N "$EGRESS_CHAIN" 2>/dev/null || true
  ip6tables -F "$EGRESS_CHAIN" || true

  ip6tables -A "$EGRESS_CHAIN" -o lo -j ACCEPT
  ip6tables -A "$EGRESS_CHAIN" -m state --state ESTABLISHED,RELATED -j ACCEPT

  while read -r dnsip; do
    [[ -z "$dnsip" ]] && continue
    if [[ "$dnsip" =~ : ]]; then
      ip6tables -A "$EGRESS_CHAIN" -p udp -d "$dnsip" --dport 53 -j ACCEPT
      ip6tables -A "$EGRESS_CHAIN" -p tcp -d "$dnsip" --dport 53 -j ACCEPT
    fi
  done < <(resolver_ips)

  if [[ -n "${GATEWAY_V6:-}" ]]; then
    ip6tables -A "$EGRESS_CHAIN" -d "$GATEWAY_V6" -j ACCEPT
  fi

  ip6tables -A "$EGRESS_CHAIN" -m set --match-set "$IPSET_NETS6" dst -j ACCEPT
  ip6tables -A "$EGRESS_CHAIN" -m set --match-set "$IPSET_V6" dst -j ACCEPT
  ip6tables -A "$EGRESS_CHAIN" -j DROP

  ip6tables -D OUTPUT -j "$EGRESS_CHAIN" 2>/dev/null || true
  ip6tables -I OUTPUT 1 -j "$EGRESS_CHAIN"

  ip6tables -C INPUT -i lo -j ACCEPT 2>/dev/null || ip6tables -A INPUT -i lo -j ACCEPT
  ip6tables -C INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
fi

echo "[firewall] Rules installed."

# ========== Verification (lightweight) ==========
verify_head() {
  local url="$1" label="$2"
  if curl -I --connect-timeout 5 --max-time 10 -s "$url" >/dev/null; then
    echo "[ok] $label reachable"
  else
    echo "[FAIL] $label not reachable"
    return 1
  fi
}

overall_ok=true
verify_head "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" "VSCode Marketplace" || overall_ok=false
# verify_head "https://az764295.vo.msecnd.net/" "VSCode CDN (msecnd)" || overall_ok=false
verify_head "https://update.code.visualstudio.com/api/releases/stable" "VSCode update API" || overall_ok=false
verify_head "https://registry.npmjs.org/" "npm registry" || overall_ok=false
verify_head "https://api.github.com/zen" "GitHub API" || overall_ok=false
verify_head "https://api.openai.com/v1/models" "OpenAI API" || overall_ok=false
verify_head "https://context7.com" "Context7" || overall_ok=false

if "$overall_ok"; then
  echo "[firewall] Verification passed."
else
  echo "[firewall] Verification had failures."
fi
