# zecsy.github.io

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

## Running locally

Requires Ruby 3.x and Bundler.

```bash
bundle install
bundle exec jekyll serve
```

Then open http://localhost:4000.

## Deploying

Push to `main`. GitHub Pages builds and deploys automatically (Settings →
Pages → Deploy from branch → `main`, root folder).

## Custom domain (zecsy.com)

When ready to move to zecsy.com:

1. Add a `CNAME` file to the repo root containing exactly `zecsy.com`.
2. In the domain registrar's DNS, add:
   - `A` records for the apex (`zecsy.com`) pointing to GitHub Pages IPs:
     `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
   - A `CNAME` record for `www` pointing to `zecsy.github.io`
3. In repo Settings → Pages, set the custom domain to `zecsy.com` and enable
   **Enforce HTTPS** once the certificate is issued.
4. Update `url:` in `_config.yml` to `https://zecsy.com`.
