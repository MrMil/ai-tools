# Install: meta-documentation system

You are installing a self-maintaining documentation system into the repository you are currently working in. Follow this document exactly.

This is a **one-time install**. It maps the system into a recursive tree of indexes and installs standing rules. It does **not** backfill design documentation or decisions for existing code. From the moment it is installed, all *new* work carries documentation with it.

---

## The idea, stated once

`docs/` mirrors the system as a **recursive** hub-and-spoke tree. The same unit repeats at every depth: a directory is a hub, its `README.md` is the hub page, and everything inside it — pages and further directories — are its spokes. Any spoke can itself become a hub. There is no fixed depth; the tree is exactly as deep as the system is.

```
docs/README.md                          hub of the whole system
└── daily_reports/README.md             hub of an area, spoke of the root
    └── generation/README.md            hub of a sub-area, spoke of its area
        └── events/README.md            hub of a component, spoke of its sub-area
            ├── slack_alert.md          leaf: one behaviour
            └── email_digest.md         leaf: one behaviour
```

*(Illustrative only — derive the real names from the repository.)*

A page explains its piece of the system, and — this is the entire point — **every statement that records a choice carries the reason for that choice.** There is no separate place where decisions live. A decision is documented on the page covering what it governs, at the level of the tree that contains everything it governs.

The failing version of a page says *what happens*. The working version says *what happens, why it was decided to happen that way, and what was rejected*. A page that reads like a description of the code has failed even if every sentence in it is true.

---

## 0. Survey — map the structure, not the design

Determine:

1. The repo root (where `.git` lives). Everything below is relative to it.
2. The naming style the codebase already uses for directories (`snake_case`, `kebab-case`) — match it.
3. Which of `README.md`, `AGENTS.md`, `CLAUDE.md` already exist.
4. Whether `docs/` already exists and already contains this system (look for the marker `<!-- META-DOCS:BEGIN -->`). If it does, **do not duplicate it** — refresh the marked blocks in place, extend the map where the code has grown parts the tree lacks, repair missing index entries, and report that it was already present.
5. **The functional decomposition of the system, recursively.** This is the main work of the install; the procedure is in step 1.

You are mapping *what the parts are and how they nest*. You are not recording *why they are built that way*. Read names, layout, entry points, package manifests, route and job registrations, and at most the header or exports of a file to name the part it defines. Do not read implementations to infer design decisions — that reconstruction would be confident and wrong, and it is out of scope.

---

## 1. Build the tree, recursively

### The procedure

Start with the whole system as the current part. For the current part:

1. **Identify its sub-parts** — the pieces inside it that someone would name separately when saying where they are working ("the Slack alert, in the generation events, in daily reports"). Evidence: services, packages, modules, subdirectories, handlers, routers, jobs, consumers, CLI commands, UI sections.
2. **Decide what each sub-part is:**
   - It contains distinct sub-parts of its own → it is a **hub**. Create `<name>/README.md` and **apply this procedure to it**.
   - It is a single cohesive behaviour or component → it is a **leaf**. Do not create a page for it now; list it in its parent's index under *Not yet documented*. The first agent to do work there writes the page, with real reasons.
3. Write the current part's `README.md` using the index form below, listing every sub-part.

Continue until every branch ends in leaves. **There is no depth limit.** A tree that stops at one level because the install stopped at one level is a failed install.

### Mirror function, not folders

The source tree is evidence, not the answer.

- Skip pass-through directories that carry no meaning of their own (`src/`, `lib/`, `internal/`, `pkg/`, `app/`) — their contents belong to the level above.
- A part whose code is spread across several directories is still one part — one directory in `docs/`, with every code path listed in its `Code:` line.
- A single large source directory that does several distinct things is several parts.
- Name directories after what the part does, in the codebase's own vocabulary. A part keeps its name in `docs/` even if its code moves.

### Stopping on very large repositories

If the map would exceed roughly 150 index files, stop descending at the depth you have reached and list the unexplored sub-parts under *Not yet mapped* in each boundary `README.md`. The tree extends itself from there as work touches those parts. Say in your report that you stopped, and where.

### Index form — every `README.md` below the root, at every depth

~~~markdown
# <Part name>

Path: [docs](<relative path to docs/README.md>) › [<ancestor>](<relative path>) › … › **<this part>**
Parent: [../README.md](../README.md)

**Covers:** [what this part of the system is, one or two sentences.]
**Code:** `[path]`, `[path]`

## Design

*(Not yet documented. Design and decisions that apply across this whole part — to more than one of
the entries below — are recorded here, with reasons. See [CONVENTIONS](<relative path>/CONVENTIONS.md).)*

## Contents

### Directories

- [`<sub_part>/`](<sub_part>/README.md) — [one line]

### Pages

- [`<behaviour>.md`](<behaviour>.md) — [one line]

