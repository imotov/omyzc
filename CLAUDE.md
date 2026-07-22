# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

`omyzc` is Igor's personal Oh-My-Zsh custom directory (`ZSH_CUSTOM`). It is not an
application — there is no build, lint, or test tooling. Files here are sourced directly
by Oh-My-Zsh into an interactive zsh shell, so changes take effect on the next new shell
(or `source ~/.zshrc`).

Install (from README.md): point Oh-My-Zsh at this repo by setting in `~/.zshrc`:
```shell
ZSH_THEME="eastwood"
ZSH_CUSTOM="/Users/igor/Projects/imotov/omyzc"
plugins=(git docker docker-compose)
```

`bootstrap` is the one-shot setup script for a fresh Linux machine (referenced from a raw
GitHub URL): it clones this repo, switches the login shell to zsh, installs Oh-My-Zsh,
rewrites `~/.zshrc` (theme, `ZSH_CUSTOM`, plugin list) via `sed`, and sets global git
identity. It intentionally no-ops most steps on non-Linux (macOS is assumed already set up).

## Structure and load order

Oh-My-Zsh sources files directly in `ZSH_CUSTOM` (this repo's root) in alphabetical order,
which is why files are numerically prefixed:

- `00_update.zsh` — self-update check, modeled on Oh-My-Zsh's own update mechanism. Runs
  first (before OS setup or aliases) so a pulled update is picked up by the rest of the
  load in the same shell startup. On shell startup, if the rate-limit window has elapsed
  (stamp file `.zsh-update`, gitignored, default 7 days), it fetches `origin` and either
  reminds or fast-forwards, per `zstyle ':omyzc:update' mode` (`auto`/`reminder`/`disabled`,
  default `reminder`) and `zstyle ':omyzc:update' frequency <days>`. Manual command:
  `omyzc_update` (alias `omyzcup`); `omyzc_update --check-only` reports without pulling.
  Never auto-merges a diverged branch.
- `10_linux.zsh` / `10_macos.zsh` — OS-conditional setup (`$(uname)` check), gated by
  `Linux`/`Darwin`. Currently macOS sets up `PATH` additions (VS Code CLI, IntelliJ CLI,
  `~/.local/bin`) and `JAVA_HOME`/`ES_JAVA_HOME` via `java_home -v21`.
- `20_dev.zsh` — general dev aliases/functions: multi-remote git helpers (`gffo/gffu/gffi`,
  `gfi/gfu/gfo`, `gpi/gpu/gpo` for `imotov`/`upstream`/`origin` remotes), PR fetch/merge/clean
  helpers (`gprf`, `gprm`, `gprc`), commit-date rewriting (`gnow`, `gda`), and `cd` shortcuts
  (`cdpi`, `cdpe`, `cdpo`, etc.) to project directories under `~/Projects`.
- `30_cuvs.zsh` — project-specific aliases for NVIDIA's `cuvs` (a mamba env named `cuvs`).
- `plugins/mamba/mamba.plugin.zsh` — a drop-in replacement for Oh-My-Zsh's built-in `conda`
  plugin, aliasing the same `cn*` shortcuts to `mamba` instead of `conda`. Only used when
  `mamba` is enabled in the `plugins=(...)` list in `~/.zshrc`.

New numbered top-level files follow the same convention: `NN_name.zsh`, where the number
controls sourcing order relative to other custom files (OS/base setup low,
project-specific aliases higher).

## Conventions when editing

- Aliases/functions that depend on OS must guard with `OS=$(uname)` and check
  `"Linux"`/`"Darwin"` (see `10_macos.zsh`, `gda` in `20_dev.zsh`), since this repo is
  shared across both machines the user runs.
- Git helper naming follows a pattern: suffix `i`/`u`/`o` selects the `imotov`/`upstream`/`origin`
  remote (e.g. `gpi` = push to `imotov`, `gfo` = fetch from `origin`). Keep new remote-aware
  helpers consistent with this suffix scheme.
- There is no test suite; validate shell changes by sourcing the file (`source <file>.zsh`)
  or opening a new shell.
