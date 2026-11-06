# Elliott's Productivity App — Design Doc

**Status:** Draft v0.1 · **Last updated:** 2026-11-05 · **Owners:** Elliott, Claude

> A living document. Decisions marked ✅ are signed off. Items under
> [Open questions](#13-open-questions) still need a decision. Edit freely.

---

## 1. Summary

A local-first app for **task management, goal tracking, time planning,
self-motivation, low-friction context switching, and collecting notes and
ideas**. It runs on **Android** and **Windows**, keeps all data on each
device, and syncs over the **home network** with no cloud required. The data
model is designed so a subtree can later be **shared with another person**
over the internet.

## 2. Goals and non-goals

### Goals (v1)
1. A goal and task tree that can nest as deep as you like.
2. Goals connect to **core values** and **value statements**.
3. Markdown notes on any item.
4. Links from any item to other items, URLs, small documents and images.
5. Small **read-only attachments** (e.g. a photo of a shopping list), with
   **light markup** (drawing and highlights) that doesn't change the original.
6. Syncing of all data, attachments included, between devices on the same
   network.
7. Calendar events, deadlines and routines (recurrence uses RRULE).
8. Search by text, **core value**, **type** and **top-level project**.
9. A **Today view**, a **quick-capture inbox** and **context resume** to keep
   motivation up and friction down.

### Non-goals (v1)
- Sync over the internet, and multi-user sharing. The data model supports
  them; see [§11](#11-future-sharing-spaces).
- Two-way sync with Google or Outlook calendars (v1 only exports .ics).
- Rich document editing. Attachments are read-only and open in the device's
  own apps.
- iOS, macOS and web builds. Flutter makes them possible later, but they're
  untested.

## 3. Decisions log

| # | Decision | Choice |
|---|----------|--------|
| D1 | App framework | ✅ **Flutter** (one codebase for Android and Windows) |
| D2 | Local storage | ✅ **SQLite** via **Drift**, with **FTS5** for full-text search |
| D3 | Recurrence | ✅ **RRULE** (RFC 5545) |
| D4 | Device discovery | ✅ **mDNS / DNS-SD** on the local network |
| D5 | Item model | ✅ **One `Node` type with a `type` field.** Any node can nest under any other. |
| D6 | Values | ✅ **Inherited down the tree.** You can add extra values on any node. |
| D7 | Sync topology | ✅ **Symmetric.** Any device can sync with any other. The PC is usually on, so it acts as the practical hub. |
| D8 | Markup | ✅ **Separate overlay layer.** The original file is never changed. |
| D9 | Attachment storage | ✅ **App-managed folder**, files named by content hash |
| D10 | Calendar scope v1 | ✅ **The app's own calendar, plus .ics export** |
| D11 | Routines | ✅ **One routine node holds the RRULE, plus a completion record per occurrence** |
| D12 | Motivation features v1 | ✅ **Today view, quick-capture inbox, context resume.** Streaks and progress come later. |
| D13 | Future sharing | ✅ **`space_id` on every synced row**, starting now |

## 4. Architecture overview

```
┌──────────────────────────── Flutter app (Android / Windows) ────────────────────────────┐
│  UI layer         Tree · Today · Calendar · Search · Inbox · Node detail · Viewer       │
│     │             (Riverpod for state)                                                   │
│  Domain layer     Repositories & use-cases (move node, complete routine, link, search)  │
│     │                                                                                    │
│  Data layer       Drift (SQLite + FTS5)  ◄──►  Change log (HLC-stamped field ops)        │
│     │                                             │                                      │
│  Services         Blob store (hash-named files)   Sync engine (runs in its own isolate)  │
│                   Notifications · Global hotkey   mDNS discovery · TLS transport         │
│                   Share-sheet intake · Open-in    Pairing (QR)                           │
└──────────────────────────────────────────────────────────────────────────────────────────┘
                    ▲                                         ▲
                    └──────── LAN (Wi-Fi / Ethernet) ─────────┘
                             other devices running the app
```

**Principles**
- **Local-first.** Every device holds a full copy and works offline. Sync
  happens alongside and never blocks the UI.
- **Every write goes through the change log** (see [§7](#7-sync-design)), so
  sync, undo and future sharing all use the same mechanism.
- **Soft deletes only.** A deleted row becomes a tombstone that syncs to the
  other devices. Tombstones are purged later.

### Candidate packages (to confirm during setup)
| Need | Candidate |
|------|-----------|
| Database / ORM | `drift` + `sqlite3_flutter_libs` |
| State management | `flutter_riverpod` |
| mDNS | `bonsoir` |
| RRULE | `rrule` |
| Markdown rendering / editing | a maintained markdown widget package, plus a plain `TextField` with a formatting toolbar |
| Notifications | `flutter_local_notifications` |
| Global hotkey (Windows) | `hotkey_manager` |
| System tray (Windows) | `tray_manager` |
| Share-sheet intake (Android) | `receive_sharing_intent` or equivalent |
| Open file in another app | `open_filex` / `url_launcher` |
| Image capture / pick | `image_picker` |
| Drawing overlay | `CustomPainter` (written in-house) |
| Crypto (pairing, future end-to-end encryption) | `cryptography` / `sodium` |

## 5. Data model

All IDs are **UUIDv7**, which can be generated on any device and sort by
creation time. Every synced table has these columns:

| Column | Purpose |
|--------|---------|
| `id` | UUIDv7 primary key |
| `space_id` | Which space the row belongs to (see [§11](#11-future-sharing-spaces)) |
| `created_at` | Wall-clock time the row was created |
| `hlc` | Hybrid logical clock stamp of the latest change |
| `deleted` | Tombstone flag |

### 5.1 Tables

**`spaces`** — the unit of syncing and, later, of sharing.
`id, name, kind (personal | shared), owner_device_id`
v1 has exactly one personal space.

**`nodes`** — every goal, project, task, routine, event, note and idea.

| Column | Notes |
|--------|-------|
| `parent_id` | `NULL` = top-level (root of a project) |
| `sort_key` | Fractional index string for order among siblings (e.g. `"a0"`, `"a0V"`) |
| `type` | `goal · project · task · routine · event · note · idea · inbox_item` |
| `title` | Short text |
| `body_md` | Markdown note (may be empty) |
| `status` | `open · active · waiting · done · dropped` |
| `priority` | Optional 1–4 |
| `start_at` / `end_at` | Events and time blocks (UTC + timezone ID) |
| `due_at` | Deadline |
| `rrule` | RRULE string, for routines and recurring events |
| `completed_at` | Set when status becomes `done` |

> **Why one table?** A task can be promoted to a project, or a note to a goal,
> just by changing `type`. Tree queries, links and search work the same for
> everything.

**`core_values`** — `name, statement (markdown), color, icon, sort_key`

**`node_values`** — explicit value links: `node_id, value_id`.
A node's **effective values** are its own explicit values plus all of its
ancestors' values, computed with a recursive CTE and cached in an index table
that's rebuilt when the tree or the links change.

**`links`** — any node → something.
`from_node_id, target_kind (node | url | attachment), target_id, url, label`
Notes can use `[[Node title]]` syntax. On save, the parser keeps rows in
`links` in step with the note text.

**`attachments`** — files in the blob store.
`node_id, content_hash (SHA-256), filename, mime, size_bytes, kind (image | text | pdf | other), width, height`

**`annotations`** — markup on attachments, **one row per stroke or highlight**.
Two devices marking up the same photo then merge cleanly, since there's
nothing to conflict.
`attachment_id, kind (stroke | highlight | text_label), data_json, color, z`
- `stroke`: a list of points normalized to 0–1 of the image size, plus width.
- `highlight` (text docs): character range `{start, end}`.
- `text_label`: position plus a short string.

**`routine_completions`** — `node_id, occurrence_date, completed_at, note`
(unique per node and date).

**`today_entries`** — `date, node_id, sort_key` (the Today list for a given day).

**`node_context`** — the context-resume state for each node.
`node_id, last_opened_at, last_attachment_id, last_link_id, scratch_md, pinned_items_json`
This syncs, so you can leave a task on the PC and pick it up on the phone.

### 5.2 Local-only tables (never synced)
- `devices`: paired devices, with their public keys and names.
- `sync_state`: per peer and per space, the highest HLC seen from each origin
  device (a version vector).
- `change_log`: outgoing and applied changes (see §7).
- `fts_index`: the FTS5 virtual table.
- `ui_prefs`: window layout, theme, last tab.

### 5.3 Tree rules
- Moving a node only changes its `parent_id` and `sort_key`.
- A move that would create a **cycle** is rejected locally. If a cycle shows
  up after a sync merge (two devices made crossing moves at the same time), the
  move with the older HLC is undone, and the node goes back to its earlier
  parent.
- Deleting a node tombstones the whole subtree in one transaction.
- The **top-level project** of any node is the ancestor whose `parent_id` is
  `NULL`. It is cached alongside the effective values for fast filtering.

## 6. Feature design

### 6.1 Tree and node detail
- **Tree pane:** expand and collapse, drag to reorder or reparent, keyboard
  first on Windows (Tab to indent, Shift+Tab to outdent, Enter for a new
  sibling).
- **Breadcrumbs** and **zoom** let you focus on any subtree as if it were the
  root.
- **Node detail:** title, type, status, dates, values (explicit and inherited,
  shown separately), markdown note, links, attachments, and the child list.
- **Layout:** two panes (tree + detail) on Windows; on Android, drill-down
  navigation.

### 6.2 Values
- Values page: each value with its statement and the goals linked to it.
- Every node shows chips for its inherited values. The Today view uses them to
  answer "why does this matter?"

### 6.3 Notes, links and ideas
- Markdown subset: headings, bold and italic, lists, checkboxes, code, links,
  and `[[node links]]`.
- Editor: a plain-text editor with a toolbar and a live preview toggle.
- Backlinks: a node's detail lists every node that links to it.

### 6.4 Attachments and markup
- **Adding:** take a photo, pick a file, share into the app from another
  Android app, or drag and drop on Windows.
- **Ingest:** the file is hashed (SHA-256) and copied to
  `<app-data>/blobs/ab/cd/<hash>`. The original stays where it was, untouched.
- **Viewing:** images, `.txt` and `.md` render in the app. Anything else shows
  as a file card.
- **Open in…:** hands a **temporary copy** of the file to the device's default
  app (FileProvider on Android, the default program on Windows). Edits made
  there are not imported automatically. A **Replace file** action imports a
  new version.
- **Markup mode** (images): pen, highlighter, eraser, text label, and 4–6
  preset colors. Strokes are saved as `annotations` rows and drawn over the
  image. "Show markup" toggles the layer.
- **Markup mode** (text docs): highlight character ranges.
- **Export flattened:** renders the image plus markup into a new PNG for
  sharing outside the app.
- **Size limit:** a soft cap of **20 MB per file**; photos are optionally
  downscaled on import.

### 6.5 Calendar, deadlines and routines
- **Calendar view:** day, week and month, showing events, deadlines and time
  blocks.
- **Recurrence:** expanded on the fly from `rrule` for the visible date range.
  Nothing is stored per occurrence except completions and exceptions.
- **Routines:** a checkbox for the occurrence on each due day writes a
  `routine_completions` row. History is available now; streaks come later.
- **Exceptions** (skip or move one occurrence): stored as EXDATE/RDATE in the
  RRULE set.
- **Reminders:** local notifications, scheduled for the next N days and
  rescheduled when the app opens or a sync finishes. Android needs the
  exact-alarm permission.
- **.ics export:** export a file, and optionally publish a read-only feed from
  the PC on the LAN.
- **Time zones:** store UTC plus an IANA zone ID. All-day items store a plain
  date.

### 6.6 Search
- One search box backed by **FTS5** over titles, notes, link labels and
  attachment text (`.txt`/`.md` contents and filenames).
- **Filters** (combinable): core value (effective), type, top-level project,
  status, date range, "has attachments".
- Saved searches (later).

### 6.7 Today view (motivation)
- Pick tasks into today's list from anywhere ("Add to Today"), or from
  suggestions: items due today or overdue, routines due today, last session's
  unfinished items.
- Each entry shows **its value chips and its top-level goal**, so the reason
  behind the work is always visible.
- At the end of the day, unfinished entries can roll over to tomorrow with one
  tap.

### 6.8 Quick-capture inbox (low friction)
- **Windows:** a global hotkey (default `Ctrl+Alt+Space`) opens a small
  always-on-top capture box. Enter saves the item and dismisses the box.
- **Android:** a home-screen widget, a quick settings tile, and the share
  sheet ("Share to app" creates an inbox item, with any shared image as an
  attachment).
- Inbox items are `type = inbox_item` with no parent. The Inbox view lets you
  sort each one into the tree with a type-ahead parent picker.

### 6.9 Context resume (low friction)
- Opening a node records it in `node_context`.
- **Resume** reopens the last attachment or link and the scratch note, and
  scrolls to where you were.
- A "Recent contexts" list (last 10 nodes) is one click from anywhere.
- On Windows, the app minimizes to the tray and keeps syncing in the
  background.

## 7. Sync design

### 7.1 Change model
- Every local write records **field-level operations** in `change_log`:
  `(op_id, space_id, table, row_id, column, value, hlc, origin_device_id)`.
- **Hybrid logical clock (HLC):** `max(wall_clock, last_seen) + counter`,
  tagged with the device ID. This gives a total order even when device clocks
  are off.
- **Merging:** for each `(row, column)`, the highest HLC wins. Because merging
  happens per field, editing a title on the phone and a due date on the PC
  never conflict.
- **Exception:** `body_md` uses whole-field latest-edit-wins in v1. If you
  edit the same note on two devices before they sync, the older edit is saved
  to a "conflicted copy" note history so nothing is silently lost. (Open
  question Q-A covers merging notes with a CRDT.)

### 7.2 Discovery and pairing
- Each device advertises `_epa-sync._tcp` over mDNS with its device ID and
  port.
- **Pairing (once per pair of devices):** device A shows a QR code containing
  its device ID, its public key fingerprint and a one-time code. Device B scans
  it (or types the code on the PC), and both store each other's public key.
- **Transport:** TLS with **pinned self-signed certificates** from pairing.
  Unpaired devices are ignored.

### 7.3 Sync session
1. Discover the peer, connect, and authenticate both sides.
2. Exchange **version vectors** per space (the highest HLC seen from each
   origin device).
3. Each side sends the ops the other is missing, in HLC order, in batches.
4. Apply the ops in a transaction and rebuild the effective-value and
   project caches for the rows that changed.
5. **Blob phase:** list attachment hashes the device references but doesn't
   have, then transfer them, resuming where a transfer stopped.
6. Store the new version vector.

**When sync runs:** on app start and resume, every N minutes while the app is
open, shortly after local edits (debounced), and when a peer appears on mDNS.
On Android, best-effort background sync via WorkManager. On Windows, from the
tray process.

Because every device keeps the full op history for its spaces, syncing works
transitively: **phone → PC → laptop** carries everything.

### 7.4 Compaction
Ops older than X days that **every paired device** has acknowledged can be
dropped from `change_log`, since the row tables already hold the current
state. Tombstones are purged the same way.

## 8. Platform notes

| Topic | Android | Windows |
|-------|---------|---------|
| Background sync | WorkManager (best effort); sync on open | Tray process stays running |
| Capture | Widget, quick settings tile, share sheet | Global hotkey, drag and drop |
| Notifications | `flutter_local_notifications` + exact alarms | Toast notifications |
| Open in… | FileProvider intent | Default program for the file type |
| mDNS | NSD (via `bonsoir`); multicast lock needed | Bonjour/DNS-SD via `bonsoir` |
| Storage path | App-internal storage | `%APPDATA%\ElliottsProductivityApp` |
| Firewall | — | First run asks to allow the sync port on private networks |

## 9. Security and privacy
- No cloud, no accounts, no telemetry.
- Only paired devices can sync (mutual TLS with pinned keys).
- Database encryption at rest (SQLCipher) is **optional, later**. Device-level
  encryption is assumed for now.
- Backups: the PC writes a nightly SQLite backup plus the blob folder to a
  user-chosen location.

## 10. Project structure (proposed)

```
ElliottsProductivityApp/
├─ docs/DESIGN.md
├─ app/                      Flutter app
│  ├─ lib/
│  │  ├─ ui/                 screens & widgets (tree, today, calendar, search, inbox, viewer)
│  │  ├─ domain/             use-cases, models
│  │  ├─ data/               drift tables, DAOs, migrations, FTS
│  │  ├─ sync/               HLC, change log, protocol, discovery, pairing
│  │  ├─ blobs/              hash store, ingest, transfer
│  │  └─ platform/           notifications, hotkey, tray, share intake, open-in
│  └─ test/
└─ tools/                    scripts (e.g. two-instance sync test harness)
```

## 11. Future: sharing spaces

Built on the decisions above (D13 and the [earlier discussion](#appendix-a-sharing-research-notes)):
- Sharing a node creates a **new shared space**, and the node's subtree is
  re-tagged with that `space_id`.
- Sync stays the same, scoped per space. An **encrypted relay** (e.g.
  Cloudflare Durable Object per space) carries ops between people. The relay
  can't read the data: each space has a key, delivered through the invite
  link or QR code.
- **Personal data stays personal:** `node_values`, `today_entries` and
  `node_context` rows always live in the owner's *personal* space, even when
  they point at nodes in a shared space.
- Moving a node into a shared subtree re-tags it. Moving one out deletes it
  for the other members.
- Large attachments go through R2-style object storage (no egress fees), or
  directly between devices when both are online.
- **v1 requirement:** every query and every sync step is scoped by
  `space_id`, even though there's only one space.

## 12. Milestones

| # | Milestone | Done when… |
|---|-----------|------------|
| M0 | Project skeleton | The Flutter app builds and runs on Windows and an Android phone; Drift is set up; CI runs tests |
| M1 | Tree + notes | Create, nest, reorder and move nodes; markdown notes; works offline on one device |
| M2 | Values + search | Values with statements, inheritance, FTS5 search with value, type and project filters |
| M3 | LAN sync | Pairing, mDNS, HLC change log, field-level merge; phone ⇄ PC sync verified with a two-instance test harness |
| M4 | Attachments + markup | Capture or import, hash store, blob sync, viewer, drawing overlay, open-in |
| M5 | Calendar + routines | RRULE expansion, calendar views, routine completions, reminders, .ics export |
| M6 | Motivation + friction | Today view, quick-capture (hotkey, widget, share sheet), context resume |
| M7 | Polish | Backups, conflict-copy UI, performance with 10k+ nodes |
| Later | Sharing, streaks and progress, Google Calendar, SQLCipher | — |

## 13. Open questions

| ID | Question | Current leaning |
|----|----------|-----------------|
| Q-A | Merge simultaneous note edits with a CRDT (e.g. Yjs-style) instead of keeping conflicted copies? | Not in v1; revisit when sharing arrives |
| Q-B | Should text-doc markup be highlights only, or also freehand drawing over a rendered page? | Highlights only |
| Q-C | Should "done" tasks stay in the tree, or move to an archive view after N days? | Hide after 7 days, toggle to show |
| Q-D | Does a goal's progress come from its done children, or is it set by hand? | From children, with an optional manual override (when progress bars arrive) |
| Q-E | Should the Today view allow time-blocking (dragging tasks onto the calendar)? | Later, after M6 |
| Q-F | Exact markdown package choice | Decide in M1 after a short spike |

---

## Appendix A: Sharing research notes
- Peer-to-peer was considered for sharing and rejected for now. It still
  needs signaling, STUN and TURN servers; it fails when either phone is
  offline; and NAT traversal on mobile networks is unreliable.
- An encrypted mailbox relay costs fractions of a cent per user per month.
  The main cost driver is attachments, so plan quotas around storage.
