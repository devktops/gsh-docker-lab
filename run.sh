#!/usr/bin/env bash
set -euo pipefail

# ── Colour helpers ────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

note() { echo -e "${CYAN}${BOLD}[~]${NC} $*"; }
ok()   { echo -e "${GREEN}${BOLD}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}${BOLD}[!]${NC} $*"; }
fail() { echo -e "${RED}${BOLD}[✗]${NC} $*" >&2; exit 1; }

# ── Banner ────────────────────────────────────────────────────────────────────
echo -e "\n${BLUE}${BOLD}"
cat <<'BANNER'
    ____             __             __          __
   / __ \____  _____/ /_____  _____/ /   ____ _/ /_
  / / / / __ \/ ___/ //_/ _ \/ ___/ /   / __ `/ __ \
 / /_/ / /_/ / /__/ ,< /  __/ /  / /___/ /_/ / /_/ / by DevKTOps
/_____/\____/\___/_/|_|\___/_/  /_____/\__,_/_.___/
BANNER
echo -e "${NC}"
echo -e "  ${CYAN}Google Cloud Shell Edition${NC}\n"

# ── Prerequisites ─────────────────────────────────────────────────────────────
note "Checking prerequisites..."

command -v docker &>/dev/null \
  || fail "docker not found — is Docker running in Cloud Shell?"

if docker compose version &>/dev/null 2>&1; then
  COMPOSE="docker compose"
elif command -v docker-compose &>/dev/null 2>&1; then
  COMPOSE="docker-compose"
else
  fail "docker compose / docker-compose not found"
fi

command -v curl &>/dev/null || fail "curl not found"

ok "Docker : $(docker --version | awk '{gsub(/,/,""); print $3}')"
ok "Compose: $($COMPOSE version --short 2>/dev/null || echo 'available')"

# ── Write compose config to a persistent work dir ────────────────────────────
WORK_DIR="$HOME/.devktops-lab"
mkdir -p "$WORK_DIR"

cat > "$WORK_DIR/docker-compose.yml" << 'COMPOSE'
version: "3.9"

networks:
  lab:
    driver: bridge

volumes:
  lab-state:

services:

  portal:
    image: devktops/docker-lab-portal:latest
    container_name: lab-portal
    ports:
      - "8080:8080"
    networks:
      - lab
    depends_on:
      - node
      - labapi
    healthcheck:
      test: ["CMD", "curl", "-sf", "http://localhost:8080/healthz"]
      interval: 5s
      timeout: 3s
      retries: 18
      start_period: 10s
    restart: unless-stopped

  node:
    image: devktops/docker-lab-node:latest
    container_name: lab-node
    hostname: lab-node
    networks:
      - lab
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - lab-state:/data
    expose:
      - "7681"
    restart: unless-stopped

  labapi:
    image: devktops/docker-lab-api:latest
    container_name: lab-api
    networks:
      - lab
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - lab-state:/data
    expose:
      - "5000"
    restart: unless-stopped
COMPOSE

cd "$WORK_DIR"

# ── Tear down any previous run ────────────────────────────────────────────────
note "Cleaning up any previous lab instance..."
$COMPOSE down --remove-orphans --volumes 2>/dev/null || true
ok "Environment clean"

# ── Pull images ───────────────────────────────────────────────────────────────
note "Pulling lab images..."
$COMPOSE pull
ok "Images ready"

# ── Start the stack ───────────────────────────────────────────────────────────
note "Starting lab stack..."
$COMPOSE up -d
ok "Stack started"

# ── Wait for portal health ────────────────────────────────────────────────────
note "Waiting for portal to become healthy..."
MAX_WAIT=90
ELAPSED=0
until curl -sf http://localhost:8080/healthz &>/dev/null; do
  if [[ $ELAPSED -ge $MAX_WAIT ]]; then
    warn "Health check timed out. Dumping portal logs:"
    $COMPOSE logs --tail=30 portal
    fail "Portal did not become healthy within ${MAX_WAIT}s"
  fi
  sleep 2; ELAPSED=$((ELAPSED + 2))
  echo -ne "\r  ${CYAN}Waiting...${NC} ${ELAPSED}s / ${MAX_WAIT}s   "
done
echo -e "\r  ${GREEN}${BOLD}[✓]${NC} Portal is healthy                    "

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}${BOLD}Lab environment is ready!${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
echo -e "  ${CYAN}1. Open the lab portal${NC}"
echo -e "     Click ${BOLD}Web Preview${NC} (top-right) → ${BOLD}Preview on port 8080${NC}\n"
echo -e "  ${CYAN}2. Enter the access token provided by your instructor${NC}\n"
echo -e "  ${CYAN}3. Stop the lab when finished${NC}"
echo -e "     ${BOLD}cd ~/.devktops-lab && ${COMPOSE} down${NC}\n"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
