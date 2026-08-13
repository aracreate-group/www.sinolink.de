# SinoLink Website

The public websites for SinoLink — a static site covering two domains,
**sinolink.de** (English, German, Chinese) and **sinolink.pt** (Portuguese),
from a single repository with one shared set of assets.

Every language lives once in `src/`. `make build` copies that single source into
one folder per domain under `dist/`, differing only in which language becomes
`index.html`. Cloudflare Pages runs that build itself, so nothing generated is
committed.

## Stack

| Layer | Tool |
| --- | --- |
| Markup | Static HTML, exported from Webflow and hand-maintained since |
| Styles | Plain CSS (`normalize.css` + Webflow `base.css` / `style.css`) |
| Scripts | Webflow runtime bundle (`assets/js/app.js`) |
| Fonts | Figtree, self-hosted as woff2 |
| Contact form | Web3Forms, called directly from the browser |
| Hosting | Cloudflare Pages, one project per domain |
| Local server | `python3 -m http.server` via `make dev` |
| Task runner | make |
| Release automation | semantic-release |

No Google services are used anywhere on the site — fonts are self-hosted in
`src/assets/fonts`. This is deliberate, so the site stays reliable in regions
where Google is blocked.

## Layout

```
src/                          One flat set of pages, one copy of each language
├── en.html                   English
├── de.html                   German
├── cn.html                   Chinese
├── pt.html                   Portuguese
├── impressum.html            Legal notice (shared by all languages)
├── privacy-policy.html       Privacy policy (shared by all languages)
├── assets/                   css, js, images, videos, fonts
├── robots-de.txt             Crawler rules, one per domain
├── robots-pt.txt
├── sitemap-de.xml            Sitemap, one per domain
└── sitemap-pt.xml
```

The crawler files are per-domain because each has to advertise its own sitemap
URL. `make build` renames the matching pair to `robots.txt` and `sitemap.xml` in
each output folder.

`make build` turns that into one document root per domain:

```
dist/                         Generated, gitignored, never committed
├── de/                       sinolink.de
│   ├── index.html            Copy of en.html
│   ├── de.html cn.html pt.html
│   ├── impressum.html privacy-policy.html
│   ├── robots.txt sitemap.xml    From the -de pair
│   └── assets/
└── pt/                       sinolink.pt
    ├── index.html            Copy of pt.html
    ├── en.html de.html cn.html
    ├── impressum.html privacy-policy.html
    ├── robots.txt sitemap.xml    From the -pt pair
    └── assets/
```

Both domains ship every language, so the menu never has to leave the domain the
visitor is on. The only difference between the two folders is which language was
copied to `index.html`.

`dist/` is deliberately not `releases/`. The conventions treat `releases/` as
committed, tagged artefacts, whereas this output is regenerated on every deploy
and belongs in the gitignore.

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

Two Cloudflare Pages projects, one per domain, both connected to this repository
and both building from the same `src/`. Each project runs its own make target and
serves its own output folder, so each domain has a real document root of its own.
Nothing is redirected, rewritten or masked: the address bar always shows the
domain the visitor typed.

### Cloudflare Pages settings

Under **Settings > Build configuration** for each project:

| Setting | sinolink.de | sinolink.pt |
| --- | --- | --- |
| Framework preset | None | None |
| Build command | `make build-de` | `make build-pt` |
| Build output directory | `dist/de` | `dist/pt` |
| Root directory (advanced) | leave blank | leave blank |

**Root directory must stay blank.** With a build command in play it sets where
the build *runs*, not what gets served, and `dist/` is gitignored so it does not
exist at checkout time. The folder to serve goes in Build output directory.

Add the custom domain under **Settings > Custom domains** on each project:
`sinolink.de` on the first, `sinolink.pt` on the second. `sinolink.pt` has to be
an active zone in the same Cloudflare account before it can be attached.

