#!/usr/bin/env bash

printf "\n\n"
echo "# ────────────────────────────────────────────────────────────────────────"
echo "#        PACKAGE INSTALLATION (Part I: Core install from package manager)"
echo "# ────────────────────────────────────────────────────────────────────────"
printf "\n\n"

cd ~/.config/home-manager

if ! command -v apt >/dev/null || ! grep -qi ubuntu /etc/os-release; then
    echo "This script requires an Ubuntu-based system"
    exit 1
fi

echo "[+] Updating package lists (Debian/Ubuntu)..."
# $SUDO apt update || { echo "Failed to update package lists"; exit 1; }
$SUDO apt update 

echo "[+] Installing essential core packages..."    # Not essential per se, but essentials for my workflow,enchancements, and customizations
command -v curl >/dev/null 2>&1 || $SUDO apt install curl -y
command -v wget >/dev/null 2>&1 || $SUDO apt install wget -y
command -v tar >/dev/null 2>&1 || $SUDO apt install tar -y
command -v unzip >/dev/null 2>&1 || $SUDO apt install unzip -y
command -v xclip >/dev/null 2>&1 || $SUDO apt install xclip -y
command -v build-essential >/dev/null 2>&1 || $SUDO apt install build-essential -y
command -v locate >/dev/null 2>&1 || $SUDO apt install locate -y
command -v sed >/dev/null 2>&1 || $SUDO apt install sed -y
command -v coreutils >/dev/null 2>&1 || $SUDO apt install coreutils -y
command -v vim >/dev/null 2>&1 || $SUDO apt install vim-gtk3 -y
command -v vim-gtk3 >/dev/null 2>&1 || $SUDO apt install vim-gtk3 -y # GUI VIM
command -v libc6 >/dev/null 2>&1 || $SUDO apt install libc6 -y
command -v p7zip-full >/dev/null 2>&1 || $SUDO apt install p7zip-full -y

# Languages
echo "[+] Installing dev related packages..."    # Not essential per se, but essentials for my workflow,enchancements, and customizations
command -v python3 >/dev/null 2>&1 || $SUDO apt install python3 -y
command -v perl >/dev/null 2>&1 || $SUDO apt install perl -y
command -v make >/dev/null 2>&1 || $SUDO apt install make -y
command -v gcc >/dev/null 2>&1 || $SUDO apt install gcc -y
command -v git-all >/dev/null 2>&1 || $SUDO apt install git-all -y
command -v cmake >/dev/null 2>&1 || $SUDO apt install cmake -y
command -v libstdc++6 >/dev/null 2>&1 || $SUDO apt install libstdc++6 -y
command -v libc6-dev >/dev/null 2>&1 || $SUDO apt install libc6-dev -y
command -v libc6-dev-i386 >/dev/null 2>&1 || $SUDO apt install libc6-dev-i386 -y
command -v nasm >/dev/null 2>&1 || $SUDO apt install nasm -y
command -v binutils >/dev/null 2>&1 || $SUDO apt install binutils -y
command -v bc >/dev/null 2>&1 || $SUDO apt install bc -y
command -v cargo >/dev/null 2>&1 || $SUDO apt install cargo -y
command -v pandoc >/dev/null 2>&1 || $SUDO apt install pandoc -y
command -v nodejs >/dev/null 2>&1 || $SUDO apt install nodejs -y
command -v npm >/dev/null 2>&1 || $SUDO apt install npm -y
command -v ninja-build >/dev/null 2>&1 || $SUDO apt install ninja-build -y
command -v gettext >/dev/null 2>&1 || $SUDO apt install gettext -y
command -v lua5.3 >/dev/null 2>&1 || $SUDO apt install lua5.3 -y
command -v jq >/dev/null 2>&1 || $SUDO apt install jq -y
command -v python3-pygments >/dev/null 2>&1 || $SUDO apt install python3-pygments -y
command -v bash >/dev/null 2>&1 || $SUDO apt install bash -y
command -v gawk >/dev/null 2>&1 || $SUDO apt install gawk -y
command -v pipx >/dev/null 2>&1 || $SUDO apt install pipx -y
pipx ensurepath

