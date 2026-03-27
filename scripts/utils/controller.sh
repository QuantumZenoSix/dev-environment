#!/bin/sh
# Installation of packages and copying of config files

# set -euo pipefail  # safer bash scripting

INSTALL_TYPE=$1
INSTALL_SUBTYPE=$2
OPTION=$3

CALLING_USER=$(whoami)

# Maintain user's home (even if calling with sudo)
HOME=$(getent passwd "$CALLING_USER" | cut -d: -f6)

SUDO=""

# if not root, run as sudo
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
    printf "[+] Not running as root - adding sudo\n"
else
    printf "[+] Running as root\n"
fi

# Set pwd to project root ($0)
# cd $(dirname "$0") && cd ../ && cd ../ && pwd || exit

# Set pwd to root
cd ~/.config/home-manager

# Install latest
if [ -d ./Dev-Environment/ ]; then
    echo "Found Dev-Environment. Re-cloning..."
    $SUDO rm -rf ./Dev-Environment
fi

# ────────────────────────────────────────────────
#             Distro Detection
# ────────────────────────────────────────────────

if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
else
    echo "Error: /etc/os-release not found — cannot reliably detect distribution"
    exit 1
fi

# Normalize to lower case and check family
ID_LIKE="${ID_LIKE:-$ID}"
ID_LIKE=$(echo "$ID_LIKE" | tr '[:upper:]' '[:lower:]')

if echo "$ID_LIKE" | grep -q -E 'debian|ubuntu|pop|linuxmint|zorin'; then
    DISTRO_FAMILY="debian"
    PKG_MANAGER="apt"
    echo "[+] Detected Debian-based system (using apt)"
elif echo "$ID" "$ID_LIKE" | grep -q -E 'fedora|nobara|rhel|centos|rocky|almalinux'; then
    DISTRO_FAMILY="fedora"
    PKG_MANAGER="dnf"
    echo "[+] Detected Fedora-based / RPM-based system (using dnf)"
elif echo "$ID" "$ID_LIKE" | grep -q -E 'arch|cachy'; then
    DISTRO_FAMILY="arch"
    PKG_MANAGER="pacman"
    echo "[+] Detected Arch-based (using pacman)"
else
    echo "Error: Unsupported distribution."
    echo "       Detected ID=$ID  ID_LIKE=$ID_LIKE"
    echo "       This script currently supports only Debian-family, Arch,  and Fedora-family systems."
    exit 1
fi

sync_nvim_files(){

    echo "[+] Copying Vim/Neovim files..."
    if [ -d $HOME/.config/nvim/ ]; then
        mkdir -p $HOME/.config/nvim
    fi

    # [.config] If backup folder exists remove it so we can overwrite it
    if [ -d $HOME/.config/nvim-backup ]; then
        rm -rf $HOME/.config/nvim-backup
    fi

    # Save copy of any existing nvim files in case we need to restore
    [ -d "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$HOME/.config/nvim-backup"

    # Copy nvim files
    cp -v -r ./dotfiles/.config/nvim  $HOME/.config/

    # [.local files (nvim cache) ] If backup folder exists move it so we can restore if needed and so that it leaves the .local dir empty to empty the cache
    [ -d "$HOME/.local/share/nvim-backup" ] && rm -rf "$HOME/.local/share/nvim-backup"
    [ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim-backup"

    echo "[+] Nvim files copied!"

    # Vim
    cp -f -v ./dotfiles/.vimrc  $HOME/

    echo "[+] Vim files copied!"
    echo

}
set_login_shell_zsh(){


    if which zsh >/dev/null 2>&1; then

        current_shell=$(getent passwd "$USER" | cut -d: -f7 || echo "")

        case "$current_shell" in
            *zsh)
                echo "→ Login shell is already zsh – no change needed"
                ;;
            *)
                echo "[+] Current login shell: ${current_shell:-not found}"
                echo "[+] Changing login shell to zsh... (may prompt for password)"
                
                if chsh -s "$(command -v zsh)"; then
                    echo "→ Login shell updated (takes effect in new sessions)"
                else
                    echo "→ chsh failed – try running it manually"
                fi
                ;;
        esac

        # Don't open new zsh shell
        # if [ "${INSTALL_SUBTYPE}" != "noupdateshellenv" -a "${INSTALL_SUBTYPE}" != "os-pop" ]; then
        #     zsh
        # fi

    fi

}

