#!/usr/bin/env bash
# Debian/Ubuntu counterpart of pkg_install_arch.sh + pkg_lists/arch_base.txt.
# Package names map to the Arch list where possible; anything not in apt is built/installed manually below.

printf "\n\n"
echo "# ────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION (Part I: Core install from package manager)"
echo "# ────────────────────────────────────────────────────────────────────────"
printf "\n\n"

cd ~/.config/home-manager

# shellcheck disable=SC1091
. /etc/os-release

if ! command -v apt >/dev/null || ! echo "$ID $ID_LIKE" | grep -qiE 'debian|ubuntu'; then
    echo "This script requires a Debian/Ubuntu-based system"
    exit 1
fi

UBUNTU_CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}"   # Mint/Pop report their own VERSION_ID, but the Ubuntu base codename

# PPAs (and add-apt-repository/software-properties-common, which Debian 13 no longer ships) are Ubuntu-only
IS_UBUNTU=0
echo "$ID $ID_LIKE" | grep -qi ubuntu && IS_UBUNTU=1

IS_WSL=0
grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=1

export DEBIAN_FRONTEND=noninteractive
FAILED_PKGS=()

# Install the first available candidate of the given package names.
# Also tries the '<name>t64' variant (Ubuntu 24.04+ renamed many libs during the 64-bit time_t transition).
# Usage: apt_pkg <pkg> [fallback-pkg ...]
apt_pkg(){
    local candidates=() p
    for p in "$@"; do candidates+=("$p" "${p}t64"); done

    for p in "${candidates[@]}"; do
        if dpkg-query -W -f='${Status}' "$p" 2>/dev/null | grep -q "install ok installed"; then
            return 0
        fi
    done

    for p in "${candidates[@]}"; do
        if apt-cache policy "$p" 2>/dev/null | grep -q 'Candidate: [^(]'; then
            echo "→ Installing $p"
            $SUDO apt install -y "$p" && return 0
        fi
    done

    echo "[!] Could not install: $*"
    FAILED_PKGS+=("$*")
    return 1
}

# Returns 0 if any of the given packages (or their t64 variant) is available from apt
apt_has(){
    local p
    for p in "$@"; do
        apt-cache policy "$p" "${p}t64" 2>/dev/null | grep -q 'Candidate: [^(]' && return 0
    done
    return 1
}

echo "[+] Updating package lists (Debian/Ubuntu)..."
$SUDO apt update
[ "$IS_UBUNTU" -eq 1 ] && $SUDO apt install -y software-properties-common   # add-apt-repository

echo "[+] Installing essential core packages..."    # Not essential per se, but essentials for my workflow,enchancements, and customizations
# xz-utils: Nix installer tarball | lsb-release/gnupg: llvm.sh | fontconfig: fc-list/fc-cache (minimal Debian lacks all of these, Arch base has them)
for pkg in \
    build-essential binutils bzip2 coreutils curl wget tar zip unzip sed gawk sudo less \
    man-db rsync openssh-client openssl iproute2 net-tools \
    xclip xsel p7zip-full libc6 restic btop htop tree bc \
    xz-utils lsb-release gnupg fontconfig git-filter-repo
do
    apt_pkg "$pkg"
done
apt_pkg dnsutils bind9-dnsutils     # dnsutils is only a virtual package on Debian 13
apt_pkg 7zip                        # Newer 7zip (24.04+), p7zip-full above covers older releases
apt_pkg plocate mlocate locate      # mlocate (Arch)

# Arch installs plain 'vim' - only pull in the GTK/X11 build (system clipboard) on desktop installs
if [ "${INSTALL_SUBTYPE}" = "desktop" ]; then
    apt_pkg vim-gtk3 vim
else
    apt_pkg vim
fi

# Hardware/networking pkgs are pointless inside WSL
if [ "$IS_WSL" -eq 0 ]; then
    apt_pkg network-manager         # NetworkManager (Arch)
    apt_pkg iw
    apt_pkg linux-firmware firmware-linux firmware-linux-free   # Debian splits firmware by repo component
