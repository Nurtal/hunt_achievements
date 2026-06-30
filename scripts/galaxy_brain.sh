#!/usr/bin/env bash
# Galaxy Brain : obtenir des réponses acceptées dans des Discussions (Q&A).
# Pré-requis : Discussions ACTIVÉES sur le repo + gh authentifié avec scope discussions.
# Mécanique : créer une discussion Q&A -> y répondre -> marquer la réponse comme acceptée.
set -euo pipefail

OWNER="${OWNER:-Nurtal}"
NAME="${NAME:-hunt_achievements}"
COUNT="${COUNT:-2}"  # 2 = 1er palier

# Récupère l'ID du repo et une catégorie de discussion de type ANSWERABLE (Q&A).
read -r REPO_ID CAT_ID < <(gh api graphql -f query='
  query($owner:String!, $name:String!) {
    repository(owner:$owner, name:$name) {
      id
      discussionCategories(first:25) { nodes { id name isAnswerable } }
    }
  }' -F owner="$OWNER" -F name="$NAME" \
  --jq '.data.repository as $r | [$r.id, ([$r.discussionCategories.nodes[] | select(.isAnswerable)][0].id)] | @tsv')

if [[ -z "${CAT_ID:-}" || "$CAT_ID" == "null" ]]; then
  echo "[galaxy_brain] ✗ Aucune catégorie Q&A trouvée."
  echo "  -> Active les Discussions et crée une catégorie de format 'Question / Answer'."
  exit 1
fi

for i in $(seq 1 "$COUNT"); do
  echo "[galaxy_brain] discussion $i/$COUNT"
  DISC_ID=$(gh api graphql -f query='
    mutation($repo:ID!, $cat:ID!, $title:String!, $body:String!) {
      createDiscussion(input:{repositoryId:$repo, categoryId:$cat, title:$title, body:$body}) {
        discussion { id }
      }
    }' -F repo="$REPO_ID" -F cat="$CAT_ID" \
       -F title="Question $i pour Galaxy Brain" \
       -F body="Question auto-générée pour le badge Galaxy Brain." \
       --jq '.data.createDiscussion.discussion.id')

  COMMENT_ID=$(gh api graphql -f query='
    mutation($disc:ID!, $body:String!) {
      addDiscussionComment(input:{discussionId:$disc, body:$body}) { comment { id } }
    }' -F disc="$DISC_ID" -F body="Réponse à la question $i." \
       --jq '.data.addDiscussionComment.comment.id')

  gh api graphql -f query='
    mutation($id:ID!) { markDiscussionCommentAsAnswer(input:{id:$id}) { clientMutationId } }' \
    -F id="$COMMENT_ID" >/dev/null
  echo "[galaxy_brain] discussion $i : réponse marquée comme acceptée."
done

echo "[galaxy_brain] OK — $COUNT réponses acceptées."
