# Partner strip — four-column grid, cell outlines

**Source:** formerly `__sec_preview2.html`
**Subject:** the partner logo strip on the Chinese homepage
**Outcome:** not shipped

## What it was trying to do

[partner-strip-grid.md](partner-strip-grid.md) with the centre guide swapped for
**cell outlines**. The grid container gets a blue outline and every direct child a
red outline plus a translucent red fill, so the actual cell boundaries are visible
rather than inferred from where the logos happen to sit.

This answers a different question from the centre guide: not "is the strip
centred?" but "is the empty space inside the cells or between them?" — the usual
cause of logos that look unevenly spaced when the columns are in fact equal.

## Layout approach

Identical to the grid variant. Only the debug rules differ:

```css
.section-2.partners-yellow { background-color: #f6c506; }
.section-2.partners-yellow .grid { justify-items: center; align-items: center; }
.section-2.partners-yellow .grid img { width: 100%; max-width: 200px; height: auto; }

@media screen and (min-width: 992px) {
  .section-2.partners-yellow .grid {
    width: 100%;
    grid-template-columns: repeat(4, 1fr);
    column-gap: 24px;
  }
}

body { margin: 0 }

/* Debug overlay — not part of the design */
.section-2.partners-yellow .grid > * { outline: 2px solid red; background: rgba(255,0,0,.12); }
.section-2.partners-yellow .grid      { outline: 3px solid blue; }
```

`outline` is used rather than `border` deliberately — outlines are drawn outside
the box and do not participate in layout, so the overlay cannot shift the very
positions being measured.

## Markup

Same structure as the grid variant, with shortened `alt` text and no
`loading="lazy"`, and without the closing EMS caption:

```html
<section class="section-2 partners-yellow">
  <div class="logo-label">
    <span class="cta-yellow-label-icon" style="color:#222;">+</span>
    <strong class="bold-text-3">合作伙伴网络</strong>
  </div>
  <div class="w-layout-grid grid">
    <a href="https://www.batchone.com/" target="_blank" class="link-block-2 w-inline-block">
      <img src="images/partner-logo/2.svg" width="250" height="100" alt="BatchOne">
    </a>
    <a href="https://aracreate.group/" target="_blank" class="link-block-3 w-inline-block">
      <img src="images/partner-logo/1.svg" width="250" height="100" alt="AraCreate">
    </a>
    <img src="images/partner-logo/3.svg" width="250" height="100" alt="PONY">
    <img src="images/partner-logo/4.svg" width="250" height="100" alt="TST">
  </div>
</section>
```

## Reusing this

The two debug rules are generic — retarget the selectors and they will expose the
cells of any grid on the site. Everything else duplicates
[partner-strip-grid.md](partner-strip-grid.md), which is the fuller reference of
the two.
