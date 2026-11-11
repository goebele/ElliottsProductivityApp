# Elliott's Productivity App — Design Doc

**Status:** Draft v0.18 · **Last updated:** 2026-11-09 · **Owners:** Elliott, Claude

> **v0.18:** A **review pass (M6.5)** comes before LAN sync: a UX
> walk-through of every screen, a review of everything sync will lock in,
> and a code-health pass. Findings and decisions are kept in §14.

> **v0.17 (M6, Today):** **Today is the home screen** (what the detail
> pane shows when nothing is open; phones open on a Today / Tree /
> Calendar bar). It **fills itself** with routines due today, items due
> today, overdue items and today's events (you choose which; In progress
> is optional), plus anything you **Add to Today**. Any entry can be
> removed for the day, and the list dragged into order. Picks left undone
> are asked about the next day; routines and deadlines carry on by
> themselves. **Pick one for me** offers a random open item, by value or
> tag (§6.7).

> **v0.16 (M5):** **Timers** (▶ on an item; one runs at a time; a bar
> across the top with Pause / Stop; Windows tray icon and an always-on-top
> mini window; Android ongoing notification), **focus mode** (25 min or
> the estimate, then a chime and Keep going / Done / Take a break),
> **estimates** and **time entries** with roll-ups, **progress** at every
> level with a hand-set override, and a **Review** page (day / week /
> month / dates) with Copy as Markdown and Export (§6.15, §6.16).

> **v0.15:** **Show in calendar** on an item (⋮, or the chip by its dates)
> opens the calendar filtered to it and everything under it, replacing the
> calendar's "Under an item…" picker (§6.5).

> **v0.14:** The calendar copes with busy days: cells cap at three entries
> plus **+n more**; clicking a day lists everything on it; right-click (or
> long-press) asks before adding; and a filter bar (kind, hide done, tag,
> value, under any item) (§6.5).

> **v0.13 (M4):** A **Calendar** entry under the tree (day / week / month;
> clicking empty time adds an item there). **Repeating subtrees** (D24):
> items inside a repeating item are done per occurrence, and the parent is
> done for the day when they all are (Q-L). Time slots store their **time
> zone**, so a repeat at 18:00 stays at 18:00 across DST. **Reminders** per
> item in the date dialog (Windows toasts, Android notifications).
> **.ics export** is opt-in per item ("Include in calendar export"), plus
> ⋮ → Export to calendar for one item (§6.5).

> **v0.12 (M3):** **Attachments**: a Files list in the notes column
> (thumbnails for images), added by file picker, drag and drop or Ctrl+V
> on Windows, or the camera on phones. Each file has its own page (images
> zoom and pan, `.md` renders, others get a file card) with **Open in…**,
> **Replace file**, **Rename**, **Remove** (Undo) and, for images,
> **Export with markup**. **Markup**: pen, highlighter, text labels and
> eraser on images; highlights on text files. Ancestors' files can be
> **linked** into a child, and search finds files by name and text (§6.4,
> §6.6, §6.10).

> **v0.11:** **Sharing an item with another person never shares tags or
> values**: both are always personal (§5.0, D28, §6.14, §11.2). Device sync
> still carries them between your own devices. Open: whether `#tags` typed
> in shared text become tags for the others (Q-M).

> **v0.10:** A **Tags page** (create, star as favourite, colour, rename or
> merge, delete, usage counts) and **favourite tags** as one-tap chips at
> the top of the tag picker (§6.14).

> **v0.9 (M2):** **Values** (a Values page under the tree; chips on each
> item, inherited ones faded with "from Trip"), **tags** (a picker, plus
> `#name` typed in a title or text), and **search** (a box above the tree,
> FTS5, filter chips, shortcuts like `#tag/*` and `value:`). Carried over
> from M1: **collapsing breadcrumbs** on narrow screens, **zooming** the
> tree into an item, and **Peek** (hover card on Windows, long-press sheet
> on phones, pinnable as a side panel). See §6.1.1, §6.2, §6.6, §6.14.

> **v0.8:** **LAN sync moves to M7**, after the single-device features
> (attachments, calendar, time, Today view), so the UI is fully usable on
> one machine first. Blob and timer sync move with it (§12). Polish (M8)
> gains a concrete **accessibility pass**, including keyboard tree controls.
> Removal confirmations name outside links and shortcuts (§6.11).

> **v0.7:** Completing is an explicit, labelled **Done** button (with a
> short burst, a haptic tap on phones and Undo), not a toggle. On a
> repeating item it completes the current occurrence. Every status is in a
> compact menu, also on right-click of a tree row. Tree rows and Items rows
> can be **dragged** to reorder or nest. **Archive and Trash** are built: a ⋮
> menu on each item, confirmations, and Archive/Trash lists under the tree
> (§6.11). **Child views** (panels, checklist, steps) have a switcher by
> the Items heading (§6.13). **Markdown** renders via
> `flutter_markdown_plus`, with a formatting toolbar and preview (§6.3).
> **Placements** are built as ↗ shortcuts: "Also show in…", shown in the
> tree and Items, draggable and removable (§6.12). **Linked ancestor notes**:
> a "From above" list in the notes column, a "Link from above…" picker, and
> 📌 notes shared with all sub-items (§6.10). Plain tasks have no row icon, so
> nothing looks like a checkbox that can't be ticked (§6.1).

> **v0.6:** Repeats can be **every N days / weeks / months** from a start
> date ("Weekly pattern" for chosen weekdays, e.g. fortnightly). A repeating
> item's children can be an **exclusive set** that takes turns, one per
> occurrence, by who is most overdue (D36, §6.5.1). Until sync (M7), local
> data may be wiped freely; migrations are kept only as far as is convenient.

> **v0.4:** Item types cut to **goal, project, task, idea**. List, routine
> and event are now things any item can *have*, not types; inbox is a
> capture state, not a type (D5, D11, §5.2, §6.8).
>
> **v0.5:** An item's own text is its **description**. **Notes** are their
> own (non-task) type: an item can have any number, shown in a collapsible
> **notes column** beside it rather than among its items. Deadline, time slot
> and repeat are edited in **one date & time dialog** (§6.1, §6.3).