install_oh_my_zsh_and_powerline(){

    # 'noupdateshellenv' means we're just updating our local files - no need to install ohmyzsh/fonts/powerline
    if [ "${INSTALL_SUBTYPE}" != "noupdateshellenv" ]; then

        # Install fonts
        printf "[+] Installing fonts..."
        unzip -o ./fonts/JetBrainsMonoNerdFont-REGULARFONTSONLY.zip  -d ./fonts/
        sudo cp ./fonts/*.ttf /usr/share/fonts/truetype/

        if command -v zsh &> /dev/null
        then

            # This removes powerline (since powerline install in ~/.oh-my-zsh) so make sure this is before powerline install
            if [ -d $HOME/.oh-my-zsh ]; then
                rm -rf $HOME/.oh-my-zsh
            fi

            printf "[+] Installing oh-my-zsh...\n\n"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

            # If powerline isn't installed, oh-my-zsh+powerline should be installed for installed for good measure - and shell updated
            if [ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k/ ]; then

                printf "[+] Installing powerlevel10k...\n\n"
                git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
                # sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
            
            fi

        fi

    fi
}
copy_config_files(){

    echo "# ────────────────────────────────────────────────"
    echo "#        CONFIG INSTALLATION "
    echo "# ────────────────────────────────────────────────"

    PWD=$(pwd)
    printf "[+] Home: $HOME | PWD: $PWD\n"

    # # Sync local config files with cloned repo so i can push up my changes
    cp -f -v ./dotfiles/.bash_aliases  $HOME/
    cp -f -v ./dotfiles/.bash_git  $HOME/
    cp -f -v ./dotfiles/.bash_pbx  $HOME/
    cp -f -v ./dotfiles/.bash_utils  $HOME/
    cp -f -v ./dotfiles/.bashrc  $HOME/
    cp -f -v ./dotfiles/.p10k.zsh  $HOME/
    cp -f -v ./dotfiles/.tmux.conf  $HOME/
    cp -f -v ./dotfiles/.vimrc  $HOME/
    cp -f -v ./dotfiles/.zshrc   $HOME/
    cp -f -v ./dotfiles/.zsh_customizations  $HOME/
    cp -f -v ./dotfiles/.tmux_init.sh  $HOME/
    cp -f -v ./dotfiles/.wezterm.lua  $HOME/

    # __________ Spotify-player ___________
    if [ ! -d $HOME/.config/spotify-player/ ]; then
        mkdir -p $HOME/.config/spotify-player
    fi
    cp -v -r ./dotfiles/.config/spotify-player  $HOME/.config/

    cp -v -f -r ./dotfiles/.config/lazygit  $HOME/.config/


    # ---------------------------------------------------------------------
    # Copy starship profile
    cp -v -f -r ./dotfiles/.config/starship.toml  $HOME/.config/

    # Copy Yazi config
    cp -v -f -r ./dotfiles/.config/yazi  $HOME/.config/

    # Install custom shell scripts and exes
    sudo cp -v -f -r ./usr_local_bin/* /usr/local/bin/

    install_oh_my_zsh_and_powerline

    # Installing oh-my-zsh can wipe out our ~/.zshrc - let's copy it over again in case
    cp -v ./dotfiles/.zshrc   $HOME/

    echo "[+] Configuration files copied!"


}


setup_nix(){

    # This installs Nix in multi-user mode (recommended for security and reproducibility) and runs non-interactively
    curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes

    # Enable experimental features (user-level)
    mkdir -p ~/.config/nix

    if ! grep -q '^experimental-features' ~/.config/nix/nix.conf 2>/dev/null ; then
        echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
    fi


    if [ ! -s ~/.config/home-manager/home.nix ]; then
        echo "Cannot find home flake, prinring ~/.config/home-manager contents"
        echo "pwd: "
        pwd
        ls -hal ~/.config/home-manager
    else
        # Replace flakes with proper username
        sed -i "s:REPLACETHISUSERNAME:${CALLING_USER}:g" ~/.config/home-manager/flake.nix
        sed -i "s:REPLACETHISUSERNAME:${CALLING_USER}:g" ~/.config/home-manager/home.nix
    fi

    # Stage everything and reload nix stuff
    git add flake.nix home.nix
    sudo systemctl daemon-reload
    sudo systemctl enable nix-daemon.socket
    sudo systemctl start nix-daemon.socket
    sudo systemctl restart nix-daemon
    sudo systemctl status nix-daemon.service

    install_oh_my_zsh_and_powerline

    [[ -f ~/.bashrc ]] && rm ~/.bashrc
    [[ -f ~/.zshrc ]] && rm ~/.zshrc

    # Create a ~/.zshrc which only starts home-manager - loading a new shell will trigger it
    cat >  ~/.zshrc<< 'EOF'
if [ -s /tmp/started_home_manager ]; then
    echo "→ After loading a new shell run 'nix run github:nix-community/home-manager -- init --switch -b backup --flake .#${USER}' to activate home-manager"
else
    touch /tmp/started_home_manager
    cd ~/.config/home-manager/
    git add -A
    nix run github:nix-community/home-manager -- init --switch -b backup --flake .#${USER}
    # echo "Run 'source ~/.zshrc' to see the latest changes '"

    printf "\n\n\n"
    echo "# ────────────────────────────────────────────────"
    echo "#        NIX HOME MANAGER ACTIVATED! "
    echo "# ────────────────────────────────────────────────"
    printf "\n\n\n"
    echo "→ Run 'up' to update your local dotfiles with any changes made to your home flake (~/.config/home-manager/home.nix)"
    echo "# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────"
    echo
    echo
    echo

    zsh
fi
EOF

    # CONF_MSG="→ After loading a new shell run 'up' to activate home-manager"
    # CONF_MSG="→ After loading a new shell run 'nix run github:nix-community/home-manager -- init --switch --flake .#${CALLING_USER}' to activate home-manager"

    # We need to start a new shell to use nix and activate home-manager
    # However, if we can find the nix binary and the user profile (which we can create) we can likely automate the activation process
    #
    # if [ -s /nix/var/nix/profiles/default/bin/nix ]; then
    #
    #     mkdir -p ~/.local/state/nix/profiles  &> /dev/null
    #
    #     echo "[+] Found nix! Running home-manager for the first time..."
    #     pwd
    #     /nix/var/nix/profiles/default/bin/nix run github:nix-community/home-manager -- init --switch -b backup --flake .#${CALLING_USER}
    #     echo "[+] Finished running home manager"
    # fi
    #
    # # If .zshrc has been created, home-manager must have done it's thing
    # if [ -s ~/.zshrc ]; then
    #     CONF_MSG="→ Home-Manager Activated!\nRun 'zsh' to load a new shell and run 'up' reload any home-manager changes (~/.config/home-manager/home.nix)"
    # else
    #     CONF_MSG="→ After loading a new shell run 'nix run github:nix-community/home-manager -- init --switch --flake .#${CALLING_USER}' to activate home-manager"
    # fi


}

###########
# START   #
###########
#
# INSTALL_TYPE      =   full | configonly | nvimonly | pkgsonly
# INSTALL_SUBTYPE   =   desktop
# OPTION            =   pop | cachy


# ────────────────────────────────────────────────
#             NVIM-ONLY MODE (distro agnostic)
# ────────────────────────────────────────────────
if [ "${INSTALL_TYPE}" = "nvimonly" ] || [ "${INSTALL_TYPE}" = "full" ] || [ "${INSTALL_TYPE}" = "configonly" ] ; then

    sync_nvim_files

fi

# ────────────────────────────────────────────────
#        PACKAGE INSTALLATION (skip if configonly)
# ────────────────────────────────────────────────
# Unless we're explicitly calling to only copy the configs, then let's start installing (modes: full, installonly)
if [ "${INSTALL_TYPE}" == "full" ] || [  "${INSTALL_TYPE}" == "pkgsonly" ]; then

    if [ "$DISTRO_FAMILY" = "debian" ]; then

        . ./scripts/pkg_install_debian.sh

    elif [ "$DISTRO_FAMILY" = "arch" ]; then  

        . ./scripts/pkg_install_arch.sh

    elif [ "$DISTRO_FAMILY" = "fedora" ]; then

        echo "Yeah...about.. that... [TBD]"

    fi


fi




# ────────────────────────────────────────────────
#             CONFIG COPY (distro agnostic)
# ────────────────────────────────────────────────

if [ "${INSTALL_TYPE}" = "full" ] || [ "${INSTALL_TYPE}" = "configonly" ]; then

    # ./scripts/utils/config_copy.sh
    # sync_nvim_files

    echo ""
    echo ""
    read -p "Do you want nix to manage config files? (y/n) " yn

    use_home_manager=0

    # Validate response using case statement
    case $yn in
        [Yy]* ) 
            echo "[+] Setting up Nix/home-manager..."
            use_home_manager=1
            ;;
        [Nn]* ) 
            echo "Manually copying files..."
            ;;
        * ) 
            echo "Invalid input. Defaulting to 'n'."
            ;;
    esac   


    if [ $use_home_manager -eq 1 ]; then
        setup_nix
    else
        copy_config_files
    fi

    set_login_shell_zsh

fi





# ────────────────────────────────────────────────
#             DESKTOP-RELATED PACKAAGES
# ────────────────────────────────────────────────

if [ "${INSTALL_SUBTYPE}" = "desktop" ]; then

    if [ "${OPTION}" = "pop" ]; then

        echo "Running dry run first..."
        . ./scripts/pop_os_setup/desktop-apps.sh 1   

        printf "[+] Dry run complete! Review results. \n\nLive run will execute in 20s if this script isn't aborted with Ctrl+c\n\n"
        sleep 20
        . ./scrips/pop_os_setup/desktop-apps.sh 0

        echo "[+] Installing additional packages for gaming/graphics updates"
        . ./scripts/pop_os_setup/gaming.sh

        echo "[+] Running housekeeping tasks"
        . .scripts./pop_os_setup/housekeeping.sh


    elif [ "${OPTION}" = "cachy" ]; then

        . ./scripts/cachy_os_setup/desktop.sh
        . ./scripts/cachy_os_setup/housekeeping.sh

    fi

fi



if [ "${INSTALL_TYPE}" = "full" ] || [ "${INSTALL_TYPE}" = "configonly" ]; then
    # echo "$CONF_MSG"
    # echo "→ You may need to log out/in or simply run 'zsh'"
    # Just load a new shell to get going instead - not much overhead

    if command -v zsh &> /dev/null; then
        zsh
    else
        echo "→ zsh is not installed. To utilize zsh features install zsh."
    fi
else

    printf "\n\n\n"
    echo "# ────────────────────────────────────────────────"
    echo "#        FINISHED! "
    echo "# ────────────────────────────────────────────────"
    printf "\n\n\n"

fi


