# Website for zecsy.com

Landing page and linktree for **ZECsy**, a Zcash community and marketing team.
Built with Jekyll and hosted on GitHub Pages.

## Editing content

Everything you'd change day to day lives in two data files and the config:

| What | Where |
| --- | --- |
| Luma calendar embed / donation u-address / title & tagline | `_config.yml` |
| Manual event banner (fallback when no Luma calendar is set) | `_data/event.yml` |
| Link buttons (guides, wallet, CipherPay, merch) | `_data/links.yml` |
| Team photo and vision statement | `_data/team.yml` |

Notes:

- Links marked `tbd: true` render as "coming soon" and aren't clickable. When
  the merch store goes live, set the real `url` and remove `tbd`.
- The donation QR code is generated in the browser from `donation.uaddress` in
  `_config.yml`, so changing the address updates the QR automatically.

### Automatic events via Luma

Once the ZECsy Luma calendar / organizer account exists:

1. Open [luma.com/home/calendars](https://luma.com/home/calendars) and choose
   the ZECsy calendar.
2. Go to **Settings → Embed** and copy the calendar embed URL from the iframe
   code. It looks like `https://luma.com/embed/calendar/cal-XXXXXXXX/events`.
3. Paste it into `luma_embed_url:` in `_config.yml`.

Upcoming events will then display automatically at the top of the page — no
site edits needed per event. Until then, the manual banner in `_data/event.yml`
is shown instead (set `active: false` there to hide it entirely).

A scheduled GitHub Action (`.github/workflows/luma-check.yml`) checks the Luma
API every 6 hours and records whether any upcoming events exist in
`_data/luma_status.json`. When there are none, the page shows a compact
"Follow ZECsy on Luma" card instead of an empty calendar widget. You can also
trigger the check manually from the repo's Actions tab (useful right after
publishing a new event).

## Running locally

Requires Ruby 3.x and Bundler.

```bash
bundle install
bundle exec jekyll serve
```

Then open http://localhost:4000.
