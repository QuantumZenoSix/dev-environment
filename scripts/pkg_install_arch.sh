#!/usr/bin/env bash


echo "# ──────────────────────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION | System update and setting up access to AUR"
echo "# ──────────────────────────────────────────────────────────────────────────────────────────"

# Set pwd to root
cd ~/.config/home-manager

# GLOBALS
AUR="yay -S --needed " 
PACMAN="$SUDO pacman -S --needed "
FILE="./pkg_lists/arch_base.txt"


# Some pkgs can't have 'yes' piped to them as they require user input. 
# Use --noconfirm for these to accept default
interactive_pkgs=(
    "base-devel"
    "font-manager"
    "alsa-lib"
    "ffmpeg"
    "p7zip"
    "neovim"
)


# Verify file exists
if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found"
    exit 1
fi


echo
echo "Reading packages from: $FILE"
echo "----------------------------------------"

# Populate 'packages' array
mapfile -t packages < "$FILE"

# Remove empty lines and comments, keep only real package names
packages=("${packages[@]//[[:space:]]/}")          # trim whitespace
packages=("${packages[@]%%#*}")                    # remove inline comments
packages=("${packages[@]/#/}")                     # remove lines starting with #

# Filter out empty entries
packages=($(printf '%s\n' "${packages[@]}" | grep -v '^$'))