echo "[+] Installing terminal/workflow extras..."
command -v zsh >/dev/null 2>&1 || $SUDO apt install zsh -y
command -v tmux >/dev/null 2>&1 || $SUDO apt install tmux -y
command -v sshfs >/dev/null 2>&1 || $SUDO apt install sshfs -y
command -v sshpass >/dev/null 2>&1 || $SUDO apt install sshpass -y
command -v xsel >/dev/null 2>&1 || $SUDO apt install xsel -y
command -v tree >/dev/null 2>&1 || $SUDO apt install tree -y
command -v fonts-powerline >/dev/null 2>&1 || $SUDO apt install fonts-powerline -y
command -v pkg-config >/dev/null 2>&1 || $SUDO apt install pkg-config -y
command -v font-manager >/dev/null 2>&1 || $SUDO apt install font-manager -y # GUI
command -v direnv >/dev/null 2>&1 || $SUDO apt install direnv -y
command -v clang >/dev/null 2>&1 || $SUDO apt install clang -y
# command -v mssql-tools --ignore-missing >/dev/null 2>&1 || $SUDO apt install mssql-tools --ignore-missing -y   # Requires MicrSoft repo

echo "[+] Installing misc tools..."
# Fastfetch
$SUDO add-apt-repository ppa:zhangsongcui3371/fastfetch
$SUDO apt update
command -v fastfetch >/dev/null 2>&1 || $SUDO apt install fastfetch -y

command -v htop >/dev/null 2>&1 || $SUDO apt install htop -y

echo "[+] Installing various dependencies..."
command -v pkg-config >/dev/null 2>&1 || $SUDO apt install pkg-config -y
command -v libssl-dev >/dev/null 2>&1 || $SUDO apt install libssl-dev -y
command -v libxcb1-dev >/dev/null 2>&1 || $SUDO apt install libxcb1-dev -y
command -v libxcb-render0-dev >/dev/null 2>&1 || $SUDO apt install libxcb-render0-dev -y
command -v libxcb-shape0-dev >/dev/null 2>&1 || $SUDO apt install libxcb-shape0-dev -y
command -v libxcb-xfixes0-dev >/dev/null 2>&1 || $SUDO apt install libxcb-xfixes0-dev -y
# command -v crossbuild-essential-arm64 >/dev/null 2>&1 || $SUDO apt install crossbuild-essential-arm64 -y

echo "[+] Installing various dependencies (fragile)..." # Packages which may not be found in older package repos
command -v fzf >/dev/null 2>&1 || $SUDO apt install fzf -y
command -v ripgrep >/dev/null 2>&1 || $SUDO apt install ripgrep -y
command -v unixodbc-dev >/dev/null 2>&1 || $SUDO apt install unixodbc-dev -y
command -v docker.io >/dev/null 2>&1 || $SUDO apt install docker.io -y
command -v docker-compose-plugin >/dev/null 2>&1 || $SUDO apt install docker-compose-plugin -y

