# SOURCE

The SinoLink website itself — plain static HTML, CSS, JS and media, served
as-is with no build step.

```
src/
├── de/         sinolink.de — English (index), German, Chinese, plus legal pages
├── pt/         sinolink.pt — Portuguese
├── assets/     Shared CSS, JS, images, videos and fonts used by both sites
├── robots.txt
└── sitemap.xml
```

`de/` and `pt/` are each a domain's document root; `assets/` sits one level
above them and is reached as `../assets/...` from both. That relative layout is
load-bearing — see the deployment notes in the root `README.md` before moving
anything.

Third-party and generated files under `assets/` (the Webflow CSS/JS bundles and
`normalize.css`) are not hand-maintained and carry no project file header. See
`LICENSE`.