if (( ${#packages[@]} == 0 )); then
    echo "No valid packages found in the file."
    exit 1
fi

echo "Found ${#packages[@]} packages to install:"
printf '  - %s\n' "${packages[@]}"
echo

read -p "Continue with installation? (y/N) " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Update system
echo "[+] Updating system packages..."
yes | $SUDO pacman -Syu 


# Essentials
$PACMAN  base-devel --noconfirm           # build-essential: GCC/make/etc for system builds/AUR 
yes | $PACMAN git 
yes | $PACMAN go 
yes | $PACMAN rustup  && rustup update


# Install yay if needed
if ! command -v yay >/dev/null 2>&1 ; then

    # Yay installation (for AUR) (needs go)
    echo "[+] Installing yay..."
    if [ "$(id -u)" -ne 0 ]; then
        git clone https://aur.archlinux.org/yay.git
        $SUDO chown -R ${CALLING_USER}:${CALLING_USER} yay && cd yay && makepkg -si  && cd ../
    else
        printf "[+] Running as root, cannot install yay ['makepkg' command must not be run as root. Skipping AUR packages.]\n"
        AUR="echo Cannot install (yay not installed). Skipping "
    fi

fi

# Ensure we're at project root
cd ~/.config/home-manager/

# remove yay source files
rm -rvf ./yay


echo


echo "# ──────────────────────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION | Installing pacman and aur packages"
echo "# ──────────────────────────────────────────────────────────────────────────────────────────"

using_pacman=1

# Main PKG installation loop
for pkg in "${packages[@]}"; do

    # Check if this is a NOTE
    if [[ "${pkg}" =~ NOTE ]]; then

        if [[ "${pkg}" =~ NOTE-AUR ]]; then
            using_pacman=0
        fi

        printf "\n\n$pkg\n"
        continue

    fi


    echo "→ Installing $pkg"

    # Pacman vs yay
    if [[ $using_pacman -eq 1 ]]; then

        if [[ "${interactive_pkgs[@]}" =~ "$pkg" ]]; then
            $PACMAN "$pkg" --noconfirm
        else
            yes | $PACMAN "$pkg"
        fi


    else

        # Try with pacman in case it's now available but will likely work with yay
        if [[ "${interactive_pkgs[@]}" =~ "$pkg" ]]; then
            $PACMAN  $pkg || $AUR $pkg 
        else
            yes | $PACMAN  $pkg || yes | $AUR $pkg 
        fi

    fi

    printf "\n\n"

done

echo




echo "# ──────────────────────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION (manual) | Installing packages not in pacman/yay "
echo "# ──────────────────────────────────────────────────────────────────────────────────────────"

echo "[+] Handling packages/tasks that cannot be directly handles with package manager alone"
yes | $AUR lazydocker        || curl -sSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
yes | $AUR posting           || uv tool install --python 3.13 posting   # fallback

echo "[+] Installing lazyssh..."
# Detect latest version
LATEST_TAG=$(curl -fsSL https://api.github.com/repos/Adembc/lazyssh/releases/latest | jq -r .tag_name)
# Download the correct binary for your system
curl -LJO "https://github.com/Adembc/lazyssh/releases/download/${LATEST_TAG}/lazyssh_$(uname)_$(uname -m).tar.gz"
# Extract the binary
tar -xzf lazyssh_$(uname)_$(uname -m).tar.gz
# Move to /usr/local/bin or another directory in your PATH
sudo mv lazyssh /usr/local/bin/
# enjoy!
# lazyssh

echo "[+] Installing darya..."          # cli alternative to gui-based baobab (https://github.com/GNOME/baobab)
curl -fsSL https://mr.katebzadeh.xyz/tools/darya/install | bash

echo "[+] Installing TPM (tmux plugin manager)..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "[+] Installing tree-sitter-cli..."
rustup default stable
cargo install --locked tree-sitter-cli

echo "[+] Installing basalt (obsidian reader)..."
cargo install basalt-tui

echo "[+] Installing x-cmd..."
eval "$(curl https://get.x-cmd.com)"

echo "[+] Setting default nodejs version to use via npm"

# Source and install node version
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

if command -v nvm >/dev/null; then
    echo "nvm installation suceeded. installing version."
    # echo -e "\t[!] Available nvm versions:"
    # nvm list-remote       # avaiable versions
    echo -e "\t[+] Installing node v22..."
    nvm install v22.17.0  # install a version
    echo -e "\t[+] Installed versions:"
    nvm list              # View installed versions
    echo -e "\t[+] Selecting v22.17"
    nvm use v22.17.0 
fi


echo "[+] Enabling Docker service..."
$SUDO  systemctl enable docker
$SUDO  systemctl start docker



echo "[+] Installing Docker Compose Viewer (dcv)..."
git clone https://github.com/tokuhirom/dcv.git
cd dcv
make build-helpers
go build -o dcv
sudo mv dcv /usr/local/bin/

echo "[+] Installing Yazi bookmarks plugin..."
sudo ya pkg add dedukun/bookmarks

echo "[+] Installing Spotify Player dependencies..."

echo "[+] Installing neohtop-cli..."
$SUDO npm install -g neohtop-cli


# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh
# Set taildrop location
mkdir -p "/home/${CALLING_USER}/Downloads/taildrops" 
$SUDO tailscale file get "/home/${CALLING_USER}/Downloads/taildrops" 
sudo tailscale set --operator=$CALLING_USER




# 1. Modern / recommended (PipeWire + official package)
$PACMAN spotify-player --noconfirm  
$PACMAN libsixel-player --noconfirm  
$PACMAN pavucontrol --noconfirm   # pavucontrol still works via pipewire-pulse

# ────────────────────────────────────────────────
# 2. OR if you insist on PulseAudio backend:
# sudo pacman -S --needed pulseaudio pulseaudio-bluetooth pavucontrol libsixel

# Then (if not using the official package):
# cargo install spotify_player --no-default-features --features pulseaudio-backend,media-control,sixel --force

# 3. Or if you prefer building from source with your chosen features:
#    (most common choice today = gstreamer backend = native PipeWire support)
# cargo install spotify_player --no-default-features --features "gstreamer-backend,media-control,sixel,image,notify,lyric-finder"


# PipeWire check        
if systemctl --user is-active pipewire >/dev/null; then
    yes | $PACMAN pipewire      # libpipewire-0.3-0: PipeWire lib 
fi



echo "# ──────────────────────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION COMPLETE!"
echo "# ──────────────────────────────────────────────────────────────────────────────────────────"


# NOT USING AT THE MOMENT
# $AUR  mssql-tools  # mssql-tools: MS SQL tools, AUR 
# $AUR  aarch64-linux-gnu-gcc  # crossbuild-essential-arm64: ARM cross-compiler, AUR 
# $AUR  tufw  # GUI for ufw
# yes | $PACMAN gvim  # vim-gtk3: GUI vim with GTK/X11 
# $PACMAN zoxide         || $AUR zoxide

# echo "[+] Installing siggy..."
# cargo install siggy
# no longer using - requires signal-cli (https://github.com/AsamK/signal-cli) which has its own dependencies (including java - not worth it)

# User should install informant on their own as it could block other things the script installs
# pacman -S informant       # Read arch news before updating
