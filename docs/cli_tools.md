# CLI Tools Reference

Every command-line tool the Arch install path sets up, grouped by job, with what it's for and how to call it.

- **Sources of truth:**
  - `pkg_lists/arch_base.txt`: pacman packages, then AUR packages after `NOTE-AUR`
  - `scripts/pkg_install_arch.sh`: the essentials block, plus the manual installs (curl / cargo / npm / git)
  - `scripts/utils/controller.sh`: oh-my-zsh and powerlevel10k
  - `scripts/cachy_os_setup/desktop.sh`: desktop installs only ([§15](#15-desktop-install-extras-cachyos))
- **Install-source tags:** `pacman` · `AUR` (yay) · `manual` (curl / cargo / npm / git in `pkg_install_arch.sh`) · `shell` (`controller.sh`) · `desktop` (`desktop.sh`)
- **†** means the tool wasn't installed on the machine this was generated on. Its command name comes from the package metadata or the upstream docs.
- **Your aliases** are shown as `alias → command` and come from `dotfiles/.bash_aliases`. Custom shell functions (`gt_*`, `dk_*`, `ut_*`, `nx_*`…) are listed in `pkg_lists/cmd_list.txt`. Run `cf` to fuzzy-find them.
- **Keeping it current:** after editing the package lists or install scripts, ask Claude to "update the CLI tools doc". This runs the project skill `.claude/skills/cli-tools-docs/`.
- **Last synced:** 2026-11-05

---

## Table of Contents

1. [Quick Picks: "I want to…"](#1-quick-picks-i-want-to)
2. [Shell & Terminal](#2-shell--terminal)
3. [Files, Search & Navigation](#3-files-search--navigation)
4. [Disks & Filesystems](#4-disks--filesystems)
5. [Archives & Compression](#5-archives--compression)
6. [Text, Data & Documents](#6-text-data--documents)
7. [Editors](#7-editors)
8. [Git](#8-git)
9. [Languages & Build Toolchains](#9-languages--build-toolchains)
10. [Containers](#10-containers)
11. [System & Process Monitoring](#11-system--process-monitoring)
12. [Networking, Remote & Backup](#12-networking-remote--backup)
13. [Media, Images & Clipboard](#13-media-images--clipboard)
14. [Package & System Management](#14-package--system-management)
15. [Desktop Install Extras (CachyOS)](#15-desktop-install-extras-cachyos)
16. [Libraries, Fonts & Firmware (nothing to run)](#16-libraries-fonts--firmware-nothing-to-run)
17. [Install Issues Found](#17-install-issues-found)

---

## 1. Quick Picks: "I want to…"

| I want to… | Reach for |
| --- | --- |
| Find a file by name | `fd name` (alias `f`), or `locate name` |
| Search text in files | `rg pattern` (alias `r`) |
| Pick something from a list interactively | `fzf` (alias `ff`), or `fv` to open the pick in Neovim |
| Browse files in a TUI | `y` (yazi, cd's into the last dir on exit) |
| Read a file with syntax highlighting | `bat file` |
| See what's eating disk space | `dust`, or `darya` for an interactive treemap |
| See mounted filesystems and free space | `dysk` |
| Explore JSON / YAML | `jless file.json`, or `jq` to transform it |
| View a CSV | `csvlens file.csv` |
| Read Markdown | `glow file.md` or `treemd file.md` |
| Read a `.docx` | `doxx file.docx` |
| Convert documents | `pandoc in.md -o out.docx` |
| Work with Git visually | `lazygit` (alias `lg` / `gg`), or `oy` for diffs |
| Manage Docker | `lazydocker` (alias `lzd`) |
| Pick an SSH host | `lazyssh` (alias `lzs`) |
| Browse a database | `lazysql` (alias `lzq`) |
| Test an HTTP API | `posting` |
| Watch CPU / RAM / processes | `btop` (or `htop`) |
| Watch the GPU | `nvtop` |
| Mix audio | `wiremix` |
| See which ports are open and what's listening | `ss -tulpn`, or `snitch` |
| Capture packets | `sudo tcpdump -i any port 22` |
| Re-run a command when files change | `fd -e py \| entr -c python main.py` |
| Back up a directory | `restic -r <repo> backup <dir>` |
| Copy or sync files | `rsync -avh --progress src/ dest/` |
| Download video or audio | `yt-dlp URL` / `yt-dlp -x --audio-format mp3 URL` |
| Convert audio or video | `ffmpeg -i in.mkv out.mp4` |
| Resize or convert images | `magick in.png -resize 50% out.jpg` |
| Start a Python project | `uv init && uv add <pkg>` |
| Switch Node versions | `nvm use 22` |
| Install a package | `sudo pacman -S pkg` / `yay -S pkg` |

---

## 2. Shell & Terminal

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `zsh` | `zsh` (pacman) | Main interactive shell | `chsh -s $(which zsh)` |
| oh-my-zsh | `ohmyzsh` install script (shell) | zsh framework. Plugins are set in `dotfiles/.zsh_customizations` | `omz update` · `omz plugin list` |
| ↳ plugin `sudo` | oh-my-zsh | Prefix the current or last command with `sudo` | Press `Esc` twice |
| ↳ plugin `copybuffer` | oh-my-zsh | Copy the current command line to the clipboard | `Ctrl+O` |
| ↳ plugin `copypath` / `copyfile` | oh-my-zsh | Copy a path / a file's contents to the clipboard | `copypath [file]` · `copyfile file` |
| ↳ plugin `colorize` | oh-my-zsh | Syntax-highlighted `cat` / `less` | `ccat file` · `cless file` |
| ↳ plugin `fancy-ctrl-z` | oh-my-zsh | `Ctrl+Z` on an empty prompt resumes the suspended job (`fg`) | `Ctrl+Z` |
| ↳ plugins `zsh-syntax-highlighting`, `colored-man-pages`, `ssh` | oh-my-zsh | Highlight commands as you type, color man pages, ssh host completion | Automatic |
| `p10k` | powerlevel10k (shell, `git clone`) | zsh prompt theme | `p10k configure` |
| `bash` | `bash` (pacman) | Fallback shell and script interpreter | `bash script.sh` |
| `tmux` | `tmux` (pacman) | Terminal multiplexer (WezTerm handles this day to day) | `tmux new -s main` · `tmux a -t main` · `tmux ls` |
| TPM | `tmux-plugins/tpm` (manual, `git clone`) | tmux plugin manager | `prefix` + `I` installs plugins from `.tmux.conf` |
| `direnv` | `direnv` (pacman) | Loads and unloads env vars per directory from `.envrc` (hooked in zsh) | `direnv allow` · `direnv deny` · `nx_make_dev_flake` creates one |
| `fastfetch` | `fastfetch` (pacman) | System info banner | `fastfetch` |
| `gum` | `gum` (pacman) | Pretty prompts and spinners for shell scripts | `gum choose a b c` · `gum input` · `gum confirm "Go?" && cmd` · `gum spin --title "…" -- cmd` |
| `chafa` | `chafa` (pacman) | Render images as text in the terminal | `chafa image.png` · `chafa --size 60x30 image.png` |
| `man`, `apropos` | `man` (pacman) | Manual pages | `man rsync` · `apropos compress` |
| `less` | `less` (pacman) | Pager | `less file` → `/pattern`, `n`, `F` (follow), `q` |
| `bat` | `bat` (pacman) | `cat` with syntax highlighting and git markers | `bat file` · `bat -p file` (plain) · `cmd \| bat -l json` |
| `pygmentize` | `python-pygments` (pacman) | Syntax highlighter (used by `ut_o_colorme`) | `pygmentize -g file` |
| `x` † | x-cmd (manual, `curl` installer) | Collection of CLI helper modules, loaded as a shell function | `x` (shell function; modules listed at x-cmd.com) |

---

## 3. Files, Search & Navigation

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `fd` | `fd` (pacman) | Fast, friendly `find` (respects `.gitignore`) | `fd name` · `fd -e py` · `fd -H -t d config` · alias `f` → `fd --regex --max-depth 10 --hidden` |
| `rg` | `ripgrep` (pacman) | Fast recursive grep (also Neovim's `grepprg`) | `rg pattern` · `rg -i -t py foo` · `rg -l foo` (files only) · `rg -uu foo` (include ignored and hidden) · alias `r` → `rg -.` (search hidden) |
| `fzf` | `fzf` (pacman) | Interactive fuzzy finder for any list | `cmd \| fzf` · alias `ff` → fzf at 40% height · alias `fv` → open the pick in Neovim |
| `yazi`, `ya` | `yazi` (AUR) | TUI file manager with previews. The bookmarks plugin is installed by the script | `y` (shell function: cd's into the last dir on exit) · `ya pkg add <plugin>` |
| `tree` | `tree` (pacman) | Directory tree listing | `tree -L 2` · `tree -a -I node_modules` |
| `locate`, `updatedb` | `mlocate` (AUR section; provides **plocate**) | Instant filename lookup from an index | `sudo updatedb` then `locate name` |
| `which` | `which` (pacman) | Show the path of a command | `which nvim` |
| `entr` | `entr` (pacman) | Run a command whenever watched files change | `fd -e go \| entr -r go run .` · `ls *.md \| entr -c glow README.md` |
| coreutils | `coreutils` (pacman) | `ls cp mv rm cat head tail sort uniq wc du df cut tr tee date …` | Standard. `man <cmd>` |

---

## 4. Disks & Filesystems

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `dust` | `dust` (AUR section) | Visual `du`: what's big, as a tree | `dust` · `dust -d 2 /path` · `dust -r` (biggest at the top) |
| `darya` | darya (manual, `curl` installer) | Interactive TUI disk usage explorer with a treemap | `darya [path]` |
| `dysk` | `dysk` (pacman) | Table of mounted filesystems with usage bars (`df` replacement) | `dysk` |
| `sshfs` | `sshfs` (pacman) | Mount a remote directory over SSH | `sshfs user@host:/path ~/mnt/x` · unmount `fusermount -u ~/mnt/x` |
| `mount.cifs` | `cifs-utils` (pacman) | Mount Windows/Samba shares | `sudo mount -t cifs //server/share /mnt/x -o username=me` |
| `smbclient` | `smbclient` (pacman) | FTP-like client for SMB shares | `smbclient -L //server -U user` (list shares) · `smbclient //server/share -U user` |
| `fusermount` | `fuse2` (pacman) | FUSE v2, needed to run AppImages and unmount FUSE mounts | `fusermount -u <mountpoint>` |

---

## 5. Archives & Compression

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `tar` | `tar` (pacman) | Create and extract tarballs | `tar -xf a.tar.gz` · `tar -czf out.tar.gz dir/` · `tar -tf a.tar` (list) |
| `zip`, `unzip` | `zip`, `unzip` (pacman) | `.zip` archives | `zip -r out.zip dir/` · `unzip a.zip -d dir/` · `unzip -l a.zip` |
| `7z` | `p7zip` (pacman) | 7-Zip, and extracts almost any format | `7z x a.7z` · `7z a out.7z dir/` · `7z l a.7z` |
| `bzip2`, `bunzip2` | `bzip2` (pacman) | `.bz2` compression | `bzip2 file` · `bunzip2 file.bz2` |

---

## 6. Text, Data & Documents

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `jq` | `jq` (pacman) | Query and transform JSON | `jq . f.json` · `jq '.items[].name' f.json` · `curl … \| jq -r .tag_name` |
| `jless` | `jless` (AUR section) | Collapsible pager for JSON **and YAML** | `jless f.json` · `cmd \| jless` · `jless --yaml f.yml` |
| `csvlens` | `csvlens` (AUR section) | Interactive CSV viewer | `csvlens data.csv` · `csvlens -t data.tsv` · `csvlens -d ';' data.csv` |
| `glow` | `glow` (pacman) | Render Markdown in the terminal | `glow README.md` · `glow -p file.md` (pager) · `glow` (browse `.md` in cwd) |
| `treemd` | `treemd` (pacman) | Markdown navigator with a heading-tree pane | `treemd README.md` |
| `doxx` | `doxx` (pacman) | View Word `.docx` files in the terminal | `doxx file.docx` |
| `pandoc` | `pandoc` (pacman) | Convert between document formats | `pandoc in.md -o out.docx` · `pandoc in.docx -t gfm --extract-media=media -o out.md` (= `ut_txt_docx_to_md`) |
| `pdftotext`, `pdftoppm`, `pdfunite`, `pdfinfo` … | `poppler` (pacman) | PDF utilities | `pdftotext f.pdf -` · `pdftoppm -png f.pdf page` · `pdfunite a.pdf b.pdf out.pdf` |
| `sed` | `sed` (pacman) | Stream editor | `sed -i 's/old/new/g' file` |
| `awk` | `gawk` (pacman) | Column and text processing | `awk -F, '{print $2}' data.csv` |
| `bc` | `bc` (pacman) | Arbitrary-precision calculator | `echo 'scale=3; 10/3' \| bc` · `bc -l` |
| `envsubst` | `gettext` (pacman) | Fill `$VARS` in a template | `envsubst < tpl.conf > out.conf` |
| `basalt` † | `basalt-tui` (manual, `cargo install`) | TUI for reading Obsidian vaults | `basalt` |

---

## 7. Editors

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `nvim` | `neovim` (pacman) | Main editor (plugins documented in `nvim_plugins.md`) | alias `nv` · `fv` (fzf → nvim) · `nvim-custom` (alternate config via `NVIM_APPNAME`) |
| `vim`, `vimdiff` | `vim` (pacman) | Classic Vim (uses `dotfiles/.vimrc`) | `vim file` · `vimdiff a b` |
| `xxd` | `vim` (pacman) | Hex dump and reverse | `xxd file \| less` · `xxd -r dump > file` |
| `vi`, `ex`, `view` | `vi` (pacman) | POSIX vi | `vi file` |

---

## 8. Git

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `git` | `git` (pacman, essentials) | Version control | Many `gt_*` helper functions: see `cmd_list.txt` |
| `lazygit` | `lazygit` (AUR section) | Git TUI (config in `dotfiles/.config/lazygit`) | aliases `lg`, `gg` · `?` inside for keys |
| `oy` † | `oyo` (AUR) | Diff viewer: step through changes, or a classic scrollable diff (config in `dotfiles/.config/oyo`) | `oy --help` |
| `git filter-repo` | `git-filter-repo` (pacman) | Rewrite history (replaces `filter-branch`) | `git filter-repo --path secret.txt --invert-paths` · `git filter-repo --strip-blobs-bigger-than 10M` |
| `gittop` † | `gittop` (AUR) | **AUR package = GitHub notifications client** (AmarBego/GitTop). See [§17](#17-install-issues-found) | `gittop` |

---

## 9. Languages & Build Toolchains

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `gcc`, `g++` | `gcc` (pacman) | GNU C/C++ compilers | `gcc -g -O0 -Wall main.c -o main` |
| `clang`, `clang++` | `clang` (pacman) | LLVM C/C++ compilers | `clang -g main.c -o main` |
| `clangd` · `clang-format` · `clang-tidy` · `scan-build` | `clang` (pacman) | C/C++ LSP · formatter · linter · static analyzer | `clang-format -i file.c` · `clang-tidy file.c --` · `scan-build make` |
| `llvm-*`, `opt`, `llc` | `llvm` (pacman) | LLVM toolchain utilities | `llvm-objdump -d bin` · `llvm-symbolizer` |
| `make` | `make` (pacman) | Build from a Makefile | `make` · `make -j$(nproc)` · `make clean` |
| `cmake`, `ctest` | `cmake` (pacman) | Build-system generator | `cmake -S . -B build && cmake --build build` |
| `ninja` | `ninja` (pacman) | Fast build backend | `cmake -G Ninja -B build && ninja -C build` |
| `nasm` | `nasm` (pacman) | x86 assembler | `nasm -f elf64 a.asm -o a.o && ld a.o -o a` |
| `objdump`, `nm`, `readelf`, `strings`, `strip`, `ld` | `binutils` (pacman) | Inspect and link binaries | `objdump -d bin` · `nm bin` · `readelf -h bin` · `strings bin \| less` |
| `pkg-config` | `pkgconf` (pacman) | Compiler and linker flags for libraries | `gcc x.c $(pkg-config --cflags --libs openssl)` |
| `makepkg` | `base-devel` (pacman, essentials) | Build Arch/AUR packages | `makepkg -si` |
| `go`, `gofmt` | `go` (pacman, essentials) | Go toolchain | `go run .` · `go build` · `go mod tidy` · `go install pkg@latest` |
| `rustup`, `cargo`, `rustc` | `rustup` (pacman, essentials) | Rust toolchain manager and build tool | `rustup update` · `cargo new app` · `cargo run` · `cargo clippy` · `cargo install <crate>` |
| `python3`, `pydoc` | `python` (pacman) | Python | `python3 -m venv .venv` · alias `serve` → `python3 -m http.server 8000` |
| `uv`, `uvx` | `uv` (AUR section) | Fast Python package, venv, and project manager | `uv init` · `uv add requests` · `uv run main.py` · `uvx ruff check` · `ut_o_uv_init` |
| `node` | `nodejs-lts-jod` (pacman) | Node.js 22 LTS | `node app.js` |
| `npm`, `npx` | `npm` (pacman) | Node package manager and runner | `npm i` · `npm run dev` · `npx <pkg>` |
| `pnpm` | `pnpm` (pacman) | Disk-efficient Node package manager | `pnpm install` · `pnpm add <pkg>` · `pnpm dlx <pkg>` |
| `nvm` | `nvm` (pacman) + `nvm install v22.17.0` (manual) | Switch Node versions (shell function) | `nvm ls` · `nvm install 22` · `nvm use 22` |
| `lua`, `luac` | `lua` (pacman) | Lua interpreter and compiler | `lua script.lua` |
| `perl` | `perl` (pacman) | Perl | `perl script.pl` · `perl -c script.pl` (syntax check) |
| `perlcritic` | `perl-perl-critic` (pacman) | Perl linter (used by nvim-lint) | `perlcritic file.pl` · `perlcritic --severity 3 file.pl` |
| `tree-sitter` | `tree-sitter-cli` (pacman **and** `cargo install`) | Parser generator, required by nvim-treesitter | `tree-sitter --version` · `tree-sitter parse file` |

---

## 10. Containers

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `docker` | `docker` (pacman; service enabled by the script) | Container engine and CLI | `docker ps -a` · `docker run --rm -it ubuntu bash` · `docker exec -it <c> bash` · `docker logs -f <c>` · `docker system prune` |
| `docker compose` / `docker-compose` | `docker-compose` (pacman; ships both the CLI plugin and the binary) | Multi-container apps from `compose.yml` | `docker compose up -d` · `docker compose logs -f` · `docker compose down` |
| `lazydocker` | `lazydocker` (manual: AUR, falling back to the upstream script) | Docker TUI | alias `lzd` |
| `dcv` | `tokuhirom/dcv` (manual, `go build`) | Docker Compose viewer TUI | `dcv` in a directory with a compose file |
| helpers | `dotfiles/.bash_wrappers` | Throwaway distro containers | `dk_arch` · `dk_ubuntu` · `dk_force_old_version` |

---

## 11. System & Process Monitoring

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `btop` | `btop` (pacman) | Full resource monitor (CPU, mem, disks, net, processes) | `btop` |
| `htop` | `htop` (pacman) | Classic process viewer | `htop` · `F9` kill · `F6` sort |
| `nvtop` | `nvtop` (pacman) | GPU usage and processes (NVIDIA, AMD, Intel) | `nvtop` |
| `neohtop-cli` | `neohtop-cli` (manual, `npm -g`) | Modern process-viewer dashboard | `neohtop-cli` |
| `snitch` † | `snitch-bin` (AUR) | Friendlier `ss`/`netstat`: who's connected and listening | `snitch` |
| `wiremix` | `wiremix` (pacman) | TUI audio mixer for PipeWire | `wiremix` |
| `playerctl` | `playerctl` (pacman) | Control any MPRIS media player | `playerctl play-pause` · `playerctl next` · `playerctl metadata` |

---

## 12. Networking, Remote & Backup

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `ssh`, `scp`, `sftp`, `ssh-keygen`, `ssh-copy-id`, `ssh-add` | `openssh` (pacman) | Remote shell, file copy, keys | `ssh user@host` · `scp f user@host:/tmp/` · `ssh-copy-id user@host` · helpers `ut_ssh_make_key`, `ut_ssh_reload_key` |
| `sshpass` | `sshpass` (pacman) | Non-interactive password SSH (scripts only; prefer keys) | `SSHPASS=… sshpass -e ssh user@host` |
| `lazyssh` | `Adembc/lazyssh` (manual, GitHub release) | TUI SSH host manager (reads `~/.ssh/config`) | alias `lzs` |
| `curl` | `curl` (pacman) | HTTP client and downloader | `curl -fsSL url` · `curl -I url` · `curl -X POST -H 'Content-Type: application/json' -d '{}' url` |
| `wget` | `wget` (pacman) | Downloader | `wget url` · `wget -c url` (resume) |
| `posting` | `posting` (manual: AUR, falling back to `uv tool install`) | TUI HTTP API client (Postman-like) | `posting` |
| `ip`, `ss`, `bridge`, `tc` | `iproute2` (pacman) | Modern network config and socket stats | `ip a` · `ip r` · `ss -tulpn` (listening ports) |
| `ifconfig`, `netstat`, `arp`, `route` | `net-tools` (pacman) | Legacy network tools | `netstat -tulpn` · `arp -a` |
| `dig`, `host`, `nslookup` | `dnsutils` (pacman) | DNS lookups | `dig example.com` · `dig +short example.com MX` · `host 1.1.1.1` |
| `iw` | `iw` (pacman) | Wireless device config | `iw dev` · `iw dev wlan0 link` |
| `nmcli` | `networkmanager` (**listed as `NetworkManager`, see [§17](#17-install-issues-found)**) | NetworkManager CLI | `nmcli device wifi list` · `nmcli device wifi connect SSID password PW` · `nmcli con show` |
| `tcpdump` | `tcpdump` (pacman) | Packet capture | `sudo tcpdump -i any port 22` · `sudo tcpdump -w cap.pcap` · helper `ut_sys_view_incoming_requests` |
| `ufw` | `ufw` (pacman) | Simple firewall front end | `sudo ufw status verbose` · `sudo ufw allow 22/tcp` · `sudo ufw enable` |
| `tailscale` † | tailscale (manual, `curl` installer) | WireGuard mesh VPN. Taildrop files land in `~/Downloads/taildrops` | `tailscale status` · `tailscale ip -4` · `tailscale file cp f <device>:` · `ut_o_taildrop_to_phone` |
| `openssl` | `openssl` (pacman) | TLS and crypto toolkit | `openssl s_client -connect host:443` · `openssl x509 -in cert.pem -noout -text` · `openssl rand -hex 32` |
| `rsync` | `rsync` (pacman) | Fast local and remote sync | `rsync -avh --progress src/ dest/` · `rsync -avz dir/ user@host:/path/` · add `--delete` to mirror |
| `restic` | `restic` (pacman) | Encrypted, deduplicated backups | `restic -r <repo> init` · `restic -r <repo> backup ~/dir` · `restic -r <repo> snapshots` · `restic -r <repo> restore latest --target /tmp/r` |
| `lazysql` | `lazysql` (AUR section) | TUI database client (Postgres, MySQL, SQLite, MSSQL…) | alias `lzq` |
| `isql`, `odbcinst` | `unixodbc` (pacman) | ODBC driver manager and SQL shell | `odbcinst -j` · `isql <DSN> user pass` |

---

## 13. Media, Images & Clipboard

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `ffmpeg`, `ffprobe`, `ffplay` | `ffmpeg` (pacman) | Convert, inspect, and play audio/video | `ffmpeg -i in.mkv out.mp4` · `ffmpeg -i in.mp4 -vn out.mp3` · `ffprobe file` |
| `magick` | `imagemagick` (pacman) | Image convert, resize, compose | `magick in.png out.jpg` · `magick in.jpg -resize 50% out.jpg` · `magick identify img` |
| `yt-dlp` | `yt-dlp` (pacman) | Download video and audio from YouTube and most sites | `yt-dlp URL` · `yt-dlp -F URL` (formats) · `yt-dlp -x --audio-format mp3 URL` · helper `ut_o_mp3_dl` |
| `spotify_player` | `spotify-player` (manual, pacman) | Spotify TUI client (config in `dotfiles/.config/spotify-player`) | `spotify_player` |
| `rubberband` | `rubberband` (pacman) | Time-stretch and pitch-shift audio | `rubberband -t 1.25 in.wav out.wav` · `rubberband -p 2 in.wav out.wav` |
| `img2txt`, `cacaview` | `libcaca` (pacman) | Color ASCII-art images | `img2txt image.png` |
| `sxiv` | `sxiv` (pacman) | Minimal X11 image viewer | `sxiv img.png` · `sxiv -t dir/*` (thumbnails) |
| `qview` † | `qview` (AUR) | Minimal Qt image viewer (GUI) | `qview img.png` |
| `wlsunset` † | `wlsunset-git` (AUR) | Day/night colour-temperature shift for Wayland (night mode) | `wlsunset -l <lat> -L <lon>` |
| `pavucontrol` | `pavucontrol` (manual, pacman) | Volume and audio-device GUI (works with PipeWire) | `pavucontrol` |
| `cd-info`, `bd_info` | `libcdio`, `libbluray` (pacman) | CD / Blu-ray disc info | `cd-info` · `bd_info /dev/sr0` |
| `xclip` | `xclip` (pacman) | X11 clipboard from the CLI | `cmd \| xclip -selection clipboard` · `xclip -o -selection clipboard` |
| `xsel` | `xsel` (pacman) | X11 clipboard (alternative) | `cmd \| xsel -b` · `xsel -b -o` |

---

## 14. Package & System Management

| Command | Package (source) | Purpose | Common usage |
| --- | --- | --- | --- |
| `pacman` | base system | Arch package manager | `sudo pacman -Syu` · `pacman -Ss term` · `pacman -Qi pkg` · `pacman -Ql pkg` · `pacman -Qo /path` · `sudo pacman -Rns pkg` |
| `yay` | built by `pkg_install_arch.sh` (`makepkg -si`) | AUR helper (same flags as pacman) | `yay -S pkg` · `yay -Syu` · `yay -Ss term` |
| `flatpak` | `flatpak` (pacman) | Sandboxed apps from Flathub | `flatpak install flathub <app-id>` · `flatpak run <app-id>` · `flatpak update` · `flatpak list` |
| `eget` † | `eget` (AUR section, **not found in AUR**, see [§17](#17-install-issues-found)) | Install a prebuilt binary from GitHub releases | `eget zyedidia/micro --to ~/.local/bin` |
| `sudo`, `sudoedit`, `visudo` | `sudo` (pacman) | Run as root, edit root files safely | `sudo -i` · `sudoedit /etc/hosts` · `sudo visudo` |
| `font-manager` | `font-manager` (pacman) | Font browser (GUI) | `font-manager` |
| Home Manager | Nix (`controller.sh`) | Applies these dotfiles | alias `up` → `nx_up` |

---

## 15. Desktop Install Extras (CachyOS)

Installed only by `scripts/cachy_os_setup/desktop.sh`. Tools not on this reference machine aren't marked †.

| Command | Package | Purpose | Common usage |
| --- | --- | --- | --- |
| `paru` | `paru` | AUR helper that ships with CachyOS | `paru -Syu` · `paru -S pkg` |
| `fish` | `fish` | Alternate shell | `fish` |
| `sensors` | `lm-sensors` | CPU and board temperatures and fans | `sensors` · `sudo sensors-detect` |
| `vainfo` | `libva-utils` | Check VA-API hardware video decoding | `vainfo` |
| `tlp`, `tlp-stat` | `tlp`, `tlp-rdw` | Laptop power management | `sudo tlp-stat -s` · `sudo tlp start` |
| `syncthing` | `syncthing` | Continuous file sync (web UI on `localhost:8384`) | `syncthing` · helper `ut_o_move_conflicted_files` |
| `wl-copy`, `wl-paste` | `wl-clipboard` | Wayland clipboard | `cmd \| wl-copy` · `wl-paste` |
| `cliphist` | `cliphist` | Wayland clipboard history | `wl-paste --watch cliphist store` · `cliphist list` |
| `wtype` | `wtype` | Type text into the focused Wayland window | `wtype 'hello'` |
| `gpu-screen-recorder` | `gpu-screen-recorder` | Low-overhead GPU screen recording | `gpu-screen-recorder --help` |
| `gamemoderun`, `mangohud`, `gamescope` | `gamemode`, `mangohud`, `gamescope` | Gaming performance mode, FPS overlay, micro-compositor | Steam launch options: `gamemoderun mangohud %command%` |
| `winetricks` | `winetricks` | Install Windows DLLs and fonts into Wine prefixes | `winetricks` |
| `snapper` | `snapper`, `snap-pac` | Btrfs snapshots (auto-snapshot on every pacman transaction) | `sudo snapper list` · `sudo snapper create -d "before X"` |
| `ufw` / `gufw` | `ufw`, `gufw` | Firewall (CLI / GUI) | see [§12](#12-networking-remote--backup) |
| `remmina` (+ FreeRDP 3 CLI) | `freerdp`, `remmina` | RDP client (GUI, plus FreeRDP's CLI) | `remmina` · `pacman -Ql freerdp \| grep bin/` for the CLI names |

**GUI apps from the same script (no CLI use):** Brave, LibreOffice, OBS, Inkscape, GIMP, Audacity, Obsidian, Telegram, Signal, Discord, Spotify, Steam, mpv, VLC, Postman, Thonny, Wireshark (Qt), sniffnet, neohtop (GUI), monique (monitors), Picard, Nemo, Ark, GParted, EasyEffects (+ lsp-plugins, calf), neovim-qt, WezTerm (`wezterm-git`), omniget, Bottles (Flatpak).

---

## 16. Libraries, Fonts & Firmware (nothing to run)

These are installed as dependencies for builds, media, or rendering. You won't call them directly.

| Package | What it's for |
| --- | --- |
| `glibc`, `lib32-glibc` | C library (64- and 32-bit; 32-bit is needed by Steam and Wine) |
| `libxcb` | X11 client library |
| `linux-firmware` | Device firmware blobs |
| `alsa-lib`, `dbus` | Audio and IPC libraries (`dbus-send` / `dbus-monitor` exist for debugging) |
| `libass`, `libbluray`, `zimg`, `ncurses` | Subtitle rendering, Blu-ray access, image scaling, terminal UI library |
| `perl-padwalker` | Perl module needed by `perl-debug-adapter` (Neovim DAP) |
| `powerline-fonts`, `ttf-nerd-fonts-symbols`, `ttf-nerd-fonts-symbols-mono`, `ttf-jetbrains-mono-nerd` | Prompt and icon glyphs for p10k, Neovim, yazi, lazygit. `controller.sh` also copies JetBrains Mono Nerd Font from `./fonts/` |
| `pipewire` | Audio server (only reinstalled if it's already running) |

---

## 17. Install Issues Found

Found while generating this doc. Nothing has been changed.

| # | Where | Problem | Suggested fix |
| --- | --- | --- | --- |
| 1 | `arch_base.txt` → `NetworkManager` | Pacman names are case-sensitive and the package is `networkmanager`, so this line fails with "target not found" (it's in the pacman section, so there's no yay fallback) | Rename to `networkmanager` |
| 2 | `arch_base.txt` → `eget` (AUR section) | `yay -Si eget` finds nothing, so the install fails | Use upstream's install script, or `go install github.com/zyedidia/eget@latest` |
| 3 | `arch_base.txt` → `gittop` | The AUR `gittop` is **AmarBego/GitTop, a GitHub notifications client**, but `cmd_list.txt` describes it as an "interactive git repository monitor" | Confirm which tool you meant and fix the package or the description |
| 4 | `pkg_install_arch.sh` → `$PACMAN libsixel-player` | No such package (`pacman -Si` errors) | Probably `libsixel` (sixel image support for spotify_player) |
| 5 | `controller.sh` + `.zsh_customizations` | `zsh-syntax-highlighting` is in `plugins=(…)`, but no script clones it into `~/.oh-my-zsh/custom/plugins/`. `install_oh_my_zsh_and_powerline` also `rm -rf`s `~/.oh-my-zsh` first, so a reinstall deletes it and oh-my-zsh warns "plugin not found" | Add `git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"` next to the powerlevel10k clone |
| 6 | `.bash_aliases` → `alias l='eza'` | `eza` isn't in any package list | Add `eza` to `arch_base.txt`, or drop the alias |
| 7 | `tree-sitter-cli` | Installed twice: pacman (`arch_base.txt`) and `cargo install --locked tree-sitter-cli` (`pkg_install_arch.sh`) | Keep one |
| 8 | `arch_base.txt` comments | Copy-paste comments are wrong: `less # tar: Archiver…`, `ufw # gawk: AWK…`. `bat` is listed twice | Cosmetic cleanup |
| 9 | `cmd_list.txt` | Lists tools no script in this repo installs (e.g. `duf`, `glances`, `pv`, `termshark`, `hwinfo`, `smartctl`, `cpupower`, `brightnessctl`) | They come with CachyOS or were installed by hand. Add the ones you rely on to `arch_base.txt` |
