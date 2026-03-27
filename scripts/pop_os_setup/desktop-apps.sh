#!/bin/bash

# =========================================================
# 🚀 Pop!_OS Applications Installer (AppImage > APT )
# =========================================================
# Prioritizing AppImages and APT installs but will use flatpak for non-essential apps, apps that aren't easy to automate, and apps that I don't mind having scheduled updates. Snaps are dead to me
# Works on ubuntu-based os really not just Pop!
# Install desktop apps and creates .desktop files for appimages

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# DRY_RUN: Set to 1 to avoid actually installing anything - just see what would get installed
DRY_RUN=${1}

# -----------------------------
# Applications List
# -----------------------------
# Format: [Name|cli_name]="method|cmd;method|cmd"
declare -A apps=(

    ["Brave Browser|brave-browser"]="apt|curl -fsS https://dl.brave.com/install.sh | sh"
    ["Obsidian|obsidian"]="appimage|https://github.com/obsidianmd/obsidian-releases/releases/download/v1.12.4/Obsidian-1.12.4.AppImage"
    ["Steam|steam"]="apt|sudo apt install -y steam"
    ["LibreOffice|libreoffice"]="apt|sudo apt install -y libreoffice"
    ["VLC|vlc"]="apt|sudo apt install -y vlc"
    ["OBS Studio|obs"]="script|placeholder"
    ["Wireshark|wireshark"]="apt|sudo apt install -y wireshark"
    ["Thonny|thonny"]="apt|sudo apt install -y thonny"
    ["Audacity|audacity"]="appimage|https://github.com/audacity/audacity/releases/download/Audacity-3.7.7/audacity-linux-3.7.7-x64-20.04.AppImage;apt|sudo apt install -y audacity"
    ["Postman|postman"]="appimage|https://github.com/suciptoid/postman-appimage/releases/download/continous/Postman-10.12.0-x86_64.AppImage;flatpak|flatpak install flathub com.getpostman.Postman -y"
    ["Signal|signal-desktop"]="script|placeholder"
    ["Wezterm|wezterm"]="script|placeholder"
    ["Docker|docker"]="script|placeholder"
    ["Telegram|Telegram"]="flatpak|flatpak install flathub org.telegram.desktop -y"
    ["Spotify|spotify"]="flatpak|flatpak install flathub com.spotify.Client -y"
                            
)



# I've choosen specific installtion methods for each app that's optimal. 
# Here are some reasons:
    # Brave     - apt | gets updates somewhat frequently
    # Obsidian  - appimage | auto updates itself
    # Steam     - apt | sweet spot with size/updates/performace
    # Telegram  - flatpak | appimage is janky and flatpak is polished
    # etc... (for example, sometimes app images are unavialable or unnofical or apt is old so I'll use flatpak in those cases too)

