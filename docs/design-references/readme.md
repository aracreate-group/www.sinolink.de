# DESIGN REFERENCES

Reference material for anyone — human or AI assistant — making design changes to
this site. Each file records a layout that was built and evaluated: what it was
trying to achieve, the exact CSS and markup used, and whether it shipped.

These are **references, not source**. Nothing here is served. Read them to
understand why the live markup looks the way it does before changing it.

| Reference | Subject | Outcome |
| --- | --- | --- |
| [partner-strip-flex.md](partner-strip-flex.md) | Partner logo strip, flexbox distribution + measurement harness | Not shipped |
| [partner-strip-grid.md](partner-strip-grid.md) | Partner logo strip, 4-column grid with centre guide | Not shipped |
| [partner-strip-grid-debug.md](partner-strip-grid-debug.md) | Same grid with cell outlines for debugging | Not shipped |

All three explored a **yellow-background** treatment for the partner strip. The
live site rejected it — see [the shipped layout](#the-shipped-layout) below.

## The shipped layout

`src/de/index.html`, `german.html`, `chinese.html` and `src/pt/index.html` all use
a plain `.section-2` with the page background. The yellow (`#f6c506`) survives only
as the colour of the `+` icon in the section label:

```html
<section class="section-2">
  <div class="logo-label">
    <span class="cta-yellow-label-icon" style="color:#f6c506;">+</span>
    <strong class="bold-text-3">PARTNER NETWORK</strong>
  </div>
  <div class="w-layout-grid grid">
    <a href="https://www.batchone.com/" target="_blank" class="link-block-2 w-inline-block">
      <img src="../assets/images/2.svg" loading="lazy" width="250" height="100" alt="">
      <img src="../assets/images/2-colour.svg" loading="lazy" alt="" class="...">
    </a>
    ...
  </div>
  <div class="logo-label"><strong class="bold-text-4">Various EMS Service and Much More…</strong></div>
</section>
```

Two differences from every reference below are worth knowing before editing:

- The live strip uses **paired logos** — `N.svg` plus `N-colour.svg` from
  `src/assets/images/`, stacked for a hover colour swap. The references use the
  flat single-file `partner-logo/N.svg` set, which is *not* what ships.
- The live strip uses the **stock Webflow `.grid`** with no layout overrides. The
  column and gap rules in the references were per-page `<style>` blocks that were
  never promoted into `style.css`.

## Note on paths

These references were written when CSS and images sat at the repo root. Their
original `css/...` and `images/...` links predate the move into `src/assets/`, so
the markup below is reproduced as it was written. Add the `../assets/` prefix if
you rebuild any of it.
