# SinoLink Website

Static HTML/CSS/JS site covering two domains from one repository.

## Folder structure

```
/
├── assets/     Shared CSS, JS, images, videos, fonts — used by both /de and /pt
├── de/         sinolink.de site — English, German, Chinese
│   ├── index.html            English (homepage)
│   ├── german.html           German
│   ├── chinese.html          Chinese
│   ├── impressum.html        Legal notice (shared by all languages, including PT for now)
│   └── privacy-policy.html   Privacy policy (shared by all languages, including PT for now)
├── pt/         sinolink.pt site — Portuguese only
│   └── index.html            Portuguese (homepage)
├── robots.txt
└── sitemap.xml
```

## Domain setup for IT

- **sinolink.de** → point the domain's document root at the `/de` folder. `de/index.html` is the homepage.
- **sinolink.pt** → point the domain's document root at the `/pt` folder. `pt/index.html` is the homepage.
- **`/assets`** must stay reachable by both folders as `../assets/...` (i.e. it needs to sit one level above `de/` and `pt/`, exactly as in this repo). Both domains currently share the same images, videos, fonts, and CSS/JS from this one folder — nothing is duplicated.
- The Portuguese page's "Legal Notice" / "Privacy Policy" footer links currently point at `../de/impressum.html` and `../de/privacy-policy.html` — i.e. `sinolink.pt` currently reuses the legal pages hosted on `sinolink.de`. If the two domains are ever deployed to **separate, unrelated hosting** (not sharing a filesystem), these links need to be changed to full web addresses (e.g. `https://sinolink.de/impressum.html`) instead — same for the language-switcher links between `/de` and `/pt`, which currently use short relative links (`../de/...`, `../pt/...`) that only work while both folders live together.

## Notes

- No build step — plain static HTML, just upload/serve as-is.
- Contact form submits via a third-party service (Web3Forms), called directly from the browser — works regardless of hosting.
- No Google services are used anywhere on the site (fonts are self-hosted in `/assets/fonts`) — this is intentional, for reliability in regions where Google is blocked.
