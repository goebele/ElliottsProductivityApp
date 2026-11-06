# Elliott's Productivity App — Design Doc

**Status:** Draft v0.3 · **Last updated:** 2026-11-05 · **Owners:** Elliott, Claude

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
| D5 | Item model | ✅ **One `Node` type with a `type` field.** Any node can nest under any other. |
| D6 | Values | ✅ **Inherited down the tree.** You can add extra values on any node. |
| D7 | Sync topology | ✅ **Symmetric.** Any device can sync with any other. The PC is usually on, so it acts as the practical hub. |
| D8 | Markup | ✅ **Separate overlay layer.** The original file is never changed. |
| D9 | Attachment storage | ✅ **App-managed folder**, files named by content hash |
| D10 | Calendar scope v1 | ✅ **The app's own calendar, plus .ics export** |
| D11 | Routines | ✅ **One routine node holds the RRULE, plus a completion record per occurrence.** Its children repeat with it (D24). |
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
| D24 | Recurring subtrees | ✅ **When a recurring node repeats, its children repeat with it.** Completion is recorded per occurrence. |
| D25 | Send, then share more | ✅ **One canonical copy.** A sent node moves into its real place when the bigger tree is shared. Your old filing becomes a **placement** (shortcut). |
| D26 | Multiple parents | ✅ **One real parent, plus personal placements** (not a true multi-parent graph) |
| D27 | Child views v1 | ✅ **Detail panels (default), checklist, steps**, plus the tree pane. Board, table and gallery come later. |
| D28 | Tags | ✅ **Explicit**, with optional "include children" in search. Tags are **shared** or **private**. |
| D29 | Time | ✅ **Estimates, timers, time tracking**, rolled up the tree |
| D30 | Reports | ✅ **"What I did this week"** at minimum, plus progress on goals and projects |
| D31 | Location | ✅ **QR place tags only** in v1. No extra hardware. |
| D32 | Pairing | ✅ **Confirm on both devices** (matching code), plus an **optional pairing PIN** stored on each device |
| D33 | Versioning | ✅ **Protocol and schema versions in sync.** Only additive schema changes; data a device doesn't recognize is kept and passed along, never dropped. |
| D34 | Remote blob naming | ✅ **Encrypt each blob separately and name it with a keyed hash.** No bundling everything into one archive. |
| D35 | UI strings | ✅ **Kept out of code from day one** (Flutter `gen-l10n` with ARB files) |

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
| Markdown rendering / editing | a maintained markdown widget package, plus a plain `TextField` with a formatting toolbar |
| Notifications | `flutter_local_notifications` |
| Global hotkey (Windows) | `hotkey_manager` |
| System tray (Windows) | `tray_manager` |
| Share-sheet intake (Android) | `receive_sharing_intent` or equivalent |
| Open file in another app | `open_filex` / `url_launcher` |
| Image capture / pick | `image_picker` |
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
  children, shared tags, assignees and attachments. Once shared, every member
  sees it.
- **Personal data** lives in **your personal space** and points at a node:
  value links, private tags, Today entries, context resume, placements,
  time entries, contact labels, child-view overrides and activity history. No
  one else ever receives it, even when the node it points at is shared.

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

**`nodes`** — every goal, project, task, list, routine, event, note and idea.

