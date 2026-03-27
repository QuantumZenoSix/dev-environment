#!/usr/bin/env bash

# ______________________________________________________________________________
#                                                                               |
#                                                                               |
#   There's sometimes a brightness issues on Pop! OS                            |
#   This script should resolve it: https://github.com/pop-os/pop/issues/2227    |
#                                                                               |
# ______________________________________________________________________________|

# ___________  Run these steps first if not already ________
# Add your user to the video group:                         |
# sudo usermod -a -G video $USER                            |
#                                                           |
# Istall inotify-tools                                      |
# sudo apt install inotify-tools                            |
#                                                           |
# Add to cron                                               |
# @reboot /home/someone/script.sh                           |
#                                                           |
# __________________________________________________________|



path=/sys/class/backlight/nvidia_0

inotifywait -q -m -e close_write $path |
while read -r actual_brightness event; do
    # echo "brightness event"
   brightness_var=$(expr $(expr $(cat $path/actual_brightness) \* 255) / 100)
   echo $brightness_var > /sys/class/backlight/amdgpu_bl0/brightness
done


# Alternativly you can try this to set a %: 
# https://github.com/Hummer12007/brightnessctl
# Run: ./brightnessctl -d 'nvidia_0'  s 50%

