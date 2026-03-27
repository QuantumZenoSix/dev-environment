#!/usr/bin/env bash

# CachyOS Post-Install Recommended Tasks Script
# Run with: bash this_script.sh   (or make executable: chmod +x script.sh && ./script.sh)
# Review each section before running!
# Contains installations for desktop/gaming apps as well as gaming optimizations/checks

# set -euo pipefail
# commented the above out - living on the edge 

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"



echo "============================================================="
echo " CachyOS Post-Install Setup Script"
echo "============================================================="
echo "Current date: $(date)"
echo "This will:"
echo "  - Update the full system"
echo "  - Re-run hardware detection (chwd) for GPU drivers"
echo "  - Install common useful packages / codecs / fonts"
echo "  - Set up basic firewall (ufw)"
echo "  - Install gaming meta-packages (optional)"
echo "  - Some performance/QoL tweaks"
echo ""
read -p "Press Enter to continue (or Ctrl+C to cancel) ..."



echo -e "${GREEN}=========================================="
echo -e " Full system update "
echo -e "==========================================${NC}"
sleep 1

echo -e "Updating the system (pacman -Syu) ..."
sudo pacman -Syu --noconfirm

echo -e "${GREEN}=========================================="
echo -e " Hardware detection → ensures correct GPU drivers (NVIDIA/AMD/Intel) "
echo -e "==========================================${NC}"
sleep 1
#    chwd -a is safe to run again; it usually does nothing if already configured
echo -e "Running CachyOS hardware detection (chwd) for drivers ..."
sudo chwd -a

# Quick GPU status check (informational)
echo -e "\nGPU / driver quick check:"
lspci -k | grep -EA3 'VGA|3D|Display' || true
glxinfo | grep "OpenGL renderer" || echo "glxinfo not found yet"

# For NVIDIA users — extra check/fix if proprietary driver seems missing
# if lspci | grep -i nvidia >/dev/null; then
#     echo -e "\nNVIDIA GPU detected → checking proprietary driver status ..."
#     if ! pacman -Qs nvidia >/dev/null; then
#         echo "→ Proprietary NVIDIA driver not found. Installing stable branch via chwd..."
#         sudo chwd -i nvidia  # or try: sudo chwd -i nvidia-open  (newer cards)
#         sudo mkinitcpio -P
#     else
#         echo "→ NVIDIA packages appear to be installed."
#     fi
# fi
# COMMENTED THE ABOVE OUT - SHOULD WORK BUT RISKY

echo -e "${GREEN}=========================================="
echo -e " Common useful packages: codecs, fonts, firmware, utilities "
echo -e "==========================================${NC}"
sleep 1

echo -e "Installing common packages (codecs, fonts, firmware, tools) ..."
sudo pacman -S --needed --noconfirm \
    ttf-ms-fonts noto-fonts-emoji \
    vulkan-icd-loader libva-vdpau-driver libva-utils \
    ffmpeg ffmpegthumbnailer gst-plugin-pipewire gst-plugins-{good,bad,ugly} \
    linux-firmware intel-ucode amd-ucode \
    networkmanager network-manager-applet \
    ufw gufw \
    bash-completion fish zsh \
    lm-sensors tlp tlp-rdw \
    git base-devel paru   # paru AUR helper is usually already there, but ensure

# Optional: extra Intel/AMD GPU media packages (chwd often installs these already)
sudo pacman -S --needed --noconfirm intel-media-driver intel-media-sdk onevpl-intel-gpu || true

echo -e "${GREEN}=========================================="
echo -e " Common useful GUI/desktop applications: Spotify, Discord, LibreOffice, etc "
echo -e "==========================================${NC}"
sleep 1

sudo pacman -S --needed --noconfirm steam libreoffice-fresh vlc obs-studio wireshark-qt thonny audacity mpv signal-desktop docker discord libreoffice-fresh gimp inkscape brave-bin

paru --needed --noconfirm -S obsidian-bin wezterm-bin telegram-desktop postman-bin spotify 

echo -e "${GREEN}=========================================="
echo -e " Firewall setup (ufw) — simple + enable "
echo -e "==========================================${NC}"
sleep 1

echo -e "Setting up ufw firewall (allow ssh if needed) ..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
# Uncomment if you use SSH (incoming into your machine):
# sudo ufw allow ssh

sudo ufw --force enable
sudo systemctl enable --now ufw

echo -e "${GREEN}=========================================="
echo -e " Gaming packages (very common on CachyOS) "
echo -e "==========================================${NC}"
sleep 1

read -p "Install gaming meta-packages (cachyos-gaming-meta + applications)? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "Installing gaming packages ..."
    sudo pacman -S --needed --noconfirm cachyos-gaming-meta cachyos-gaming-applications
    # Optional extras many gamers want
    sudo pacman -S --needed --noconfirm mangohud goverlay gamemode vkbasalt gamescope
