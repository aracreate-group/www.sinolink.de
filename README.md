# SinoLink Website

The public websites for SinoLink — a static site covering two domains,
**sinolink.de** (English, German, Chinese) and **sinolink.pt** (Portuguese),
from a single repository with one shared set of assets.

There is no build step. The contents of `src/` are served exactly as they sit
on disk.

## Stack

| Layer | Tool |
| --- | --- |
| Markup | Static HTML, exported from Webflow and hand-maintained since |
| Styles | Plain CSS (`normalize.css` + Webflow `base.css` / `style.css`) |
| Scripts | Webflow runtime bundle (`assets/js/app.js`) |
| Fonts | Figtree, self-hosted as woff2 |
| Contact form | Web3Forms, called directly from the browser |
| Local server | `python3 -m http.server` via `make dev` |
| Task runner | make |
| Release automation | semantic-release |

No Google services are used anywhere on the site — fonts are self-hosted in
`src/assets/fonts`. This is deliberate, so the site stays reliable in regions
where Google is blocked.

## Layout

```
src/
├── de/                       sinolink.de — document root for the German domain
│   ├── index.html            English (homepage)
│   ├── german.html           German
│   ├── chinese.html          Chinese
│   ├── impressum.html        Legal notice (shared by all languages, incl. PT)
│   └── privacy-policy.html   Privacy policy (shared by all languages, incl. PT)
├── pt/                       sinolink.pt — document root for the Portuguese domain
│   └── index.html            Portuguese (homepage)
├── assets/                   Shared by both domains — css, js, images, videos, fonts
├── robots.txt
└── sitemap.xml
```

The rest of the repo follows the standard araCreate layout: `docs/`, `tests/`,
`releases/`, `logs/`, `.archives/`, `scripts/`.

## Design references

Before reworking a section of the site, read
[docs/design-references/](docs/design-references/). Each file there records a layout
that was built and evaluated — the intent, the exact CSS and markup, and whether it
shipped — so a decision that was already tested is not quietly undone. The partner
logo strip is documented in full, including the four partner URLs and `alt` text,
and why the yellow-background treatment was rejected.

This folder is the design context for anyone working on the site, and the first
thing an AI assistant should be pointed at when asked to change the layout.

## Deployment

> **Changed:** the site now lives under `src/`. Both document roots must be
> repointed from `/de` and `/pt` to `src/de` and `src/pt`.

- **sinolink.de** → point the document root at `src/de`. `index.html` is the homepage.
- **sinolink.pt** → point the document root at `src/pt`. `index.html` is the homepage.
- **`src/assets`** must stay reachable from both as `../assets/...` — it needs to sit
  one level above `de/` and `pt/`, exactly as in this repo. Both domains share the
  same images, videos, fonts and CSS/JS from this one folder; nothing is duplicated.
- Every path in the site is relative — there are no root-relative (`/...`) links — so
  the site also works when served from any subdirectory.
- If the two domains are ever deployed to **separate, unrelated hosting** (not sharing
  a filesystem), the Portuguese page's "Legal Notice" and "Privacy Policy" links
  (`../de/impressum.html`, `../de/privacy-policy.html`) and the language-switcher links
  between `/de` and `/pt` must become full web addresses
  (e.g. `https://sinolink.de/impressum.html`). They only work while both folders live
  together.

### Known issue: robots.txt and sitemap.xml

`robots.txt` and `sitemap.xml` sit beside `de/` and `pt/`, one level *above* both
document roots, so they are **not** currently reachable at
`https://www.sinolink.de/robots.txt` or `/sitemap.xml` — which is the address
`robots.txt` itself advertises. This predates the move into `src/` and has been left
as-is rather than changed silently. Fixing it means deciding whether both domains get
their own copies (`src/de/` and `src/pt/`) or only sinolink.de does.

## Commands

```
make help       # Print the banner and this target list (default)
make install    # No dependencies — static HTML, CSS and JS
make setup      # Check python3 is available
make dev        # Serve src/ at localhost:8080 — /de/ and /pt/ side by side
make dev-de     # Serve src/de as its own document root, as in production
make dev-pt     # Serve src/pt as its own document root, as in production
make build      # No build step — src/ is served as-is
make test       # Check every asset reference in src/ resolves on disk
make release    # Cut a semantic release
make clean      # Remove .DS_Store cruft
```

Run `make test` before any deploy — it resolves every `src`, `href`, `url(...)`
and video path in `src/` against the filesystem and fails on the first missing
file, which is the failure mode this site is most prone to.

## Conventions

See [aracreate-conventions](https://github.com/aracreate-group/aracreate-conventions)
for the repo structure, file headers, naming, versioning and git rules. Project-specific
rules on top of those:

- **Never push, merge into, or otherwise modify the `main` branch.** All work happens on
  `dev` (or feature branches off `dev`). Deploys to `main`/production only happen when
  explicitly named and confirmed.
- **This project is open source under Apache-2.0**, so file headers carry
  `SPDX-License-Identifier: Apache-2.0` rather than the `LicenseRef-Proprietary` the
  conventions use by default.
- The Webflow-generated bundles (`assets/css/base.css`, `assets/css/style.css`,
  `assets/js/app.js`) and `assets/css/normalize.css` are third-party or generated. They
  carry no project file header and are not hand-edited beyond what the site requires.
- HTML file headers are placed immediately after `<!DOCTYPE html>` rather than at the very
  top of the file, so no content precedes the doctype.

## License

Licensed under the Apache License, Version 2.0 — see [LICENSE](LICENSE).
Copyright 2026 SinoLink Deutschland.

Third-party components keep their own licences and are listed in [NOTICE](NOTICE):
`normalize.css` (MIT), the Webflow-generated bundles (Webflow Terms of Service), and
Figtree (SIL OFL 1.1).

The licence grants no trademark rights (Apache-2.0 §6). The SinoLink name and logo,
the marketing copy, and the photography, video and partner logos in `src/assets` are
brand assets — included so the site can be built and run, not licensed for reuse
elsewhere. See [NOTICE](NOTICE).