| Column | Notes |
|--------|-------|
| `parent_id` | The single **real** parent. `NULL` = top-level. (Extra appearances are placements, below.) |
| `sort_key` | Fractional index string for order among siblings (e.g. `"a0"`, `"a0V"`) |
| `type` | `goal · project · task · list · routine · event · note · idea · inbox_item` |
| `title` | Short text |
| `body_md` | Markdown note (may be empty) |
| `body_format` | `md_lww` in v1. Leaves room for a CRDT note format later. |
| `child_view` | `panels · checklist · steps` (default `panels`; `list` nodes default to `checklist`). Personal overrides go in `node_user_prefs`. |
| `status` | `open · active · waiting · done · dropped` |
| `completed_by` | The user who completed it (non-recurring nodes) |
| `priority` | Optional 1–4 |
| `estimate_minutes` | Optional time estimate |
| `start_at` / `end_at` | Events and time blocks (UTC + timezone ID) |
| `due_at` | Deadline |
| `rrule` | RRULE string, for routines and recurring events. All descendants repeat with it (D24). |
| `completed_at` | Set when status becomes `done` |
| `lifecycle` | `live · archived · trashed` (separate from `status`; see [§6.11](#611-archive-and-trash)) |
| `lifecycle_at` | When it was archived or trashed (starts the 30-day Trash timer) |
| `lifecycle_root_id` | The node the user actually archived or trashed. Descendants point to it, so restoring brings back the whole subtree that went together. |

> **Why one table?** A task can be promoted to a project, or a note to a goal,
> just by changing `type`. Tree queries, links and search work the same for
> everything.

**`node_assignees`** *(shared)* — `node_id, user_id`. **No rows means anyone
can do it** (the default).

**`placements`** *(personal)* — extra places a node appears **for you only**.
`node_id, parent_node_id (NULL = top level), sort_key`
Used for (a) putting a node you received somewhere in your own tree, and
(b) shortcuts, e.g. "Buy paint" also showing under your "Errands". See
[§6.12](#612-placements-one-node-several-places).

**`core_values`** *(personal)* — `name, statement (markdown), color, icon, sort_key`

**`node_values`** *(personal)* — explicit value links: `node_id, value_id`.
A node's **effective values** are its own explicit values plus all of its
ancestors' values. For you, that includes ancestors reached through your
placements. They're computed with a recursive CTE and cached in a local
index table.

**`tags`** — `name, color, kind (normal | place)`. A tag in a shared space is
shared; a tag in your personal space is private.
**`node_tags`** — `node_id, tag_id`. The row lives in the same space as the tag.

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
- `stroke`: a list of points normalized to 0–1 of the image size, plus width.
- `highlight` (text docs): character range `{start, end}`.
- `text_label`: position plus a short string.

**`occurrence_completions`** *(shared)* — completions for recurring nodes
**and their descendants**.
`node_id, occurrence_date, completed_by, completed_at, note`, unique per
`(node_id, occurrence_date)`. `occurrence_date` is the occurrence of the
nearest recurring ancestor (or of the node itself).

**`time_entries`** *(personal)* — `node_id, started_at, ended_at (NULL = timer running), source (timer | manual), note`

**`today_entries`** *(personal)* — `date, node_id, sort_key`

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
- `fts_index`: the FTS5 virtual table.
- `ui_prefs`: window layout, theme, last tab, language.

## 6. Feature design

### 6.1 Tree and node detail
- **Tree pane:** expand and collapse, drag to reorder or reparent, keyboard
  first on Windows (Tab to indent, Shift+Tab to outdent, Enter for a new
  sibling).
- **Breadcrumbs** and **zoom** let you focus on any subtree as if it were the
  root.
- **Tree context in every node view** (see [§6.1.1](#611-tree-context-navigate--peek)).
- **Node detail:** title, type, status, assignees, tags, dates, estimate and
  time spent, values (explicit and inherited, shown separately), progress,
  markdown note, links, attachments, and the children (shown in the node's
  [child view](#613-child-views)).
- **Layout:** two panes (tree + detail) on Windows; on Android, drill-down
  navigation.

#### 6.1.1 Tree context: navigate + peek
Every displayed node knows its whole line of ancestors and its children.
Example: working on *Test New Feature*, you can reach *Implement Feature*
(parent), *Project* (grandparent) and *Test Case 1* (child) in one click.

- **Ancestors:** full breadcrumbs from the top-level project down to the
  current node. Each one is clickable. On narrow Android screens, middle
  levels collapse to "…" and tapping expands them. If you opened the node
  through a placement, the breadcrumb also shows "via Errands".
- **Children:** shown in the node's child view, and you can expand a child to
  see its own children.
- **Navigate:** clicking an ancestor or child opens it. **Back/forward
  history** works with mouse buttons and `Alt+←/→` on Windows, and the back
  gesture on Android.
- **Peek:** look at another node's context without leaving the current one.
  - Windows: hover for a peek card, or click a peek icon to pin a **side
    panel**.
  - Android: long-press for a bottom sheet.
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
  different values of their own.

### 6.3 Notes, links and ideas
- Markdown subset: headings, bold and italic, lists, checkboxes, code, links,
  and `[[node links]]`.
- Editor: a plain-text editor with a toolbar and a live preview toggle.
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
  RRULE set.
- **Reminders:** local notifications, scheduled for the next N days and
  rescheduled when the app opens or a sync finishes. Android needs the
  exact-alarm permission. No push in v1.
- **.ics export:** export a file, and optionally publish a read-only feed from
  the PC on the LAN.
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

### 6.8 Quick-capture inbox (low friction)
- **Windows:** a global hotkey (default `Ctrl+Alt+Space`) opens a small
  always-on-top capture box. Enter saves the item and dismisses the box.
- **Android:** a home-screen widget, a quick settings tile, and the share
  sheet ("Share to app" creates an inbox item, with any shared image as an
  attachment).
- Inbox items are `type = inbox_item` with no parent. The Inbox view lets you
  sort each one into the tree with a type-ahead parent picker.
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
- **When creating a child:** the new-child form has a "Link from above"
  section, which lists the ancestors' notes and attachments with checkboxes.
- **Later, from the child:** in the child's detail, **Link from ancestors…**
  opens the same picker.
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
  23 items") and any items outside it that link into it ("Used by 3 items
  elsewhere").
- **Purging:** after 30 days in Trash (or **Empty Trash**), rows become
  tombstones. Attachment files are freed once no live row references their
  hash on any device. **`activity` rows are kept**, so reports still show the
  work.
- Archive and Trash state are ordinary synced fields, so they apply on every
  device.

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

### 6.13 Child views
How a node **shows its children**. Set on the node (`child_view`), and you can
override it just for yourself.

| View | Looks like | Good for |
|------|-----------|----------|
| **Panels** *(default)* | One card per child, showing status, due date, assignees, tags, estimate vs. time spent, progress bar, note preview and child count | Projects, goals, anything with substance |
| **Checklist** | A plain list with inline checkboxes. Children that have their own children show a small "›" to drill in. | Shopping lists, packing lists (default for `list` nodes) |
| **Steps** | A numbered sequence. **Only the next unfinished step is highlighted**; the rest are dimmed. | Procedures and "just do the next thing" (ADHD-friendly) |
| *Later:* Board | Kanban columns by status | Workflows |
| *Later:* Table | Rows with columns (due, assignee, estimate, tags) | Planning and triage |
| *Later:* Gallery | Image cards | Recipes, photo lists |
| *Later:* Timeline | Children placed on a calendar | Time-blocking |

Every view can still nest without limit. The view only changes how one level
is drawn, and you can always drill into a child.

### 6.14 Tags
- Create tags anywhere with `#name` in a title or note, or from the tag picker.
- **Shared tags** live in the node's space. **Private tags** live in your
  personal space, so you can tag a shared task `#annoying` without anyone
  seeing it.
- Tags are **explicit** (shown only where you put them). Search can add
  "include children".
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

| # | Milestone | Done when… |
|---|-----------|------------|
| M0 | Project skeleton | The Flutter app builds and runs on Windows and an Android phone; Drift is set up; gen-l10n is wired up; the user identity key is created on first run; CI runs tests |
| M1 | Tree + notes | Create, nest, reorder and move nodes; markdown notes; child views (panels, checklist, steps); placements; linking ancestor notes; Archive and Trash; works offline on one device |
| M2 | Values, tags + search | Values with statements and inheritance; shared and private tags; FTS5 search with every filter |
| M3 | LAN sync | Pairing (code confirmed on both devices + optional PIN); mDNS; HLC change log; field-level merge; version handshake and passing along unknown ops; phone ⇄ PC sync verified with a two-instance test harness |
| M4 | Attachments + markup | Capture or import, hash store, blob sync, viewer, drawing overlay, open-in; linking ancestor attachments |
| M5 | Calendar + routines | RRULE expansion, recurring subtrees, calendar views, occurrence completions, reminders, .ics export |
| M6 | Time + reports | Estimates, timers (synced), manual entries, roll-ups, progress bars, weekly review |
| M7 | Motivation + friction | Today view, quick-capture (hotkey, widget, share sheet), context resume, QR place tags |
| M8 | Polish | Backups, conflict-copy UI, performance with 10k+ nodes |
| Next | Sharing | Encrypted relay, send / share / merge, assignees in the UI, contact labels |
| After | iOS, push | Plus streaks, board/table/gallery views, geofence/Wi-Fi/Bluetooth triggers, Google Calendar, SQLCipher |

## 13. Open questions

| ID | Question | Current leaning |
|----|----------|-----------------|
| Q-A | Merge simultaneous note edits with a CRDT (e.g. Yjs-style) instead of keeping conflicted copies? | Not in v1 (`body_format` leaves room); revisit with sharing |
| Q-B | Should text-doc markup be highlights only, or also freehand drawing over a rendered page? | Highlights only |
| Q-C | Should "done" tasks stay in the tree, or move to an archive view after N days? | See Q-H |
| Q-E | Should the Today view allow time-blocking (dragging tasks onto the calendar)? | Later (Timeline view) |
| Q-F | Exact markdown package choice | Decide in M1 after a short spike |
| Q-G | Restoring one child from Trash whose parent is also in Trash: where does it go? | Restore it under the nearest live ancestor (or as top-level) and say so |
| Q-H | Should done items be auto-archived after 7 days? | Yes, with a setting to turn it off |
| Q-I | Should time tracked on a **shared** task be visible to the other members? | No by default; opt in per space |
| Q-J | Offer an offline recovery phrase for the user identity key? | Yes, optional, in the sharing release |
| Q-K | Merge rules when a sent node's space and the larger shared space have different members | Merge only if the larger space includes all members; otherwise keep a nested space |
| Q-L | Should a recurring parent auto-complete when all children are done for that occurrence? | Yes (as specified in §6.5); confirm in M5 |

*Resolved: Q-D (goal progress comes from children, with a manual override;
see §6.16).*

---

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
