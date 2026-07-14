# Handoff: aemeredith.com Redesign (Ruby static site + Elle Bread ordering)

## Overview

Redesign of aemeredith.com — Elle Meredith's personal site — as a 3-page site:

1. **Home** — bio, testimonials, work values, community, talks
2. **Articles** — list of her articles/newsletters, standardized on `title` + `date` frontmatter
3. **Elle Bread** — a mini-bakery order form (public) with an admin side (weekly bread selection + order history)

The user wants the site rebuilt as a **Ruby static site generator** (Home + Articles are static content), plus a small **dynamic backend** for Elle Bread (order form → Postgres + email notification, simple admin).

## About the Design Files

The files in this bundle (`Home.dc.html`, `Articles.dc.html`, `Elle Bread.dc.html`) are **design references built as self-contained HTML prototypes** — they are not production code to copy directly. They run in a custom lightweight component runtime (`support.js`, included for reference/viewing only — do not port it). Treat them as a precise visual + interaction spec to recreate:

- Home and Articles → as static pages/templates in the chosen Ruby static site generator (e.g. Jekyll, Middleman, Bridgetown, or a hand-rolled Ruby script — user has not committed to one; recommend Bridgetown or a minimal custom Rake-based generator given the small scope).
- Elle Bread → the **visual design and client-side interaction** (bread selection, quantity steppers, live total, admin toggle UI) should be recreated, but the **data layer is entirely unbuilt** in this prototype — see "Backend Requirements" below. This needs real server-side implementation.

## Fidelity

**High-fidelity.** Colors, typography, spacing, and layout are final. Recreate pixel-precise using the design tokens below. Copy (all body text on Home/Articles) is real content provided by the user, not placeholder — carry it over verbatim. Exceptions, clearly not final:
- **Articles list content is placeholder** — 10 invented article titles/dates standing in for the user's real `/posts` files. Do not ship these; replace with real parsed post data.
- **Elle Bread's bread list, prices, and order history are placeholder** — invented for the prototype. Replace with the user's real bread YAML and real order data.

## Design System

- **Typography**: `'Helvetica Neue', Helvetica, Arial, sans-serif` — Swiss/International Typographic Style. No serif, no italic body text. Large-scale contrast: oversized headline (64–96px) vs. small caps labels (13px, letter-spacing 0.06em, uppercase).
- **Color palette**:
  - White `#ffffff` (background)
  - Near-black `#111111` (primary text, borders, buttons)
  - Mid gray `#555555` / `#777777` / `#999999` (secondary text, muted labels)
  - Light gray `#dddddd` / `#eeeeee` / `#cccccc` (hairline rules)
  - Accent red `#c11c1c` — used sparingly: section numbers, active nav underline, hover states, primary CTA hover
- **Grid**: content max-width 1120px (760px for narrower text columns on some sections), centered, 24px side padding. Sections use a `60px | 1fr` two-column grid — the left column holds a small red section number ("01", "02"...), the right column holds content. This numbering is a core motif — keep it on every major section.
- **No rounded corners, no shadows, no gradients.** Borders are 1px hairlines (`#ddd`/`#eee`) or bold 2–3px rules (`#111`) for major dividers (header/footer).
- **Buttons**: rectangular, no border-radius. Primary = black bg/white text, hover → red bg. Outline = white bg/black 1.5px border, hover → invert to black bg/white text.

## Screens / Views

### 1. Home (`Home.dc.html`)
- **Header**: logo-as-link "ELLE MEREDITH" (uppercase, bold, red-on-hover) top-left; nav top-right: Home / Articles / Elle Bread (active = bold black w/ red underline; inactive = gray, hover = darker + red underline via fake-bold text-shadow trick, not `font-weight`, to avoid layout shift), divider, then GitHub + LinkedIn icon links (real SVG logos, currentColor, hover → red).
- **Section 01 — Hero**: Oversized two-line name (96px), tagline paragraph (20px), row of 3 pill-less uppercase label spans ("Currently — Blackmill", "Previously Director of Eng — thoughtbot", "20+ years in software").
- **Section 02 — Bio**: Two-column (1fr 1fr, 48px gap) prose, 17px/1.65 line-height. Full text provided by user (see live file for exact copy — do not paraphrase).
- **Section 03 — Community**: Single column, max 65ch, small uppercase label heading + prose paragraph with inline links (Rails Girls, RubyConfAU, Ruby Australia, GORUCO, GORUCO X, GORUCO conference).
- **Section 04 — Testimonials carousel**: One quote at a time, italic 16px muted gray, fixed-height container (230px) to prevent layout jump on quote-length change. Below: citation (name + title), then a control row: prev arrow button (outline, invert on hover) — counter "01 / 04" — next arrow button (solid black, invert on hover). Behavior:
  - Auto-advances every 6s
  - Pauses on hover/focus/touch of the container
  - 250ms opacity crossfade on change (fade out → swap → fade in)
  - Supports left/right arrow keys when focused
  - Supports touch swipe (50px threshold)
  - 4 testimonials total (full text in the live file)
- **Section 05 — Work values** (full-bleed `#c11c1c` red band, white text): numbered list 01–09, 2-column, of the user's stated work values.
- **Section 06 — Talks**: numbered heading, single-column list of 43 talks (title + venue/date), collapsed to first 8 with a "Show all 43 talks" toggle (red text button, expands/collapses via component state).
- **Footer**: 3px black top rule, small gray copyright line.

### 2. Articles (`Articles.dc.html`)
- Same header/nav pattern (Articles active).
- **Section 01**: "Articles" H1 (64px) + one-line subhead describing the topic focus (team culture / org dynamics / leadership).
- **Year-grouped list**: each year section shows the year as a large light-gray numeral (32px, `#ddd`) in the left grid column, and in the right column a list of article rows: title (19px) left, date (13px gray, monospace-free) right, hairline divider between rows. Hovering a row turns the title text red (`.article-row:hover .article-title`).
- No article detail/reading page exists yet — links currently go to `#`. Real implementation needs a post detail template.

