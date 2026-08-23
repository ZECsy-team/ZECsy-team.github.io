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
| Zcash friends directory (public) | `_data/orgs.csv` |
| Zcash friends directory (research, not committed) | `_private/orgs.csv` |

Notes:

- Links marked `tbd: true` render as "coming soon" and aren't clickable. When
  the merch store goes live, set the real `url` and remove `tbd`.
- Links marked `internal: true` are pages on this site and open in the same tab.
- The donation QR code is generated in the browser from `donation.uaddress` in
  `_config.yml`, so changing the address updates the QR automatically.
- The friends directory is split: edit `_private/orgs.csv` (never commit it),
  then run `ruby scripts/publish-directory.rb` to refresh the public file.
  See [The friends directory](#the-friends-directory-directory) below.

## The friends directory (`/directory/`)

**Mylo never commit `_private/orgs.csv`!** That file is the full research
spreadsheet — organizer names, notes, sources, status — and it is gitignored
on purpose. GitHub Pages would publish anything that lands in this repo.

There are two CSVs:

| File | In git? | What it holds |
| --- | --- | --- |
| `_private/orgs.csv` | No. Gitignored. Do not force-add it. | Research copy: organizers, notes, sources, status, extra handles |
| `_data/orgs.csv` | Yes. This is what the site builds from. | Public listing only: `name`, `region`, `twitter`, `bluesky`, `website` |

Mylo's Workflow:

1. Open `_private/orgs.csv` in a spreadsheet (not the old root-level file).
2. When listings are ready to show, publish the public columns:

   ```bash
   ruby scripts/publish-directory.rb
   ```

3. Commit `_data/orgs.csv`. Leave `_private/orgs.csv` untracked.

The script copies only those five columns. Cells that read `TBD` or
`NOT FOUND` become empty, so a placeholder never becomes a broken link. Private
column names can stay as they are (`country_region`, `x_handle`,
`bluesky_handle`); the script maps them.

`_private/orgs.example.csv` is the header row only, so the research schema
lives in git without any of the research.

The directory page asks search engines not to index it until that
`noindex` flag is removed from `directory.html`.

## Automatic events via Luma

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