fi

# Languages
echo "[+] Installing dev related packages..."    # Not essential per se, but essentials for my workflow,enchancements, and customizations
for pkg in \
    python3 python3-pip python3-venv python3-pygments perl make gcc clang cmake ninja-build nasm \
    libstdc++6 libc6-dev libc6-dev-i386 pkg-config gettext jq pandoc bash git-all direnv pipx \
    libperl-critic-perl
do
    apt_pkg "$pkg"
done
apt_pkg lua5.4 lua5.3
pipx ensurepath

echo "[+] Installing terminal/workflow extras..."
for pkg in \
    zsh tmux sshfs sshpass fonts-powerline font-manager bat ripgrep fzf chafa \
    entr nvtop ufw flatpak smbclient cifs-utils tcpdump wlsunset
do
    apt_pkg "$pkg"
done
apt_pkg libfuse2                    # fuse2 (Arch) - needed for AppImages (t64 variant tried automatically)
apt_pkg nsxiv sxiv                  # Terminal image viewer (sxiv was replaced by nsxiv in newer releases)
apt_has doxx && apt_pkg doxx       # .docx viewer (falls back to cargo below if missing)

# qView isn't packaged for Ubuntu - use flathub
if apt_has qview; then
    apt_pkg qview
elif command -v flatpak >/dev/null 2>&1; then
    $SUDO flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    $SUDO flatpak install -y --noninteractive flathub com.interversehq.qView
fi

# Ubuntu ships 'bat' as 'batcat' - expose it as 'bat' like on Arch
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

# Fastfetch only lands in the official repos on newer releases (Debian 13+ ships it; the PPA is Ubuntu-only)
if ! apt_has fastfetch && [ "$IS_UBUNTU" -eq 1 ]; then
    $SUDO add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    $SUDO apt update
fi
apt_pkg fastfetch

echo "[+] Installing various dependencies..."
for pkg in libssl-dev libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev unixodbc unixodbc-dev; do
    apt_pkg "$pkg"
done
# apt_pkg crossbuild-essential-arm64

echo "[+] Installing docker..."
apt_pkg docker.io
apt_pkg docker-compose-v2 docker-compose-plugin docker-compose

echo "[+] Installing various sound/media-related dependencies..."
# Older releases ship ffmpeg 4.x - the PPA only supports pre-24.04 releases
if [[ "$UBUNTU_CODENAME" =~ ^(focal|jammy)$ ]]; then
    $SUDO add-apt-repository -y ppa:ubuntuhandbook1/ffmpeg6
    $SUDO apt update
fi
for pkg in \
    ffmpeg imagemagick poppler-utils playerctl libasound2-dev libass9 libbluray2 libcaca0 \
    libcdio-cdda2 libcdio-paranoia2 libcdio19 librubberband2 libzimg2 libdbus-1-dev libpulse-dev
do
    apt_pkg "$pkg"
done
apt_pkg libncurses-dev libncursesw5-dev

if systemctl --user is-active pipewire >/dev/null 2>&1; then
    echo "Using PipeWire, installing specific dependencies..."
    apt_pkg libpipewire-0.3-0
fi

echo "[+] (optional) installing vulkan graphics drivers..."
apt_pkg vulkan-tools
apt_pkg mesa-utils

echo "[+] Installing Tufw (UFW GUI)..."
if ! command -v tufw >/dev/null 2>&1; then
    wget https://github.com/peltho/tufw/releases/download/v0.2.4/tufw_0.2.4_linux_amd64.deb -O ./tufw_0.2.4_linux_amd64.deb
    $SUDO apt install ./tufw_0.2.4_linux_amd64.deb -y
    rm -f ./tufw_0.2.4_linux_amd64.deb
fi

