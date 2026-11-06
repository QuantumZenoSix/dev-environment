---
name: cli-tools-docs
description: Regenerates or updates cli_tools.md (repo root), the command-line reference of every tool the Arch install path sets up (pkg_lists/arch_base.txt, the manual installs in scripts/pkg_install_arch.sh, the oh-my-zsh setup in scripts/utils/controller.sh, and the CachyOS desktop extras), with how to call each tool, what it's for, the user's aliases, and install issues. Use when the user adds, removes, or renames packages in pkg_lists/arch_base.txt or the install scripts, adds CLI aliases for a tool, or asks to update, refresh, sync, or audit the CLI tools / packages / command-line reference doc.
argument-hint: "[package name or 'full' resync]"
---

# CLI Tools Docs

Keep `cli_tools.md` (repo root) **true to the install scripts**. The package lists and scripts are the source of truth. Never document a command, flag, or binary name you haven't confirmed from `pacman`, the tool's own `--help`, or its upstream docs.

## Sources to read

| What | Where |
| --- | --- |
| Main package list | `pkg_lists/arch_base.txt`. Lines before `NOTE-AUR` are installed with pacman; lines after it with pacman, falling back to yay. `#` starts a comment; `NOTE…` lines are section banners |
| Essentials + manual installs | `scripts/pkg_install_arch.sh`: the essentials block (`base-devel`, `git`, `go`, `rustup`) and the "manual" section (curl installers, `cargo install`, `npm -g`, `git clone`, `uv tool`, extra `$PACMAN` lines at the bottom) |
| Shell setup | `install_oh_my_zsh_and_powerline` in `scripts/utils/controller.sh`; `plugins=(…)` and `ZSH_THEME` in `dotfiles/.zsh_customizations` |
| Desktop extras | `scripts/cachy_os_setup/desktop.sh` (CLI tools go in §15; GUI apps go in its one-line list) |
| Aliases | `dotfiles/.bash_aliases` (the "Your aliases" info: `alias → command`) |
| Custom functions | `pkg_lists/cmd_list.txt`. Reference helper functions next to the tool they wrap (e.g. `ut_o_mp3_dl` with yt-dlp), but don't document the functions themselves |

## Gather package facts

From the repo root:

```bash
bash .claude/skills/cli-tools-docs/gather.sh > <scratchpad>/pkgs.tsv
```

Columns: `section` (pacman/aur), `installed` (yes/no on this machine), `package`, `description`, `binaries` (from `/usr/bin`).

- **Command names** come from the `binaries` column. When a package isn't installed, check `yay -Si <pkg>` (`Provides`) or upstream docs, and mark the row **†**.
- A `NOT FOUND in pacman repos or AUR` description means the install line is broken. Add it to §17.
- For flags and usage, run the tool's `--help` if it's installed. Otherwise use Context7 or the upstream README. Stick to a few common, stable invocations.
- For manual installs (not in `arch_base.txt`), check `command -v <tool>`.

Then confirm coverage. Every package must appear somewhere in the doc, including libraries and fonts in §16:

```bash
cut -f3 <scratchpad>/pkgs.tsv | sort -u | while read -r p; do grep -qF "\`$p\`" cli_tools.md || echo "MISSING: $p"; done
```

## Doc structure (keep this order and these anchors)

The header block lists sources, install-source tags, the † meaning, the aliases note, how to update, and a **Last synced** date. Below it, the Table of Contents, then:

1. **Quick Picks: "I want to…"**, task → command, for the most-used tools
2. Shell & Terminal (including oh-my-zsh plugins as `↳ plugin` rows)
3. Files, Search & Navigation
4. Disks & Filesystems
5. Archives & Compression
6. Text, Data & Documents
7. Editors
8. Git
9. Languages & Build Toolchains
10. Containers
11. System & Process Monitoring
12. Networking, Remote & Backup
13. Media, Images & Clipboard
14. Package & System Management
15. Desktop Install Extras (CachyOS): CLI table, then a one-line GUI app list
16. Libraries, Fonts & Firmware (nothing to run)
17. Install Issues Found: # · Where · Problem · Suggested fix

Category table columns: **Command | Package (source) | Purpose | Common usage**
- Command: the binary name(s) actually on PATH (e.g. `rg`, not `ripgrep`; `spotify_player`, not `spotify-player`).
- Package (source): package name plus a tag: `pacman`, `AUR` / `AUR section`, `manual` (with method), `shell`, `desktop`, or `pacman, essentials`.
- Common usage: 1–4 examples separated by ` · `. Include the user's alias or helper function when one exists. Escape pipes as `\|`.

Put a new tool in the category matching its job. Add it to Quick Picks only if it's a daily driver.

## Install issues (§17)

Check for these while reading:
- Package names that pacman or yay can't resolve (case matters: `networkmanager`, not `NetworkManager`).
- AUR package names that resolve to a different project than the one described in `cmd_list.txt` or the comments.
- Tools installed twice by different methods (pacman + cargo, etc.).
- Aliases or `plugins=(…)` entries that depend on something no script installs.
- Steps that delete state another step needs (e.g. `rm -rf ~/.oh-my-zsh` before custom plugins are restored).
- Inline comments in `arch_base.txt` that describe a different package.

Drop issues that have been fixed. This skill only documents; never change the package lists or scripts unless the user asks.

## Finish

1. Update the **Last synced** date.
2. Re-check ToC anchors against headings.
3. Report what changed: tools added or removed, issues found or resolved, and which rows are † (unverified locally).