echo "[+] Installing various sound-related dependencies..."
$SUDO add-apt-repository ppa:ubuntuhandbook1/ffmpeg6
command -v playerctl >/dev/null 2>&1 || $SUDO apt install playerctl -y
command -v libasound2-dev >/dev/null 2>&1 || $SUDO apt install libasound2-dev -y
command -v ffmpeg >/dev/null 2>&1 || $SUDO apt install ffmpeg -y
command -v libass9 >/dev/null 2>&1 || $SUDO apt install libass9 -y
command -v libbluray2 >/dev/null 2>&1 || $SUDO apt install libbluray2 -y
command -v libcaca0 >/dev/null 2>&1 || $SUDO apt install libcaca0 -y
command -v libcdio-cdda2 >/dev/null 2>&1 || $SUDO apt install libcdio-cdda2 -y
command -v libcdio-paranoia2 >/dev/null 2>&1 || $SUDO apt install libcdio-paranoia2 -y
command -v libcdio19 >/dev/null 2>&1 || $SUDO apt install libcdio19 -y
command -v librubberband2 >/dev/null 2>&1 || $SUDO apt install librubberband2 -y
command -v libzimg2 >/dev/null 2>&1 || $SUDO apt install libzimg2 -y
command -v libdbus-1-dev >/dev/null 2>&1 || $SUDO apt install libdbus-1-dev -y
command -v libncursesw5-dev >/dev/null 2>&1 || $SUDO apt install libncursesw5-dev -y
command -v libpulse-dev >/dev/null 2>&1 || $SUDO apt install libpulse-dev -y
command -v libssl-dev >/dev/null 2>&1 || $SUDO apt install libssl-dev -y
command -v libxcb1-dev >/dev/null 2>&1 || $SUDO apt install libxcb1-dev -y
command -v libxcb-render0-dev >/dev/null 2>&1 || $SUDO apt install libxcb-render0-dev -y
command -v libxcb-shape0-dev >/dev/null 2>&1 || $SUDO apt install libxcb-shape0-dev -y
command -v libxcb-xfixes0-dev >/dev/null 2>&1 || $SUDO apt install libxcb-xfixes0-dev -y

if systemctl --user is-active pipewire >/dev/null; then
    echo "Using PipeWire, installing specific dependencies..."
    command -v libpipewire-0.3-0  >/dev/null 2>&1 || $SUDO apt install libpipewire-0.3-0  -y
fi

echo "[+] (optional) installing vulkan graphics drivers..."
command -v vulkan-tools >/dev/null 2>&1 || $SUDO apt install vulkan-tools -y
command -v mesa-utils >/dev/null 2>&1 || $SUDO apt install mesa-utils -y

echo "[+] Installing Tufw (UFW GUI)..."
$SUDO  wget https://github.com/peltho/tufw/releases/download/v0.2.4/tufw_0.2.4_linux_amd64.deb -O ./tufw_0.2.4_linux_amd64.deb
$SUDO  apt install ./tufw_0.2.4_linux_amd64.deb -y
$SUDO  rm ./tufw_0.2.4_linux_amd64.deb

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

echo "[+] Installing Rust (rustup)..."
if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # shellcheck disable=SC1091
    . "$HOME/.cargo/env"
fi
rustup update

echo "[+] Installing uv python package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh
  
echo "[+] Installing Go (if needed)..."
if ! command -v go >/dev/null 2>&1 || ! go version | grep -qE 'go1.2[2-9]'; then
    $SUDO rm -rf /usr/local/go
    wget https://go.dev/dl/go1.24.4.linux-amd64.tar.gz
    tar -xvf go1.24.4.linux-amd64.tar.gz
    $SUDO mv go /usr/local/
    rm -f go*.tar.gz
    export PATH="$PATH:$HOME/go/bin"
fi


echo "[+] Installing jless (json viewer)"
if ! command -v jless --verion >/dev/null 2>&1 ; then
    cargo install jless
fi

echo "[+] Installing entr (if needed for tmux auto-reload)..."
if ! command -v entr >/dev/null 2>&1; then
    git clone https://github.com/eradman/entr.git
    cd entr
    ./configure
    sudo make test
    sudo make install
    cd ../
    rm -rf entr
fi

echo "[+] Installing nvm..."
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash # Install nvm version 0.40.3
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
if command -v nvm >/dev/null; then
    echo "nvm installation suceeded. installing version."
    echo -e "\t[!] Available nvm versions:"
    nvm list-remote       # avaiable versions
    echo -e "\t[+] Installing node v22..."
    nvm install v22.17.0  # install a version
    echo -e "\t[+] Installed versions:"
    nvm list              # View installed versions
    echo -e "\t[+] Selecting v22.17"
    nvm use v22.17.0 
