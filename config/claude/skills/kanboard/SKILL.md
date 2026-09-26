---
name: kanboard
description: Use when starting, pausing, finishing or deploying a tracked piece of work, when work turns up that no card covers, or when reading, creating, moving or commenting on a Kanboard task or board.
---

# Kanboard

Kanboard holds **the state of work**. The wiki holds project concepts and facts
about systems. Activity, tickets and progress belong on a card: put progress in a
card comment, never in a wiki note.

## The script

`~/.claude/skills/kanboard/kb` — not on `$PATH`, so call it by that path.

Run it with no arguments for the full command list. It reads the board address and
the credentials at runtime, and it never prints the token. If it exits with "no
kanboard config", no board is set up on this machine: say so and carry on without
it.

Projects, columns and categories take a name or an id, so `kb move 17 doing` and
`kb new traddle backlog Bug "title"` both work without a lookup first.

## What each column means

| Column | The card sits here when |
|---|---|
| backlog | The work is a possibility, or a raw report. Bugs and feature requests land here. |
| ready | The work is defined and someone can pick it up. |
| doing | Someone works on it. It stays here through review, an open PR, and deployment. |
| done | Deployed and confirmed. |

## Move the card the moment its state changes

Not at the end of a session.

- Move a card to doing when you **start** the work.
- A card stays in doing while it waits on a person, on a review, or on a deploy.
- Move it to done once the change is deployed and confirmed.
- Find work that no card covers: create one. backlog if it is a possibility, ready
  if it is already defined.

## Classify with a category, not a tag

Every task holds exactly one category: **Bug**, **Feature Request**,
**Improvement**, or **Research**. Category ids differ per project, so name the
category and let `kb` resolve it. The tag feature is unused.

## When something fails

The agent user is a `project-member`: it can capture and move work, and it cannot
change board structure. Columns, new projects and permissions need
`project-manager` **on that project**, which an application-admin role does not
grant.

For the rest of the API behaviour, search the agent wiki for `kanboard`. The note
there holds the permission model, the real search-keyword list, and the traps.
Use `kb call <method> <json>` to reach a procedure the script does not wrap.
