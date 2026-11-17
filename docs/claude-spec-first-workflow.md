# Claude Code workflow: spec first

A proposed workflow for Claude Code sessions. It is on trial on one machine, in that machine's `~/.claude/CLAUDE.md`. Nothing in this repo loads this file: it is a copy to read and to carry to other machines later.

To use it on a machine, paste the text below into `~/.claude/CLAUDE.md`, and add a line that names the ozh home for that machine.

---

## Workflow: spec first

Applies to all work, in every repo. The user can skip it for any task by saying so.

A tool named below may be absent on a machine. When it is absent, skip that step and say so in one line.

### Start of a task

- **Judge the size first and say it in one line: "full flow" or "light".** Light = a quick question, a one-off artifact, a small change with no design decision, or anything the user says should skip the flow. Light work gets none of the steps below. The user can overrule the call either way.
- **For full flow, ask once, in one prompt:**
  1. Search the agent wiki for this topic? (`agent-wiki` skill)
  2. Which Switchyard stream? Propose one from the `switchyard-stream` skill's list, or a new name and goal when none fits.
  3. Start a spec document?
- Do not search the wiki or record a stream before the user answers.

### Spec

- **While a spec is being written or revised, it is a Claude document** (docs connector). With no docs connector, use a markdown file in the session's folder. Sections: Status line (`Draft` / `Agreed` / `In progress` / `Done` / `Dropped`, with date), Goal, Context and evidence, Non-goals, Approach, Open questions, Verification, Decision log, Links.
- **Do not start implementation before the user marks the spec `Agreed`.** A spec with a blocking open question cannot be `Agreed`.
- **When the user marks it `Agreed`, offer to bring it into ozh.** On yes: export the document to markdown, run `ozh spec add`, put the manifest id in Links. From then on ozh is the record and the document is the workbench.
- **ozh home:** the machine's own `CLAUDE.md` names the home for each kind of work. If it names none, use `$OZH_HOME`; if that is not set, ask. ozh does not find a home from another repo: pass `--home <dir>` or set `OZH_HOME`. Never commit or push an ozh home without approval for that push.
- **Then offer claim candidates.** List them in the spec document, each with the sentence it quotes. Create only the ones the user approves: `ozh claim new "..." --from <manifest> --quote "..."`. They start as `proposed`. Attesting is the user's step, not yours.

### Changes during work

- **The flow can go back from any stage, PR review included.**
- **Test for every change: does it contradict a sentence in Goal, Non-goals, Approach or Verification?**
  - Yes: stop the work. Revise the document. Wait for the user to mark it `Agreed` again. Import the revision (`ozh spec add <spec.md> --manifest <id> --note "..."`). Then continue.
  - No: it is an implementation detail. Carry on.

### End of a task

- **PR:** follow the repo's PR rules.
- **No PR:** write the outcome in the spec and set its status. Record durable facts in the agent wiki.
- **Switchyard:** record again when the spec is revised, and when a PR exists.
