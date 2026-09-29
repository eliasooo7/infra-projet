#!/usr/bin/env bash
set -euo pipefail
NAME="tp3-mon-app"
if docker ps -a --format '{{.Names}}' | grep -qx "$NAME"; then
  echo "Arret et suppression de $NAME"
  docker stop "$NAME" >/dev/null
  docker rm "$NAME" >/dev/null
else
  echo "$NAME absent : rien a faire"
fi
docker image prune -f >/dev/null
echo "OK: teardown termine"
