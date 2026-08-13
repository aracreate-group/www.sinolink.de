# Partner strip — four-column grid

**Source:** formerly `__sec_preview.html`
**Subject:** the partner logo strip on the Chinese homepage
**Outcome:** not shipped

## What it was trying to do

The same yellow partner band as [partner-strip-flex.md](partner-strip-flex.md),
but keeping the Webflow grid and giving it four explicit equal columns instead of
switching to flexbox. A fixed red guide line at `left: 50%` makes it obvious at a
glance whether the strip is centred on the page.

This is the most complete of the three references — it is the only one carrying
the real partner URLs, `alt` text, `loading="lazy"`, and the closing EMS caption.
Start here if you are rebuilding the section.

## Layout approach

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

/* Centre guide — debug aid, not part of the design */
.guide { position: fixed; top: 0; bottom: 0; width: 2px; background: red; z-index: 99 }
```

`justify-items: center` centres each logo inside its own column, which is what
gives even spacing without flexbox. The 24px `column-gap` matches the `gap` used
in the flex variant, so the two were directly comparable.

## Markup

```html
<section class="section-2 partners-yellow">
  <div class="logo-label">
    <span class="cta-yellow-label-icon" style="color:#222;">+</span>
    <strong class="bold-text-3">合作伙伴网络</strong>
  </div>
  <div class="w-layout-grid grid">
    <a href="https://www.batchone.com/" target="_blank" class="link-block-2 w-inline-block">
      <img src="images/partner-logo/2.svg" loading="lazy" width="250" height="100" alt="BatchOne">
    </a>
    <a href="https://aracreate.group/" target="_blank" class="link-block-3 w-inline-block">
      <img src="images/partner-logo/1.svg" loading="lazy" width="250" height="100" alt="AraCreate">
    </a>
    <img src="images/partner-logo/3.svg" loading="lazy" width="250" height="100" alt="PONY Testing">
    <img src="images/partner-logo/4.svg" loading="lazy" width="250" height="100" alt="TST Technology">
  </div>
  <div class="logo-label">
    <strong class="bold-text-4">各类 电子制造服务 (EMS) 及更多其它服务</strong>
  </div>
</section>

<div class="guide" style="left:50%"></div>
```

## The four partners

Recorded here because this is the only reference that names them all:

| Slot | Logo file | Partner | Link |
| --- | --- | --- | --- |
| 1 | `partner-logo/2.svg` | BatchOne | https://www.batchone.com/ |
| 2 | `partner-logo/1.svg` | AraCreate | https://aracreate.group/ |
| 3 | `partner-logo/3.svg` | PONY Testing | — |
| 4 | `partner-logo/4.svg` | TST Technology | — |

Slots 3 and 4 are unlinked. The logo file numbers do **not** match slot order —
slot 1 uses `2.svg`, slot 2 uses `1.svg`. The live site preserves this same
ordering with its `2.svg` / `1.svg` pairs.

## Reusing this

The `.guide` rule is a debug aid — strip it before shipping anything based on
this. The `alt` text and partner URLs above are the values to carry forward; the
live markup currently ships `alt=""` on these logos.
