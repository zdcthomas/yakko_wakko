# Mode switching costs a reboot, and nothing else

Modes on `opt` are NixOS specialisations, so the machine can switch between
them in two ways: a reboot plus a boot-menu choice, or a runtime call to
`switch-to-configuration`. We expose only the reboot. There is deliberately no
`mode <name>` command, and there will not be one.

## Why

The point of a mode is friction, and friction only works if it sits on the
escape. An earlier attempt at the same goal — a commented-out
`networking.extraHosts` blocklist in `nix/hosts/opt/configuration.nix` — died
because the block and the unblock cost the same edit and rebuild. When the
escape is as cheap as the block, the escape always wins.

A runtime switch would be much cheaper than a reboot, so it would become the
only path anyone uses. The reboot cost is the feature: it closes every window,
loses the session, and takes about a minute. An impulse does not survive that.

## Consequences

- Every mode change loses your open windows. This is intended.
- A crash or a kernel update drops you at the boot menu, which is why the
  default entry matters. See `CONTEXT.md` for what the modes are.
- Anyone who "fixes" this by adding a runtime switch removes the entire
  mechanism. Read this file before doing that.