# -----------------------------
# Variables
# -----------------------------
total=${#apps[@]}
counter=0
failed_apps=()
forced_app="${1}"

# Ensure /opt/Applications exists
if [[ ! -d /opt/Applications/ ]]; then
    sudo mkdir -p /opt/Applications
    sudo chmod 755 /opt/Applications
fi
PATH="/opt/Applications/:$PATH"

echo -e "${YELLOW}=========================================="
echo -e "      Pop!_OS Applications Installer"
echo -e "==========================================${NC}"
sleep 1

# -----------------------------
# Function to create an icon for AppImages
# -----------------------------
get_icon_path() {
    local app_name="$1"
    local icon_dir="$HOME/.local/share/applications/icons"
    local icon_path="${icon_dir}/${app_name}.png"

    [[ ! -d "$icon_dir" ]] && mkdir -p "$icon_dir"

    if [[ -f "$icon_path" ]]; then
        echo "$icon_path"
        return 0
    fi

    local downloaded=false

    case "$app_name" in
        "wezterm")
            wget -q "https://raw.githubusercontent.com/QuantumZenoSix/Dev-Environment/refs/heads/main/assets/icons/wezterm.png" \
                -O "$icon_path" 2>/dev/null && downloaded=true
            ;;
        "brave-browser")
            wget -q "https://raw.githubusercontent.com/QuantumZenoSix/Dev-Environment/refs/heads/main/assets/icons/brave.png" \
                -O "$icon_path" 2>/dev/null && downloaded=true
            ;;
        "obsidian")
            wget -q "https://raw.githubusercontent.com/QuantumZenoSix/Dev-Environment/refs/heads/main/assets/icons/obsidian.png" \
                -O "$icon_path" 2>/dev/null && downloaded=true
            ;;
        "steam")
            wget -q "https://raw.githubusercontent.com/QuantumZenoSix/Dev-Environment/refs/heads/main/assets/icons/steam.png" \
                -O "$icon_path" 2>/dev/null && downloaded=true
            ;;

        "signal-assets")
            wget -q "https://raw.githubusercontent.com/QuantumZenoSix/Dev-Environment/refs/heads/main/assets/icons/signal.png" \
                -O "$icon_path" 2>/dev/null && downloaded=true
            ;;
        "audacity")
            wget -q "https://raw.githubusercontent.com/QuantumZenoSix/Dev-Environment/refs/heads/main/assets/icons/audacity.png" \
                -O "$icon_path" 2>/dev/null && downloaded=true
            ;;
        "postman")
            wget -q "https://raw.githubusercontent.com/QuantumZenoSix/Dev-Environment/refs/heads/main/assets/icons/postman.png" \
                -O "$icon_path" 2>/dev/null && downloaded=true
            ;;
        *)
            echo "${YELLOW}No icon rule for $app_name${NC}" >&2
            return 1
            ;;
    esac

    if $downloaded; then
        echo "$icon_path"
        return 0
    else
        echo "${RED}Failed to download icon for $app_name${NC}" >&2
        return 1
    fi
}
# -----------------------------
# Function to create a .desktop file for AppImages
# -----------------------------
create_desktop_entry() {
    local name="$1"
    local path="$2"
    local cli_name="$3"

    echo "[+] Creating dekstop entry (.desktop) with details: name: >${name}< | path: >${path}< | cli_name: >${cli_name}<"
    local icon_path=$(get_icon_path "$cli_name")
    echo "[+] icon_path: ${icon_path}"

    desktop_file="$HOME/.local/share/applications/${cli_name// /-}.desktop"
    touch $desktop_file
    chmod +x $desktop_file

    echo "[Desktop Entry]
Type=Application
Name=$name
Comment=
Exec=$path
Icon=$icon_path
Terminal=false
Categories=Utility;" | tee $desktop_file

}


# -----------------------------
# Function to install app via script
# -----------------------------
install_script(){
    
    if [[ "${1}" = "signal-desktop" ]]; then
        
        # NOTE: These instructions only work for 64-bit Debian-based
        # Linux distributions such as Ubuntu, Mint etc.

        # 1. Install our official public software signing key:
        wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
        cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

        # 2. Add our repository to your list of repositories:
        wget -O signal-desktop.sources https://updates.signal.org/static/desktop/apt/signal-desktop.sources;
        cat signal-desktop.sources | sudo tee /etc/apt/sources.list.d/signal-desktop.sources > /dev/null

        # 3. Update your package database and install Signal:
        sudo apt update && sudo apt install signal-desktop

    elif [[ "${1}" = "proton-apps" ]]; then

        # TBD - Will use browser extensions for now
        #
        # Add Flathub (skip if already added)
        # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        # (Requires NetworkManager-openvpn and a keyring like GNOME Keyring or KWallet for credential storage.)
        # ["ProtonVPN|proton-vpn"]="flatpak |flatpak install flathub com.protonvpn.www"
        # ["ProtonPass|proton-pass"]="flatpak |flatpak install flathub me.proton.Pass"
        echo "Skipping..."

    elif [[ "${1}" = "obs-studio" ]]; then

        # Optional dependencies
        sudo apt install ffmpeg v4l2loopback-dkms -y
        
        # Official OBS PPA Repo
        sudo add-apt-repository ppa:obsproject/obs-studio
        # sudo add-apt-repository ppa:appimagelauncher-team/daily


        sudo apt update
        sudo apt install obs-studio -y


    elif [[ "${1}" = "wezterm" ]]; then

        curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
        chmod +x WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
        sudo mv ./WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage /opt/Applications/wezterm

        create_desktop_entry "Wezterm" "/opt/Applications/wezterm" "wezterm"

    elif [[ "${1}" = "docker" ]]; then

        # Add Docker's official GPG key:
        sudo apt update
        sudo apt install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

        sudo apt update
        sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        sudo systemctl status docker

    fi

}


