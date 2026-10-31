---
name: agent-wiki
description: Use when looking up or recording durable knowledge about a system you have investigated before - answering "what do we know about X", "did we figure out Y", "check the wiki", or before re-deriving a fact about a machine, service, or codebase that a previous session may have already answered. Also use after discovering a fact that stays true once the task ends.
---

# Agent wiki

A local markdown knowledge base of durable findings. Search it before deriving a
fact; write to it when you find one.

## The script

`~/.claude/skills/agent-wiki/wiki` — not on `$PATH`, so call it by that path.

Run `wiki path` first. It resolves the wiki root in this order: `$AGENT_WIKI_DIR`,
then `~/.config/agent-wiki/path`, then a shallow search of `$HOME` for a directory
containing `agent_wiki/INDEX.md`. If it exits non-zero the wiki is not on this
machine — say so and carry on without it.

## Looking something up

**Search first. Read whole files last.** A note's answer is typically 3-6% of its
bytes, so reading one to get one fact wastes ~95% of what you spend.

1. `wiki search <term>` — matching lines with file and line number. Often enough
   on its own.
2. `wiki digest` — every note's one-line summary. Cheaper than reading the index.
   Use when you do not know the vocabulary to search for.
3. `wiki show <name>` — the summary plus the `## Use` block of one note. Use when
   a search hit needs its surrounding context.
4. `Read` the whole file only when 1-3 leave the question open.

Prefer several cheap searches over one expensive read.

`wiki search` skips `raw/` and `log.md`. To search sources, run
`rg <term> "$(wiki path)/raw"`.

## Layout

- `INDEX.md` at the root: what each directory holds, and links to the shards.
- `<dir>/INDEX.md`: one line per note in that directory.
- `<dir>/<note>.md`: the notes.
- `log.md`: an append-only record of changes to the wiki.
- `raw/`: optional source material that notes cite. See below.

This file is the only schema. Do not repeat its rules in the wiki's `INDEX.md`.

## Writing a note

Write the note when you find the fact, not at the end of the session. Check
`wiki digest` first — if a note covers the topic, update it rather than adding a
second one.

Before you write, ask: **would a session that is not doing this task need this?**
If only this task needs it, it is work state: put it on the task's card, ticket or
PR, not in the wiki.

One file per topic, short kebab-case name, system prefix first so globs narrow
fast (`foo-auth-model.md`, not `auth-model-in-foo.md`). Name the note after the
system or mechanism, never after a customer, ticket, project phase or one-time
effort: `relay-magnite.md`, not `acme-magnite-ask.md`. A fact you found while
helping one customer goes in the system's note, with the customer's IDs as single
lines. Facts about a project you build go in that project's own docs; the wiki
keeps only what applies outside the project.

No story: no "The ask", timeline, Slack quotes or "what we tried" sections. Keep
a dead end only as a "not true" fact.

Use this skeleton. It exists so partial reads work:

```markdown
# <topic>

<One line. The whole answer, standalone, no pronouns referring elsewhere.>

## Use

<3-8 lines. The command, the path, the gotcha. What a reader acts on.>

## Details

<Everything else. Rarely read.>
```

Then add one line to the directory's `INDEX.md`: a link and a hook that lets a
reader decide whether to open the file without opening it. The hook holds no
dates, versions, PR states or other values that drift. When the note changes,
rewrite the hook; do not append to it.

Then append one line to the log:

```
wiki log <op> <note-name or topic>
```

`<op>` is one of `add`, `update`, `merge`, `remove`, `lint`, `raw`. The script
writes `## [YYYY-MM-DD] <op> | <title>`. `wiki log` with no arguments shows the
recent entries.

## When a new fact conflicts with an old one

Never overwrite silently. If the new fact is better evidence (newer, or checked
directly), replace the old line and say in the log entry what changed. If you
cannot tell which is right, keep both under `## Open questions` in the note, each
with its evidence, and say how to settle it.

## Raw sources (optional)

`raw/` holds source material that a note cites: a doc page, a transcript excerpt,
command output, a spec. Notes link to it as `raw/<file>`. Files in `raw/` are
never edited after they land.

You do not need it for most notes. Use it only when the source is hard to get
again and a later reader may need to re-check the claim. A note with a command
or a URL as evidence needs no raw copy.

**Never put anything sensitive in `raw/`**: no credentials, tokens, keys,
customer data, personal data, or private messages. Redact before you save, or
cite where the source lives instead.

## Lint and consolidation

Run `wiki lint` after a batch of writes, and before a consolidation pass. It
exits non-zero on errors (broken links, a note missing from its index, an index
entry with no file, duplicate entries, links to agent project memory). It also
lists warnings: oversized indexes and hooks, notes with no `## Use`, and orphans.

A consolidation pass, run when lint or the index shows drift:

- Merge notes that cover the same topic. Leave no stub; fix the links.
- Rewrite a note's summary and `## Use` from scratch when appended updates make
  them read as a history.
- Rewrite long or dated index hooks into one stable line.
- Move work state (PR status, next steps, "in progress") to the task tracker.
- Fold notes named after a task or customer into the system notes they describe.
- Link orphans from the notes they relate to.
- Log the pass: `wiki log lint <what changed>`.

## Rules that keep lookups cheap

- **One fact, one line.** A fact wrapped across two lines cannot be grepped, only
  read. Keep each claim on a single line even if it runs long.
- **Exact strings on their own line.** Commands, paths, error text, option names.
  These are the anchors searches land on.
- **Never record a value that will drift.** Counts, versions, sizes, dates, "as of
  today" state. Record the command that yields the current value instead. A stale
  fact costs twice: once to read, once to re-verify.
- **Record what is not true**, when you had to disprove it. "X cannot talk to Y"
  saves the next session the same dead end.
- **Do not record** task chatter, what the repo already states, or anything a
  reader could see by looking at the code.
- Link related notes with `[[note-name]]`.
- **Work state is not a fact.** PR status, deploy status and next steps go in the
  task tracker, never in a note or a hook.
- Split a note when it passes ~80 lines *and* its sections get consulted
  independently. Shard a directory's index when it passes ~150 lines.

## Sensitivity

The wiki may live in a private repo while other config does not. Never copy wiki
content into a public repository, and never record a live credential anywhere -
record where it lives and how to rotate it. The same holds for `raw/`.