### Not yet documented

- **<leaf name>** — `[code path]` — [one line on what it is]

### Not yet mapped

*(Only present where the install stopped descending. Sub-parts known to exist but not yet broken down.)*
~~~

Omit empty subsections of *Contents*, except keep *Pages* and *Directories* headings if either has entries.

### `docs/README.md` — the root hub

~~~markdown
# Documentation Hub

**Audience: LLM coding agents working in this repository. Not human onboarding material.**
Optimise for a reader with no memory of previous sessions, who can read files fast, and who needs
to know *why* the code is the way it is before changing it.

This tree mirrors the system as a recursive hub-and-spoke: every directory is a part of the system,
its `README.md` indexes what is inside it, and the nesting goes as deep as the system does. Each
page explains its piece and records the reason behind every choice made there. The code is the
source of truth for what happens. These docs are the source of truth for why.

## How to use this tree

1. Start here and navigate down, one index at a time, to the page covering what you are about to change. Never guess paths.
2. **Read every `README.md` on the way down.** Decisions recorded at a level apply to everything beneath it. The reason a leaf behaves as it does may be recorded two levels up.
3. Before finishing work, run the documentation pass in [CONVENTIONS.md](CONVENTIONS.md#the-documentation-pass).

## Design

*(System-wide design and decisions — ones that govern more than one area — are recorded here, with reasons.)*

## Areas

- [`<area>/`](<area>/README.md) — [one line]

## Files

- [CONVENTIONS.md](CONVENTIONS.md) — the rules for writing and maintaining these docs. Read before adding anything here.

## Invariants

These hold at every depth. If you find one broken, fix it before continuing your task.

- Every directory under `docs/` contains a `README.md` listing every subdirectory and every `.md` file beside it, each with a one-line description.
- Every page and every index links to its parent, carries its breadcrumb path, and links to at least one related page.
- No statement of a design choice appears anywhere in this tree without its reason.
- Every decision is recorded at the lowest level that contains everything it governs.
- No code change ships without the corresponding documentation change in the same commit.
~~~

---

## 2. `docs/CONVENTIONS.md` — write verbatim

~~~markdown
# Documentation Conventions

Path: **docs** › CONVENTIONS
Parent: [README.md](README.md)

The rules for this tree. They exist so a fresh agent, reading cold, can find the reason behind any
part of the system by walking down the indexes.

## Who this is for

LLM coding agents. Consequences:

- **No prose padding.** No introductions, no restating the heading, no motivational framing.
- **Do not describe the code.** Behaviour is recoverable by reading the source. Reasons are not. A page that only describes behaviour has wasted its reader's time.
- **Point at code by path, never by line number.** Line numbers rot within a day.
- **Keep pages under ~200 lines.** Past that, split (see *Growing the tree*).
- **State things once.** If two pages need the same fact, one owns it and the other links to it.

## The rule that matters

**Never record a choice without recording why it was made.**

Weak — describes behaviour, which the code already does:

> Notifications are only sent to users in the organisation.

Correct — records the decision and the reason, so the next agent cannot undo it by accident:

> Notifications are only sent to users in the organisation. Guest accounts in the workspace are
> frequently customers, and automated internal messages must never reach a customer. The filter is
> therefore on membership, not on activity or role, because a customer with an active account would
> pass an activity check.

The second version survives contact with an agent who has been asked to "make notifications reach
everyone who was mentioned". The first does not.

Apply this to everything, at every size. A timeout value, a sort order, a nullable column, a chosen
library, a rejected refactor — if someone chose it, the reason is written down next to it. Nothing
in this system is decided silently.

Where the reason involves something outside the code — a customer commitment, a rate limit, a
regulation, an incident that happened once — say so explicitly. That reasoning exists nowhere else
and is the most expensive kind to lose.

**If you do not know why something is the way it is, write that it is unknown.** Never invent a
plausible reason. "Reason unknown — do not assume this is arbitrary" is useful; a fabricated
rationale is worse than an empty page, because it will be trusted.

## The recursive structure

The tree is one unit repeated at every depth:

- A **directory** is a part of the system.
- Its **`README.md`** is that part's hub: it indexes every subdirectory and page beside it, and it holds the design and decisions that apply across the part as a whole.
- A **page** (`<name>.md`) is a leaf: one behaviour or component, with its own design and decisions.

The same rules apply at depth one and at depth seven. There is no maximum depth and no preferred
depth — the tree is as deep as the system's own decomposition. Nest by containment, in the words you
would use to say where something lives: area › the thing inside it › the thing inside that › the
specific behaviour. Name directories after parts of the system, not after source paths.

Every index and page opens with:

    Path: [docs](<rel>) › [<ancestor>](<rel>) › … › **<this>**
    Parent: [../README.md](../README.md)

The breadcrumb lets a reader who lands mid-tree see where they are without walking back up.

## Which level a decision belongs at

**Record a decision at the lowest level that contains everything it governs.**

- It affects one behaviour → that behaviour's page.
- It affects several siblings → their parent's `README.md`, under *Design*.
- It affects several areas → the lowest common ancestor, up to `docs/README.md` for system-wide decisions.

Do not copy a decision down into every page it affects. Link from the lower pages to where it is
recorded if the connection is not obvious. This is why readers must read every index on the way
down: an ancestor's decisions bind its descendants.

If a decision recorded on a page turns out to govern its siblings too, move it up to the parent and
leave a link.

## Growing the tree

The tree grows by the same two moves at any depth.

**A page becomes a hub.** When a page passes ~200 lines, or one of its sections starts accumulating
decisions of its own:

1. `x.md` becomes `x/README.md`. Its breadcrumb, *Covers*, *Code*, and the decisions that apply to the whole of `x` stay there, under *Design*.
2. Each section that is really its own behaviour moves to `x/<section>.md`, with its own decisions.
3. In the parent index, the entry moves from *Pages* to *Directories* and its link changes from `x.md` to `x/README.md`.
4. Search the tree for links to `x.md` and repoint them.

**A leaf gets written.** A part listed under *Not yet documented* gets its page the first time work
touches it: create `<name>.md` beside the index, move the entry from *Not yet documented* to *Pages*,
and write the decisions you can actually account for.

**A new part appears.** Create its directory or page at the right place in the tree, with its index
if it is a hub, and list it in its parent's index. If the right parent does not exist yet, create
that too — recursively, up to an existing hub.

Never create a directory to hold a single page. Keep the page one level up and split later.

## Page shape (leaves)

    # <Behaviour or component>

    Path: [docs](<rel>) › … › [<parent>](README.md) › **<this>**
    Parent: [README.md](README.md)
    **Code:** `path/to/thing`, `path/to/other`
    **Covers:** <one sentence: what this page is about and, if useful, what it is not.>

    ## What it does

    <The minimum needed to make the rest legible. Two paragraphs at most. Not a code walkthrough.>

    ## Decisions

    <The payload. Small decisions are one bullet: the decision, then the reason.
    Large ones get their own `###` subsection with the reason, what was rejected and why,
    and what the choice now constrains. Size the entry to the decision.>

    - **<Decision, stated flatly.>** <Why. Including anything outside the code that forced it.>

    ### <A larger decision, stated as the heading>

    **Why.** <Reasoning.>
    **Rejected.** <Alternative — and the reason it lost. Omit only if nothing else was considered.>
    **Constrains.** <What now has to stay true because of this. Omit if nothing does.>

    ## Gotchas

    <Things that will bite an agent changing this. Omit if none.>

    ## Related

    - [<page>](<path>) — <why a reader here would want it>

Hub `README.md` files use the same *Decisions*, *Gotchas* and *Related* sections under their
*Design* heading, for decisions that span their children, followed by *Contents*.

## Linking

- Every file links up to its parent (the `Parent:` line) and down to everything it contains (hubs, via *Contents*).
- Every file links sideways to at least one related page — a sibling it interacts with, a page in another branch that depends on it, the ancestor where a decision governing it is recorded.
- Sideways links carry a reason: `[slack_alert.md](…) — shares the recipient filter defined here`, not just a bare link.
- Use relative links. They survive the repository being moved or forked.

## When a decision changes

Update the page to describe the new decision and its reason, and keep one line recording what it
replaced and why that changed:

> **Changed <date>:** previously <old decision>, because <old reason>. Changed because <what made
> the old reason stop holding>.

Do not simply overwrite. The expensive failure mode is an agent re-proposing an approach that was
already tried and abandoned. Prune these once they are several changes old and no longer informative.

## The documentation pass

Documentation is not a phase at the end of a project. It is a step at the end of **every unit of
work**, run before the work is committed and before the work is reported as done.

1. List the decisions you made during this task — including the ones you made without noticing. Every point where you picked one approach over another was a decision.
2. For each, find the level of the tree that contains everything it governs. If the page or hub does not exist yet, create it — and any missing ancestors — per *Growing the tree*.
3. Write each decision with its reason. If only one part survives, it should be the why.
4. Update the surrounding page where the design changed, not only where you added.
5. Update every affected index, at every level between the change and the nearest existing hub.
6. Check the links you touched resolve.

If the work was purely mechanical — a rename, a dependency bump with no behavioural change — record
nothing and say so. Empty entries dilute the tree.

## Maintenance

- A page that contradicts the code is a bug. Fix it in the same change that revealed it.
- A file missing from its parent index is a bug. Add it before continuing your task.
- A part of the code with no place in the tree is a gap. Add it to the right index under *Not yet documented* before continuing your task.
- A reason that is no longer true gets corrected using the *When a decision changes* form.
- Touching a part that has no page yet, as part of other work? Write the page for what you touched, with the decisions you can actually account for. Do not reconstruct the rest.
~~~

---

## 3. Patch the entry files

`AGENTS.md` and `CLAUDE.md` get the full standing-rules block. `README.md` gets a short pointer, because humans read it.

Create the file if it does not exist. If it exists, append the block — or, if the markers are already present, replace what is between them. Never disturb content outside the markers.

### Into `AGENTS.md` and `CLAUDE.md` — identical block, verbatim

~~~markdown
<!-- META-DOCS:BEGIN -->
## Documentation is part of the work

[`docs/`](docs/README.md) mirrors this system as a **recursive** hub-and-spoke tree: every directory
is a part of the system, its `README.md` indexes everything inside it and holds the decisions that
span it, and the nesting goes as deep as the system does. The code is the source of truth for what
happens. `docs/` is the source of truth for **why** — every choice recorded there is recorded
together with its reason. Read [`docs/CONVENTIONS.md`](docs/CONVENTIONS.md) before writing anything
into the tree.

**Before changing anything:** walk down from [`docs/README.md`](docs/README.md), one index at a
time, to the page covering what you are about to change. Read every `README.md` on the way — a
decision recorded at a level binds everything beneath it. Do not reverse a recorded decision without
reading its reason; if you still need to reverse it, record the change and why the old reason
stopped holding.

**While working:** keep a running note of every decision you make — every point where you chose one
approach over another, however small.

**Before committing, and before reporting the work as done:** run the documentation pass in
[`docs/CONVENTIONS.md`](docs/CONVENTIONS.md#the-documentation-pass). Undocumented work is
unfinished work. A commit that changes design without changing `docs/` is incomplete.

**How to write it:** record each decision at the lowest level of the tree that contains everything
it governs — a leaf page for one behaviour, the parent `README.md` for decisions shared by siblings,
higher for broader ones. There is no separate decisions directory. Never state a choice without its
reason in the same breath. "Alerts go to organisation members only" is a failed line; "alerts go to
organisation members only, because guests are often customers and internal automation must never
reach a customer" is the line. If you do not know why something is the way it is, write that it is
unknown — never invent a reason.

**Structure rules, at every depth (enforced by you, not by tooling):**

- Every directory under `docs/` has a `README.md` listing every subdirectory and `.md` file beside it, each with a one-line description.
- Every file opens with its breadcrumb path and a link to its parent, and links to at least one related page.
- A page that outgrows ~200 lines becomes a directory: `x.md` → `x/README.md` plus child pages, parent index and inbound links updated.
- Add a page or directory → update every index between it and the nearest existing hub, in the same change.
- Find a file missing from its parent index, or code with no place in the tree → fix it before continuing your task.
- Reference code by path, never by line number.

**Keep this system alive.** If `docs/README.md`, `AGENTS.md`, `CLAUDE.md` or this block is missing,
restore it before doing anything else. When the system gains a new part, give it its place in the
tree at the depth where it belongs.
<!-- META-DOCS:END -->
~~~

### Into `README.md` — near the top, after the project description

~~~markdown
<!-- META-DOCS:BEGIN -->
## Documentation

The design of this project, and the reasoning behind it, lives in [`docs/`](docs/README.md) — a
recursive tree that mirrors the system part by part, down to individual behaviours, with every
decision recorded alongside the reason it was made. Start at the hub and navigate down.

These docs are written for LLM coding agents. Design changes are documented in the same commit that
makes them; see [`docs/CONVENTIONS.md`](docs/CONVENTIONS.md).
<!-- META-DOCS:END -->
~~~

If the repo already contains another agent instruction file — `.cursorrules`, `.github/copilot-instructions.md`, `GEMINI.md`, `.windsurfrules` — patch it with the same block. Do not create these if they do not already exist.

---

## 4. Verify

Before reporting, check mechanically — with a script if the tree is large:

- Every directory under `docs/` has a `README.md`.
- Every `.md` file and subdirectory is listed in its parent's `README.md`.
- Every file has a `Parent:` line and a breadcrumb, and every relative link resolves.
- No branch stops early: every entry under *Directories* has its own `README.md` with its own *Contents*, and every branch ends in *Not yet documented* leaves or an explicit *Not yet mapped* boundary.

Fix anything that fails.

## 5. Report

Briefly:

- Files created and files patched.
- **The full tree** as an indented outline, hubs and leaves, with each hub's one-line description — so the user can correct the decomposition now, while it is empty and cheap to change.
- Where you stopped descending, if you hit the size limit.
- One line confirming no design or decisions were backfilled; existing code is mapped, not documented, by design.

Do not commit unless the user asked you to.