The build image is Ubuntu 22.04 with GNU Make 3.81 preinstalled, so the targets
run with no extra setup. Note the Make version: 3.81 predates `.ONESHELL` and
`$(file ...)`, so keep the Makefile to plain recipes.

### Why two projects rather than one

A Pages project serves exactly one output directory. Splitting the domains into
two projects means each gets its own root natively, with no host-routing Function
and no `_redirects` rules. Cloudflare does not support hostname matching in
`_redirects`, so a single project would have required a Pages Function to map the
`Host` header to a folder.

The cost is that `src/assets` is copied into both output folders, since anything
a project serves has to sit inside its output. That duplication exists only on
Cloudflare, never in git. At 35 MB across 51 files, with the largest single file
at 11 MB against a 25 MiB per-asset cap, it is well inside the limits.

### Duplicate content

Both domains ship all four languages, so every page is reachable at two
addresses, for example `sinolink.de/pt.html` and `sinolink.pt/index.html`.
Search engines will split ranking between them unless told which is primary.

The sitemaps already draw that line. Each language is listed exactly once, on
the domain that owns it: English, German and Chinese under sinolink.de,
Portuguese under sinolink.pt. The two files carry the reciprocal halves of one
hreflang cluster, so each declares the other's languages as its alternates. The
legal pages are listed only under sinolink.de. `/en.html` is left out of the
sitemap entirely, since it is the same page as the sinolink.de root.

Each page also carries a `<link rel="canonical">` naming its one primary
address, which is what a crawler arriving directly on `sinolink.pt/de.html` by
following the menu needs, since the sitemap alone would never reach it:

| Page | Canonical |
| --- | --- |
| `en.html` | `https://sinolink.de/` |
| `de.html` | `https://sinolink.de/de.html` |
| `cn.html` | `https://sinolink.de/cn.html` |
| `pt.html` | `https://sinolink.pt/` |
| `impressum.html` | `https://sinolink.de/impressum.html` |
| `privacy-policy.html` | `https://sinolink.de/privacy-policy.html` |

English on sinolink.de is the primary language for the site as a whole, which is
why `en.html` canonicalises to the bare sinolink.de root and `x-default` in both
sitemaps points there too.

The tag travels with the file, so it needs no per-domain handling in the build.
`pt.html` declares `https://sinolink.pt/` whichever domain serves it, and
`index.html` inherits the right tag automatically by being a copy. Between them
the two domains serve fourteen URLs, which these six tags collapse to six.

Every absolute URL in the site uses the bare apex form, `https://sinolink.de`
and `https://sinolink.pt`, with no `www`. Attach the apex as the custom domain
on each Cloudflare project, and redirect `www` to it so the two forms do not
compete. Note the repository directory is still named `www.sinolink.de`, which
is historical and does not reflect the canonical hostname.

## Commands

```
make help       # Print the banner and this target list (default)
make install    # No dependencies — static HTML, CSS and JS
make setup      # Check python3 is available
make dev        # Serve src/ at localhost:8080 (open /en.html, src has no index)
make dev-de     # Build sinolink.de and serve it, exactly as in production
make dev-pt     # Build sinolink.pt and serve it, exactly as in production
make build      # Build both domains into dist/
make build-de   # Build sinolink.de into dist/de  (Cloudflare runs this)
make build-pt   # Build sinolink.pt into dist/pt  (Cloudflare runs this)
make test       # Check every asset reference in src/ resolves on disk
make release    # Cut a semantic release
make clean      # Remove dist/ and .DS_Store cruft
```

`build-de` and `build-pt` both depend on `test`, which resolves every `src`,
`href`, `url(...)` and video path in `src/` against the filesystem and fails on
the first missing file. That is the failure mode this site is most prone to, so
a broken reference now fails the Cloudflare build rather than shipping.

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
- Build output goes to a gitignored `dist/`, not to `releases/`. The conventions treat
  `releases/` as committed and tagged artefacts, which this output is not — Cloudflare
  regenerates it from `src/` on every deploy.

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
