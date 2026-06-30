# Roadmap — Débloquer les GitHub Achievements

Objectif : débloquer un maximum de badges de profil GitHub
(liste de référence : https://github.com/drknzz/GitHub-Achievements).

Ce repo (`Nurtal/hunt_achievements`) sert de terrain de jeu : la plupart des badges
peuvent être obtenus **sur son propre dépôt**, sans dépendre de tiers.

## Pré-requis d'exécution

Toutes ces actions passent par l'**API/web de GitHub** (créer/fermer une issue, ouvrir
et merger une PR, gérer des discussions) — un simple `git push` ne débloque **aucun** badge.
Il faut donc l'un de ces accès :

- `gh` (GitHub CLI) authentifié (`gh auth login`), **ou**
- un Personal Access Token (classic) avec les scopes `repo` + `read:discussion`/`write:discussion`,
  exporté dans `GH_TOKEN`/`GITHUB_TOKEN`.

Le push git lui-même fonctionne déjà (clé SSH `id_github`).

---

## Badges auto-réalisables (sur ce repo)

| Badge | Condition (1er palier) | Statut |
|-------|------------------------|--------|
| **Quickdraw** | Fermer une issue/PR < 5 min après ouverture | ⬜ |
| **YOLO** | Merger une PR sans review | ⬜ |
| **Pull Shark** | 2 PR mergées | ⬜ |
| **Pair Extraordinaire** | 1 commit co-authored dans une PR mergée | ⬜ |
| **Galaxy Brain** | 2 réponses acceptées dans des Discussions | ⬜ |

### Phase 1 — Quickdraw (≈1 min)
Ouvrir une issue puis la refermer immédiatement (< 5 minutes).
→ `scripts/quickdraw.sh`

### Phase 2 — Pull Shark + YOLO + Pair Extraordinaire (groupées)
Une seule mécanique de PR sert les trois badges :
1. Créer une branche, faire un commit **avec un trailer `Co-authored-by:`** (→ Pair Extraordinaire).
2. Pousser, ouvrir la PR, la merger **sans review** (→ YOLO).
3. Répéter pour atteindre **2 PR mergées** (→ Pull Shark, 1er palier).
→ `scripts/pull_shark.sh`

> Pour **Pair Extraordinaire**, le co-auteur doit être un **vrai compte GitHub**
> (l'email du trailer doit être associé à un compte). Utiliser un 2ᵉ compte à soi
> ou un collaborateur réel. Sinon le badge ne s'enregistre pas.

### Phase 3 — Galaxy Brain (≈5 min)
1. Activer les **Discussions** sur le repo (Settings → Features → Discussions).
2. Créer une discussion dans une catégorie de type **Q&A**.
3. Y répondre, puis **marquer la réponse comme acceptée** (×2 pour le 1er palier).
→ `scripts/galaxy_brain.sh` (utilise l'API GraphQL)

---

## Badges nécessitant des tiers / hors-scope automatisation

| Badge | Condition | Pourquoi pas auto |
|-------|-----------|-------------------|
| **Starstruck** | Repo avec ≥ 16 ⭐ | Étoiles d'autres utilisateurs |
| **Open Sourcerer** | PR mergées dans plusieurs repos publics tiers | Dépend de mainteneurs externes |
| **Public Sponsor** | Sponsoriser un contributeur | Paiement réel requis |

Pistes : demander des ⭐ à des contacts, contribuer à de vrais projets open-source
(bonnes premières issues), sponsoriser 1 € via GitHub Sponsors.

---

## Paliers supérieurs (pour aller plus loin)

- **Pull Shark** : 2 → 16 (bronze) → 128 (argent) → 1024 (or)
- **Pair Extraordinaire** : 1 → 10 → 24 → 48
- **Galaxy Brain** : 2 → 8 → 16 → 32

Les scripts sont paramétrables (nombre d'itérations) pour viser les paliers supérieurs.
