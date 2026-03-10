# axiom-designs

AXE Technology design system — Build Doctrine reference implementations in HTML/CSS. Component library, layout templates, animations, and showcase pages.

## Quick Start

```bash
make preview     # Open showcase in browser
make build       # Validate all HTML files exist
```

## Structure

```
components/     Buttons, cards, forms, tables, modals, navigation
layouts/        Full-page layouts — dashboards, command center, globe view
animations/     Loaders, transitions, particle systems, SVG animations
showcase/       Combined showcase pages
axiom-hud.css   Core HUD stylesheet
```

## Components

| File | Contents |
|------|----------|
| `components/buttons.html` | Primary, ghost, destructive CTAs |
| `components/cards.html` | Surface cards with accent bars |
| `components/tables.html` | Dark-themed data tables |
| `components/forms.html` | Input fields, selects, toggles |
| `components/modals.html` | Dialog overlays |
| `components/navigation.html` | Nav bars, sidebars, tabs |
| `components/panels.html` | Collapsible panels |
| `components/indicators.html` | Status badges, progress bars |
| `components/data-displays.html` | Charts, metrics, readouts |

## Layouts

| File | Description |
|------|-------------|
| `layouts/command-center.html` | Multi-panel ops dashboard |
| `layouts/intel-dashboard.html` | Intelligence overview |
| `layouts/threat-dashboard.html` | Threat monitoring view |
| `layouts/globe-view.html` | Geographic visualization |
| `layouts/targeting-overlay.html` | Precision targeting HUD |
| `layouts/boot-sequence.html` | System boot animation |

## Design Tokens

All implementations follow [Build Doctrine](https://github.com/memjar/axe-brand/blob/main/BUILD_DOCTRINE.md) — dark by default, `#00C48C` action green, sharp corners, left-aligned.

---

*Built by AXE Technology. Established February 2, 2026.*
