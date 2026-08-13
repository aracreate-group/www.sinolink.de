# Partner strip — flexbox distribution

**Source:** formerly `__measure.html`
**Subject:** the partner logo strip on the Chinese homepage
**Outcome:** not shipped

## What it was trying to do

Distribute four partner logos evenly across the full width of a yellow band, and
**measure the result** rather than eyeball it. The inline script prints the
bounding box of the grid and every child to the page, so left/right/centre
positions can be read off directly and compared against the intended symmetry.

This is the measurement harness of the three references — the other two are
visual. Reach for this one when the question is "are these actually centred?"
rather than "does this look right?".

## Layout approach

Flexbox with `space-evenly`, overriding the Webflow `.grid` at the desktop
breakpoint only. Below 992px the stock Webflow grid behaviour is left alone and
logos simply fill their cell up to a 200px cap.

```css
.section-2.partners-yellow { background-color: #f6c506; }
.section-2.partners-yellow .grid img { width: 100%; max-width: 200px; height: auto; }

@media screen and (min-width: 992px) {
  .section-2.partners-yellow .grid {
    display: flex;
    width: 100%;
    justify-content: space-evenly;
    align-items: center;
    gap: 24px;
  }
  .section-2.partners-yellow .grid img { width: 200px; }
}

body { margin: 0 }
```

Note `display: flex` replaces the grid entirely here — that is the substantive
difference from [partner-strip-grid.md](partner-strip-grid.md), which keeps the
grid and sets explicit columns instead.

## Markup

```html
<section class="section-2 partners-yellow">
  <div class="logo-label">
    <span style="color:#222;">+</span>
    <strong class="bold-text-3">合作伙伴网络</strong>
  </div>
  <div class="w-layout-grid grid">
    <a href="#" class="link-block-2 w-inline-block">
      <img src="images/partner-logo/2.svg" width="250" height="100">
    </a>
    <a href="#" class="link-block-3 w-inline-block">
      <img src="images/partner-logo/1.svg" width="250" height="100">
    </a>
    <img src="images/partner-logo/3.svg" width="250" height="100">
    <img src="images/partner-logo/4.svg" width="250" height="100">
  </div>
</section>
<pre id="out" style="font:14px monospace;padding:12px"></pre>
```

Logos 1 and 2 are wrapped in links; 3 and 4 are bare images. That asymmetry is
inherited from the Webflow export and is present in the live site too.

## Measurement harness

Appends `display`, horizontal margins, and the left/right/centre of the grid and
each child to the `<pre id="out">` block:

```js
function r(el) {
  var b = el.getBoundingClientRect();
  return { l: Math.round(b.left), r: Math.round(b.right), c: Math.round((b.left + b.right) / 2) };
}
var grid = document.querySelector('.grid');
var gm = getComputedStyle(grid);
var o = 'display=' + gm.display + ' marginL=' + gm.marginLeft + ' marginR=' + gm.marginRight + '\n';
o += 'grid ' + JSON.stringify(r(grid)) + '\n';
var it = grid.children;
for (var i = 0; i < it.length; i++) { o += 'item' + i + ' ' + JSON.stringify(r(it[i])) + '\n'; }
document.getElementById('out').textContent = o;
```

## Reusing this

The harness is the reusable part and is not specific to this section — point the
`querySelector` at any container to get the same readout. Everything else was
superseded; see the shipped layout in [readme.md](readme.md).
