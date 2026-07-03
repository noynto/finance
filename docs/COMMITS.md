# Messages de commit

Ce projet utilise [semantic-release](https://github.com/semantic-release/semantic-release) (`.releaserc.json`, workflow `.github/workflows/release.yml`) pour calculer automatiquement la version et générer le changelog à chaque merge sur `main`. Le plugin `@semantic-release/commit-analyzer` lit l'historique des commits selon la convention **Angular** (aucune config custom dans `.releaserc.json`, donc le preset par défaut s'applique) : **le format du message détermine directement le bump de version**. Un mauvais format = pas de release, ou un mauvais type de bump.

## Format

```
<type>(<scope optionnel>): <description>

<corps optionnel>

<footer optionnel>
```

- **type** : obligatoire, en minuscules, voir tableau ci-dessous
- **scope** : optionnel, entre parenthèses, précise la zone touchée (ex: `kubernetes`, `web`, `mongodb`)
- **description** : courte, à l'impératif, en français (comme le reste de l'historique du projet), sans point final

## Types et impact sur la version

| Type | Bump de version | Exemple réel du projet |
|------|------------------|-------------------------|
| `feat` | **minor** (`1.2.0` → `1.3.0`) | `feat(kubernetes): init container pour la création de l'utilisateur MongoDB` |
| `fix` | **patch** (`1.2.0` → `1.2.1`) | `fix: renommer MONGO_URI en FINANCE_MONGODB_URI dans le secret Kubernetes` |
| `perf` | **patch** | `perf: réduire la consommation mémoire JVM du pod` |
| `chore` | aucun release déclenché | `chore(kubernetes): suppression des manifests otel/monitoring` |
| `docs`, `style`, `refactor`, `test`, `ci`, `build` | aucun release déclenché | — |

## Breaking change → version majeure

Pour déclencher un bump **major** (`1.x.x` → `2.0.0`), ajouter un footer `BREAKING CHANGE:` décrivant le changement, ou suffixer le type d'un `!` (ex: `feat!: ...`).

```
feat(mongodb): changer le format de stockage des transactions

BREAKING CHANGE: nécessite une migration manuelle des documents existants
```

## Règles pratiques

- Un commit = un changement logique. Ne pas mélanger un `feat` et un `fix` sans rapport dans le même commit.
- Le `scope` doit correspondre à un module ou un dossier reconnaissable (`web`, `kubernetes`, `domain`, `persistence`, etc.) — regarder `git log` pour rester cohérent avec l'existant.
- Si le changement ne doit **pas** déclencher de release (typo, formatting, README, config CI), utiliser `chore`, `docs`, `ci` ou `style` — jamais `fix`/`feat` par réflexe.