echo "[+] Installing Nerd Font symbols..."    # ttf-nerd-fonts-symbols(-mono) (Arch). JetBrainsMono Nerd is installed by controller.sh
if ! fc-list | grep -qi "Symbols Nerd Font"; then
    mkdir -p "$HOME/.local/share/fonts/NerdFontsSymbolsOnly"
    curl -fLo /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip \
        && unzip -o /tmp/NerdFontsSymbolsOnly.zip -d "$HOME/.local/share/fonts/NerdFontsSymbolsOnly" \
        && fc-cache -f
    rm -f /tmp/NerdFontsSymbolsOnly.zip
fi

# Keep at end
printf "[+] Removing stale lockfiles...\n\n"
$SUDO rm -f /var/lib/dpkg/lock-frontend
$SUDO rm -f /var/lib/dpkg/lock


# ────────────────────────────────────────────────
#         Distro-agnostic tool installs
# ────────────────────────────────────────────────

echo "# ────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION (Part II: Distro-agnostic Tools not via package manager)"
echo "# ────────────────────────────────────────────────"

# Software that isn't installed via a distro's package manager (may contain fixed versions). The order below is important.
echo "[+] Installing prerequisites!"

echo "[+] Enabling docker service..."
$SUDO  systemctl enable docker
$SUDO  systemctl start docker

echo "[+] Installing Rust (rustup)..."    # apt's cargo is too old for most of the crates below
if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
# shellcheck disable=SC1091
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
rustup default stable
rustup update

echo "[+] Installing uv python package manager..."
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

echo "[+] Installing Go (if needed)..."    # apt's golang lags behind what the go tools below require
GO_LATEST=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -n1)
if [ -n "$GO_LATEST" ] && { ! command -v go >/dev/null 2>&1 || [ "$(go env GOVERSION)" != "$GO_LATEST" ]; }; then
    wget "https://go.dev/dl/${GO_LATEST}.linux-amd64.tar.gz"
    $SUDO rm -rf /usr/local/go
    $SUDO tar -C /usr/local -xzf "${GO_LATEST}.linux-amd64.tar.gz"
    rm -f "${GO_LATEST}.linux-amd64.tar.gz"
fi
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

echo "[+] Installing nvm..."
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash # Install nvm version 0.40.3
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
if command -v nvm >/dev/null; then
    echo "nvm installation suceeded. installing version."
    echo -e "\t[+] Installing node v22..."
    nvm install v22.17.0  # install a version
    echo -e "\t[+] Installed versions:"
    nvm list              # View installed versions
    echo -e "\t[+] Selecting v22.17"
    nvm use v22.17.0
    nvm alias default v22.17.0
fi

echo "[+] Done installing prerequisites!"

printf "\n\n---------------------------------------------------\n\n"

# MAIN INSTALLATIONS

# Cargo ____________________________________
echo "[+] Installing csvlens"
cargo install csvlens

echo "[+] Installing Dust..."
cargo install du-dust

echo "[+] Installing jless (json viewer)"
command -v jless >/dev/null 2>&1 || cargo install jless

echo "[+] Installing fd..."
cargo install fd-find

echo "[+] Installing tree-sitter-cli..."
cargo install --locked tree-sitter-cli

echo "[+] Installing dysk (df alternative)..."
cargo install --locked dysk

echo "[+] Installing treemd (markdown tree viewer)..."
cargo install treemd

echo "[+] Installing oyo (git diff viewer)..."
cargo install oyo --locked

echo "[+] Installing basalt (obsidian reader)..."
cargo install basalt-tui

if ! command -v doxx >/dev/null 2>&1; then
    echo "[+] Installing doxx (.docx viewer)..."
    cargo install doxx
fi

echo "[+] Installing wiremix (pipewire mixer)..."
apt_pkg libpipewire-0.3-dev && cargo install wiremix