> A living document. Decisions marked ✅ are signed off. Items under
> [Open questions](#13-open-questions) still need a decision. Edit freely.

---

## 1. Summary

A local-first app for **task management, goal tracking, time planning,
self-motivation, low-friction context switching, and collecting notes and
ideas**. It is built first for one person (with possible ADHD) and later for
others with similar goals, **including families sharing to-dos**.

It runs on **Android** and **Windows**, keeps all data on each device, and
syncs over the **home network** with no cloud required. The data model
supports **users, spaces and sharing from day one**, so internet sharing
(through an encrypted relay) and iOS can be added without migrating existing
data.

## 2. Goals and non-goals

### Goals (v1)
1. A goal and task tree that can nest **as deep as you like**.
2. Goals connect to **core values** and **value statements**.
3. Markdown notes on any item.
4. Links from any item to other items, URLs, small documents and images.
5. Small **read-only attachments** (e.g. a photo of a shopping list), with
   **light markup** (drawing and highlights) that doesn't change the original.
6. Syncing of all data, attachments included, between **one user's
   devices** on the same network.
7. Calendar events, deadlines and routines (recurrence uses RRULE). A
   recurring node's **children repeat with it**.
8. Search by text, **core value**, **tag**, **type** and **top-level project**.
9. A **Today view**, a **quick-capture inbox** and **context resume** to keep
   motivation up and friction down.
10. **Linked ancestor items:** a child can link notes and docs from its
    parent or any other ancestor, without copying them. There's always exactly
    one original.
11. **Archive and Trash:** both are recoverable, and children always go with
    their parent.
12. **Tags**, for organizing and searching.
13. **Time estimates, timers and time tracking.**
14. **Progress, reports and summaries**, at minimum "what did I do this
    week".
15. **Child views:** how a node shows its children (detail panels,
    checklist, steps).
16. **QR place tags:** print a code, stick it in a room, scan it to see that
    room's tasks.
17. **Assignees.** The default is "anyone can do it".

### Non-goals (v1), with the schema ready for them
- Sharing over the internet through the relay. The data model is ready; see
  [§11](#11-sharing-spaces-and-sending).
- Push notifications.
- iOS. Planned for the version after the relay is set up.
- Location triggers by GPS, Wi-Fi or Bluetooth (only QR place tags in v1).
- Two-way sync with Google or Outlook calendars (v1 only exports .ics).
- Rich document editing. Attachments are read-only and open in the device's
  own apps.
- Board, table and gallery child views.

## 3. Decisions log

| # | Decision | Choice |
|---|----------|--------|
| D1 | App framework | ✅ **Flutter** (one codebase for Android and Windows) |
| D2 | Local storage | ✅ **SQLite** via **Drift**, with **FTS5** for full-text search |
| D3 | Recurrence | ✅ **RRULE** (RFC 5545) |
| D4 | Device discovery | ✅ **mDNS / DNS-SD** on the local network |
| D5 | Item model | ✅ **One `Node` type with a `type` field.** Any node can nest under any other. **Types: goal, project, task, idea, plus note (v0.5)**, the one non-task type (no status, no dates). Everything else is an optional feature any item can have: a description, a deadline, a time slot (an *event*), a repeat rule (a *routine*), a list layout (a *list*). The UI infers "event", "routine" and "list" from those fields. |
| D6 | Values | ✅ **Inherited down the tree.** You can add extra values on any node. |
| D7 | Sync topology | ✅ **Symmetric.** Any device can sync with any other. The PC is usually on, so it acts as the practical hub. |
| D8 | Markup | ✅ **Separate overlay layer.** The original file is never changed. |
| D9 | Attachment storage | ✅ **App-managed folder**, files named by content hash |
| D10 | Calendar scope v1 | ✅ **The app's own calendar, plus .ics export** |
| D11 | Routines | ✅ **A routine is any item with an RRULE, plus a completion record per occurrence.** Any schedule: every N days, every weekday, a weekly pattern (chosen weekdays) every N weeks, a day of the month every N months, counted from a series start date (`repeat_start`). Its children repeat with it (D24). |
| D12 | Motivation features v1 | ✅ **Today view, quick-capture inbox, context resume, progress and reports.** Streaks come later. |
| D13 | Future sharing | ✅ **`space_id` on every synced row**, starting now |
| D14 | Linking ancestor items | ✅ **Pick specific items** (not a live "follow parent" toggle), when creating the child or later |
| D15 | Link reach | ✅ **Any ancestor**, not only the direct parent |
| D16 | Editing linked notes | ✅ **Edit in place.** The edit goes to the single original, labeled "from: <owner>". |
| D17 | Moving a linked child | ✅ **Links are kept** after moves and can be unlinked by hand |
| D18 | Removal | ✅ **Archive** (hidden, kept indefinitely) **+ Trash** (restorable for 30 days, then purged). Children always go with their parent. |
| D19 | Search and linked items | ✅ A linked item **matches filters for its owner and every node linking it**, and is **listed once** |
| D20 | Tree context in node view | ✅ **Navigate + peek** for all ancestors and children, with back/forward history. Looked up on the fly; nothing stored. |
| D21 | Identity | ✅ **Users + devices.** A user is an opaque ID plus a public key. **Names are local labels** that you choose for people, and a sender can attach an alias. No personal information beyond what's in your own tasks and notes ever leaves your devices. |
| D22 | Shared vs personal state | ✅ Every field is either **shared** (it lives in the node's space) or **personal** (it lives in your personal space and points at the node) |
| D23 | Assignment | ✅ **Optional assignees. None means anyone can do it.** A multi-person task is a parent with several assignees and one assigned subtask each. |
| D24 | Recurring subtrees | ✅ **When a recurring node repeats, its children repeat with it.** Completion is recorded per occurrence. Exception: an exclusive set (D36). |
| D25 | Send, then share more | ✅ **One canonical copy.** A sent node moves into its real place when the bigger tree is shared. Your old filing becomes a **placement** (shortcut). |
| D26 | Multiple parents | ✅ **One real parent, plus personal placements** (not a true multi-parent graph) |
| D27 | Child views v1 | ✅ **Detail panels (default), checklist, steps**, plus the tree pane. Board, table and gallery come later. |
| D28 | Tags | ✅ **Explicit**, with optional "include children" in search. Tags are **always personal** (v0.11): sharing an item never shares its tags, just as it never shares values. |
| D29 | Time | ✅ **Estimates, timers, time tracking**, rolled up the tree |
| D30 | Reports | ✅ **"What I did this week"** at minimum, plus progress on goals and projects |
| D31 | Location | ✅ **QR place tags only** in v1. No extra hardware. |
| D32 | Pairing | ✅ **Confirm on both devices** (matching code), plus an **optional pairing PIN** stored on each device |
| D33 | Versioning | ✅ **Protocol and schema versions in sync.** Only additive schema changes; data a device doesn't recognize is kept and passed along, never dropped. |
| D34 | Remote blob naming | ✅ **Encrypt each blob separately and name it with a keyed hash.** No bundling everything into one archive. |
| D35 | UI strings | ✅ **Kept out of code from day one** (Flutter `gen-l10n` with ARB files) |
| D36 | Exclusive sets | ✅ **A repeating item's children can take turns** ("One sub-item at a time", in the Repeat section). Each occurrence suggests **at most one** child: the one furthest past its own next due date. Children may have their own cadence; without one they use the parent's. Never two in one occurrence, even when behind; **nothing** when none is due. See §6.5.1. |

## 4. Architecture overview

```
┌──────────────────────────── Flutter app (Android / Windows) ────────────────────────────┐
│  UI layer         Tree · Today · Calendar · Search · Inbox · Node detail · Viewer       │
│     │             Reports · Timer · (Riverpod for state, gen-l10n for strings)           │
│  Domain layer     Repositories & use-cases (move, complete, link, place, search, time)  │
│     │                                                                                    │
│  Data layer       Drift (SQLite + FTS5)  ◄──►  Change log (HLC-stamped field ops)        │
│     │                                             │                                      │
│  Services         Blob store (hash-named files)   Sync engine (runs in its own isolate)  │
│                   Notifications · Global hotkey   mDNS discovery · TLS transport         │
│                   Share-sheet intake · Open-in    Pairing · Identity keys                │
│                   QR scan / deep links            Protocol & schema versioning           │
└──────────────────────────────────────────────────────────────────────────────────────────┘
                    ▲                                         ▲
                    └──────── LAN (Wi-Fi / Ethernet) ─────────┘          later: encrypted relay
                             other devices running the app                (§11)
```

**Principles**
- **Local-first.** Every device holds a full copy of the spaces it belongs
  to and works offline. Sync happens alongside and never blocks the UI.
- **Every write goes through the change log** (see [§7](#7-sync-design)), so
  sync, undo, reports and sharing all use the same mechanism.
- **Soft deletes only.** A deleted row becomes a tombstone that syncs to the
  other devices. Tombstones are purged later.
- **Privacy by design.** No accounts, emails or real names. Identity is a key
  pair, and names are local labels.
- **Built to evolve.** Schema changes to synced tables are additive only.
  Columns are never renamed or repurposed, only deprecated.

### Candidate packages (to confirm during setup)
| Need | Candidate |
|------|-----------|
| Database / ORM | `drift` + `sqlite3_flutter_libs` |
| State management | `flutter_riverpod` |
| Localization | `flutter_localizations` + `gen-l10n` (ARB files) |
| mDNS | `bonsoir` |
| RRULE | `rrule` |
| Markdown rendering / editing | `flutter_markdown_plus` (the maintained fork of the discontinued `flutter_markdown`; GitHub-flavoured, custom syntax for `[[node links]]`), plus a plain `TextField` with a formatting toolbar |
| Notifications | `flutter_local_notifications` ✅ (+ `timezone`, `flutter_timezone`) |
| Global hotkey (Windows) | `hotkey_manager` |
| System tray (Windows) | `tray_manager` ✅ 0.5 (+ `window_manager` 0.5 for the mini window; 0.6/0.8 moved to a new API) |
| Share-sheet intake (Android) | `receive_sharing_intent` or equivalent (M6) |
| Open file in another app | `open_filex` ✅ |
| Image capture / pick | `image_picker` ✅ (camera); `file_picker` ✅ (files) |
| Drag and drop / paste (Windows) | `desktop_drop` ✅ / `pasteboard` ✅ |
| Hashing | `crypto` (SHA-256) ✅ |
| QR generate / scan | `qr_flutter` / `mobile_scanner` |
| Drawing overlay | `CustomPainter` (written in-house) |
| Crypto (identity, pairing, end-to-end encryption) | `cryptography` / `sodium` |

## 5. Data model

All IDs are **UUIDv7**, which can be generated on any device and sort by
creation time. Every synced table has these columns:

| Column | Purpose |
|--------|---------|
| `id` | UUIDv7 primary key |
| `space_id` | Which space the row belongs to (see [§11](#11-sharing-spaces-and-sending)) |
| `created_at` / `created_by` | When the row was created, and by which **user ID** |
| `updated_by` | The user who made the latest change |
| `hlc` | Hybrid logical clock stamp of the latest change |
| `deleted` | Tombstone flag |

### 5.0 Shared vs personal (read this first)
Every piece of data belongs to exactly one space:
- **Shared data** lives in the **node's space**: the title, note, status,
  children, assignees and attachments. Once shared, every member
  sees it.
- **Personal data** lives in **your personal space** and points at a node:
  value links, tags, Today entries, context resume, placements,
  time entries, contact labels, child-view overrides and activity history. No
  one else ever receives it, even when the node it points at is shared.
- **Sharing an item with another person (v0.11) never shares your tags or
  values.** Each member organises a shared item with their own. (Syncing
  your own devices is different: everything in your personal space syncs
  between them.)

In v1 everything is in your personal space, so this split costs nothing yet.
It matters as soon as sharing arrives.

### 5.1 Identity

**`users`** — one row per person you know about (including yourself).
`id (opaque UUID), identity_public_key, created_at`
That's all. There's **no name, email or phone number**.

**`contact_labels`** *(personal)* — what *you* call each user.
`user_id, label, suggested_alias, color`
- `label` is yours alone, and you can rename anyone at any time.
- `suggested_alias` is the alias a sender attached to an invite or a sent
  task. It's sent inside the encrypted payload and is only used as the
  starting label.
- Your own display name is just a label in your own `contact_labels`.

**`devices`** *(local-only, see §5.4)*: `device_id, user_id, device_public_key, signed_by_user_key, label`

### 5.2 Core tables

**`spaces`** — the unit of syncing and sharing.
`id, kind (personal | shared), root_node_id, merged_into_space_id`
- v1 has exactly one personal space per user.
- `merged_into_space_id` is set when a smaller share gets absorbed into a
  larger one (see [§11.3](#113-send-then-share-more)).

**`space_members`** — `space_id, user_id, role (owner | editor | viewer), joined_at`

**`nodes`** — every goal, project, task and idea, including those that are
lists, routines or events.

| Column | Notes |
|--------|-------|
| `parent_id` | The single **real** parent. `NULL` = top-level. (Extra appearances are placements, below.) |
| `sort_key` | Fractional index string for order among siblings (e.g. `"a0"`, `"a0V"`) |
| `type` | `goal · project · task · idea · note` (v0.5). A note under an item is listed in its notes column, not among its items or in the tree. A value this app version doesn't know reads as `task` and is kept as stored. |
| `title` | Short text |
| `body_md` | Markdown text: an item's **description**, or a note's content (may be empty) |
| `body_format` | `md_lww` in v1. Leaves room for a CRDT note format later. |
| `child_view` | `panels · checklist · steps`; `NULL` = `panels`. Picked with the view switcher by the Items heading. Personal overrides go in `node_user_prefs`. |
| `status` | `open · active · waiting · done · dropped` |
| `completed_by` | The user who completed it (non-recurring nodes) |
| `priority` | Optional 1–4 |
| `estimate_minutes` | Optional time estimate |
| `start_at` / `end_at` | Events and time blocks (UTC + timezone ID) |
| `due_at` | Deadline with a time of day |
| `due_date` | All-day deadline, `YYYY-MM-DD` (what the UI sets in v1) |
| `rrule` | RRULE string, for routines and recurring events. All descendants repeat with it (D24), unless they are an exclusive set (D36). |
| `repeat_start` | First day of the repeat series, `YYYY-MM-DD`. Intervals count from it (which weeks "every 2 weeks" means). Null = the day the node was created. |
| `exclusive_children` | Children take turns, one per occurrence (D36). Only meaningful with `rrule`. |
| `completed_at` | Set when status becomes `done` |
| `lifecycle` | `live · archived · trashed` (separate from `status`; see [§6.11](#611-archive-and-trash)) |
| `lifecycle_at` | When it was archived or trashed (starts the 30-day Trash timer) |
| `lifecycle_root_id` | The node the user actually archived or trashed. Descendants point to it, so restoring brings back the whole subtree that went together. |

> **Why one table?** A task can be promoted to a project, or an idea to a
> goal, just by changing `type`. Tree queries, links and search work the same
> for everything.
>
> **Why so few types? (v0.4)** A list is a task shown differently, a routine
> is a task that repeats, an event is a task at a set time, and notes are
> something any item can have. Making those types forced a choice ("is this a
> routine or a list?") the user shouldn't have to make, so they are fields
> instead and can be combined (a weekly routine shown as a checklist).

**`node_assignees`** *(shared)* — `node_id, user_id`. **No rows means anyone
can do it** (the default).

**`placements`** *(personal)* — extra places a node appears **for you only**.
`node_id, parent_node_id (NULL = top level), sort_key`
Used for (a) putting a node you received somewhere in your own tree, and
(b) shortcuts, e.g. "Buy paint" also showing under your "Errands". See
[§6.12](#612-placements-one-node-several-places).

**`core_values`** *(personal)* — `name, statement (markdown), color, icon, sort_key`.
Deleting a value tombstones it and every `node_values` row that uses it.

**`node_values`** *(personal)* — explicit value links: `node_id, value_id`.
A node's **effective values** are its own explicit values plus all of its
ancestors' values. For you, that includes ancestors reached through your
placements. In v0.9 they're computed on read (no cache table yet); a cache
can come with the M8 performance pass if 10k+ nodes need it.

**`tags`** *(personal)* — `name, color, kind (normal | place)`. Tags always
live in your personal space; there are no shared tags (v0.11). Names
match case-insensitively, and must be writable inline (a letter first, then
letters, digits, `_`, `-`; spaces become `-`). **A tag lasts while something
uses it** unless it is `kept` (made or edited on the Tags page) or a
`favorite`: removing its last use tombstones it, and using the name again
revives the same row. *(v0.10: `favorite` and `kept` columns, schema v9.
Since tags are personal, these can stay on the tag row.)*
**`node_tags`** *(personal)* — `node_id, tag_id, origin (inline | attached)`.
Lives in your personal space, even when the node is shared. `inline` rows come from `#name` in the
node's title or text and are kept in step with it on every save;
`attached` rows come from the tag picker.

**`links`** — any node → something.
`from_node_id, target_kind (node | note | url | attachment), target_id, url, label, origin (inline | attached)`
- `target_kind = note`: `target_id` is the node whose `body_md` is linked.
  This is how a child links an ancestor's note.
- `origin = inline`: created by `[[Node title]]` syntax in a note. On save, the
  parser keeps these rows in step with the note text.
- `origin = attached`: created through the UI, e.g. linking ancestor items
  (see [§6.10](#610-linked-ancestor-items)). These are never touched by the
  note parser.
- A unique index on `(from_node_id, target_kind, target_id)` among non-deleted
  rows stops the same item being linked twice.

**`attachments`** — files in the blob store.
`node_id, content_hash (SHA-256), filename, mime, size_bytes, kind (image | text | pdf | other), width, height`
`node_id` is the attachment's **single owner**. Every other place it appears
is a `links` row pointing at it, so there is only ever one attachment record
and one file.

**`annotations`** — markup on attachments, **one row per stroke or highlight**.
Two devices marking up the same photo then merge cleanly, since there's
nothing to conflict.
`attachment_id, kind (stroke | highlight | text_label), data_json, color, z`
*(v0.12, schema v10: `attachments` and `annotations` built; erasing a mark
sets `deleted`.)*
- `stroke`: `{"points": [x0, y0, x1, y1, …], "width", "pen": "pen" |
  "highlighter"}`, points normalized to 0–1 of the image size, width as a
  fraction of its shorter side.
- `highlight` (text docs): character range `{start, end}`.
- `text_label`: position plus a short string.

**`occurrence_completions`** *(shared)* — completions for recurring nodes
**and their descendants**.
`node_id, occurrence_date, completed_by, completed_at, note`, unique per
`(node_id, occurrence_date)`. `occurrence_date` is the occurrence of the
nearest recurring ancestor (or of the node itself).

**`time_entries`** *(personal)* — `node_id, started_at, ended_at (NULL = timer running), source (timer | manual), note`

**`today_entries`** *(personal)* — `date, node_id, sort_key, hidden, resolved`
(v0.17: `hidden` takes an automatic entry off that day; `resolved` marks a
left-over pick as kept or dropped.)

**`node_context`** *(personal)* — the context-resume state for each node.
`node_id, last_opened_at, last_attachment_id, last_link_id, scratch_md, pinned_items_json`

**`node_user_prefs`** *(personal)* — `node_id, child_view_override, collapsed`

**`activity`** *(personal)* — a durable history for reports. It survives
change-log compaction and Trash purges.
`at, node_id, action (completed | uncompleted | created | time_logged | archived | …), title_snapshot, top_project_snapshot, values_snapshot, minutes`

### 5.3 Tree rules
- Each node has exactly **one real parent**. Moving a node only changes its
  `parent_id` and `sort_key`.
- **A new node gets its parent's `space_id`**, so a subtask added under a
  shared task is automatically shared with that task's members.
- A move (or placement) that would create a **cycle** is rejected locally.
  If a cycle shows up after a sync merge, the move with the older HLC is
  undone.
- A `parent_id` pointing to a node **you can't see** (it's in a space you
  aren't a member of) is treated as top-level for you. You place the node
  with a placement.
- **Archiving or deleting** a node applies to its whole subtree in one
  transaction: every descendant gets the same `lifecycle` and
  `lifecycle_root_id`. Deleting moves items to **Trash**. Tombstones
  (`deleted = 1`) are only written when Trash is purged after 30 days or
  emptied by hand (see [§6.11](#611-archive-and-trash)).
- The **top-level project** of any node is its topmost visible ancestor.
  It is cached alongside the effective values for fast filtering.

### 5.4 Local-only tables (never synced)
- `devices`: paired devices, with their public keys and labels.
- `local_secrets`: the user identity private key, device private key,
  space keys and optional pairing PIN hash (in OS secure storage where
  available).
- `sync_state`: per peer and per space, the highest HLC seen from each origin
  device (a version vector).
- `change_log`: outgoing and applied changes (see §7).
- `pending_unknown_ops`: ops this app version doesn't understand yet, kept and
  passed along (see [§7.5](#75-versioning)).
- `node_search`: the FTS5 index over `nodes.title` and `body_md`
  (external content, kept in step by triggers; `lib/data/search.drift`).
- `ui_prefs`: window layout, theme, last tab, language.

## 6. Feature design

### 6.1 Tree and node detail
- **Tree pane:** expand and collapse, drag to reorder or reparent, keyboard
  first on Windows with **arrow keys** (v0.7; see below). Tab is left for
  moving focus, so it never traps keyboard or screen-reader users (WCAG
  2.1.2).
  - **Drag and drop (v0.7):** with a mouse a row drags as soon as it moves;
    on touch, long-press starts the drag (so phone tree rows have no status
    menu). Dropping on a row's top or bottom quarter puts the item just
    above or below it (a line shows where); the middle puts it inside, last,
    and expands that row. The space under the last row means "last at the
    top level". An item can't be dropped on itself or inside its own
    subtree. Each move offers Undo, and only `parent_id` and `sort_key`
    change (§5.3).
  - **Items list:** a drag handle on each row of a node's Items list
    reorders its children.
  - **Keyboard (built in M8, with the accessibility pass):** Tab and Shift+Tab move focus into and
    out of the tree as one stop. Inside it, ↑/↓ move between rows, → expands
    (or goes to the first child), ← collapses (or goes to the parent), and
    Enter opens the row. **Alt+Shift+↑/↓** moves the item up or down among
    its siblings, and **Alt+Shift+→/←** indents it (last item of the
    sibling above) or outdents it (just after its parent). Moves offer Undo
    like drags.
  - **Screen readers (M8):** each row exposes the same moves as accessibility
    actions (Move up, Move down, Indent, Outdent), so TalkBack and Narrator
    users never need to drag (WCAG 2.5.7).
  - *Later, optional:* a "Move to…" picker for long distances.
- **Breadcrumbs** and **zoom** let you focus on any subtree as if it were the
  root.
- **Tree context in every node view** (see [§6.1.1](#611-tree-context-navigate--peek)).
- **Node detail:** title, type, status, assignees, tags, dates, estimate and
  time spent, values (explicit and inherited, shown separately), progress,
  markdown note, links, attachments, and the children (shown in the node's
  [child view](#613-child-views)).
- **Done button (v0.7):** a labelled **Done** button at the far end of the
  title row, away from the title. It only completes: open, active and waiting
  go to done. Pressing it plays a short burst (and a haptic tap on phones)
  and shows a snack bar with Undo. A done item shows "Completed {date}" with
  a small **Reopen** link instead of the button. On a repeating item that is
  still going, the button reads **Done for today** (or "Done for {date}" for
  the current occurrence, the latest on or before today), writes
  `occurrence_completions`, and leaves the item open. It then shows
  "Completed for today" with Undo. Before the series starts it is disabled.
- **Status menu:** all five statuses, from a compact "Open ▾" button beside
  the title, or by right-clicking or long-pressing the Done button or any
  item's **tree row**. "Done" from the menu ends a routine for good.
  Sub-item lists keep their checkboxes for now. Tree rows show no icon for
  plain tasks; goals, projects, ideas, notes and inferred routines, events
  and lists keep theirs.
- **Add-ons row (v0.5):** "+ Description" (the editor appears only once
  added; v0.7: it closes with its ✕ or Esc, after which a non-empty
  description shows as read-only text that opens the editor when clicked,
  and an empty one goes back to the chip), and dates (v0.7: "Show as list" became the view switcher, §6.13). The item's dates (deadline, time slot,
  repeat) show as chips; tapping any opens the **one date & time dialog**,
  where each part has its own switch, and a chip's ✕ removes just that part.
  With no dates yet, one "+ Date & time" chip opens the dialog. Goals and
  projects get the same add-ons, e.g. a time period and a deadline.
- **Notes column (v0.5):** an item's notes (and later its documents and
  items linked from ancestors, §6.10) sit in a column beside it, **collapsed
  by default** behind a "Notes (n)" button. On narrow screens it is a
  collapsed section under the item's items. Opening a note shows just its
  title and text.
- **Tree icons** follow what the item has: a repeat shows the routine icon, a
  time slot the event icon, a list layout the list icon.
- **Layout:** two panes (tree + detail) on Windows; on Android, drill-down
  navigation.

#### 6.1.1 Tree context: navigate + peek
Every displayed node knows its whole line of ancestors and its children.
Example: working on *Test New Feature*, you can reach *Implement Feature*
(parent), *Project* (grandparent) and *Test Case 1* (child) in one click.

- **Ancestors:** full breadcrumbs from the top-level project down to the
  current node. Each one is clickable. On narrow Android screens, middle
  levels collapse to "…" and tapping expands them (v0.9: below 600 px, with
  more than two levels, it shows first › … › last). If you opened the node
  through a placement, the breadcrumb also shows "via Errands".
- **Zoom (v0.9):** "Zoom in" on a tree row's right-click menu, or "Zoom
  tree here" in an item's ⋮ menu, shows that item's children as the tree's
  top level. A bar above the tree names it, with ↑ (zoom out one level) and
  ✕ (whole tree). New items and drops at the end land inside it.
- **Children:** shown in the node's child view, and you can expand a child to
  see its own children.
- **Navigate:** clicking an ancestor or child opens it. **Back/forward
  history** works with mouse buttons and `Alt+←/→` on Windows, and the back
  gesture on Android.
- **Peek:** look at another node's context without leaving the current one.
  - Windows: hover for a peek card (after ~0.7 s), and **Pin beside** on the
    card keeps it as a **side panel** to the right of the detail pane.
  - Android: long-press for a bottom sheet. *Not on tree rows*, where
    long-press drags (v0.7); peek works on breadcrumbs, Items rows, search
    results, "from:" tags, inherited value chips and the Values page.
  - **v0.9 built:** the card shows path, type, status, item count, values,
    tags, description and notes, with **Open**. Not yet: editing the note in
    place, and "Link here".
  - The peek shows that node's note (editable in place), links, attachments,
    values and status. "Open" navigates to it; "Link here" links its
    note or doc into the current node (see [§6.10](#610-linked-ancestor-items)).
- **Nothing extra is stored:** ancestors come from a recursive query on
  `parent_id`, and children from an index on `(parent_id, sort_key)`. Both are
  sub-millisecond at expected sizes (depth around 10, tens of thousands of
  nodes). History is in-memory UI state per device.

### 6.2 Values
- Values page: each value with its statement and the goals linked to it.
- Every node shows chips for its inherited values. The Today view uses them to
  answer "why does this matter?"
- Values are **personal**. Two family members can tie the same shared task to
  different values of their own. Sharing an item never shares the values tied
  to it or to the items above it (v0.11).
- **UI (v0.9):** a **Values** entry under the tree (above Archive and Trash)
  opens the Values page: each value as a card with its icon, colour,
  statement and the items tied to it (goals first), with Edit, Delete
  (confirmed, says how many items it's untied from) and a drag handle to
  reorder; **New value…** adds one (name, "why it matters", icon, colour).
- On an item, under the title: its own values as chips (✕ unties), then
  inherited ones, faded, as "Family · from Trip" (click opens Trip), then
  **+ Value**, a menu of values to tick plus **New value…**. Notes have no
  values.

### 6.3 Notes, links and ideas
- **Description vs notes (v0.5):** an item's description is its own markdown
  text. Notes are separate `note` items under it, any number of them, so they
  can be moved, searched and linked like any item. They show in the notes
  column (§6.1).
- Markdown subset: headings, bold and italic, lists, checkboxes, code, links,
  and `[[node links]]`.
- Editor: a plain-text editor with a toolbar and a live preview toggle.
  **Built (v0.7):** toolbar for bold, italic, heading (`## `), bulleted and
  numbered lists, link and code (inline, or fenced across lines); each
  toggles off again. **Preview** renders what is in the field. A closed
  description and the notes column render Markdown; card previews (panels,
  note cards) show the text without markup. Task-list checkboxes render
  read-only. Links open in the browser (http, https, mailto only).
  `[[node links]]`, backlinks and "Convert checkboxes to items" come with
  linking.
- **Note pages (v0.7):** a note opens formatted and read-only with an
  **Edit** button (a new, empty note opens in its editor). Editing shows
  **Save** (or Esc), which returns to the formatted view; clicking the text
  edits too. **← Back to {item}** returns to the item the note belongs to.
  Saving is still automatic; Save only ends editing.
- Backlinks: a node's detail lists every node that links to it.
- **Lists that people tick off belong in child nodes, not markdown
  checkboxes.** Child nodes merge per field, so two people ticking off items
  at the same time never overwrite each other. A "Convert checkboxes to
  items" action turns pasted checkbox lists into child nodes.

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
- **Built (v0.12):**
  - **Where:** a **Files** list in the notes column, below the item's own
    notes (the button reads "Notes & files (n)"): image thumbnails, then a
    row per other file. **+ Add** offers Choose files…, Take photo (phones;
    downscaled to 2560 px, quality 85) and Paste image (Windows).
  - **Windows:** drop files anywhere on an item's page; **Ctrl+V** attaches
    a clipboard image when no text field has focus. Larger than 20 MB asks
    first ("Attach anyway" / Skip). Every add offers Undo.
  - **Page:** clicking a file opens its page in the detail pane (pushed on
    phones), with **Back to {item}** (or to the item it was linked into),
    size and dimensions, and "Linked into N items" chips. Images zoom and
    pan; `.md` renders formatted; `.txt`, `.csv` and `.log` show as text
    (over 2 MB: use Open in…); PDFs and others show a file card. No PDF
    rendering in the app (decided v0.12).
  - **⋮:** Open in… (a temporary copy, by `open_filex`), Replace file…
    (markup stays), Export with markup… (images; a PNG at full size via
    the Save dialog), Rename, Remove file (Undo).
  - **Markup (images):** **Mark up** switches to drawing: pen, highlighter
    (translucent, multiply), text label (asks for the text), eraser (whole
    marks the swipe touches), six colours, Undo for this session's marks;
    **Done** returns to viewing. "Show/Hide markup" toggles the layer. The
    page doesn't scroll while marking up, so vertical strokes draw.
  - **Markup (text):** in Mark up, `.md` shows its raw text; select and
    **Highlight** (five colours), **Clear** removes highlights in the
    selection. Highlights are character ranges of the raw text, shown
    whenever the raw text is.
  - **Files on disk:** `<app support>/blobs/ab/cd/<sha256>`. At startup,
    after the Trash purge, files no attachment of a non-deleted item uses
    are deleted (removed files are kept until then, so Undo works).

### 6.5 Calendar, deadlines and routines
- **Calendar view:** day, week and month, showing events, deadlines and time
  blocks.
- **Recurrence:** expanded on the fly from `rrule` for the visible date range.
  Nothing is stored per occurrence except completions and exceptions.
- **Recurring subtrees (D24):** when a node repeats, **its whole subtree
  repeats with it**. Each occurrence shows the children fresh, and ticking a
  child writes an `occurrence_completions` row for that child and that
  occurrence date.
  - The parent's occurrence **completes automatically when all its
    children are done** for that date. It can also be ticked by hand.
  - *Example:* "Saturday chores" (weekly, assigned to all four family
    members) has four children, one assigned to each person. Every Saturday
    all four reappear unticked, and the parent completes when the last one is
    done.
- **Exceptions** (skip or move one occurrence): stored as EXDATE/RDATE in the
  RRULE set. *Not built in M4 (left out by choice, v0.13).*
- **Built (v0.13):**
  - **Calendar page:** a **Calendar** entry under the tree, above Values,
    opens it in the detail pane (a full page on phones). **Day / Week /
    Month**, ‹ Today ›, and Export. Day and week: an all-day row (deadlines
    🏳, routines 🔁), then hours, opened at 07:00; overlapping events share
    the width. Month: six weeks, three entries a day then "+n more". Done
    entries are struck through. Entries peek on hover and open on click.
  - **Crowded days (v0.14):** a month cell, and the all-day row of each
    day in week/day view, shows at most three entries (fewer if the cell is
    short), then **+n more**. Overlapping timed events share the column
    width down to about 44 px each; any that don't fit become a "+n" at
    their time.
  - **Day list (v0.14):** clicking a day (its header, empty time, a month
    cell or "+n more") lists everything on it, all-day first then by time,
    with kind, time and done; it sits beside the calendar when there's room
    (860 px), else in a bottom sheet. "Add on this day…" at the end.
  - **Adding (v0.14):** right-click empty space (long-press on phones) for
    a small dialog: "New event · Tue 10 · 9:00–10:00" (week/day, on the
    half hour) or "New item · due Tue 10" (month cell or day header), with
    a title field. **Nothing is created until Add**; the snack bar offers
    Open. No dragging, ticking or skipping from the calendar (decided
    v0.13).
  - **Filters (v0.14):** a bar under the header: **Events / Deadlines /
    Repeats** (shown kinds), **Hide done**, **Tag** and **Value** (any of
    those picked; values count when inherited). **Clear filters** resets.
    Kept while the app is open.
  - **Show in calendar (v0.15):** on an item, ⋮ → **Show in calendar**, or
    the chip by its dates, opens the calendar filtered to that item and
    everything under it (any level), at its next date (today if none is
    ahead). The bar shows "Only Trip ✕"; ✕ shows everything again. This
    replaces picking an item from the calendar.
  - **What's shown:** time slots (repeating ones on each occurrence),
    all-day and timed deadlines, and repeats without a time slot as all-day
    entries. Items inside a repeating item aren't listed; it stands for
    them.
  - **Repeating subtrees:** an item's status follows the nearest repeating
    item above it (its own rule first). Done, the checklist, steps and
    panels all tick per occurrence; nothing is ticked for good. A parent's
    occurrence is done when all its items are (recursively), or, for a
    one-at-a-time set, when its pick is. Children of a one-at-a-time set
    keep their own cadence (D36). Dropped items count as done.
  - **Time zones:** saving a time slot stores the device's IANA zone; each
    occurrence is placed at the same wall-clock time in that zone, then
    shown in local time.
  - **Reminders:** a **Remind me** row in the date & time dialog. With a
    time slot: at the time, 10 min, 1 hour or 1 day before; all-day: on the
    day or the day before, at 09:00. Several allowed; off by default.
    Stored per person (`reminders`: node, minutes before the start, or
    before 00:00 for all-day items). The next 14 days (up to 60) are
    scheduled at startup and two seconds after any change; done
    occurrences and items are skipped. Tapping one opens the item. Android
    asks for notification and exact-alarm permission with the first
    reminder, and falls back to inexact alarms without it.
  - **.ics:** "Include in calendar export" in the date dialog (personal,
    `node_user_prefs.ics_export`, off by default) chooses what Calendar →
    Export puts in the file; ⋮ → **Export to calendar (.ics)…** saves one
    item. Events keep their zone (TZID) and rule; repeats without a slot
    are all-day repeating events; deadlines are all-day "Due: …" events.
    Nothing is ever sent anywhere: syncing everything to Google or Outlook
    stays out of scope.

#### 6.5.1 Exclusive sets: children that take turns (D36)
*Example:* goal **Workout** repeats daily; its children **Arms** (every 3
days), **Core** (every 2 days) and **Legs** (no repeat of its own). Workout is
on the list every day, but only one exercise is suggested.

- **Switch:** "One sub-item at a time" in the Repeat section of the date &
  time dialog. Removing the parent's repeat turns it off.
- **Cadence:** each child's own repeat, or the parent's if it has none (so a
  plain rotation needs no setup).
- **Due date:** for "every N days", the last completion + N days (a gap: doing
  it late shifts the next one). For weekly and monthly patterns, the
  pattern's next day after the last completion. Never done = most overdue.
- **Pick:** the child furthest past its due date; ties go to list order.
  At most one per **parent occurrence**: once a child is done for the
  current occurrence (e.g. Monday's, which also covers Tuesday for a Mon/
  Wed/Fri parent), nothing more is suggested, however far behind the others
  are. If no child is due, **nothing** is suggested (a natural rest day).
- **Completion** is per occurrence (`occurrence_completions`, with the
  parent's occurrence date). Undo writes a tombstone so it syncs.
- **Display (M1):** a card on the parent: "Next up: Arms · 2 days overdue"
  with Mark done, "Done: Arms" with Undo, or "Nothing due right now". Each
  child shows its cadence and when it was last done. The Today view (M6)
  will show the current pick.
- **Reminders:** local notifications, scheduled for the next N days and
  rescheduled when the app opens or a sync finishes. Android needs the
  exact-alarm permission. No push in v1.
- **.ics export:** export a file, and optionally publish a read-only feed from
  the PC on the LAN. *(v0.13: file only, per item opt-in; a LAN feed could
  come with LAN sync in M7.)*
- **Time zones:** store UTC plus an IANA zone ID. All-day items store a plain
  date.

### 6.6 Search
- One search box backed by **FTS5** over titles, notes, link labels and
  attachment text (`.txt`/`.md` contents and filenames).
- **Filters** (combinable): core value (effective), **tag** (with "include
  children"), type, top-level project, status, assignee, date range, "has
  attachments", "include archived".
- **Linked items:** a note or attachment matches a filter if its **owner
  or any node linking it** matches (e.g. a doc owned by Project A and linked
  into a task under Project B shows up when filtering by B).
- **Listed once:** results are grouped by item, so a linked doc appears a
  single time, with "Owner: Project A · linked in 2 places". Placed nodes are
  also listed once.
- Archived items are hidden unless "include archived" is on. Trashed items
  only appear in the Trash view.
- Search syntax shortcuts: `#tag`, `#tag/*` (include children), `@user`,
  `value:Health`, `type:task`, `in:"Project"`.
- Saved searches (later).
- **UI (v0.9):** the box sits at the top of the tree pane (**Ctrl+F**
  focuses it). While it has text or a filter, results replace the tree,
  one row per item with its path ("Trip › Europe", "linked in 2 places",
  "archived"); **Esc** or ✕ clears it and the tree returns. The ⚙ (tune)
  button shows the filter chips: **Value, Tag** (with "Include items under
  tagged ones"), **Type, Status, Project** (a top-level item), **Due** (a
  date range) and **Include archived**. Chips and typed shortcuts combine.
  Values and tags must all match; types and statuses match any. Words match
  as prefixes, titles rank above text, `"quotes"` match a phrase, and
  `status:`/`is:` filter by status. Clicking a tag chip on an item searches
  for it.
- **Files (v0.12):** filenames and the text of `.txt`/`.md` files (up to
  1 MB) are in a second FTS5 index, `attachment_search`; matching files are
  listed after items as "name · Owner › path · file" and open their page.
  Filters judge a file by its owner and the items linking it (D19); a Type
  filter leaves files out. A **Has files** chip keeps items with files.
- **Not yet:** link labels (no labelled links exist yet), the assignee
  filter (sharing).

### 6.7 Today view (motivation)
- Pick tasks into today's list from anywhere ("Add to Today"), or from
  suggestions: items due today or overdue, routines due today, last session's
  unfinished items.
- Each entry shows **its value chips and its top-level goal**, so the reason
  behind the work is always visible.
- Each entry shows its estimate, with a **▶ start timer** button. The day
  header shows planned vs. tracked time.
- At the end of the day, unfinished entries can roll over to tomorrow with one
  tap.
- **Built (v0.17), revised after review:**
  - **Home:** a **Today** entry first under the tree; the detail pane
    shows Today whenever nothing else is open (it replaces "Select an
    item"). Phones open on a bottom bar: **Today / Tree / Calendar**.
  - **Fills itself, unobtrusively:** routines due today (repeats with no
    time slot, done per occurrence; their items come with them), items
    due today, overdue items ("Overdue · 2 days"), events today, and
    optionally items with status Active. ⚙ chooses which (routines, due,
    overdue and events by default), saved as a personal setting
    (`user_settings`, key `today.sources`).
  - **Your picks:** ⋮ → **Add to Today** on any item (and Remove from
    Today). ✕ on an entry takes it off today's list (with Undo); for an
    automatic one this hides it for that day only.
  - **Order:** drag handles; dragging stores the order for that day.
    Unsorted automatic entries follow: overdue, due, events by time,
    routines, active.
  - **Entries:** an icon for why it's there, the title (struck through
    when done today), the reason and its path; click opens it, hover
    peeks. (Done, values and timers per entry: not on Today yet, decided
    v0.17.)
  - **Next day:** routines and deadlines need nothing; items you picked
    and didn't finish get a card, "2 items you added on earlier days
    aren't done", with **Keep on today** or **Drop**, asked once.
  - **Pick one for me** (🎲): a random open task, project or goal not
    already on Today, optionally narrowed by values and tags; Another, or
    Add to Today.
  - **Data (schema v13):** `today_entries` (personal: date, node, sort
    key, hidden, resolved) and `user_settings` (personal key → JSON).
- **Next (planned):** **time blocks**: dedicate a block of the day to a
  tag, value or high-level item and have Today fill it with concrete
  tasks from under it, up to the block's length by estimate; and saved
  filters for Pick one for me.

### 6.8 Quick-capture inbox (low friction)
- **Windows:** a global hotkey (default `Ctrl+Alt+Space`) opens a small
  always-on-top capture box. Enter saves the item and dismisses the box.
- **Android:** a home-screen widget, a quick settings tile, and the share
  sheet ("Share to app" creates an inbox item, with any shared image as an
  attachment).
- **Inbox is a capture state, not a type (v0.4).** Only quick-capture puts
  things there; items you create by hand never land in the inbox. Two kinds
  of capture:
  - **Inbox:** "remind me soon". A task with an *unsorted* flag (field to be
    added in M6), surfaced quickly until you file it.
  - **Idea:** "think about this later". `type = idea`, surfaced in a periodic
    review to flesh out, turn into a task or project, or just keep.
- The Inbox view lets you sort each one into the tree with a type-ahead
  parent picker; filing clears the flag.
- Items **sent to you** by someone else also arrive in the Inbox until you
  place them (see [§11.2](#112-sending-a-node)).

### 6.9 Context resume (low friction)
- Opening a node records it in `node_context`.
- **Resume** reopens the last attachment or link and the scratch note, and
  scrolls to where you were.
- A "Recent contexts" list (last 10 nodes) is one click from anywhere.
- Starting a timer on a node also resumes its context.
- On Windows, the app minimizes to the tray and keeps syncing in the
  background.

### 6.10 Linked ancestor items
Lets a child reuse the notes and docs of its parent or any other ancestor.
Nothing is copied, so each item still has exactly one original.

**Where it's offered**
- **From the child:** **Link from above…** at the end of the "From above"
  list in its notes column opens the picker. (Not offered at creation:
  children are added from a one-line field, v0.8.)
- The picker groups items by ancestor level (Parent → Grandparent → … →
  top-level project). Items already linked are shown ticked, and unticking one
  removes the link.

**What gets linked**
- An ancestor's **note**: a `links` row with `target_kind = note`.
- An ancestor's **attachment**: a `links` row with `target_kind = attachment`.
- Both use `origin = attached`. The child never gets its own copy.

**How it appears on the child**
- Linked items are listed together with the child's own items, each marked
  with a small "from: <owner title>" tag. Clicking the tag jumps to the owner.
- **Linked notes are editable in place.** The edit goes to the owner's
  `body_md`, so everyone linking it sees the change right away.
- **Linked attachments** open in the normal viewer, and markup is shared,
  since annotations belong to the attachment, not the link.
- The owner's detail shows "Linked into: N items", with a list.

**Rules**
- **No duplicates:** linking the same item twice is blocked by the unique
  index, and grouped results show each item once.
- **Moving the child** keeps its links (D17), even if the owner is no longer
  an ancestor. The tag still names the owner, and you can unlink by hand.
- **The owner is archived or trashed:** the child keeps the link, shown as a
  greyed placeholder ("Source archived" / "Source in Trash") with a
  **Restore source** action. If the source is purged from Trash, the
  placeholder becomes "Source deleted" and can be cleared.
- **Unlinking** removes only the `links` row. The original is never touched.
- **Sharing:** a link from a shared space to an item in a personal space
  shows as "Private item" to other members.

**Built (v0.7).** Since v0.5 an item's notes are `note` items, so what a
child links is an **ancestor's note item** (`target_kind = note`,
`target_id` = the note). Descriptions and attachments aren't linkable yet.
- **Where (v0.7, revised):** linked notes are a separate **From above**
  list in the item's **notes column** (or notes section on narrow screens),
  under its own notes. "Notes (n)" counts both. Each card shows the title, a
  preview, a small **↳ from: Trip** tag (opens the owner) and **Unlink**.
- **Shared with all sub-items (📌):** a note's pin button (on its card in
  the owner's notes column, or on the note's page) sets
  `nodes.shared_with_children`. The note then appears in the From above list
  of **every item under the owner, at any depth**, tagged **📌 pinned by:
  Trip**, nearest ancestor first, before explicit links. It can't be unlinked
  from a sub-item (unpin it on the owner); in the picker it shows ticked and
  locked. A note both pinned and linked is listed once.
- **Link from above…** opens a picker grouped by ancestor, nearest first
  ("Europe (parent)", then "Trip"…), with checkboxes; ticking links and
  unticking unlinks at once. Notes linked earlier that are no longer above
  (the item moved, D17) are listed under "Linked earlier, no longer above".
- **Editing:** clicking a linked note opens the original note's page, so
  edits go to the one original. Its **Back** button returns to the item you
  came from, and the breadcrumb shows "🔗 via Pack bags".
- A note's page lists **Linked into N items** as chips.
- Owner archived or trashed: the card is greyed ("Source archived" / "Source
  in Trash") with **Restore source**. Purged: "Source deleted" with
  **Clear**.
- **Files (v0.12):** the same "Link from above…" picker lists the
  ancestors' files under **Files**; linked files appear in "From above"
  with "from: Owner" and Unlink, and open their page with Back to the
  child. Pinning to all sub-items is for notes only.
- Links are offered from the child's notes column, not when creating it:
  children are added by a one-line field under Items, so there is no form
  to put a picker in (v0.8).
- Archive, Trash and Delete forever confirmations say how many items
  elsewhere link the group's notes (§6.11).
- Schema v6 adds `links` with the unique index among non-deleted rows;
  v7 adds `nodes.shared_with_children`.

### 6.11 Archive and Trash
Two ways to remove something. **Children always go with their parent.**

| | Archive | Trash |
|---|---|---|
| Purpose | Done or paused work you want to keep | Things you don't want |
| Visible in tree / Today / calendar | No | No |
| Searchable | With the "include archived" filter | Only in the Trash view |
| Reminders and routines | Paused | Paused |
| Kept | Indefinitely | 30 days, then purged (tombstoned and blobs freed) |
| Restore | Archive view → Restore | Trash view → Restore |

- **Subtree behavior:** archiving or trashing a node sets `lifecycle` on it
  and all its descendants, with `lifecycle_root_id` pointing to that node.
  Restoring the root brings back exactly that group. Children that were
  archived separately earlier stay archived.
- **Confirmation:** the dialog shows the size of the subtree ("Project X and
  23 items"), any items outside it that link its notes ("Used by 3 items
  elsewhere"), and its shortcuts placed outside it, which disappear with it
  and come back on Restore.
- **Purging:** after 30 days in Trash (or **Empty Trash**), rows become
  tombstones. Attachment files are freed once no live row references their
  hash on any device. **`activity` rows are kept**, so reports still show the
  work.
- Archive and Trash state are ordinary synced fields, so they apply on every
  device.
- **UI (v0.7):** a ⋮ menu at the end of an item's title row has **Archive**
  and **Move to Trash**. Every removal asks first, naming the subtree size
  ("It and 3 items inside it…"), plus the "used by items elsewhere" and
  shortcuts lines when they apply. After removing, the page moves to the parent, and a snack bar
  offers Undo. **Archive** and **Trash** entries (with counts) sit under the
  tree; each lists one row per group (newest first) with how many items went
  with it, where it was, when, and for Trash the days left. Rows have
  **Restore**, plus **Move to Trash** (Archive) or **Delete forever**
  (Trash); Trash has **Empty Trash**. Opening a removed item shows a banner
  ("In the Archive", or "Archived with Project X") with Restore, which
  restores the whole group. A restored group whose old parent is gone
  (archived, trashed or purged) comes back at the end of the top level.
  Expired Trash is purged at startup. Auto-archiving done items (Q-H) comes
  later.

### 6.12 Placements: one node, several places
A node has **one real parent** but can **appear in other places for you**.

- **Add a shortcut:** "Also show in…" puts the node under another parent in
  your tree, e.g. "Buy paint" under your "Errands".
- **Received nodes:** a node someone sends you is placed in your Inbox or
  wherever you file it. That's a placement too.
- **It's the same node:** edits, subtasks, status and attachments are shared
  across every place it appears. Subtasks you add go under the real node, so
  other members of its space see them, but they **never see your placement
  parents** (like "Errands").
- **Display:** placed nodes show a small ↗ marker. The breadcrumb shows the
  real path, plus "via <placement parent>".
- **Effective values and tags** for you include the placement parent's
  ancestors.
- **Why not true multiple parents?** With several real parents, breadcrumbs,
  the top-level project, value inheritance, archive cascades and cycle checks
  would all become ambiguous. Placements give the same everyday result while
  keeping one clear tree.
- **Built (v0.7), as "shortcuts":**
  - **Add:** ⋮ → **Also show in…** opens a searchable picker of your items
    (plus Top level). Places it can't go are greyed: itself, anything shown
    under it, its real parent, and places it already shows. Notes can't be
    placed. Undo in the snack bar.
  - **Show:** a shortcut sits among the parent's real children (one shared
    sort-key space) in the **tree** and in the parent's **Items** (every child
    view), marked ↗. It counts toward the parent's item count and progress.
    Shortcuts don't take part in a one-at-a-time set.
  - **Move:** dragging a ↗ row (tree or Items) moves only the shortcut;
    the real row moves the real item. Moving an item to where one of its
    shortcuts is drops that shortcut.
  - **Remove:** right-click a ↗ row → **Remove shortcut**, or ⋮ → "Remove
    shortcut from Errands" on the item's page.
  - **Breadcrumb:** opened through a shortcut, the page shows "↗ via
    Errands" (tap to go there) before the real path.
  - **Loops:** a placement or move is refused if the new parent is shown
    anywhere under the node, through real children or shortcuts.
  - **Archive:** archiving the item hides its shortcuts; archiving the
    shortcut's parent does not archive the item (it isn't really there).
  - Schema v5 adds `placements` (personal space). Effective values and tags
    through placements come with values and tags.

### 6.13 Child views
How a node **shows its children**. Set on the node (`child_view`), and you can
override it just for yourself.

| View | Looks like | Good for |
|------|-----------|----------|
| **Panels** *(default)* | One card per child, showing status, due date, assignees, tags, estimate vs. time spent, progress bar, note preview and child count | Projects, goals, anything with substance |
| **Checklist** | A plain list with inline checkboxes. Children that have their own children show a small "›" to drill in. | Shopping lists, packing lists |
| **Steps** | A numbered sequence. **Only the next unfinished step is highlighted**; the rest are dimmed. | Procedures and "just do the next thing" (ADHD-friendly) |
| *Later:* Board | Kanban columns by status | Workflows |
| *Later:* Table | Rows with columns (due, assignee, estimate, tags) | Planning and triage |
| *Later:* Gallery | Image cards | Recipes, photo lists |
| *Later:* Timeline | Children placed on a calendar | Time-blocking |

Every view can still nest without limit. The view only changes how one level
is drawn, and you can always drill into a child.

**Built in v0.7:**
- **Switcher:** three icon buttons (Panels, Checklist, Steps) beside the
  "Items" heading. Panels is the default for every item.
- **Panels:** one full-width card per child, stacked: icon, title, note
  count, then status (if not open), deadline, time slot and repeat; a
  progress bar of done/dropped vs. all items ("4/6"); and two lines of the
  description. Assignees, tags and time come with those features. Finished
  children are dimmed and struck through.
- **Checklist:** a checkbox, the title, and "›" with a count for children
  that have items.
- **Steps:** numbered. The first unfinished step is highlighted with a
  **Done** button; later steps are dimmed (still openable); finished steps
  show ✓, which unticks them.
- **All views** keep drag handles to reorder. A one-at-a-time set (D36)
  ignores the view: its rows show cadence and last completion, and the
  switcher is hidden.
- *Later:* the personal override (`node_user_prefs`).

### 6.14 Tags
- Create tags anywhere with `#name` in a title or note, or from the tag picker.
- **Tags are personal (v0.11).** Sharing an item with someone never shares
  your tags: you can tag a shared task `#annoying` and no one else sees it,
  and they tag it with their own. There are no shared tags.
- **Inline `#tags` in shared text:** the title and text are shared, so the
  words are visible to every member; whether they also become tags for the
  others is open question Q-M.
- Tags are **explicit** (shown only where you put them). Search can add
  "include children".
- **Inline rules (v0.9):** `#` then a letter starts a tag (letters, digits,
  `_`, `-`), so `#1` and `# Heading` aren't tags. Code spans and blocks are
  skipped, and so is a `#` right after a letter, digit, `/`, `(` or `&`
  (URL fragments, `[x](#anchor)`). Deleting the text removes the tag.
- **UI (v0.9):** under the title, chips for the item's tags, then **+ Tag**
  (type a name, existing tags are suggested, Enter adds). Picker tags have
  ✕; tags from the text don't (their tooltip says to edit the text).
  Clicking a tag searches for it.
- **Favourites (v0.10):** starred tags are the common categories (#work,
  #home). They show as one-tap toggle chips at the top of the **+ Tag**
  picker, before the search field, and first in the search Tag filter. They
  are ordinary tags otherwise: they don't pass down to children (searching
  a tagged top-level item with "include children" already covers its tree).
- **Tags page (v0.10):** a **Tags** entry under the tree, below Values.
  Create a tag (kept even while unused); favourites first, then the rest.
  Each row has a star, a colour (dot shown on chips everywhere), how many
  items use it (click to search), **Rename** and **Delete**.
  - **Rename** rewrites `#old` to `#new` in every title and text. Renaming
    to an existing name **merges**: every item gets the other tag (once),
    the text is rewritten, and star and colour carry over.
  - **Delete** (confirmed, with the count) removes it from every item and
    turns `#name` in text into plain `name`, so it doesn't come back.
- **Place tags** (`kind = place`) are tags that can be printed as QR codes
  (see [§6.17](#617-qr-place-tags)).

### 6.15 Time: estimates, timers, tracking
- **Estimate:** optional `estimate_minutes` on any node. Parents show the sum
  of their children's estimates next to their own.
- **Timer:** ▶ on any node or Today entry. There is **one running timer per
  user**, so starting another pauses the first.
  - The running timer syncs, so you can start on the PC and stop on the phone.
  - Windows shows it in the tray and a small always-on-top chip. Android shows
    an ongoing notification with pause and stop.
- **Focus mode** (optional): a countdown from the estimate or a chosen
  length, with a gentle chime and a "keep going / done / break" prompt.
- **Manual entries:** add or edit time after the fact.
- **Roll-ups:** tracked vs. estimated time for any subtree, value, tag or
  project.
- Time entries are **personal** by default (see Q-I).
- **Built (v0.16):**
  - **Timer:** ▶ in an item's title row: Start timer, Focus for 25m, or
    Focus for the estimate. While it runs a bar across the top of the app
    shows "⏱ Pack bags · 23:41" with **Pause** and **Stop** (click the
    name to open the item); ▶ on that item becomes ■. Pause ends the time
    entry and the bar reads "Paused · …" with Resume (the paused state is
    this device's only); resuming starts a new entry. Starting another
    item stops the first.
  - **Focus:** counts down with a progress line; at zero, a chime and
    **Keep going** (keeps counting), **Done** (stops and marks the item
    done) or **Take a break** (stops; a 5-minute break bar with End
    break). The countdown length is stored on the entry so it shows on
    every device.
  - **Windows:** a tray icon while a timer runs or is paused (tooltip
    "⏱ Pack bags · 0:23", menu Show / Pause or Resume / Stop; click shows
    the app), and a **mini window** button on the bar that shrinks the app
    to the bar alone, always on top; its expand button restores it.
  - **Android:** an ongoing notification with a running clock and Pause /
    Stop.
  - **Estimates and time:** chips under the title: **Est. 1h** (presets
    15m–8h or minutes; ✕ clears) and **25m of 1h** (or "Track time"),
    which opens the item's time entries: newest first, edit or delete,
    **Add time…** (day, start, length, note). When items under it have
    estimates or time: "Items: 45m of 2h".
  - **Data (schema v12):** `time_entries` (personal: node, start, end or
    running, source timer/manual, focus minutes, note) and `activity`
    (personal, add-only: created, completed, uncompleted, archived,
    trashed, restored, time logged; with title, top-level project and
    values as they were).

### 6.16 Progress, reports and summaries
- **Progress bars** on goals and projects: done children ÷ all children
  (recursively), with an optional manual override. Recurring nodes count the
  current occurrence.
- **Weekly review: "What did I do this week?"**
  - Completed items, grouped by **top-level project** and by **value**.
  - Time tracked per project, value and tag, against estimates.
  - Routine adherence (e.g. "Gym: 3/3").
  - Items created vs. completed, plus anything overdue or carried over.
  - Export as Markdown, or copy to clipboard.
- **Other ranges:** day, week, month, or custom dates.
- Built from the `activity` table, `time_entries` and
  `occurrence_completions`, so it still works after archiving and purging.
- **Built (v0.16):**
  - **Progress:** under an item's title when it has items under it: a bar
    and "4/12 · 33%", counting every level (repeats count today's
    occurrence); panels show the same. ⋮ → **Set progress manually…** (a
    slider) shows "80% (set by hand)"; **Count items again** clears it
    (`nodes.progress_override`).
  - **Review:** a **Review** entry under the tree (after Calendar). Day /
    Week / Month / Dates…, ‹ This one ›. Totals (completed, created,
    tracked, overdue); completed by project (as it was when completed) and
    by value; time by project, value and tag against estimates; routines
    "Gym 3/3"; overdue items. **Copy as Markdown** and **Export (.md)**.
    Completing then un-completing within the range doesn't count. History
    starts at v0.16: earlier completions aren't in it.

### 6.17 QR place tags
Room-level "location" with no extra hardware: you just need paper.

- Create a **place tag** (e.g. "Kitchen", "Garage") and tag nodes with it.
- **Print QR:** the code contains only an app link and the tag ID
  (`epa://place/<tag_id>`). No names or personal information.
- **Scan** with the phone camera or the in-app scanner: the app opens a list
  of that place's open tasks (respecting routines due today).
- Place tags in a shared space work for the whole family: one QR on the fridge
  shows the household's kitchen tasks.
- **Later:** geofences (stores), Wi-Fi network (home or work), Bluetooth device
  (car), and "at my PC" contexts.

## 7. Sync design

### 7.1 Change model
- Every local write records **field-level operations** in `change_log`:
  `(op_id, space_id, table, row_id, column, value, hlc, origin_device_id, author_user_id, schema_version)`.
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
- Set-like tables (`node_tags`, `node_assignees`, `placements`, `links`,
  `annotations`) are **add/remove rows**, so concurrent additions never
  conflict.

### 7.2 Discovery and pairing (your own devices)
- Each device advertises `_epa-sync._tcp` over mDNS with an opaque device ID
  and port. Nothing personal is included.
- **Pairing a new device:**
  1. On the new device, choose "Join my devices". It lists the devices it finds
     on the LAN.
  2. Pick one. **Both screens show the same 6-digit code.**
  3. **Confirm on both devices.**
  4. If the existing device has a **pairing PIN** set (optional, stored
     only as a local hash), the new device must enter it as well.
  5. The existing device sends the **user identity key** and space keys over
     the encrypted channel, then signs the new device's key.
- **Transport:** TLS with **pinned keys** from pairing. Unpaired devices are
  ignored.
- **Recovery:** while any one of your devices survives, you can pair a
  replacement. An optional offline recovery phrase is open question Q-J.

### 7.3 Sync session
1. Discover the peer, connect, and authenticate both sides.
2. **Version handshake** (see §7.5).
3. Exchange **version vectors** per space (the highest HLC seen from each
   origin device).
4. Each side sends the ops the other is missing, in HLC order, in batches.
5. Apply the ops in a transaction and rebuild the effective-value and
   project caches for the rows that changed.
6. **Blob phase:** list attachment hashes the device references but doesn't
   have, then transfer them, resuming where a transfer stopped.
7. Store the new version vector.

**When sync runs:** on app start and resume, every N minutes while the app is
open, shortly after local edits (debounced), and when a peer appears on mDNS.
On Android, best-effort background sync via WorkManager. On Windows, from the
tray process.

Because every device keeps the full op history for its spaces, syncing works
transitively: **phone → PC → laptop** carries everything.

### 7.4 Compaction
Ops older than X days that **every paired device** has acknowledged can be
dropped from `change_log`, since the row tables already hold the current
state. Tombstones are purged the same way. The `activity` table is not
affected.

### 7.5 Versioning
Different devices and people **will** run different app versions.
- **Handshake:** each side sends `protocol_version` and
  `min_compatible_protocol`. If they're incompatible, sync stops with a clear
  message telling the user to update the older app. Data is never partially
  applied.
- **Ops carry `schema_version`.** A device that receives ops for tables or
  columns it doesn't know **stores them in `pending_unknown_ops`, passes them
  along to other peers, and applies them after it upgrades**. Unknown data is
  never dropped.
- **Additive-only schema rules for synced tables:** add tables and columns
  freely. Never rename, repurpose or change the meaning of a column.
  Deprecate it and add a new one instead.
- Local Drift migrations run on upgrade, and each one is tested against a
  snapshot of the previous schema.

## 8. Platform notes

| Topic | Android | Windows |
|-------|---------|---------|
| Background sync | WorkManager (best effort); sync on open | Tray process stays running |
| Capture | Widget, quick settings tile, share sheet | Global hotkey, drag and drop |
| Timer | Ongoing notification with controls | Tray + always-on-top chip |
| QR | Camera scan + deep link `epa://` | Print or export QR (scan with the phone) |
| Notifications | `flutter_local_notifications` + exact alarms | Toast notifications |
| Open in… | FileProvider intent | Default program for the file type |
| mDNS | NSD (via `bonsoir`); multicast lock needed | Bonjour/DNS-SD via `bonsoir` |
| Secrets | Android Keystore | Windows DPAPI / Credential Locker |
| Storage path | App-internal storage | `%APPDATA%\ElliottsProductivityApp` |
| Firewall | — | First run asks to allow the sync port on private networks |
| iOS (later) | Planned for after the relay. Keep platform code behind `platform/` interfaces. | |

## 9. Security and privacy
- **No accounts, emails, phone numbers or real names.** A user is an opaque
  ID plus a public key. Names are local labels, and a sender's alias is only a
  suggestion inside an encrypted payload.
- **Nothing personal leaves your devices** except the content you
  deliberately put in shared tasks and notes, and that only goes to the
  members of the space.
- No telemetry.
- Only paired devices can sync (mutual TLS with pinned keys), and pairing
  needs confirmation on both devices, plus an optional PIN.
- mDNS announcements and QR codes contain only opaque IDs.
- Database encryption at rest (SQLCipher) is **optional, later**. Device-level
  encryption is assumed for now. Keys live in the OS's secure storage.
- Backups: the PC writes a nightly SQLite backup plus the blob folder to a
  user-chosen location.

## 10. Project structure (proposed)

```
ElliottsProductivityApp/
├─ docs/DESIGN.md
├─ app/                      Flutter app
│  ├─ lib/
│  │  ├─ l10n/               ARB string files (no UI strings in code)
│  │  ├─ ui/                 screens & widgets (tree, child views, today, calendar, search, inbox, viewer, reports, timer)
│  │  ├─ domain/             use-cases, models
│  │  ├─ data/               drift tables, DAOs, migrations, FTS
│  │  ├─ sync/               HLC, change log, protocol, versioning, discovery, pairing
│  │  ├─ identity/           user & device keys, contact labels
│  │  ├─ blobs/              hash store, ingest, transfer
│  │  └─ platform/           notifications, hotkey, tray, share intake, open-in, QR, secure storage
│  └─ test/
└─ tools/                    scripts (e.g. two-instance sync test harness)
```

## 11. Sharing: spaces and sending

Not in v1, but the v1 schema fully supports it (D13, D21–D26, D34).

### 11.1 Model
- A **space** is a subtree plus its members. Your personal space holds
  everything that isn't shared, plus all your **personal** rows (§5.0).
- Sharing a node creates a **shared space** rooted at that node, and its
  subtree is re-tagged with that `space_id`. New children inherit it.
- **Transport:** an **encrypted relay** (e.g. a Cloudflare Durable Object
  per space) carries ops between people. Each space has its own key,
  delivered through the invite link or QR code. The relay sees only opaque
  space IDs and ciphertext, and keeps no logs.
- **LAN-only sharing** could come first: since sync is already per space,
  two people's devices on the same home network can sync a shared space
  without the relay.

### 11.2 Sending a node
- "Send to…" a node (a single task or a whole subtree) creates a shared space
  rooted at it, with you and the recipient as members.
- **Not sent:** your tags, values, placements and other personal data
  (§5.0). The recipient sees the item untagged and adds their own.
- You can attach an **alias** for yourself. It travels encrypted and becomes
  the recipient's suggested label for you.
- The recipient gets it in their **Inbox** and files it with a placement.
  Subtasks either of you add are visible to both.
- **Assignment:** you can assign it to the recipient, or leave it unassigned
  (anyone).

### 11.3 Send, then share more
*Example:* Sam sends you "Buy paint". You place it under your "Errands".
Later Sam shares the whole "Repaint Kitchen" project, which contains "Buy
paint".
- There is still **one "Buy paint"** (same node ID, never copied).
- The smaller space **merges into** the larger one: its rows are re-tagged and
  the old space gets `merged_into_space_id`.
- For you, "Buy paint" now appears in its **real place inside Repaint
  Kitchen**. Your "Errands" placement stays as a **shortcut** (↗), and you can
  remove it.
- Subtasks you added to "Buy paint" appear under Sam's "Repaint Kitchen" too.
  Sam never sees your "Errands".
- **Two pieces of one tree** sent separately are two spaces with two
  placements. Because node IDs are shared, they join up automatically if the
  common ancestor is shared later.
- **Different members:** a space can only merge into a larger one whose
  members include all of its members. Otherwise it stays a **nested space**
  with its own members (see Q-K).

### 11.4 Attachments over the relay
- Each blob is **encrypted on its own** with the space key and stored under
  `HMAC(space_key, content_hash)`. The relay can't tell what a file is or
  match it across spaces.
- **Why not bundle everything into one encrypted archive?** Any change would
  re-upload the whole bundle, devices couldn't fetch just the photo they need,
  and one corrupt bundle would lose everything. Ops are already sent in
  encrypted batches, and very small attachments (under ~256 KB) could later be
  packed into batches too.
- Large files go to R2-style object storage (no egress fees), or directly
  between devices when both are online.

### 11.5 Moving across spaces
- Moving a node into a shared subtree re-tags it (and its subtree) into that
  space.
- Moving it out deletes it for the other members (after a confirmation that
  says so).

## 12. Milestones

The UI is made fully usable on one device first (M1–M6); sync comes after
(M7). Everything is still written through the change log from day one
(§7), so sync can be switched on without reworking the data layer.

| # | Milestone | Done when… |
|---|-----------|------------|
| M0 | Project skeleton | The Flutter app builds and runs on Windows and an Android phone; Drift is set up; gen-l10n is wired up; the user identity key is created on first run; CI runs tests |
| M1 | Tree + notes | Create, nest, reorder and move nodes; markdown notes; child views (panels, checklist, steps); placements; linking ancestor notes; Archive and Trash; works offline on one device |
| M2 | Values, tags + search | Values with statements and inheritance; personal tags with inline `#tags`; FTS5 search with the filters that exist so far. **Carried over from M1:** collapsing breadcrumbs, zooming the tree, Peek |
| M3 | Attachments + markup | Capture or import (picker, drag and drop, paste, camera), hash store, viewer, drawing overlay, text highlights, open-in, export with markup; linking ancestor attachments; file search. *Android share-sheet intake moves to M6 with quick capture.* |
| M4 | Calendar + routines | RRULE expansion, recurring subtrees, calendar views (day/week/month, click to add), occurrence completions, time zones on repeats, reminders, opt-in .ics export. *Skip/move one occurrence: not built.* |
| M5 | Time + reports | Estimates, timers (bar, tray, mini window, Android notification), focus mode, manual entries, roll-ups, recursive progress with override, review page with Markdown export |
| M6 | Motivation + friction | **Today view (built v0.17: home screen, fills itself, picks, reorder, carry-over, pick one for me)**; next: time blocks; quick-capture (hotkey, widget, share sheet), context resume, QR place tags |
| M6.5 | UI/UX + lock-in review | Every screen walked through on Windows and a phone, findings decided and fixed (§14.1); everything sync locks in reviewed and settled (§14.2); code-health items done or scheduled (§14.3). Screenshots of every screen once the direction is clear |
| M7 | LAN sync | Pairing (code confirmed on both devices + optional PIN); mDNS; HLC change log; field-level merge; version handshake and passing along unknown ops; attachment blob sync; running timers sync; phone ⇄ PC sync verified with a two-instance test harness. **Rules to settle first:** two moves on different devices that together form a cycle (A under B, B under A); the same pair added twice in a set-like table (`node_tags`, `node_values`, `links`, whose unique index would reject the second row on apply) |
| M8 | Polish + accessibility | Backups, conflict-copy UI, performance with 10k+ nodes. **Accessibility pass:** keyboard tree controls (§6.1); screen-reader move actions on tree and Items rows; labels, focus order and traversal checked with Narrator and TalkBack; text scaling to 200% without clipping; contrast to WCAG 2.1 AA in light and dark; touch targets of at least 48 dp |
| Next | Sharing | Encrypted relay, send / share / merge, assignees in the UI, contact labels |
| After | iOS, push | Plus streaks, board/table/gallery views, geofence/Wi-Fi/Bluetooth triggers, Google Calendar, SQLCipher |

## 13. Open questions

| ID | Question | Current leaning |
|----|----------|-----------------|
| Q-A | Merge simultaneous note edits with a CRDT (e.g. Yjs-style) instead of keeping conflicted copies? | Not in v1 (`body_format` leaves room); revisit with sharing |
| Q-B | Should text-doc markup be highlights only, or also freehand drawing over a rendered page? | Highlights only |
| Q-C | Should "done" tasks stay in the tree, or move to an archive view after N days? | See Q-H |
| Q-E | Should the Today view allow time-blocking (dragging tasks onto the calendar)? | Later (Timeline view) |
| Q-F | Exact markdown package choice | ✅ `flutter_markdown_plus` (v0.7) |
| Q-G | Restoring one child from Trash whose parent is also in Trash: where does it go? | Restore it under the nearest live ancestor (or as top-level) and say so |
| Q-H | Should done items be auto-archived after 7 days? | Yes, with a setting to turn it off |
| Q-I | Should time tracked on a **shared** task be visible to the other members? | No by default; opt in per space |
| Q-J | Offer an offline recovery phrase for the user identity key? | Yes, optional, in the sharing release |
| Q-K | Merge rules when a sent node's space and the larger shared space have different members | Merge only if the larger space includes all members; otherwise keep a nested space |
| Q-L | Should a recurring parent auto-complete when all children are done for that occurrence? | ✅ Yes (v0.13); for an exclusive set, when its one pick is done |
| Q-M | When a shared item's title or text contains `#work`, does it become a tag for the other members too? | Yes, each member's app reads it into **their own** personal tag (they see the word anyway, and `#` in text is a deliberate act); picker tags stay private. Removing the word removes it for everyone. Decide with sharing |

*Resolved: Q-D (goal progress comes from children, with a manual override;
see §6.16).*

---

## 14. Review pass (M6.5)

Before LAN sync (M7). Once two devices exchange changes, table and column
names, enum values and what syncs become hard to change (additive-only,
§7.5), and the UI's choices start to live in people's data. So everything
gets one deliberate look first.

**How it runs**
1. **Elliott drives** the UX walk-through, using the app on Windows and a
   phone, and reports what feels wrong or unclear. Claude logs each one in
   §14.1, proposes a fix, and makes it once it's decided.
2. **Claude drafts** the lock-in (§14.2) and code-health (§14.3) findings
   from the code; each gets a decision before M7.
3. **Screenshots later:** once opinions and intent are clearer, every
   screen is rendered at phone and desktop sizes with sample data for a
   final consistency check.

Each finding has an id, the issue, a proposal, the decision and its state
(open · decided · done · won't do).

### 14.1 UX walk-through
*Filled in as Elliott uses the app.* Screens to cover: Today, tree
(search, filters, zoom, drag), item page (title row, chips, description,
Items and child views, notes column, files, peek), note page, file page
and markup, Calendar (day/week/month, day list, filters), Review, Values,
Tags, Archive/Trash, date & time dialog, timer bar and mini window, phone
navigation (bottom bar, pages, sheets).

| ID | Screen | Issue | Proposal | Decision | State |
|----|--------|-------|----------|----------|-------|
| U1 | | | | | open |

### 14.2 Lock-in review (draft)
What M7 makes hard to change, and what needs a decision before it.

| ID | Area | Issue | Proposal | State |
|----|------|-------|----------|-------|
| L1 | Set-like rows | Two devices adding the same pair create two rows with different ids: `links` has a unique index among live rows, so applying the second would fail; `node_tags`, `node_values`, `placements`, `reminders` would hold duplicates. | Derive the row id from its pair (e.g. a hash of node + target), so both devices write the *same* row and merging is field-level as usual; re-adding after removal flips `deleted`. Drop the unique index. | open |
| L2 | One-per-node rows | `node_user_prefs` (one row per node) and `user_settings` (one row per key) can likewise get two rows if two devices create them before syncing. | Same: id derived from node id / key. | open |
| L3 | Tags by name | Two devices can each create `#work` before syncing: two tags with one name. | Derive a tag's id from its normalised name within the space (then they're the same row), or merge same-named tags on apply (move uses, tombstone one). | open |
| L4 | Moves | Two moves on different devices can form a cycle (A under B, B under A). | On apply, if a cycle appears, the move with the older HLC is undone (§5.3 already says so); a test harness case for it. | open |
| L5 | Running timer | "One running timer per user" can break when two devices start one before syncing. | On apply, keep the newest running entry; end the other at the newer one's start. | open |
| L6 | Today rows | Two devices ordering or hiding the same item on the same day write separate rows. | Id from date + node (as L1). | open |
| L7 | Enum values | Stored by name; renaming one later breaks other devices. Current names include `textLabel`, `timeLogged`, `dueToday`-style camelCase. | Freeze the names as they are (or rename now, while data can still be wiped), and list them in §5 as fixed. | open |
| L8 | Shared vs personal | Check each table and column against §5.0 once more: e.g. `progress_override` and `estimate_minutes` are shared (on the node), `reminders`, `time_entries`, `today_entries`, `activity`, `user_settings` personal; tag favourites/colour live on personal tags. | Confirm or move before M7. | open |
| L9 | Activity | Add-only rows grow forever and sync to every device. | Keep, but exclude from compaction (as §7.4 says) and consider a per-row size check (title snapshots only). | open |
| L10 | Local-only state | Paused timer, notes-column open, filters, zoom, peek pin are per device and never sync. | Confirm that's wanted (pause especially: pausing on the PC isn't seen on the phone). | open |
| L11 | Migrations | Until now local data could be wiped; from the first real sync, every schema change needs a tested migration. | From M7 on, migrations are kept; the migration test already covers every version. | open |

### 14.3 Code health (draft)

| ID | Area | Issue | Proposal | State |
|----|------|-------|----------|-------|
| C1 | `node_repository.dart` | ~1,550 lines: nodes, moves, placements, links, archive/trash, occurrences, progress, plus wiring for the other repositories. | Split by concern (placements, links, lifecycle, occurrences) into part files or small classes behind the same `NodeRepository` API. | open |
| C2 | `calendar_page.dart` | ~1,200 lines: page, filter bar, quick-add, day list, time grid, month grid. | One file per view; shared entry chip widget. | open |
| C3 | `widget_test.dart` | ~2,500 lines, 51 tests in one file with shared helpers. | Move helpers to `test/support/app_harness.dart`; split tests by area (tree, item, calendar, time, today…). | open |
| C4 | "Refresh" queries | Several live views re-run a whole computation on any change to broad tables (`SELECT 1 AS …` triggers). Fine now; slow with 10k+ items. | Note for the M8 performance pass; measure first. | open |
| C5 | Repeated UI patterns | Confirm dialogs, colour pickers, "summary chip + menu" filters and item pickers are written several times. | Extract shared widgets (confirm dialog, colour row, filter-menu chip, item picker). | open |
| C6 | Platform code in tests | Notifications, tray and window code are switched off in widget tests by flags. | Put them behind small interfaces with fakes, so tests can check that a timer shows in the tray or a reminder is scheduled. | open |
| C7 | Android | Builds, but nothing has run on a phone (camera, notifications, permissions, layouts). | Run on a device early in the UX walk-through. | open |

## Appendix A: Sharing research notes
- Peer-to-peer was considered for sharing and rejected for now. It still
  needs signaling, STUN and TURN servers; it fails when either phone is
  offline; and NAT traversal on mobile networks is unreliable.
- An encrypted mailbox relay costs fractions of a cent per user per month.
  The main cost driver is attachments, so plan quotas around storage.

## Appendix B: Hard-to-retrofit checklist
These are in the v1 schema even though v1 barely uses them:
- [x] `space_id` on every synced row
- [x] `users` + `created_by` / `updated_by` + op `author_user_id`
- [x] Separation of shared and personal rows (§5.0)
- [x] `placements` (one real parent; extra appearances are personal)
- [x] `node_assignees`, plus `completed_by` on nodes and occurrences
- [x] `body_format` for a future note CRDT
- [x] Protocol and schema versioning, and passing along unknown ops
- [x] Keyed-hash blob naming for the relay
- [x] User identity key that signs device keys
- [x] `activity` table for durable reports
- [x] UI strings in ARB files
