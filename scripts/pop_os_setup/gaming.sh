#!/usr/bin/env bash

# ================================================================
# Pop!_OS Gaming Setup Script (2025–2026 edition)
# Installs: Steam, Lutris, Heroic, Bottles, ProtonUp-Qt, MangoHud,
#           GameMode, Goverlay, vkBasalt, Gamescope, codecs, Winetricks,
#           OBS Studio, and a few nice-to-haves.
#
# Features:
#   - System update first
#   - Restricted codecs for video playback in games/browsers
#   - Performance tools (GameMode auto-activates on launch)
#   - Overlays & monitoring (MangoHud + Goverlay GUI)
#   - Launchers for non-Steam stores (Epic, GOG, Battle.net, etc.)
#   - Wine/Proton manager (ProtonUp-Qt)
#   - Optional extras: vkBasalt (shaders), Gamescope (compositor)
#
# How to run:
#   1. Save as e.g. gaming-setup.sh
#   2. chmod +x gaming-setup.sh
#   3. ./gaming-setup.sh
# ================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

echo "================================================================"
echo " Pop!_OS Gaming Setup — Starting..."
echo "================================================================"

# ─────────────────────────────────────────────────────────────────────
# 1. Update the system first — always good practice
# ─────────────────────────────────────────────────────────────────────
echo "→ Updating package lists and upgrading installed packages..."
sudo apt update && sudo apt full-upgrade -y
sudo apt autoremove -y

# ─────────────────────────────────────────────────────────────────────
# 2. Install multimedia codecs (for in-game videos, browsers, etc.)
# ─────────────────────────────────────────────────────────────────────
echo "→ Installing restricted multimedia codecs..."
sudo apt install -y ubuntu-restricted-extras

# ─────────────────────────────────────────────────────────────────────
# 3. Core gaming performance & monitoring tools (apt)
# ─────────────────────────────────────────────────────────────────────
echo "→ Installing GameMode, MangoHud, Goverlay, vkBasalt..."
sudo apt install -y \
    gamemode \
    mangohud \
    goverlay \
    vkbasalt

# Optional: 32-bit MangoHud support (helps some older/OpenGL games)
# sudo apt install -y mangohud:i386

pipx install protonup

# ─────────────────────────────────────────────────────────────────────
# 4. Flatpak setup — many gaming tools are best as Flatpaks
# ─────────────────────────────────────────────────────────────────────
echo "→ Enabling Flatpak (if not already) and adding Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# ─────────────────────────────────────────────────────────────────────
# 5. Install main gaming launchers & tools via Flatpak
# ─────────────────────────────────────────────────────────────────────
echo "→ Installing Flatpak versions of key gaming apps..."
flatpak install -y --noninteractive flathub \
    net.lutris.Lutris \
    com.heroicgameslauncher.hgl \
    com.usebottles.bottles \


# Note: Steam/OBS/Proton-GE/MangoHud are best installed natively

# Optional: Gamescope (great for nested sessions, scaling, HDR, etc.)
flatpak install -y --noninteractive flathub com.valvesoftware.Steam.Utility.gamescope

# ─────────────────────────────────────────────────────────────────────
# 6. Winetricks (helps install DLLs, fonts, old DirectX for Wine/Lutris/Bottles)
# ─────────────────────────────────────────────────────────────────────
echo "→ Installing Winetricks..."
sudo apt install -y winetricks

# ─────────────────────────────────────────────────────────────────────
# 7. Optional: Extra utilities many gamers add
# ─────────────────────────────────────────────────────────────────────
echo "→ Installing nice-to-have extras..."
sudo apt install -y \
    qemu-kvm libvirt-clients libvirt-daemon-system virt-manager bridge-utils  # For looking into GPU passthrough later

# ─────────────────────────────────────────────────────────────────────
# 8. Final cleanup & hints
# ─────────────────────────────────────────────────────────────────────
echo "→ Cleaning up..."
sudo apt autoremove -y
flatpak update -y

echo ""
echo "================================================================"
echo " Setup complete! 🎮"
echo ""
echo "Next steps you should do manually:"
echo " 1. Launch ProtonUp-Qt (search 'ProtonUp-Qt') → install latest Proton-GE"
echo "    (also Wine-GE if you use Lutris/Bottles a lot)"
echo " 2. In Steam → Settings → Steam Play → Enable for all titles"
echo " 3. Add MangoHud to games: right-click game → Properties → Launch Options:"
echo "       mangohud %command%"
echo "    Or use Goverlay to configure globally/per-game"
echo " 4. For max performance: add 'gamemoderun %command%' in launch options"
echo "    (or both: gamemoderun mangohud %command%)"
echo " 5. Lutris / Heroic: log into Epic/GOG/etc. and install games"
echo " 6. Optional: vkBasalt for ReShade-like effects (config ~/.config/vkBasalt/vkBasalt.conf)"
echo ""
echo "Enjoy gaming on Pop!_OS "
echo "================================================================"
