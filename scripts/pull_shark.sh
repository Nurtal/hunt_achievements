#!/usr/bin/env bash
# Pull Shark (PR mergées) + YOLO (merge sans review) + Pair Extraordinaire (commit co-authored).
# Pré-requis : gh authentifié (ou GH_TOKEN exporté) + push SSH fonctionnel.
set -euo pipefail

REPO="${REPO:-Nurtal/hunt_achievements}"
BASE="${BASE:-main}"
COUNT="${COUNT:-2}"  # nb de PR à merger (2 = 1er palier Pull Shark)

# Co-auteur pour Pair Extraordinaire : DOIT être un vrai compte GitHub.
# Surcharger via la variable COAUTHOR, ex :
#   COAUTHOR="Jane Doe <jane@users.noreply.github.com>" ./scripts/pull_shark.sh
COAUTHOR="${COAUTHOR:-}"

git fetch origin "$BASE" >/dev/null 2>&1 || true

for i in $(seq 1 "$COUNT"); do
  branch="achievement/pr-$(date +%s)-$i"
  echo "[pull_shark] PR $i/$COUNT — branche $branch"

  git checkout -B "$branch" "origin/$BASE"
  line="contribution $i — $(date -u +%FT%TZ)"
  printf '%s\n' "$line" >> CONTRIB_LOG.md
  git add CONTRIB_LOG.md

  if [[ -n "$COAUTHOR" ]]; then
    git commit -m "chore: contribution $i" -m "" -m "Co-authored-by: $COAUTHOR"
  else
    echo "[pull_shark] ⚠ COAUTHOR non défini : Pair Extraordinaire ne sera PAS débloqué."
    git commit -m "chore: contribution $i"
  fi

  git push -u origin "$branch"

  url=$(gh pr create --repo "$REPO" --base "$BASE" --head "$branch" \
        --title "Contribution $i" --body "PR pour Pull Shark / YOLO / Pair Extraordinaire.")
  echo "[pull_shark] PR créée : $url"

  # Merge sans review => YOLO. --squash garde l'historique de base propre.
  gh pr merge --repo "$REPO" "$url" --squash --delete-branch
  echo "[pull_shark] PR $i mergée."
done

git checkout "$BASE"
echo "[pull_shark] OK — $COUNT PR mergées (Pull Shark + YOLO + Pair Extraordinaire si COAUTHOR fourni)."
