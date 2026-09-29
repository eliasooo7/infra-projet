#!/usr/bin/env bash
# Deploie l'application : build, run, healthcheck
# Usage : ./scripts/deploy.sh [version] [port]   (defaut : 1.0 8080)
set -euo pipefail

VERSION="${1:-1.0}"
PORT="${2:-8080}"
IMAGE="tp3-mon-app:${VERSION}"
NAME="tp3-mon-app"

# Verifications avant toute action
if ! command -v docker >/dev/null 2>&1; then
  echo "ERREUR: docker n'est pas installe (ou absent du PATH). Installez Docker puis relancez." >&2
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "ERREUR: le daemon Docker ne repond pas. Demarrez Docker Desktop puis relancez." >&2
  exit 1
fi
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
  echo "ERREUR: port invalide : $PORT" >&2
  exit 1
fi

cd "$(dirname "$0")/.."   # racine du depot (contient le Dockerfile)

echo "[1/4] Build $IMAGE"
docker build -q -t "$IMAGE" .

echo "[2/4] Nettoyage eventuel"
docker rm -f "$NAME" >/dev/null 2>&1 || true

echo "[3/4] Run sur le port $PORT"
docker run -d --name "$NAME" --restart unless-stopped -p "$PORT":8080 "$IMAGE" >/dev/null

echo "[4/4] Healthcheck (max 30s)"
for i in $(seq 1 10); do
  status=$(docker inspect -f '{{.State.Health.Status}}' "$NAME" 2>/dev/null || echo starting)
  [ "$status" = "healthy" ] && { echo "OK: $NAME healthy sur http://localhost:$PORT"; exit 0; }
  sleep 3
done
echo "ERREUR: healthcheck non atteint" >&2
exit 1
