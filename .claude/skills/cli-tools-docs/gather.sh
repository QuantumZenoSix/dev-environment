#!/usr/bin/env bash
# Prints one TSV row per package in pkg_lists/arch_base.txt so cli_tools.md can be checked against reality:
#   section <TAB> installed <TAB> package <TAB> description <TAB> binaries in /usr/bin
# section   = pacman | aur   (packages after the NOTE-AUR line are installed with yay)
# installed = yes | no       (on the machine running this script)
# Descriptions/binaries come from the local pacman DB when installed, else the sync DB (`pacman -Si`),
# else the AUR (`yay -Si`, network). Binaries of not-installed packages are only known if the pacman
# files DB exists (`sudo pacman -Fy`); otherwise the column is empty.
#
# Usage (from the repo root): bash .claude/skills/cli-tools-docs/gather.sh [path/to/arch_base.txt]
set -euo pipefail

list_file="${1:-pkg_lists/arch_base.txt}"
if [[ ! -f "$list_file" ]]; then
    echo "gather.sh: package list not found: $list_file" >&2
    exit 1
fi
if ! command -v pacman >/dev/null 2>&1; then
    echo "gather.sh: pacman not found - run this on an Arch-based machine" >&2
    exit 1
fi

binaries_installed() {
    # `|| true`: grep exits 1 for packages with no binaries (libraries, fonts, meta-packages like base-devel)
    pacman -Qlq "$1" | grep -E '^/usr/bin/[^/]+$' | xargs -r -n1 basename | tr '\n' ' ' || true
}

binaries_from_files_db() {
    pacman -Fl "$1" 2>/dev/null | awk '{print $2}' | grep -E '^usr/bin/[^/]+$' | xargs -r -n1 basename | tr '\n' ' ' || true
}

description_from_aur() {
    command -v yay >/dev/null 2>&1 || return 0
    timeout 30 yay -Si "$1" 2>/dev/null | sed -n 's/^Description *: //p' | head -1 || true
}

section="pacman"
while IFS= read -r raw_line; do
    # Same parsing as scripts/pkg_install_arch.sh: strip whitespace and inline comments, skip blanks
    line="${raw_line//[[:space:]]/}"
    line="${line%%#*}"
    [[ -z "$line" ]] && continue
    if [[ "$line" == NOTE* ]]; then
        [[ "$line" == NOTE-AUR* ]] && section="aur"
        continue
    fi

    pkg="$line"
    if pacman -Qq "$pkg" >/dev/null 2>&1; then
        installed="yes"
        description=$(pacman -Qi "$pkg" | sed -n 's/^Description *: //p')
        binaries=$(binaries_installed "$pkg")
    else
        installed="no"
        description=$(pacman -Si "$pkg" 2>/dev/null | sed -n 's/^Description *: //p' | head -1 || true)
        [[ -z "$description" ]] && description=$(description_from_aur "$pkg")
        [[ -z "$description" ]] && description="NOT FOUND in pacman repos or AUR"
        binaries=$(binaries_from_files_db "$pkg")
    fi
    printf '%s\t%s\t%s\t%s\t%s\n' "$section" "$installed" "$pkg" "$description" "$binaries"
done < "$list_file"