fi

echo "[+] Done installing prerequisites!"

printf "\n\n---------------------------------------------------\n\n"

# MAIN INSTALLATIONS

# Cargo ____________________________________
echo "[+] Installing csvlens"
cargo install csvlens

echo "[+] Installing Dust..."
cargo install du-dust

echo "[+] Installing TPM (tmux plugin manager)..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "[+] Installing fd..."
cargo install fd-find

echo "[+] Installing tree-sitter-cli..."
cargo install --locked tree-sitter-cli

echo "[+] Installing Yazi..."
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo build --release --locked
$SUDO  mv target/release/yazi target/release/ya /usr/local/bin/
cd ..
rm -rf yazi    



# Go _______________________________________
echo "[+] Installing lazysql..."
go install github.com/jorgerojas26/lazysql@latest

echo "[+] Installing eget..."
go install github.com/zyedidia/eget@latest

echo "[+] Installing lazygit..."
go install github.com/jesseduffield/lazygit@latest

echo "[+] Installing glow..."
go install github.com/charmbracelet/glow/v2@latest



# Other ___________________________________
echo "[+] Installing ggh ssh manager..."
curl https://raw.githubusercontent.com/byawitz/ggh/master/install/unix.sh | sh

echo "[+] Installing lazydocker..."
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

echo "[+] Installing Posting via uv..."
uv tool install --python 3.13 posting

echo "[+] Installing YouTube-downloader..."
$SUDO  wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux -O /usr/local/bin/yt-dlp; $SUDO chmod +x /usr/local/bin/yt-dlp

# echo "[+] Installing zioxide..."
# curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh


echo "[+] Installing llvm and related tools (clangd, cmake, etc)..."
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
$SUDO  ./llvm.sh 20 all
# or for latest stable release...
# sudo ./llvm.sh all

echo "[+] Installing Spotify Player..."    
$SUDO apt-get install autotools-dev -y
command -v pulseaudio >/dev/null 2>&1 || $SUDO apt install pulseaudio -y
command -v pulseaudio-module-bluetooth >/dev/null 2>&1 || $SUDO apt install pulseaudio-module-bluetooth -y
command -v pulseaudio-utils >/dev/null 2>&1 || $SUDO apt install pulseaudio-utils -y
command -v pavucontrol >/dev/null 2>&1 || $SUDO apt install pavucontrol -y
command -v libsixel-bin >/dev/null 2>&1 || $SUDO apt install libsixel-bin -y  # sixel encoder/decoder
cargo install spotify_player --no-default-features --features pulseaudio-backend,media-control,sixel


echo "[+] Installing various tools..."
command -v 7zip  >/dev/null 2>&1 || $SUDO apt install 7zip  -y
command -v poppler-utils  >/dev/null 2>&1 || $SUDO apt install poppler-utils  -y
command -v imagemagick >/dev/null 2>&1 || $SUDO apt install imagemagick -y
# command -v zoxide  >/dev/null 2>&1 || $SUDO apt install zoxide  -y
# command -v fd-find  >/dev/null 2>&1 || $SUDO apt install fd-find  -y  # Installed with cargo above
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
    $SUDO rm -rf /opt/nvim
    $SUDO tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    # echo "→ Consider adding /opt/nvim-linux-x86_64/bin to your PATH"
    # echo 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' >> $HOME/.zshrc
    # rm nvim-linux-x86_64.tar.gz
    # Already aadded to PTH in .zshrc - just export for now so we can use it now
    export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
fi

# Download and install lazygit
if ! command -v lazygit >/dev/null 2>&1; then
    printf "[+] Installing lazygit...\n\n"
    LAZYGIT_VERSION='0.40.2'
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && $SUDO mv -f lazygit /usr/local/bin/ \
    && rm lazygit.tar.gz
fi