### 3. Elle Bread (`Elle Bread.dc.html`)
Three view-states toggled by local component state (`public` / `adminLogin` / `admin`) — **in the real app these should be separate routes**, not client-side-only state:

**Public order form** (section 01 hero, section 02 form):
- Hero: "Elle Bread" H1 + one-line description.
- "This week's breads": 3 breads (selected by admin) shown with name, description, price, a stepper (− / qty / +) for quantity.
- Running total (bold, top-bordered row).
- Name + phone text inputs (plain, square, 1px `#ccc` border).
- "Place order" button — disabled (gray) until at least one item has qty > 0 AND both name and phone are filled; enabled state is solid black, hover → red.
- On submit: shows a confirmation message inline (bordered left, black). **This does not persist anywhere in the prototype** — see Backend Requirements.
- Small low-emphasis "Admin" text link at the bottom.

**Admin login** (section 02): password field + "Log in" button. **No real authentication in the prototype** — any submission logs in.

**Admin dashboard** (sections 02–04):
- "This week's 3 breads": checkbox list of the full bread catalog; exactly 3 may be checked at once (others disabled once 3 are selected) — hint text shows "X of 3 selected".
- "Order history" table: Date / Name / Phone / Order summary / Total, newest first, hairline row dividers, bold 2px header rule.
- "View public form →" link returns to the public view.

## Interactions & Behavior Summary
- Bread quantity steppers: plain +/− buttons, no min/max beyond 0 floor.
- Total recalculates live from `Σ(qty × price)` over the 3 weekly breads.
- Order form validation: submit disabled until items selected + both fields non-empty (no phone format validation implemented — add real validation server-side).
- Admin weekly-bread selection: hard cap of 3, enforced by disabling unchecked checkboxes once 3 are selected.
- All hover/focus states are implemented via small helper CSS classes in each file's `<style>` block (`.el-link`, `.nav-link`, `.nav-badge-outline/solid`, `.btn-primary`, `.btn-outline`, `.article-row`) rather than inline styles — **this is intentional**: a hover/focus pseudo-class rule can never override a property already set via an inline `style` attribute (inline always wins in CSS cascade regardless of specificity), so the resting-state color/background for anything with a hover variant must live in a real stylesheet rule. Preserve this pattern (or your framework's equivalent, e.g. CSS modules/styled-components) when reimplementing.

## State Management (client-side, for reference)
- Home: `showAllTalks` (bool), `testimonialIndex` (int), `isPaused` (bool), `quoteVisible` (bool, drives crossfade).
- Elle Bread: `view` ('public'|'adminLogin'|'admin'), `weeklyIds` (array of 3 bread ids), `qty` (map of id→int), `name`, `phone`, `orderConfirmed` (bool), `adminPassword` (string, unused for real validation).

## Design Tokens

| Token | Value |
|---|---|
| Font | `'Helvetica Neue', Helvetica, Arial, sans-serif` |
| Background | `#ffffff` |
| Text primary | `#111111` |
| Text secondary | `#555555` |
| Text muted | `#777777` / `#999999` |
| Hairline rule | `#dddddd` / `#eeeeee` |
| Accent red | `#c11c1c` |
| Max content width | `1120px` (also `760px` / `640px` for narrower text columns) |
| Section grid | `60px 1fr` columns, `24px` gap |
| Hero headline size | `96px` (Home), `64px` (Articles/Elle Bread) |
| Section label | `13px`, `700` weight, `0.06em` letter-spacing, uppercase |
| Body copy | `17px` / line-height `1.65–1.75` |
| Border radius | `0` everywhere (no rounded corners) |

## Assets
- GitHub icon: standard Octicon/simple-icons mark, inlined as SVG path (`fill="currentColor"`), included verbatim in both Home/Articles/Elle Bread headers — reuse as-is or swap for your icon library's equivalent.
- LinkedIn icon: standard simple-icons mark, same treatment.
- No other images/icons in the design — Elle Bread has no product photography yet (not asked for).

## Backend Requirements (not built in this prototype — server-side work needed)

This is the core new engineering scope beyond the static Ruby site:

1. **Bread catalog**: user has a YAML file defining bread options + prices (not attached to this design conversation — obtain from user). Parse it server-side; do not hardcode.
2. **Weekly selection (admin)**: persist "which 3 breads are active this week" — simple key-value or a small `weekly_selections` table (bread_id, week_start_date) works.
3. **Order submission (public)**: on submit, write an `orders` table row (Postgres) with: customer name, phone, line items (bread id/name, qty, unit price), computed total, created_at timestamp. Then send a notification email to the site owner with the order details (any Ruby mailer, e.g. ActionMailer standalone or a simple SMTP call — no ESP/Stripe integration needed yet per user).
4. **Order history (admin)**: query `orders` table, newest first, render as shown.
5. **Admin auth**: prototype has no real auth. Recommend a simple session-based single-password gate (env var + signed cookie) — user explicitly deprioritized full auth complexity; do not over-build.
6. **Future (explicitly not now)**: Stripe payment integration — leave a clean seam (e.g. an `orders.status` column defaulting to `unpaid`/`n/a`) so payment can be added later without a schema rewrite.

## Files
- `Home.dc.html` — Home page design reference
- `Articles.dc.html` — Articles list design reference
- `Elle Bread.dc.html` — Elle Bread public form + admin design reference (all 3 view-states in one file, state-toggled)
- `support.js` — the prototype's component runtime, included only so the HTML files render if opened directly; do not port this code
