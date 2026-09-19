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

## Writing a note

Write the note when you find the fact, not at the end of the session. Check
`wiki digest` first — if a note covers the topic, update it rather than adding a
second one.

One file per topic, short kebab-case name, system prefix first so globs narrow
fast (`foo-auth-model.md`, not `auth-model-in-foo.md`).

Use this skeleton. It exists so partial reads work:

```markdown
# <topic>

<One line. The whole answer, standalone, no pronouns referring elsewhere.>

## Use

<3-8 lines. The command, the path, the gotcha. What a reader acts on.>

## Details

<Everything else. Rarely read.>
```

Then add one line to the index: a link and a hook that lets a reader decide
whether to open the file without opening it.

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
- Link related notes with `[[wiki-links]]`.
- Split a note when it passes ~80 lines *and* its sections get consulted
  independently. Shard the index when it passes ~40 lines.

## Sensitivity

The wiki may live in a private repo while other config does not. Never copy wiki
content into a public repository, and never record a live credential anywhere -
record where it lives and how to rotate it.
