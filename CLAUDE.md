# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal dev-environment bootstrap + dotfiles repo (Arch/CachyOS first, some Debian/Pop!_OS support). It is cloned to `~/.config/home-manager` and is simultaneously:

1. An installer, driven by bash scripts (no build system, no tests).
2. A Nix Home Manager flake (`flake.nix` + `home.nix`) that deploys the files in `dotfiles/` into `$HOME`.

## Commands

```bash
# Apply dotfiles via Home Manager (what the `up` alias / `nx_up` does after a git pull)
home-manager switch -b backup --flake .#$USER

# Validate the flake / evaluate without switching
nix flake check
home-manager build --flake .#$USER

# Lint shell scripts (if shellcheck is installed)
shellcheck scripts/**/*.sh
```

The installer entry point is `scripts/utils/start.sh` (interactive menu), which sources `scripts/utils/controller.sh <mode> [desktop] [pop|cachy]` with modes `full`, `pkgsonly`, `configonly`, `nvimonly`.

## Architecture

- **Two deployment paths for the same dotfiles.** `controller.sh` either runs `setup_nix` (installs Nix, enables flakes, runs `home-manager init --switch`) or `copy_config_files` (plain `cp -f` into `$HOME`). When adding a new dotfile, update **both** `home.file` in `home.nix` and `copy_config_files` in `controller.sh`.
- **Home Manager uses the "legacy copy" style**, not declarative modules: `home.file` maps `./dotfiles/...` sources to `$HOME` paths. Exception: `programs.zsh.enable = true` means HM owns `~/.zshrc`; the repo's `dotfiles/.zshrc` is sourced via `initExtra`. Any program set to `enable = true` in `programs` will conflict with a `home.file` entry for its config unless that entry uses `lib.mkForce`.
- **Deployed files are read-only symlinks into the Nix store** — always edit the copy under `dotfiles/`, never the file in `$HOME`.
- **Flakes only see git-tracked files.** A new file under `dotfiles/` must be `git add`ed before `home-manager switch` can reference it.
- **Niri / Noctalia / Kvantum / Shelly configs are intentionally NOT managed by Nix** (Noctalia edits them at runtime). They're copied one-way by `controller.sh` on desktop installs, and `nx_up` (in `dotfiles/.bash_wrappers`) copies the live `~/.config/{niri,noctalia,shelly,Kvantum}` back into `dotfiles/.config/` so changes can be committed.
- **Username placeholder.** The committed `flake.nix`/`home.nix` use `REPLACETHISUSERNAME`; `setup_nix` seds in the real user at install time. Local working copies will therefore show the real username as an uncommitted diff — do not commit that substitution.
- **Package lists.** `pkg_lists/arch_base.txt` drives `scripts/pkg_install_arch.sh`; packages after the `NOTE-AUR` marker line are installed via `yay`. Desktop/gaming extras live in `scripts/cachy_os_setup/` and `scripts/pop_os_setup/`.
- **Shell function layout.** `dotfiles/.bash_aliases` (aliases), `.bash_wrappers` (higher-level workflow functions like `nx_up`), `.bash_utils` (helpers). All three are sourced by `dotfiles/.zshrc`. `cf` fuzzy-finds the custom functions.
- `config_exports/` holds system-level files (sddm theme/config, fstab, app exports) copied with sudo by the desktop install path; not touched by Home Manager.