# -----------------------------
# Function to install app
# -----------------------------
install_app() {
    local identifier="$1"
    local priority="$2"
    local installed=false
    local name="${identifier%%|*}"
    local cli_name="${identifier#*|}"

    if [[ ! -z "${forced_app}" && "${forced_app}" != "$cli_name" ]]; then
        echo "Forcing is enabled, skipping $cli_name"
        return
    fi

    if command -v $cli_name 2>/dev/null; then
        echo -e "${GREEN}[+] $name is already installed${NC}"
        return
    else
        # Check if installed via flatpak
        packed_flat=$(flatpak list | grep -i "$name" | wc -l)

        if [[ $packed_flat -gt 0 ]]; then
            echo "${GREEN}[+] $name is already installed (via flatpak)${NC}"
            return
        else
            echo "${YELLOW}[-] $name is NOT installed, installing...${NC}"
        fi
    fi


    local methods_tried=

    IFS=';' read -ra methods <<< "$priority"
    for method in "${methods[@]}"; do
        type="${method%%|*}"
        cmd="${method#*|}"

        echo "[+] ID: $identifier | name: $name | cli_name: $cli_name | type: $type | cmd: $cmd"

        if [[ $DRY_RUN -gt 0 ]]; then
            continue 
        fi
        
        case $type in
            appimage)
                methods_tried+="($type) "
                # file_name="${cmd##*/}"
                file_name="$cli_name"
                target_path="/opt/Applications/$file_name"
                echo -e "${YELLOW}Downloading $name AppImage to $target_path ...${NC}"

                sudo wget -q "$cmd" -O "$target_path"

                if [[ -s $target_path ]]; then
                    sudo chmod +x "$target_path"
                    installed=true
                    # # create desktop entry
                    create_desktop_entry "$name" "$target_path" "$cli_name"
                    break
                fi
                ;;
            apt)
                echo -e "${YELLOW}Installing $name via APT...${NC}"
                eval "$cmd"

                if command -v $cli_name >/dev/null 2>&1; then
                    installed=true
                    break
                fi
                ;;
            aptdeb)
                echo -e "${YELLOW}Installing $name via APT...${NC}"

                target_path="$cli_name.deb"
                sudo wget -q "$cmd" -O $target_path
                echo "[-] target_path: $target_path"

                sudo apt install $target_path -y

                if command -v $cli_name >/dev/null 2>&1; then
                    installed=true
                    break
                fi
                ;;
            flatpak)
                echo -e "${YELLOW}Installing $name via Flatpak...${NC}"
                if eval "$cmd" &>/dev/null; then
                    installed=true
                    break
                fi
                ;;
            script)
                echo -e "${YELLOW}Installing $name via script...${NC}"

                install_script "$cli_name"

                if command -v $cli_name >/dev/null 2>&1; then
                    installed=true
                    break
                fi
                ;;

        esac
    done

    echo -e "${YELLOW}[$((counter+1))/$total] $name installation attempt done.${NC}"

    if [ "$installed" = true ]; then
        echo -e "${GREEN}[✓] $name installed successfully (or attempted)${NC}"
    else
        echo -e "${RED}[✗] $name may not have installed properly.${NC}"
        failed_apps+=("$name | $methods_tried")
    fi

    percent=$(( (counter + 1) * 100 / total ))
    echo -e "${YELLOW}Progress: $percent%${NC}"
    echo "------------------------------------------"
    ((counter++))
}

# -----------------------------
# Main Loop
# -----------------------------
sudo apt update
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


for app in "${!apps[@]}"; do
    install_app "$app" "${apps[$app]}"
done

# -----------------------------
# Summary
# -----------------------------
echo -e "${YELLOW}==========================================${NC}"
if [ ${#failed_apps[@]} -eq 0 ]; then
    echo -e "${GREEN}All applications installed successfully!${NC}"
else
    echo -e "${RED}The following applications may not have installed properly:${NC}"
    for app in "${failed_apps[@]}"; do
        echo -e "${RED}- $app${NC}"
    done
fi
echo -e "${YELLOW}==========================================${NC}"




# Rebuild the user .desktop database (very often helps)
update-desktop-database ~/.local/share/applications




# Currently no working - need to find a way to redo, though these aren't important so I have no problem doing these manually until I can automate these later.

#    ["Balena Etcher|balena-etcher"]="aptdeb|https://github.com/balena-io/etcher/releases/download/v2.1.4/balena-etcher_2.1.4_amd64.deb"


