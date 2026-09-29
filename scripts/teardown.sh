#!/usr/bin/env bash
# Arrete et supprime un conteneur de facon idempotente
# Usage : ./scripts/teardown.sh [nom_conteneur]   (defaut : tp3-mon-app)
set -euo pipefail

NAME="${1:-tp3-mon-app}"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERREUR: docker n'est pas installe (ou absent du PATH)." >&2
  exit 1
fi

if [ -n "$(docker ps -aq --filter "name=^${NAME}$")" ]; then
  echo "[1/2] Arret et suppression de $NAME"
  docker stop "$NAME" >/dev/null
  docker rm "$NAME" >/dev/null
else
  echo "[1/2] $NAME absent : rien a faire"
fi

echo "[2/2] Nettoyage des images inutilisees"
docker image prune -f
echo "OK: teardown termine"