echo "[+] Installing Yazi..."
if ! command -v yazi >/dev/null 2>&1; then
    # Build the latest release (what Arch's package ships), not whatever is on main
    YAZI_TAG=$(curl -fsSL https://api.github.com/repos/sxyazi/yazi/releases/latest | jq -r .tag_name)
    git clone --depth 1 --branch "$YAZI_TAG" https://github.com/sxyazi/yazi.git
    cd yazi
    cargo build --release --locked
    $SUDO  mv target/release/yazi target/release/ya /usr/local/bin/
    cd ..
    rm -rf yazi
fi

echo "[+] Installing Yazi bookmarks plugin..."
ya pkg add dedukun/bookmarks


# Go _______________________________________
echo "[+] Installing lazysql..."
go install github.com/jorgerojas26/lazysql@latest

echo "[+] Installing eget..."
go install github.com/zyedidia/eget@latest

echo "[+] Installing lazygit..."
go install github.com/jesseduffield/lazygit@latest

echo "[+] Installing glow..."
go install github.com/charmbracelet/glow/v2@latest

echo "[+] Installing gum..."
go install github.com/charmbracelet/gum@latest

echo "[+] Installing snitch (network connection viewer)..."
go install github.com/karol-broda/snitch@latest

echo "[+] Installing Docker Compose Viewer (dcv)..."
if ! command -v dcv >/dev/null 2>&1; then
    git clone https://github.com/tokuhirom/dcv.git
    cd dcv
    make build-helpers
    go build -o dcv
    $SUDO mv dcv /usr/local/bin/
    cd ..
    rm -rf dcv
fi


# npm ______________________________________
echo "[+] Installing pnpm..."
command -v pnpm >/dev/null 2>&1 || npm install -g pnpm

echo "[+] Installing neohtop-cli..."
npm install -g neohtop-cli


# Other ___________________________________
echo "[+] Installing TPM (tmux plugin manager)..."
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "[+] Installing ggh ssh manager..."
curl https://raw.githubusercontent.com/byawitz/ggh/master/install/unix.sh | sh

echo "[+] Installing lazydocker..."
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

echo "[+] Installing lazyssh..."
LATEST_TAG=$(curl -fsSL https://api.github.com/repos/Adembc/lazyssh/releases/latest | jq -r .tag_name)
curl -LJO "https://github.com/Adembc/lazyssh/releases/download/${LATEST_TAG}/lazyssh_$(uname)_$(uname -m).tar.gz" \
    && tar -xzf "lazyssh_$(uname)_$(uname -m).tar.gz" lazyssh \
    && $SUDO mv lazyssh /usr/local/bin/
rm -f "lazyssh_$(uname)_$(uname -m).tar.gz"

echo "[+] Installing darya..."          # cli alternative to gui-based baobab (https://github.com/GNOME/baobab)
curl -fsSL https://mr.katebzadeh.xyz/tools/darya/install | bash

echo "[+] Installing GitTop (GitHub notifications client)..."
if ! command -v gittop >/dev/null 2>&1; then
    GITTOP_TAG=$(curl -fsSL https://api.github.com/repos/AmarBego/GitTop/releases/latest | jq -r .tag_name)
    curl -fLo /tmp/gittop.deb "https://github.com/AmarBego/GitTop/releases/download/${GITTOP_TAG}/gittop-${GITTOP_TAG#v}-linux-gnu-x86_64.deb" \
        && $SUDO apt install -y /tmp/gittop.deb
    rm -f /tmp/gittop.deb
fi

echo "[+] Installing Posting via uv..."
uv tool install --python 3.13 posting

echo "[+] Installing YouTube-downloader..."
$SUDO  wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux -O /usr/local/bin/yt-dlp; $SUDO chmod +x /usr/local/bin/yt-dlp

echo "[+] Installing x-cmd..."
eval "$(curl https://get.x-cmd.com)"

echo "[+] Installing llvm and related tools (clangd, cmake, etc)..."
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
$SUDO  ./llvm.sh 20 all
rm -f llvm.sh
# or for latest stable release...
# sudo ./llvm.sh all

echo "[+] Installing tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
# Set taildrop location
mkdir -p "${HOME}/Downloads/taildrops"
$SUDO tailscale file get "${HOME}/Downloads/taildrops"
$SUDO tailscale set --operator="$CALLING_USER"

echo "[+] Installing Spotify Player..."
# libpulse-dev (above) is enough to build the pulseaudio backend - it talks to pipewire-pulse fine.
# Only pull in the PulseAudio daemon when PipeWire isn't running, otherwise it would replace pipewire-pulse.
# Skip it on headless installs entirely (Arch never installs a sound server there either).
if [ "${INSTALL_SUBTYPE}" = "desktop" ] && ! systemctl --user is-active pipewire >/dev/null 2>&1; then
    apt_pkg pulseaudio
    apt_pkg pulseaudio-module-bluetooth
    apt_pkg pulseaudio-utils
fi
apt_pkg pavucontrol
apt_pkg libsixel-bin  # sixel encoder/decoder
command -v spotify_player >/dev/null 2>&1 || cargo install spotify_player --no-default-features --features pulseaudio-backend,media-control,sixel

# echo "[+] Installing zioxide..."
# curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# echo "[+] Installing Latest Tmux..."
# $SUDO apt-get install autotools-dev -y
# $SUDO apt-get install automake -y
# command -v libevent-dev >/dev/null 2>&1 || $SUDO apt install libevent-dev -y
# command -v bison >/dev/null 2>&1 || $SUDO apt install bison -y
# $SUDO apt install libncurses5-dev
# command -v libncursesw5-dev >/dev/null 2>&1 || $SUDO apt install libncursesw5-dev -y
#
# git clone https://github.com/tmux/tmux.git
# cd tmux
# sh autogen.sh
# ./configure --enable-sixel || { echo "Tmux configure failed"; }
# make && $SUDO make install || { echo "Tmux build failed"; }
# cd ../


# echo "[+] Installing mpv..."
# $SUDO  curl --output-dir /etc/apt/trusted.gpg.d -O https://apt.fruit.je/fruit.gpg
# ADDITION="deb http://apt.fruit.je/ubuntu $(cat /etc/os-release | grep 'VERSION_CODENAME' | awk -F= '{print $2}' | xargs) mpv"
# ADDITION="deb http://apt.fruit.je/ubuntu $(lsb_release -cs) mpv"
# echo $ADDITION | $SUDO  tee -a /etc/apt/sources.list.d/fruit.list
# $SUDO  apt update
# command -v mpv >/dev/null 2>&1 || $SUDO apt install mpv -y

printf "\n\n\n"

echo "# ──────────────────────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION | Part III: Installing personal bins and running checks"
echo "# ──────────────────────────────────────────────────────────────────────────────────────────"

# Note: Not doing this for Arch becase on debian I don't care where the package lives, I just need neovim and lazygit so a manual install is fine. But on Arch, I do care - I'm using pacman and nix there so how it installs is important and don't want to have a manual build if I can avoid it
echo "[+] Manually Installing any missing packages..."

if ! command -v nvim >/dev/null 2>&1; then
    printf "[+] Installing latest neovim stable release...\n\n"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    $SUDO rm -rf /opt/nvim-linux-x86_64
    $SUDO tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm -f nvim-linux-x86_64.tar.gz
    # Already added to PATH in .zshrc - just export for now so we can use it now
    export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
fi

# Download and install lazygit (fallback if 'go install' above failed)
if ! command -v lazygit >/dev/null 2>&1; then
    printf "[+] Installing lazygit...\n\n"
    LAZYGIT_VERSION=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .tag_name | sed 's/^v//')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && $SUDO mv -f lazygit /usr/local/bin/ \
    && rm lazygit.tar.gz
fi

if (( ${#FAILED_PKGS[@]} > 0 )); then
    echo "[!] The following apt packages could not be installed (not available on this release?):"
    printf '    - %s\n' "${FAILED_PKGS[@]}"
fi

echo "# ──────────────────────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION COMPLETE!"
echo "# ──────────────────────────────────────────────────────────────────────────────────────────"