fi

# ─────────────────────────────────────────────────────────────────────
# Winetricks (helps with DLLs, fonts, old DirectX in Wine/Lutris/Bottles)
# ─────────────────────────────────────────────────────────────────────
echo -e "\n→ Installing winetricks (available in repos)..."
sudo pacman -S --needed --noconfirm winetricks

# Quick tip

echo "   → Usage example: winetricks corefonts vcrun2019 dxvk    (run inside a Wine prefix or via Lutris/Bottles GUI)"

# ─────────────────────────────────────────────────────────────────────
# Flatpak setup + Flathub (safe to run multiple times)
# ─────────────────────────────────────────────────────────────────────
echo -e "\n→ Enabling Flatpak and adding Flathub repo (if not present)..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# ─────────────────────────────────────────────────────────────────────
# Optional: Flatpak gaming launchers/tools
# (Lutris & Heroic often come from cachyos-gaming-meta, but Flatpak versions are popular for sandboxing)
# Bottles & Gamescope are commonly added via Flatpak
# ─────────────────────────────────────────────────────────────────────
read -p "Install Flatpak versions of Lutris, Heroic, Bottles, and Gamescope? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n→ Installing Flatpak gaming apps..."
    flatpak install -y --noninteractive flathub com.usebottles.bottles || echo "→ Some may already be installed or skipped."

    # Optional: Extra Flatpak Vulkan layer for Gamescope in Heroic/Lutris (helps with integration)
    flatpak install -y --noninteractive flathub org.freedesktop.Platform.VulkanLayer.gamescope || true
fi


echo -e "${GREEN}=========================================="
echo -e "Optional Tools "
echo -e "==========================================${NC}"
sleep 1


# ─────────────────────────────────────────────────────────────────────
# Optional: Virtualization stack (qemu + virt-manager) for VMs / future GPU passthrough
# ─────────────────────────────────────────────────────────────────────
read -p "Install virt-manager + qemu-full + libvirt (for virtual machines, GPU passthrough experiments)? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n→ Installing virtualization packages..."
    sudo pacman -S --needed --noconfirm \
        qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs swtpm \
        libvirt edk2-ovmf

    # Basic setup (follow CachyOS wiki for full GPU passthrough)
    echo "→ Enabling libvirt service..."
    sudo systemctl enable --now libvirtd

    echo "→ Adding current user to libvirt group (re-login or reboot needed after)..."
    sudo usermod -aG libvirt "$(whoami)"

    echo "→ Optional: For Windows 11 VMs, add emulated TPM later in virt-manager."
    echo "   Check CachyOS wiki: https://wiki.cachyos.org/virtualization/qemu_and_vmm_setup"
fi



echo -e "${GREEN}=========================================="
echo -e " Optional QoL / performance tweaks "
echo -e "==========================================${NC}"
sleep 1


echo -e "Some optional tweaks ..."
# Enable AppArmor if not already (security)
sudo systemctl enable --now apparmor || true

# Snapper + pacman hook for snapshots is usually already set up on CachyOS
# But confirm btrfs snapper if using btrfs
if df -T / | grep -q btrfs; then
    sudo pacman -S --needed --noconfirm snapper snap-pac
    echo "→ btrfs detected — snapper should already be configured via CachyOS defaults"
fi

# TLP for laptops (power saving)
if [ -d /sys/class/power_supply ]; then
    echo -e "\nEnabling TLP for laptop power management..."
    sudo systemctl enable --now tlp tlp-rdw
fi

# lm-sensors config (run sensors-detect interactively if needed)
echo -e "\nlm-sensors: Run 'sudo sensors-detect' for full hardware monitoring setup (answer yes to most prompts)."
echo -e "\nFor tlp, it auto-starts on laptops; check status with 'tlp-stat -s'."


echo -e "${GREEN}=========================================="
echo -e "Final update + mkinitcpio rebuild (just in case)"
echo -e "==========================================${NC}"
sleep 1


echo -e "Final system update & initramfs rebuild ..."
sudo pacman -Syu --noconfirm
sudo mkinitcpio -P

echo -e "\n============================================================="
echo "Done! Reboot recommended → sudo reboot"
echo "After reboot:"
echo "  • Check GPU: nvidia-smi (NVIDIA) | glxinfo | grep renderer"
echo "  • Use CachyOS Hello / Package Installer for more GUI-based apps"
echo "  • Wiki: https://wiki.cachyos.org/configuration/post_install_setup"
echo "  • Forum: https://discuss.cachyos.org"
echo "Enjoy CachyOS! 🚀"


