#!/bin/bash
# General system maintenance only - no third-party apps beyond essentials
# Run as normal user; uses sudo when needed
# Works on ubuntu-based os really not just Pop!

set -euo pipefail  # Exit on errors, unset vars, pipe failures

echo "=== Pop!_OS Housekeeping - Enhanced Version ==="
echo "This will handle updates, cleanup, drivers/firmware, codecs, and basic optimizations."
echo ""

# ────────────────────────────────────────────────
echo "1. Full system update & upgrade"
echo "─────────────────────────────────────────────────"
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove --purge -y
sudo apt autoclean
rustup update stable

# ────────────────────────────────────────────────
echo "2. Install common media codecs (for mp3, h264, etc.)"
echo "─────────────────────────────────────────────────"
# This is the standard restricted extras package on Ubuntu-based systems like Pop!_OS
sudo apt install -y ubuntu-restricted-extras || echo "→ Already installed or skipped."

# ────────────────────────────────────────────────
echo "3. Update Flatpaks (including runtimes)"
echo "─────────────────────────────────────────────────"
flatpak update -y --appstream
flatpak update -y

# ────────────────────────────────────────────────
echo "4. Firmware / hardware updates"
echo "─────────────────────────────────────────────────"
#sudo fwupdmgr refresh --force
#sudo fwupdmgr get-updates
#sudo fwupdmgr update -y || echo "→ Firmware update may need reboot or manual step."
# This tends to interrupt script - run this step as needed at the end
echo "[-] Skipping..."

# ────────────────────────────────────────────────
echo "5. Update Pop!_OS recovery partition"
echo "─────────────────────────────────────────────────"
pop-upgrade recovery upgrade from-release || echo "→ Recovery update skipped (maybe already current)."

# ────────────────────────────────────────────────
echo "6. Enable periodic TRIM for SSD/NVMe (longevity & performance)"
echo "─────────────────────────────────────────────────"
sudo systemctl enable fstrim.timer --now || echo "→ TRIM already enabled."

# ────────────────────────────────────────────────
echo "7. Enable unattended security updates"
echo "─────────────────────────────────────────────────"
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

# ────────────────────────────────────────────────
echo "8. Deeper cleanup (old kernels, logs, thumbnail cache, etc.)"
echo "─────────────────────────────────────────────────"
# Limit journal size (prevents /var/log growing forever)
sudo journalctl --vacuum-time=4weeks
sudo journalctl --vacuum-size=250M

# Clear thumbnail cache (can grow large over time)
rm -rf ~/.cache/thumbnails/*

echo "→ Deep cleanup done."

# ────────────────────────────────────────────────
echo "9. Refresh font cache & re-detect hardware"
echo "─────────────────────────────────────────────────"
sudo fc-cache -fv
sudo update-initramfs -u  # Helpful after driver/firmware updates

# ────────────────────────────────────────────────
echo ""
echo "=== Housekeeping Complete! ==="
echo ""
echo "Recommended next steps:"
echo "  • Reboot now → sudo reboot"
echo "  • After reboot, optionally run again to catch anything new"
echo "  • Check for remaining updates:   apt list --upgradable"
echo "  • Firmware second pass (if needed): sudo fwupdmgr update"
echo ""
echo "Optional manual checks:"
echo "  • Timezone/locale correct?      timedatectl"
echo "  • NVIDIA installed if needed?   nvidia-smi   (only if you have NVIDIA GPU)"
echo ""

read -p "Would you like to reboot now? (y/N): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo reboot
fi

read -p "Since we're not reboting, want to update the firmware? (y/N): " answer2
if [[ "$answer2" =~ ^[Yy]$ ]]; then
    sudo fwupdmgr refresh --force
    sudo fwupdmgr get-updates
    sudo fwupdmgr update -y || echo "→ Firmware update may need reboot or manual step."
fi
