# Context

Glossary for this repository. Terms only. No implementation details.

## Mode

A named posture of the machine `opt`. A mode decides which applications and
which websites the machine can reach. Exactly one mode is active at a time.
Modes exist on `opt` only.

Three modes exist:

- **open** — no restrictions. This is the whole desktop as it stands today.
  The name is deliberate. It is not called "default", because a default
  invites the user to sit in it.
- **making** — for technical work. The desktop stays whole. A named set of
  distracting domains becomes unreachable.
- **writing** — for prose. The machine offers a terminal, an editor, a
  dictionary, a document reader and music. No browser exists. The network
  joins nothing until the user asks.

A mode is not a user account, a desktop session, or a workspace.

## Friction

The cost the user pays to change modes. Friction is deliberately symmetric and
deliberately large: every change costs a reboot and the loss of the session.

An earlier design put a cheap escape next to an expensive block. It failed,
because the user pays the cost at the moment of least resistance, and a cheap
escape always wins. See [ADR 0001](docs/adr/0001-reboot-only-mode-switching.md).

Friction is a deterrent, not a security boundary. The user owns the machine
and can always defeat a mode with enough effort. The goal is to make the
effort large enough to break the impulse.

## Blocklist

The set of domains a mode makes unreachable. There is one list, and it is
absolute — a domain is on it or it is not. An earlier design had two tiers,
where the softer tier put a timed delay in front of a site instead of blocking
it. That tier was dropped: a gate the user can pass is a gate the user passes.

`open` has no blocklist. `making` and `writing` share the same one.

## Nix vocabulary

These two Nix terms are distinct and this repository keeps them apart:

- **specialisation** — one NixOS configuration that builds several variants.
  Each variant gets its own boot entry. All variants build together.
- **configuration** — a separate entry under `nixosConfigurations`. Switching
  between two configurations is a separate build.
