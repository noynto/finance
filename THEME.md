# Theme

UI theme: **Everforest Dark Soft**

## Palette

| Token           | Hex       | Role                        |
|-----------------|-----------|-----------------------------|
| `bg`            | `#2d353b` | Background principal        |
| `bg-elevated`   | `#343f44` | Cards, panneaux             |
| `bg-elevated-2` | `#3d484d` | Inputs, surfaces secondaires|
| `border`        | `#475258` | Bordures                    |
| `fg`            | `#d3c6aa` | Texte principal             |
| `fg-dim`        | `#9da9a0` | Texte secondaire            |
| `fg-faint`      | `#7a8478` | Texte tertiaire / labels    |
| `accent`        | `#a7c080` | Vert — actions, focus       |
| `accent-hover`  | `#8fad6f` | Vert — état hover           |
| `error`         | `#e67e80` | Rouge — erreurs             |

## Usage

- Les fichiers `docs/*.html` (maquettes) et les templates `infrastructure/web/src/main/jte/*.jte` utilisent tous cette palette.
- Dans les HTML, les tokens sont exposés en CSS custom properties (`--bg`, `--fg`, …).
- Dans les JTE, la palette est déclarée dans la config Tailwind sous le namespace `ef` (`ef-bg`, `ef-accent`, …).