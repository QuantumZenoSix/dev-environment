#!/bin/bash
# General system maintenance for CachyOS (Arch-based)
# Run as normal user; uses sudo when needed
# Focuses on updates, cleanup, firmware, TRIM, etc.
# No forced reboots or recovery partition stuff
# set -euo pipefail  # Exit on errors, unset vars, pipe failures

echo "=== CachyOS Housekeeping Script ==="
echo "Handles updates (pacman + AUR via paru), cleanup, firmware, TRIM, codecs, etc."
echo "Run periodically (weekly is fine). No automatic security-only updates like Ubuntu."
echo ""

# ────────────────────────────────────────────────
echo "1. Refresh keyring & Full system + AUR update"
echo "─────────────────────────────────────────────────"
# Refresh Arch/Cachy keyring first (important on rolling releases)
sudo pacman -Sy --needed archlinux-keyring cachyos-keyring
# Update everything (pacman repos + AUR packages via paru)
paru -Syu --needed || echo "→ Update completed or nothing to do."

# ────────────────────────────────────────────────
echo "2. Install common media codecs (for mp3, h264, etc.)"
echo "─────────────────────────────────────────────────"
# PipeWire is default; install codec packages if needed
sudo pacman -S --needed gst-plugins-good gst-plugins-bad gst-plugins-ugly \
    gstreamer-vaapi libavcodec-freeworld ffmpeg ffmpegthumbs || echo "→ Already installed or skipped."

# ────────────────────────────────────────────────
echo "3. Update Flatpaks (including runtimes)"
echo "─────────────────────────────────────────────────"
flatpak update -y --appstream
flatpak update -y || echo "→ Flatpak update skipped or nothing to do."


# ────────────────────────────────────────────────
echo "4. Enable periodic TRIM for SSD/NVMe (longevity & performance)"
echo "─────────────────────────────────────────────────"
# Usually already enabled on CachyOS/Arch, but ensure it
sudo systemctl enable --now fstrim.timer || echo "→ TRIM timer already enabled or active."
# Optional: one-time manual trim (can take time)
# sudo fstrim -av || echo "→ Manual TRIM skipped or not needed."

# ────────────────────────────────────────────────
echo "5. Deeper cleanup (pacman cache, orphans, journal, thumbnails, etc.)"
echo "─────────────────────────────────────────────────"
# Install paccache if missing (from pacman-contrib)
sudo pacman -S --needed pacman-contrib

# Clean pacman cache: keep last 3 versions of each package (very safe default)
sudo paccache -r || echo "→ Cache cleanup done."
# Remove old cached versions more aggressively if desired: sudo paccache -ruk0

# Remove orphaned packages (no prompt)
paru -Rns $(paru -Qdtq) 2>/dev/null || echo "→ No orphans to remove."

# Limit journal size (prevents /var/log growing forever)
sudo journalctl --vacuum-time=8weeks
sudo journalctl --vacuum-size=500M

# Clear thumbnail cache (can grow large)
rm -rf ~/.cache/thumbnails/* || true

echo "→ Deep cleanup done."

# ────────────────────────────────────────────────
echo "6. Refresh font cache & re-detect hardware"
echo "─────────────────────────────────────────────────"
sudo fc-cache -fv
sudo mkinitcpio -P || echo "→ mkinitcpio update skipped (not always needed after housekeeping)."

# Optional: Rank mirrors if you notice slow downloads (Cachy has a tool)
# sudo cachyos-rate-mirrors  # uncomment if you want this every time


# ────────────────────────────────────────────────
echo ""
echo "=== Housekeeping Complete! ==="
echo ""
echo "Recommended next steps:"
echo " • Reboot now if kernel/firmware updated → sudo reboot"
echo " • Check for .pacnew files: find /etc -name '*.pacnew'"
echo "   → Merge them manually with pacdiff or similar if any exist"
echo " • Run 'paru' alone sometimes to review AUR updates interactively"
echo ""
echo "Optional manual checks:"
echo " • TRIM status: systemctl status fstrim.timer"
echo " • Firmware second pass (if needed): sudo fwupdmgr update"
echo " • NVIDIA check (if you have one): nvidia-smi"
echo ""

read -p "Would you like to reboot now? (y/N): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    sudo reboot
fi


