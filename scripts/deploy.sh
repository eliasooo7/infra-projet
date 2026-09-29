#!/usr/bin/env bash
set -euo pipefail
IMAGE="tp3-mon-app:${1:-1.0}"
NAME="tp3-mon-app"
PORT="${PORT:-8081}"

echo "[1/4] Build"; docker build -t "$IMAGE" .

echo "[2/4] Nettoyage eventuel"
docker rm -f "$NAME" 2>/dev/null || true

echo "[3/4] Run"
docker run -d --name "$NAME" --restart unless-stopped -p "$PORT":8080 "$IMAGE"

echo "[4/4] Healthcheck (max 30s)"
for i in $(seq 1 10); do
  status=$(docker inspect -f '{{.State.Health.Status}}' "$NAME" 2>/dev/null || echo starting)
  [ "$status" = "healthy" ] && { echo "OK: $NAME healthy"; exit 0; }
  sleep 3
done
echo "ERREUR: healthcheck non atteint" >&2; exit 1
