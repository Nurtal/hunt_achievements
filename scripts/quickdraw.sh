#!/usr/bin/env bash
# Quickdraw : fermer une issue moins de 5 minutes après son ouverture.
# Pré-requis : gh authentifié (ou GH_TOKEN exporté).
set -euo pipefail

REPO="${REPO:-Nurtal/hunt_achievements}"

echo "[quickdraw] création de l'issue..."
url=$(gh issue create --repo "$REPO" \
  --title "Quickdraw achievement" \
  --body "Issue ouverte puis fermée immédiatement pour le badge Quickdraw.")
num=$(basename "$url")
echo "[quickdraw] issue #$num créée : $url"

echo "[quickdraw] fermeture immédiate..."
gh issue close --repo "$REPO" "$num"
echo "[quickdraw] OK — issue #$num fermée. Badge Quickdraw débloqué sous peu."
