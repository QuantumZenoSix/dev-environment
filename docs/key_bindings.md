# Key Bindings Reference  

Leader key for vim/neovim: `<space>`  
Leader key for Wezterm: `<C-W>`  
This means window management is verly similar - <C-W> for window actions in Wezterm's multiplexer and <C-w> for window management within vim/nvim (keys for splits, movement, remain the same).  
`up` - Pull and update locally via home manager  
mksshkey - makes ssh keys
restart_audio - restarts pipewire
change_pop_graphics - integrated vs dedicated
get_wsl_diskusage - 
nix_make_dev_flake - 

# Table of Contents

- [Key Bindings Reference](#key-bindings-reference)
- [Shell](#shell)
  - [Custom](#custom)
  - [Diagnostics](#diagnostics)
  - [Terminal Buffer Manipulation](#terminal-buffer-manipulation)
  - [Dir navigation](#dir-navigation)
    - [Git](#git)
  - [Oh-my-ZSH Plugins](#oh-my-zsh-plugins)
  - [Nvim](#nvim)
  - [PBX [custom]](#pbx-custom)
- [Wezterm (for multiplexing)](#wezterm-for-multiplexing)
  - [copy mode options (so vimmy)](#copy-mode-options-so-vimmy)
  - [Panes](#panes)
- [TMUX (no longer using)](#tmux-no-longer-using)
  - [TMUX Configuration and Plugins](#tmux-configuration-and-plugins)
  - [Tmux copy mode options (so vimmy)](#tmux-copy-mode-options-so-vimmy)
  - [TMUX Panes](#tmux-panes)
  - [TMUX Sessions](#tmux-sessions)
  - [TMUX Windows](#tmux-windows)
- [Vim](#vim)
  - [Vim General Commands](#vim-general-commands)
  - [Modes_](#modes_)
  - [Bare Vim](#bare-vim)
  - [Vim File Explorer (netrw)](#vim-file-explorer-netrw)
  - [Vim File and Buffer Management](#vim-file-and-buffer-management)
    - [Finding Files](#finding-files)
    - [Working with vim cmd/shell](#working-with-vim-cmdshell)
    - [Managing Changes](#managing-changes)
  - [Buffers](#buffers)
    - [Viewing Buffers](#viewing-buffers)
    - [Switching Buffers](#switching-buffers)
    - [Deleting Buffers](#deleting-buffers)
  - [Windows and Panes](#windows-and-panes)
    - [Tabs](#tabs)
    - [Windows](#windows)
    - [Managing Windows](#managing-windows)
  - [Folding](#folding)
  - [Vim Navigation](#vim-navigation)
    - [Moving along line](#moving-along-line)
    - [Moving along file](#moving-along-file)
    - [Markers](#markers)
  - [Vim Searching and Replacing](#vim-searching-and-replacing)
    - [Searching](#searching)
    - [Searching, replacing, and RegEx](#searching-replacing-and-regex)
    - [Quickfix list commands](#quickfix-list-commands)
  - [SYDC (Selecting/Yanking/Deleting/Changing)](#sydc-selectingyankingdeletingchanging)
    - [Multi-Line](#multi-line)
    - [Mass Select](#mass-select)
    - [Contiguous Lines of text (paragraph)](#contiguous-lines-of-text-paragraph)
    - [Registers: Viewing/Yanking/Pasting](#registers-viewingyankingpasting)
  - [Brackets && Braces](#brackets--braces)
  - [Editing](#editing)
    - [Casing/Capitilization](#casingcapitilization)
    - [Identing](#identing)
    - [Sorting](#sorting)
    - [Indenting](#indenting)
    - [Numbers](#numbers)
  - [Vim Macros and Automation](#vim-macros-and-automation)
  - [Commenting/Uncommenting](#commentinguncommenting)
  - [Vim Troubleshooting](#vim-troubleshooting)
- [Neovim Keybindings](#neovim-keybindings)
  - [Custom Motions (using leader)](#custom-motions-using-leader)
  - [Change / Replace Word Variants](#change--replace-word-variants)
  - [Custom Motions (non-leader)](#custom-motions-non-leader)
  - [General Information](#general-information)
  - [Git (General + LazyGit)](#git-general--lazygit)
  - [Gitsigns (buffer-local – usually in plugin file)](#gitsigns-buffer-local--usually-in-plugin-file)
  - [Harpoon](#harpoon)
  - [Indent](#indent)
  - [LSP](#lsp)
  - [Telescope](#telescope)
  - [Vim-Fugitive](#vim-fugitive)
- [Yazi](#yazi)

# CLI/Shell

## Apache  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Apache                    | `apachelogacc`                | `tail -n15 -f /var/log/apache2/access.log`                |                                   | 
| Apache                    | `apachelogerr`                | `tail -n15 -f /var/log/apache2/error.log`                 |                                   |
| Apache                    | `apacherestart`               | `sudo service apache2 restart`                            |                                   |  
| Apache                    | `e0`                          | `tail -f -n 0 /var/log/apache2/error.log`                 |                                   |
| Apache                    | `ee`                          |`tail -f /var/log/apache2/error.log`                     |                                   | 
| Apache                    | `er`                          | `watch egrep -i 'DBD::' /var/log/apache2/error.log`        |                                   |
| Apache                    | `rr`                          | `sudo service apache2 restart && echo 'Apache Restarted!'` |                                   |
| Apache                    | `re`                          | `rr && ee`                                                 |                                   |
| Apache                    | `tomahawk` / `tt`             | (custom script - possibly a music player or search tool)  |                                   |

---



## General  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Custom                    | `_`                           | sudo                                                      |                                   |
| Custom                    | `ps1_powerline` / `ps1_starship` / `ps1_ohmyposh` | Keep ohmyzsh as shell environment and switch prompt customizer between powerline10k, ohmyposh, and starship (catppuccin mocha). |                                   |
| Custom                    | `ccat`                        | colorize_cat                                              |                                   |
| Custom                    | `ch`                          | /home/bobby/bin/cht.sh (command-line client for cheat.sh cheat sheets). Example `ch perl/array` |                                   |
| Custom                    | `chatgpt`                     | [custom] - CLI interface to ChatGPT/OpenAI                |                                   |
| Custom                    | `cless`                       | colorize_less                                             |                                   |
| Custom                    | `create_and_assume_user`      | [custom] self-explanatory (note: adds user to sudo group) |                                   |
| Custom                    | `colorme`                     | [custom] Pipe to this to color your text                  |                                   |
| Custom                    | `csvlens`                     | Interactive CSV file viewer                               |                                   |
| Custom                    | `diffy`                       | [custom] see diff between two files (side-by-side)        |                                   |
| Custom                    | `dirsync`                     | [custom] Directory synchronizer (sync files between directories) |                                   |
| Custom                    | `docx_to_md`                  | [custom] self-explanatory                                 |                                   |
| Custom                    | `docker_force_old_version`    | [custom] Set Docker version environment variable to 1.43  |                                   |
| Custom                    | `dockbuntu`                   | [custom] Spin up quick ubuntu container (with sudo, vim, git, curl, and wget) |                                   |
| Custom                    | `mp3_dl`                      | [custom] Download MP3 audio from youtube URL              |                                   |
| Custom                    | `egrep`                       | egrep --color=auto (grep -E)                              |                                   |
| Custom                    | `eget`                        | Easy binary downloader from GitHub releases               |                                   |
| Custom                    | `ff`                          | (fuuzzy finder) fzf --height 40% --layout reverse --border |                                   |
| Custom                    | `fgrep`                       | fgrep --color=auto                                        |                                   |
| Custom                    | `fv`                          | 'fuzzy-vim' fuzzy-find a file in the pwd to open with nvim. `nvim $(fzf --height 40% --layout reverse --border)` |                                   |
| Custom                    | `fzf`                         | General-purpose command-line fuzzy finder                 |                                   |
| Custom                    | `ggh`                         | SSH connection manager                                    |                                   |
| Custom                    | `grok`                        | [custom] - xAI Grok CLI                                   |                                   |
| Custom                    | `lazydocker`                  | Simple terminal UI for managing Docker                    |                                   |
| Custom                    | `lazygit` / `lg`              | Simple terminal UI for git commands                       |                                   |
| Custom                    | `lazysql`                     | lazy-based SQL tool                                       |                                   |
| Custom                    | `ollama`                      | Run and manage large language models locally (CLI for Ollama) |                                   |
| Custom                    | `pandoc`                      | Universal document converter (markup to markup/PDF/etc.)  |                                   |
| Custom                    | `perltidy`                    | Indent and reformat Perl scripts                          |                                   |
| Custom                    | `postboy`                     | [custom] Simple CLI-based API tool                        |                                   |
| Custom                    | `posting`                     | Postman in CLI                                            |                                   |
| Custom                    | `posty`                       | [custom] Wrapper for posting with saved collections       |                                   |
| Custom                    | `qc` / `quickconnect`         | [custom] quickconnect - ssh and rdp in cli                |                                   |
| Custom                    | `reposync`                    | [custom] ------- SEARCH repo synchronization tool         |                                   |
| Custom                    | `scpdownloads`                | [custom] cd ~/Documents/SCP-Downloads                     |                                   |
| Custom                    | `spf`                         | (custom script - possibly SPF checker or sender policy framework tool) |                                   |
| Custom                    | `sqlcmd`                      | Microsoft SQL Server command-line query tool              |                                   |
| Custom                    | `ssh_keyupdate`               | [custom] (complex ssh-agent + ssh-add command)            |                                   |
| Custom                    | `starship`                    | Cross-shell prompt (customizable prompt engine)           |                                   |
| Custom                    | `tmux`                        | tmux -2                                                   |                                   |
| Custom                    | `update_lazy`                 | [custom] self-explanatory                                 |                                   |
| Custom                    | `upandup`                     | [custom] sudo apt update && sudo apt upgrade              |                                   |
| Custom                    | `update_aws_creds.sh`         | (custom script - updates AWS credentials)                 |                                   |
| Custom                    | `vscode-cleanup`              | [custom] cleans VS Code cache/data                        |                                   |
| Custom                    | `vscode-cleanup-all`          | [custom] cleans VS Code cache/data - all                  |                                   |
| Custom                    | `vscode-cleanup-pbx`          | [custom] cleans VS Code cache/data - pbx                  |                                   |
| Custom                    | `which-command`               | whence  (?)                                               |                                   |
| Custom                    | `yt-dlp`                      | Feature-rich command-line audio/video downloader          |                                   |
| Custom                    | `wcp`                         | [custom] Copy from WSL to Windows host                    |                                   |
| Custom                    | `wcp`                         | [custom] Copy from WSL to Windows host                    |                                   |
| Custom                    | `uv_start`                    | [custom] - Initializes a uv virtual env and syncs dependencies |                                   |

## Diagnostics  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Diagnostics               | `pscpu`                       | ps auxf \| sort -nr -k 3                                  |                                   |
| Diagnostics               | `pscpu10`                     | ps auxf \| sort -nr -k 3 \| head -10                      |                                   |
| Diagnostics               | `psmem`                       | ps auxf \| sort -nr -k 4                                  |                                   |
| Diagnostics               | `psmem10`                     | ps auxf \| sort -nr -k 4 \| head -10                      |                                   |
| Diagnostics               | `get_wsl_diskusage`           |                                                           |                                   |

## Terminal Buffer Manipulation  

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Terminal Buffer Manipulation      | `Ctrl+x+e`                    | Open temp buffer to run in cli (can run on previous commands or whatevs is in cli) |                                   |
| Terminal Buffer Manipulation      | `fc`                          | edit your lsat command in $EDITOR                         |                                   |

## Dir navigation  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Dir navigation            | `...`                         | cd ../../../                                              |                                   |
| Dir navigation            | `....`                        | cd ../../../../                                           |                                   |
| Dir navigation            | `.....`                       | cd ../../../../                                           |                                   |
| Dir navigation            | `......`                      | ../../../../..                                            |                                   |
| Dir navigation            | `.4`                          | cd ../../../../                                           |                                   |
| Dir navigation            | `.5`                          | cd ../../../../..                                         |                                   |
| Dir navigation            | `..`                          | cd ..                                                     |                                   |
| Dir navigation            | `-`                           | cd -                                                      |                                   |
| Dir navigation            | `1`                           | cd -1                                                     |                                   |
| Dir navigation            | `2`                           | cd -2                                                     |                                   |
| Dir navigation            | `3`                           | cd -3                                                     |                                   |
| Dir navigation            | `4`                           | cd -4                                                     |                                   |
| Dir navigation            | `5`                           | cd -5                                                     |                                   |
| Dir navigation            | `6`                           | cd -6                                                     |                                   |
| Dir navigation            | `7`                           | cd -7                                                     |                                   |
| Dir navigation            | `8`                           | cd -8                                                     |                                   |
| Dir navigation            | `9`                           | cd -9                                                     |                                   |
| Dir navigation            | `callouts_to_list`            | (custom script - converts callouts/markdown to list format) |                                   |
| Dir navigation            | `cb`                          | clipboard manager. See `cb -h`                            |                                   |
| Dir navigation            | `l`                           | ls -lah                                                   |                                   |
| Dir navigation            | `la`                          | ls -lAh                                                   |                                   |
| Dir navigation            | `ll`                          | ls -lh                                                    |                                   |
| Dir navigation            | `ls`                          | ls --color=tty                                            |                                   |
| Dir navigation            | `lsa`                         | ls -lah                                                   |                                   |
| Dir navigation            | `md`                          | mkdir -p                                                  |                                   |
| Dir navigation            | `mkdir`                       | mkdir -pv                                                 |                                   |
| Dir navigation            | `pls`                         | ls with pretty output                                     |                                   |
| Dir navigation            | `rd`                          | rmdir                                                     |                                   |
| Dir navigation            | `cd`                          | 'cd' is now bound to 'z' (zioxode)                        |                                   |
| Dir navigation            | `cdi`                         | to view zioxide interactive list                          |                                   |

### Git  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Git                       | `git_apply_stash_by_name`     |                                                           |                                   |
| Git                       | `git_merge_changes_from_stash` |                                                           |                                   |
| Git                       | `git_fixconflict`             |                                                           |                                   |
| Git                       | `git_addcommit`               | Stage and commit                                          |                                   |
| Git                       | `git_reset`                   | Re-track current branch to repo                           |                                   |
| Git                       | `git_discard_old_stashes`     | Current stash count (keeping latest 10)                   |                                   |
| Git                       | `lg`                          | Lazygit                                                   |                                   |
| Git                       | `showmerges`                  | Shows last 15 merges                                      |                                   |
| Git                       | `showmerges`                  | git log --oneline --merges -E --grep 'DEV-[0-9]+' -n 15   |                                   |
| Git                       | `git_force_push`              | Add ssh key to agent and push                             |                                   |
| Git                       | `gc`                          | 'Git Clean' - drop all local changes - head to master, git pull, and restart apache |                                   |
| Git                       | `git_setsshkey`               | Set ssh key                                               |                                   |
| Git                       | `git_set_sshconnection`       | Set git connection to ssh instead of https (good if using ssh keys) |                                   |

## Oh-my-ZSH Plugins  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Oh-my-ZSH Plugins         | `ccat/cless`                  | colorized cat+less                                        |                                   |
| Oh-my-ZSH Plugins         | `copyfile`                    | copy file contents to system clipboard                    |                                   |
| Oh-my-ZSH Plugins         | `<C-o>`                       | copy cmdline contents to system clipboard (copybuffer)    |                                   |
| Oh-my-ZSH Plugins         | `copypath`                    | copy file path                                            |                                   |
| Oh-my-ZSH Plugins         | `<C-z>`                       | Allows pressing `<C-z>` again to switch back to a background job. |                                   |

## Nvim  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Nvim                      | `config_sync_alpha`           | Push local nvim config changes up to alpha machine        |                                   |
| Nvim                      | `local_config_save`           | Update local nvim config with latest from repo            |                                   |
| Nvim                      | `local_config_update`         | Update local config files with latest from repo (doesn't replace ~/.config/nvim and keeps cache) |                                   |
| Nvim                      | `local_config_update_and_nvim_update` | Update local config files and nvim config with latest from repo (replaces ~/.config/nvim and removes cache) |                                   |
| Nvim                      | `edit_nvim_conf`              | [custom] - open nvim in ~/.config/nvim/                   |                                   |
| Nvim                      | `nv`                          | NVIM_APPNAME=nvim-lazy nvim                               |                                   |
| Nvim                      | `nvim`                        | Neovim text editor                                        |                                   |
| Nvim                      | `nvim-custom`                 | [custom] NVIM_APPNAME="nvim-custom" nvim                  |                                   |
| Nvim                      | `clear_nvim_swaps`            | [custom] self-explanatory                                 |                                   |
| Nvim                      | `fv`                          | fuzzy find a file to open with nvim                       |                                   |

## PBX [custom]  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| PBX [custom]              | `clear_wgets`                 |                                                           |                                   |
| PBX [custom]              | `download_veeam_report`       |                                                           |                                   |
| PBX [custom]              | `perly`                       | /usr/bin/perl /home/control-io/www/DevSandbox/Sandbox/_templates/perly.pl |                                   |
| PBX [custom]              | `perlyprod`                   | /usr/bin/perl /home/control-io/www/DevSandbox/Sandbox/_templates/perlyprod.pl |                                   |
| PBX [custom]              | `prod_scratch`                | /usr/bin/perl /home/control-io/www/DevSandbox/Sandbox/_templates/prod_scratch.pl |                                   |
| PBX [custom]              | `rl`                          | tail -f /home/control-io/www/log/templog                  |                                   |
| PBX [custom]              | `rl2`                         | tail -f /home/control-io/www/log/templog2                 |                                   |
| PBX [custom]              | `reposync_thisdir_to_alpha`   | reposync . alpha ongoing                                  |                                   |
| PBX [custom]              | `restarthive.sh`              | (custom script - likely restarts a Hive service)          |                                   |
| PBX [custom]              | `restart_hive`                |                                                           |                                   |
| PBX [custom]              | `perlygrep`                   |                                                           |                                   |

# Wezterm (for multiplexing)  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| General                   | Leader key                    | `Ctrl-Space`                                              |                                   |
| General                   | `<C-T>`                       | New window (tab)                                          |                                   |
| General                   | `<C-R>`                       | Reload conf script                                        |                                   |

## copy mode options (so vimmy)    

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| copy mode options (so vimmy)      | `<Ctrl-X>`                    | Enter copy mode                                           |                                   |
| copy mode options (so vimmy)      | `<C-F>`                       | Start search (once in copy mode)                          | Enter search term and then `<Enter>` (then use `<C-n>`/`<C-p>` to search throughout matches. End search: `Esc` |
| copy mode options (so vimmy)      | `g`                           | go to top of pane (scrolls to top)                        |                                   |
| copy mode options (so vimmy)      | `G`                           | go to the bottom of the file (scrolls to bottom)          |                                   |
| copy mode options (so vimmy)      | `<C-u>` / `<C-d>`             | act as they do in vim                                     |                                   |

## Panes  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Panes                     | `<leader> v`                  | Split Windows Vertically (like vim)                       |                                   |
| Panes                     | `<leader> s`                  | Split Windows Horizontally (like vim)                     |                                   |
| Panes                     | `<alt> <arrow-key>`           | Navigate subwindows (panes) (like vim)                    |                                   |
| Panes                     | `<C-Z>`                       | Zoom/Unzoom panes                                         |                                   |

---

# TMUX  (no longer using)

## TMUX Configuration and Plugins  
- Enable TMUX plugins by install TPM: `https://github.com/tmux-plugins/tpm`  
- Reload config file: `tmux source ~/.tmux.conf`  
- Reload TMUX environment: `<C-i>`  _For re-loading Theme for example_  
- Custom Bind key I've set: `<C-t> R`  
- Open cheat.sh: `<bind-key> S`  

## Tmux copy mode options (so vimmy)    

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Tmux copy mode options (so vimmy) | `<bind-key> [`                | Enter copy mode                                           |                                   |
| Tmux copy mode options (so vimmy) | `/` / `?`                     | Start search (once in copy mode)                          | Enter search term and then `<Enter>` (then use `n`/`N` to search throughout matches - search starts at top of page, use `N` to search backwards). End search: `q` |
| Tmux copy mode options (so vimmy) | `g`                           | go to top of pane (scrolls to top)                        |                                   |
| Tmux copy mode options (so vimmy) | `G`                           | go to the bottom of the file (scrolls to bottom)          |                                   |
| Tmux copy mode options (so vimmy) | `<C-e>` / `<C-y>` / `<C-u>` / `<C-d>` | act as they do in vim                                     |                                   |
| Tmux copy mode options (so vimmy) | `<bind-key> ]`                | Paste (from tmux buffer)                                  |                                   |
| Tmux copy mode options (so vimmy) | `<C-S-v>`                     | Paste (from system clipboard)                             |                                   |

__Neovim and Cli quick copy commands__  
- Tmux quick copy (from cli to system clipboard): `Mouse select + y (while selecting)`  
- Neovim copy (clipboard) => `Select (mouse/v) + y`  

## TMUX Panes  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| TMUX Panes                | `<bind_key> \|`               | Split Windows Vertically (with my conf I use `\|` instead of `%`) |                                   |
| TMUX Panes                | `<bind_key> _`                | Split Windows Horizontally (with my conf I use `_` instead of `"`) |                                   |
| TMUX Panes                | `<bind_key> <arrow-key>`      | Navigate subwindows (panes)                               |                                   |
| TMUX Panes                | `<bind_key> Q`                | Show pane numbers                                         |                                   |
| TMUX Panes                | `<bind_key> {`                | Move current pane left                                    |                                   |
| TMUX Panes                | `<bind_key> }`                | Move current pane right                                   |                                   |
| TMUX Panes                | `<bind_key> z`                | Zoom in/out to make pane full screen                      |                                   |
| TMUX Panes                | `exit` or `<C-b> z`           | Close pane                                                |                                   |

## TMUX Sessions  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| TMUX Sessions             | `tmux new -s <name>`          | Open tmux as a named session                              |                                   |
| TMUX Sessions             | `<bind_key> D`                | To detach a tmux session                                  |                                   |
| TMUX Sessions             | `tmux ls`                     | View tmux sessions (from cli)                             |                                   |
| TMUX Sessions             | `tmux attach -t 0`            | Re-attach to session (from cli)                           |                                   |
| TMUX Sessions             | `tmux rename-session -t 0 <name>` | Rename tmux sessions (from cli)                       |                                   |
| TMUX Sessions             | `tmux kill-session -t 0 <name>` | Killing tmux sessions (from cli)                       | Where ‘0’ is your session id/name |

## TMUX Windows  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| TMUX Windows              | `<bind_key> ,`                | Rename Window                                             |                                   |
| TMUX Windows              | `<bind_key> c`                | Create new Window                                         |                                   |
| TMUX Windows              | `<bind_key> S`                | Show all Windows                                          |                                   |
| TMUX Windows              | `<bind_key> w`                | Show all Windows (with preview)                           | _Enter to select_ |
| TMUX Windows              | `<bind_key> <number>`         | Switch between windows                                    |                                   |
| TMUX Windows              | `<bind_key> &`                | Close Window (or `exit` if all panes are closed)          |                                   |

# Vim  

There are loads of good vim cheat sheets out there and this isn't a substitution, but rather a list of common/handy ones I've found to be efficient on my workflow.  
[Ultimate Cheat Sheet](https://catswhocode.com/vim-cheat-sheet)  
[LeanXinY](https://learnxinyminutes.com/docs/vim/)  
[vim.rtott](https://vim.rtott.com/)  
[DevHints-vim](https://devhints.io/vim)  

## Bare Vim  
(common settings to apply on a ad-hoc plain vim editor)

```vim  
colo slate  
set number/relativenumber  
set mouse=a  
set ignorecase  
set hlsearch  
set incsearch  
set cursorline  
syntax on
filetype on
set wrap! (toggle on of off)
```


# Full

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim General Commands      | `ter[minal]`                  | Open terminal (may need to hit `i` to beging typing)      |                                   |
| Vim General Commands      | `exit` / `<C-d>` then `<C-w> q` | to close terminal window                                |                                   |
| Vim General Commands      | `:verbose map Q`              | see what is mapped to the `Q` key                         |                                   |
| Vim General Commands      | `<C-\> <C-n>`                 | Exit "terminal mode".                                     | On "Ctrl-\ Ctrl-n" This key combination switches the terminal buffer from terminal-insert mode (where you interact with the shell) to Vim’s normal mode. In normal mode, you can use Vim commands like :hide, navigate windows, or edit other buffers. In terminal-insert mode, Vim passes most keystrokes directly to the shell, so you can’t use Vim commands like :hide until you enter normal mode. `<C-\>` is a special prefix in Vim’s terminal mode to signal a command to Vim itself rather than the shell. `<C-n>` (or Ctrl-N) tells Vim to switch to normal mode. You’ll notice the cursor behavior changes, and Vim’s command line becomes available (e.g., you can type : to enter commands). Visual cue: In normal mode, the terminal buffer becomes “read-only” from Vim’s perspective, and you can’t type into the shell until you return to insert mode (e.g., by pressing i). |
| Modes                    | `<C-b>`                       | Visual-Block mode (Ctrl+B)                                |                                   |
| Modes                    | `<S-v>`                       | Visual Line Mode                                          |                                   |


## Vim File Explorer (netrw)  

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Vim File Explorer (netrw)         | `:Explore`                    | Explorer (opens file tree)                                |                                   |
| Vim File Explorer (netrw)         | `:Vex`                        | Vertical Explorer (opens file tree)                       |                                   |
| Vim File Explorer (netrw)         | `i`                           | Rotate betweeb views (3rd is tree mode)                   |                                   |
| Vim File Explorer (netrw)         | `v`                           | Open file in vertical split (opens to left by default unless `set splitright` is set |                                   |
| Vim File Explorer (netrw)         | `u`                           | Go up one level                                           |                                   |

## Vim File and Buffer Management  

#### Finding Files

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Vim File and Buffer Management / Finding Files | `:args **/*filename*.pl` | Search for file by partial name and file type recursively |                                   |
| Vim File and Buffer Management / Finding Files | `<C-q>`                   | Adds :args results to Quickfix list (keybinding)          |                                   |

#### Working with vim cmd/shell

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Vim File and Buffer Management / Working with vim cmd/shell | `<C-r>3`               | Paste from 3 register (in insert mode or into vim command line). Useful for pasting into a search regex |                                   |
| Vim File and Buffer Management / Working with vim cmd/shell | `:read !<shell_command>` | Paste shell output into buffer.                        |                                   |
| Vim File and Buffer Management / Working with vim cmd/shell | `:g/function/d`        | Delete all lines matching the pattern 'function'          |                                   |
| Vim File and Buffer Management / Working with vim cmd/shell | `q:`                   | Opens a buffer of previous commands to execute (with enter key) |                                   |
| Vim File and Buffer Management / Working with vim cmd/shell | `q/`                   | Opens a buffer of previous searches to execute (with enter key) |                                   |
| Vim File and Buffer Management / Working with vim cmd/shell | `<C-l>`                | Move window to far left                                   |                                   |
| Vim File and Buffer Management / Working with vim cmd/shell | `<C-w>`                | delete previous word                                      |                                   |

#### Managing Changes

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Vim File and Buffer Management / Managing Changes | `:wa` / `wall`          | ("write all") save all open buffers                       |                                   |
| Vim File and Buffer Management / Managing Changes | `:e!`                   | erase all unsaved changes                                 |                                   |
| Vim File and Buffer Management / Managing Changes | `:bufdo e!`             | erase all unsaved changes (in all open buffers)           |                                   |
| Vim File and Buffer Management / Managing Changes | `u`                     | undo last change (normal mode)                            |                                   |
| Vim File and Buffer Management / Managing Changes | `<C-u>`                 | undo last change (insert mode)                            |                                   |
| Vim File and Buffer Management / Managing Changes | `<C-r>`                 | Redo                                                      |                                   |
| Vim File and Buffer Management / Managing Changes | `:w !diff %` or `:w !git diff --no-index % -` | view changes in vim before saving (or add this in .vimrc `command Diff execute 'w !,且git diff --no-index % -'`) |                                   |
| Vim File and Buffer Management / Managing Changes | `:earlier 2h`           | [Time-based undo] Reverts file to state 2hours ago (can use `m` or `s` for minutes/seconds) |                                   |
| Vim File and Buffer Management / Managing Changes | `:later 2h`             | [Time-based redo] Reverts file to state 2hours ago (can use `m` or `s` for minutes/seconds) |                                   |

### Buffers

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Buffers                   | `:E`                          | Open file nav (short for `explore`)                       |                                   |
| Buffers                   | `:e ~/.vimrc`                 | edit a file by name (short for `:edit`).                  |                                   |
| Buffers                   | `:e`                          | reload current buffer from disk                           |                                   |
| Buffers                   | `:e!`                         | Remove all unsaved changes                                |                                   |
| Buffers                   | `:vert ba`                    | edit all buffers as vertical windows                      |                                   |
| Buffers                   | `:tab ba`                     | edit all buffers as tabs                                  |                                   |
| Buffers                   | `gf`                          | Find and open the file by filename under cursor           |                                   |
| Buffers                   | `<C-^>`                       | (which is Ctrl+6) - swap back and forth between current (#) and alternate (a%) buffers. |                                   |
| Buffers                   | `:b6`                         | Go to buffer 6                                            |                                   |

### Viewing Buffers

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Viewing Buffers           | `:b` then `<C-d>`             | show all open buffers to cycle though.                    |                                   |
| Viewing Buffers           | `:ls`                         | view buffers or (`buffers` with plugin)                   |                                   |

### Switching Buffers

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Switching Buffers         | `:b file1.txt`                | Select by filename (tab shows open buffers, but can open new files as well) |                                   |
| Switching Buffers         | `:bn`                         | rotate to next buffer.                                    |                                   |
| Switching Buffers         | `:bp`                         | rotate back to previous buffer.                           |                                   |
| Switching Buffers         | `:b3`                         | Select buffer #3 (may need to force with `b!3`).          |                                   |
| Switching Buffers         | `:bf` or `:bl`                | go to first/last buffer (f/l)                             |                                   |
| Switching Buffers         | `:badd myfile.txt`            | add a new buffer by filename                              |                                   |

### Deleting Buffers

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Deleting Buffers          | `:bd myfile.txt`              | delete a buffer by buffer number or filename              |                                   |
| Deleting Buffers          | `:%bd`                        | Delete all open buffers                                   |                                   |

## Windows and Panes  

### Tabs

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Windows and Panes / Tabs  | `:tabnew` or `:tabnew {file}` | open a file in a new tab                                  |                                   |
| Windows and Panes / Tabs  | `<C-w> T`                     | move the current split window into its own tab            |                                   |
| Windows and Panes / Tabs  | `gt`                          | move to the next tab                                      |                                   |
| Windows and Panes / Tabs  | `gT`                          | move to the previous tab                                  |                                   |
| Windows and Panes / Tabs  | `2gt`                         | switch to tab #2                                          |                                   |
| Windows and Panes / Tabs  | `:tabc`                       | close the current tab and all its windows                 |                                   |
| Windows and Panes / Tabs  | `:tabo`                       | Tabonly - close all tabs except for the current one       |                                   |
| Windows and Panes / Tabs  | `:tabdo {cmd}`                | run the command on all tabs (e.g. :tabdo q - closes all opened tabs) |                                   |

### Windows

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Windows and Panes / Windows | `<C-w> s`                   | Split open buffer horizontally                            |                                   |
| Windows and Panes / Windows | `<C-w> v`                   | Split open buffer vertically                              |                                   |
| Windows and Panes / Windows | `:vert sb {filename}`       | Split buffer with another open buffer (you can enter file name or use tab to cycle through open buffers) |                                   |
| Windows and Panes / Windows | `:e {filename}`             | Edit filename in current window                           |                                   |
| Windows and Panes / Windows | `:sp {filename}`            | Split the window and open filename (if empty just splits the same buffer) |                                   |
| Windows and Panes / Windows | `:vs file`                  | Vertically split window  (enter open/unopened file)       |                                   |

### Managing Windows

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Windows and Panes / Managing Windows | `<C-w> q` or `:clo`      | Close current window                                      |                                   |
| Windows and Panes / Managing Windows | `<C-w> <up>`             | Put cursor in top window (works for any direction)        |                                   |
| Windows and Panes / Managing Windows | `<C-w> w`                | Focus on next window                                      |                                   |
| Windows and Panes / Managing Windows | `<C-w> w`                | Switch to next window                                     |                                   |
| Windows and Panes / Managing Windows | `<C-w> H`                | Make Leftmost full  vertical window                       |                                   |
| Windows and Panes / Managing Windows | `<C-w> L`                | Make Rightmost full  vertical window                      |                                   |
| Windows and Panes / Managing Windows | `<C-w>=`                 | Gives the same size to all windows                        |                                   |
| Windows and Panes / Managing Windows | `<C-w>\|`                | Current window width = 100%                               |                                   |
| Windows and Panes / Managing Windows | `50<C-w>\|`              | Current window width = 50% of initial window width        |                                   |
| Windows and Panes / Managing Windows | `<C-w>_`                 | Maximize current window vertically                        |                                   |
| Windows and Panes / Managing Windows | `:only`                  | Close all windows, except current                         |                                   |
| Windows and Panes / Managing Windows | `hide`/`unhide`          | Hide/Unhide a window (only 1)                             |                                   |
| Windows and Panes / Managing Windows | `:qa`                    | Quit All open windows (exits vim if on last tab)          |                                   |

### Folding    

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Folding                   | `zf`                          | Create a fold from selected lines                         |                                   |
| Folding                   | `zf10j`                       | Create fold from current line to 10 lines down            |                                   |
| Folding                   | `zc`                          | fold a block of code (z = fold and c = close)             |                                   |
| Folding                   | `zo`                          | unfold a block of code (z = fold and c = open)            |                                   |
| Folding                   | `zM`                          | fold all blocks in buffer                                 |                                   |
| Folding                   | `zR`                          | unfolds all in buffer                                     |                                   |

## Vim Navigation  

### Moving along line

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim Navigation / Moving along line | `t{`                     | Move to next `{` and use `;` to see sebsequent match (and `,` for previous match) |                                   |
| Vim Navigation / Moving along line | `e`                      | end of word                                               |                                   |
| Vim Navigation / Moving along line | `E`                      | end of word (punctuation included)                        |                                   |
| Vim Navigation / Moving along line | `{` / `}`                | Move up/down in paragraphs                                |                                   |

### Moving along file

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim Navigation / Moving along file | `gg`                     | Go to top of file                                         |                                   |
| Vim Navigation / Moving along file | `G`                      | go to bottom of file                                      |                                   |
| Vim Navigation / Moving along file | `{num}G` (Ex: `42G`)     | Go to line (preferred as its added to jumplist)           |                                   |
| Vim Navigation / Moving along file | `: {num}`                | Go to line                                                |                                   |
| Vim Navigation / Moving along file | `zz`                     | Center screen with cursor position (don't confuse with ZZ - save) |                                   |
| Vim Navigation / Moving along file | `I`/`A`                  | Go to begin/end of line                                   |                                   |
| Vim Navigation / Moving along file | `{`/`}`                  | move up/down along chunks of text (paragraphs)            |                                   |
| Vim Navigation / Moving along file | `gd`                     | go to definition (where func/sub is defined)              |                                   |
| Vim Navigation / Moving along file | `<C-o>` / `<C-i>`        | Jump forward/backward in jump list (`:jumps`)             |                                   |

### Markers

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim Navigation / Markers  | `<leader> rm`                 | Remove markers                                            |                                   |
| Vim Navigation / Markers  | `:marks`                      | View all markers                                          |                                   |
| Vim Navigation / Markers  | `:cc 22`                      | View the 22nd quickfix item                               |                                   |
| Vim Navigation / Markers  | `'` (backtick or single quote) | View all markers w/explanations [🔌]                      |                                   |
| Vim Navigation / Markers  | `m {a-z}`                     | Setting markers/waypoints as {a-z}                        |                                   |
| Vim Navigation / Markers  | `'{a-z}`                      | Move to marker/position {a-z}                             |                                   |
| Vim Navigation / Markers  | `:delm!`                      | vim clear all marks (or specific ranges like `:delm a-zA-Z0-9`) |                                   |
| Vim Navigation / Markers  | `''`                          | Move to previous marker position  (thats two single quotes in succession, not a single double quote) | Note: Lowercase markers are local to a file and uppercase markers are global across all files. Meaning you can re-use `a` for different places in different files but `A` only refers to one place in a single file. |

## Vim Searching and Replacing  

#### Searching

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim Searching and Replacing / Searching | `/`                     | Search (grep): type text and enter then `n`/`N` to iterate through matches |                                   |
| Vim Searching and Replacing / Searching | `<C-q>`                 | Save search results in a quickfix list (we can even grep the quick fix list with `/`) |                                   |
| Vim Searching and Replacing / Searching | `cn`/`cp`               | Next/Previous item in quickfix list. Mapped to `F11`/`F12`. |                                   |
| Vim Searching and Replacing / Searching | `<C-r> "`               | Yanks the unamed register into the search box. This will paste in anything yanked. |                                   |

#### Searching, replacing, and RegEx

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `\r`               | This represents newline                                   |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:%s/(foo)/\1\r`   | Replaces matches with itself followed by a newline ('%' represents every occurence in the buffer) |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:s/old/new/g`     | When text is selected you can use a replace (without the %) to replace text within the selected range (use `gc` to replace with confirmation first) |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:s/\VTEXTOMATCH/REPLACEWITHTHIS/` | The `\V` (very no magic mode treats all characters literaly except the `\` |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:s/\v\w+/`        | The `\v` (very magic mode treats most special cahrs as special - as in regular regex |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:s/old/new/g22`   | Replace 'old' with 'new' every every occurence in a line (g) including the next 22 lines. |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:noh`             | "No Highlighting" - remove highlited matches              |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:vim /function/ **/*.pl` | Grep all matches of `function` in every '.pl. file in current dir (recursively). Then `:cope` to create a QuickFix list |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:vim /\Vfunction/ /home/ubuntu/**/*.pl` | Grep all matches of `function` in every '.pl. file in current dir (recursively). Then `:cope` to create a QuickFix list |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:g&`              | Apply previous replace action to the entire file          |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:grep '^sub run_powershell' -g \*.pl` | Regex search using grep on perl files                  |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:grep '^sub run_powershell' -g '{*.pl,*.pm}'` | Regex search using grep on perl files (ripgrep)     |                                   |
| Vim Searching and Replacing / Searching, replacing, and RegEx | `:grep -E '^sub run_powershell' *.pl` | Regex search using grep on perl files  (posix grep) Use `:grep text %` to search current buffer |                                   |

Notes  
- `:s/foo/bar/` - replace 1st occurrence on current line  
- `:%s?foo/bar/` - replace 1st occurrence on every line  
- `:.,$s?foo/bar/` - replace 1st occurrence on every line until end of buffer  

#### Quickfix list commands

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Vim Searching and Replacing / Quickfix list commands | `:cope`                | open quickfix list                                        |                                   |
| Vim Searching and Replacing / Quickfix list commands | `:cclose`              | close quickfix list                                       |                                   |
| Vim Searching and Replacing / Quickfix list commands | `:cnext` / `:cn`       | go to next quickfix list item                             |                                   |
| Vim Searching and Replacing / Quickfix list commands | `:cprevious` / `:cp`   | go to previous quickfix list item                         |                                   |
| Vim Searching and Replacing / Quickfix list commands | `:s/foo/bar/g`         | replace text on a highlighted quickfix line               |                                   |
| Vim Searching and Replacing / Quickfix list commands | `:cdo s/foo/bar/g`     | replace text on all quickfix list items (globally - every occurence in each line) |                                   |
| Vim Searching and Replacing / Quickfix list commands | `:cdo s/foo/bar/gc`    | replace text on all quickfix list items (globally - every occurence in each line)  - with confirmation |                                   |

### Finding Multiple Occurrences  

1. Select text (in visual mode)  
2. `#` to highlight all occurences (can use `*` but that begins at next occurence)  
3. `n`/`N` to select next/previous occurences  
4. `v` again to select the highlighted occurence  

### Change multiple instances without multi-cursor  

1. Select text to change  
2. `#` to highlight all matches (selects next match)  
3. Make sure you're in normal mode  
4. `cgn` - change globally (when done changing, press `Esc` to exit insert mode)  
5. `.` to change every subsequent match.  

_(Can also use dgn to delete multiple references)_  

## SYDC (Selecting/Yanking/Deleting/Changing)

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| SYDC (Selecting/Yanking/Deleting/Changing) | `gv`                     | Re-select last selected text                              |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `viw`                    | selects just the word.                                    |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `vaw`                    | selects the word plus any surrounding whitespace.         |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `<C-r>w`                 | Copy whatever word is under cursor and paste into vim command line. (Useful for pasting into a search regex) |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `o`                      | Reverse order while continuing to select (switches cursor between start/end of selected text) |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `/<term>`                | While in visual mode, select lines based on RegEx         |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `<C-v>`                  | enter visual block mode. Once text is selected enter insert mode (`a`/`A`,`i`/`I`,`c`/`C`,`p`/`P`,`o`/`O` etc) and make changes. They will appear on the first line, but once you hit Esc those changes will be made to all selected lines. |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `gs{char}`               | Global surround. Example: Select text then `gs"`          |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `d` or `dd`               | Cuts (Deletes and yanks)                                  |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `D` / `d$`               | Cut to end of line                                        |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `Y` / `y$`               | Yank/Copy to end of line                                  |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `C`                       | Cut to end of line                                        |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `:m 5`                    | Move line under cursor (or selected lines) to line 5      |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `:2,7m 5`                 | Move lines 2-7 to line 5                                  |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `vib`                     | Select inside next `()` occurrence (works with `y`/`d`)   |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) | `viB`                     | Select inside current `{}` (works with `y`/`d`)           |                                   |

#### Multi-Line

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| SYDC (Selecting/Yanking/Deleting/Changing) / Multi-Line | `10y`               | Yank 10 lines                                             |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Multi-Line | `10d`               | Delete 10 lines                                           |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Multi-Line | `10V`               | Select 10 lines                                           |                                   |

#### Mass Select

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| SYDC (Selecting/Yanking/Deleting/Changing) / Mass Select | `ggVG`             | Select entire file                                        |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Mass Select | `:1,500y`          | Copy everything from line 1 to 500 (use `d` for delete) (can start/end on any line - usefull for slicing bits) |                                   |

#### Continguous Lines of text (paragraph)

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `yap` | Yank with newlines                                        |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `yip` | Yank without newlines                                     |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `cap` | Change with newlines                                      |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `cip` | Change without newlines                                   |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `dap` | Delete with newlines                                      |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `dip` | Delete without newlines                                   |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `vii` | Selects the "inner indent" block (lines with the same indentation level as the cursor, excluding surrounding blank lines) |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Continguous Lines of text (paragraph) | `vai` | Selects "a indent" block (includes the inner block plus the lines immediately above/below with less indentation, like a function definition). |                                   |

#### Registers: Viewing/Yanking/Pasting

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `:reg` | View registers (vim)                                      |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `"0p` | Paste from 0 register (in normal mode)                    |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `"2p` | Paste 2nd to last thing yanked (grabs from 2 register in normal mode) |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `"_dd` | Delete line and yank to black hole register (keeps registers the same). |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `"1yiw` | Yank word under cursor into register 1                 |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `ayy` | Yank line to "a" register (overwriting register a).       |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `Ayy` | Yank line to "a" register (appending to register a)       |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `"+y` | Yank text into system clipboard                           |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `<C-r> *` | put the clipboard contents (X11: primary selection)    |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `<C-r> +` | put the clipboard contents                             |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `<C-r> /` | put the last search pattern                            |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `<C-r> :` | put the last command-line                              |                                   |
| SYDC (Selecting/Yanking/Deleting/Changing) / Registers: Viewing/Yanking/Pasting | `<C-r> "` | Paste from unamed register (anything yanked). Works in insert mode and command mode | _Note: '^J' in a register will be changed to a newline when pasting._ |

### Brackets && Braces  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Brackets && Braces        | `%`                           | Select top/bottom of current block                        |                                   |
| Brackets && Braces        | `v%`                          | Select Content within parens/brackets (inclusively) if you're right before a bracket. |                                   |
| Brackets && Braces        | `vi{`                         | Selects everything within the block... then Esc to leave you at ending "}" |                                   |
| Brackets && Braces        | `ci{`                         | Change text inside brackets (exclusively)                 |                                   |
| Brackets && Braces        | `ca{`                         | Change text inside brackets (inclusively)                 |                                   |
| Brackets && Braces        | `yi{`                         | Yank text inside brackets (inclusively)                   |                                   |
| Brackets && Braces        | `ya{`                         | Yank text inside brackets (exclusively)                   |                                   |
| Brackets && Braces        | `di{`                         | Delete text inside brackets (inclusively)                 |                                   |
| Brackets && Braces        | `da{`                         | Delete text inside brackets (exclusively)                 |                                   |
| Brackets && Braces        | `{action}ab`                  | (y)ank/ (d)elete, (v)isual select entire block of code including lines where curly braces are on. Or, `zcdd` (zc to fold the block and dd to cut). |                                   |
| Brackets && Braces        | `[{`                          | Go to opening containing curly brace (scope-based) |                                   |
| Brackets && Braces        | `[{`                          | Go to opening containing curly brace (scope-based) |                                   |
| Brackets && Braces        | `]]`                          | Go to top-level opening '{', good for iteratiing through function starts. |                                   |
| Brackets && Braces        | `[[`                          | Go to top-level opening closed '{', good for iteratiing through function ends. |                                   |
## Editing    

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Editing                   | `ciw`                         | Change inner word (replace)                               |                                   |
| Editing                   | `xp`                          | swap two adjacent letters (move letter cursor one place to the right) |                                   |
| Editing                   | `J`                           | Merge lines: Apend line below to the end of the current line. |                                   |
| Editing                   | `cc`                          | change entire line.                                       |                                   |
| Editing                   | `dt/<searchterm>`             | Delete text up until search term                          |                                   |
| Editing                   | `:sort`                       | Sort selected lines (`!sort` for reverse order)           |                                   |
| Editing                   | `:norm I#`                    | Insert a '#' at the start of each selected line           |                                   |
| Editing                   | `:norm A;`                    | Append a ';' to the end of each highlited line            |                                   |
| Editing                   | `:norm I/* A */`              | Insert '/*' at the start of each selected line and append '*/' at the end of each selected line |                                   |
| Editing                   | `:g/error/norm I#`            | Insert a '#' at the start of each line that matches the pattern /error/ |                                   |
| Editing                   | `ct{`                         | Change everything from cursor position to next `{` occurence |                                   |

### Casing/Capitilization  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Editing / Casing/Capitilization | `gu` / `gU`              | Lowercase/Uppercase character under cursor                |                                   |
| Editing / Casing/Capitilization | `guiw` / `gUiw`          | Lowercase/Uppercase word under cursor                     |                                   |
| Editing / Casing/Capitilization | `guu` / `gUU`            | Lowercase/Uppercase entire line                           |                                   |
| Editing / Casing/Capitilization | `u`                      | Selected text to lower case                               |                                   |
| Editing / Casing/Capitilization | `U`                      | Selected text to upper case                               |                                   |
| Editing / Casing/Capitilization | `~`                      | Inverse casing of selected text/character under cursor.   |                                   |
| Editing / Casing/Capitilization | `g~w`                    | change case of word (until whitespace)                    |                                   |
| Editing / Casing/Capitilization | `g~~`                    | change case of entire line                                |                                   |

### Identing  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Editing / Identing        | `<<`/`>>`                     | Indent code left/right                                    |                                   |
| Editing / Identing        | `==`/`=`                      | Auto indent code (`==` for one line and `=` for multiple lines) |                                   |

### Sorting  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Editing / Sorting         | `:sort`                       | Sort all lines                                            |                                   |
| Editing / Sorting         | `:sort!`                      | Sort all lines in reverse                                 |                                   |
| Editing / Sorting         | `:sort u`                     | Sort all lines and remove duplicates                      |                                   |
| Editing / Sorting         | `:sort`/`:sort!`              | When lines are selected, this will sort in ASC/DESC order respectively. |                                   |

### Indenting  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Editing / Indenting       | `=`                           | Auto-Indenting (based on rules - works on selected text as well) |                                   |
| Editing / Indenting       | `=ap`                         | Auto-Indent Paragraph                                     |                                   |
| Editing / Indenting       | `<`                           | Indent Left                                               |                                   |
| Editing / Indenting       | `>`                           | Indent Right                                              |                                   |

### Numbers  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Editing / Numbers         | `<C-a>`                       | Increment Highlighted Numbers                             |                                   |
| Editing / Numbers         | `<C-x>`                       | Decrement Highlighted Numbers                             |                                   |
| Editing / Numbers         | `g<C-a>`                      | Increment Highlight Numbers in sequence (each matched item will increment one more than previous match). |                                   |
| Editing / Numbers         | `g<C-x>`                      | Decrement Highlight Numbers in sequence (each matched item will increment one more than previous match). |                                   |

## Vim Macros and Automation  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim Macros and Automation | `q<letter>`                   | start recording a macro                                   |                                   |
| Vim Macros and Automation | `q`                           | stop recording a macro                                    |                                   |
| Vim Macros and Automation | `@<letter>`                   | execute macro (once)                                      |                                   |
| Vim Macros and Automation | `@@`                          | Rerun the last ran macro                                  |                                   |
| Vim Macros and Automation | `<number>@<letter>`           | To execute the macro <number> times                       |                                   |
| Vim Macros and Automation | `:3,9 normal @b`              | Run macro "b" on lines 3-9.                               |                                   |
| Vim Macros and Automation | `:reg <macro_letter>`         | View register (holds macros as well - note '[^' represents the Esc key) |                                   |
| Vim Macros and Automation | `@:`                          | re-run last vim command                                   |                                   |
| Vim Macros and Automation | `.`                           | re-run last command in normal mode                        |                                   |

### Best Practices when recording macros  
- Once recording has started, type `0` to begin at the beginning of the line.  
- Once done with commands, type 'j' before you finish recording to ensure ending on the next line (in case this macro runs multiple times).  

## Commenting/Uncommenting  

### Uncommenting  
- Put your cursor on the first comment character (like #), and enter Visual-Block mode (`<C-b>` for me)  
- Go down until the last commented line and press `x`  

### Commenting  

_Option 1_  
- Enter Visual-Block mode (`<C-b>` for me) then enter `:s/^/#/`  

_Option 2_  
- Enter Visual-Block mode (`<C-b>` for me)  
- Go down until last line and press `I`, then press `#` (or other comment character), then `Esc`.  

<br />  

## Vim Troubleshooting  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim Troubleshooting       | `:highlight Delimiter`        | See what styles apply to the "Delimiter" highlightgroup   |                                   |
| Vim Troubleshooting       | `:highlight Delimiter`        | See what styles apply to the "Delimiter" highlightgroup (verbose) |                                   |
| Vim Troubleshooting       | `:echo synIDattr(synID(line("."), col("."), 1), "name")` | See highlight group applying to item under cursor |                                   |
| Vim Troubleshooting       | `:echo map(synstack(line("."), col(".")), 'synIDattr(v:val, "name")')` | See all highlight groups that could apply to item under cursor |                                   |

_Note: `<C-...>` should be taken to mean `Ctrl+`. All other keys are to be entered in succession (not simultaneously)._  

---  

# Neovim Keybindings  

- `:source $MYVIMRC` - Reload config (and plugins) without restarting nvim  
- `:MarkdownPreview` - View MarkdownPreview in browser [🔌 Markdown-Preview]  
- `<leader> ` or `<C-^>` (which is `Ctrl+6`) - swap back and forth between current (`#`) and alternate (`a%`) buffers. [🔌]  
- `<leader>u` - undotree  

## Custom Motions  (using leader) 

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Custom Motions  (using leader)    | `<leader>ld`                  | `:set nonumber norelativenumber`                          | Disable line numbers                                 |
| Custom Motions  (using leader)    | `<leader>le`                  | `:set number relativenumber`                              | Enable line + relative numbers                       |
| Custom Motions  (using leader)    | `<leader>ll`                  | Toggle number + relativenumber                            | Toggle line numbers (both modes)                     |
| Custom Motions  (using leader)    | `<leader>h`                   | `:nohlsearch<CR><esc>`                                    | Clear search highlight                               |
| Custom Motions  (using leader)    | `<leader>rm`                  | `:delm a-zA-Z0-9`                                         | Remove all marks                                     |
| Custom Motions  (using leader)    | `<leader>tb`                  | `:highlight Normal guibg=NONE ctermbg=NONE`               | Set transparent background                           |
| Custom Motions  (using leader)    | `<leader><down><down>`        | `20<C-e>`                                                 | Jump down 20 lines                                   |
| Custom Motions  (using leader)    | `<leader><up><up>`            | `20<C-y>`                                                 | Jump up 20 lines                                     |
| Custom Motions  (using leader)    | `<leader><leader>`            | `:Neotree toggle`                                         | Toggle Neo-tree file explorer                        |

### Change / Replace Word Variants  

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Change / Replace Word Variants    | `<leader>cw`                  | `*Ncgn`                                                   | Change next occurrence of word under cursor          |
| Change / Replace Word Variants    | `<leader>cW`                  | `* \| :%s::`                                              | Replace all occurrences of word (whole doc)          |
| Change / Replace Word Variants    | `<leader>aw`                  | `yiw \| :%s:\V<C-r>":<C-r>"`                             | Append to all occurrences of word                    |
| Change / Replace Word Variants    | `<leader>cy`                  | `:%s:\V<C-r>":`                                           | Replace all with last yanked text                    |
| Change / Replace Word Variants    | `<leader>ay`                  | `:%s:\V<C-r>":<C-r>"`                                     | Append last yanked text to all matches               |
| Change / Replace Word Variants    | `<leader>fw`                  | `yiw \| :vimgrep ... \| :cope`                           | Find word under cursor → quickfix list               |
| Change / Replace Word Variants    | `<leader>fW`                  | Telescope `grep_string` on `<cword>`                      | Telescope: grep string (word under cursor)           |
| Change / Replace Word Variants    | `<leader>fs`                  | Telescope `grep_string` `"sub " .. <cword>`               | Telescope: search for `sub <word>`                   |

## Custom Motions  (non-leader) 

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Custom Motions  (non-leader)      | `gcc`                         | comment out current line [🔌 vim-commentary]              |                                   |
| Custom Motions  (non-leader)      | `gc`                          | comment out a select range of lines [🔌 vim-commentary]   |                                   |
| Custom Motions  (non-leader)      | `gcgc`                        | uncomment adjacent lines [🔌 vim-commentary]              |                                   |

| Subcategory                       | Command                       | Description                                               | Notes                             |
| ---                               | ---                           | ---                                                       | ---                               |
| Custom Motions  (non-leader)      | `<C-d>`                       | `22<C-e>`                                                 | Scroll down 22 lines                         |
| Custom Motions  (non-leader)      | `<C-u>`                       | `22<C-y>`                                                 | Scroll up 22 lines                           |
| Custom Motions  (non-leader)      | `<C-e>`                       | `4<C-e>`                                                  | Scroll down faster (4×)                      |
| Custom Motions  (non-leader)      | `<C-y>`                       | `4<C-y>`                                                  | Scroll up faster (4×)                        |
| Custom Motions  (non-leader)      | `E!`                          | `:bufdo e!`                                               | Reload (discard changes) all buffers         |
| Custom Motions  (non-leader)      | `<C-_>`                       | `:split \| resize 15 \| ... terminal`                     | Open small terminal below                    |
| Custom Motions  (non-leader)      | `<Esc>`                       | `:nohlsearch<CR><Esc>`                                    | Clear search highlight + normal Esc          |
| Custom Motions  (non-leader)      | `<C-b>`                       | `<C-v>`                                                   | Enter block-wise visual mode                 |
| Custom Motions  (non-leader)      | `<F12>`                       | `:cn`                                                     | Next quickfix item                           |
| Custom Motions  (non-leader)      | `<F11>`                       | `:cp`                                                     | Previous quickfix item                       |
| Custom Motions  (non-leader)      | `>`                           | `>gv`                                                     | Indent + keep visual selection               |
| Custom Motions  (non-leader)      | `<`                           | `<gv`                                                     | Outdent + keep visual selection              |

## General Information  
- **ggh** — SSH connection manager  

## Git (General + LazyGit)  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Git (General + LazyGit)   | `<leader>gu`                  | `git reset --hard HEAD~1`                                 | Undo last commit (hard)           |
| Git (General + LazyGit)   | `<leader>ga`                  | `git stash save`                                          | Stash current changes             |
| Git (General + LazyGit)   | `<leader>gg`                  | `:LazyGitCurrentFile`                                     | Open LazyGit                      |

## Gitsigns (buffer-local – usually in plugin file)  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Gitsigns (buffer-local – usually in plugin file) | `]h` / `[h`          | Next / Prev hunk                                          |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `]H` / `[H`          | Last / First hunk                                         |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghs`        | Stage hunk                                                |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghr`        | Reset hunk                                                |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghu`        | Undo stage hunk                                           |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghp`        | Preview hunk inline                                       |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghS`        | Stage whole buffer                                        |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghR`        | Reset whole buffer                                        |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghb`        | Blame line (full)                                         |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `<leader>ghd`        | Diff this                                                 |                                   |
| Gitsigns (buffer-local – usually in plugin file) | `ih` (operator-pending) | Select hunk textobject                                 |                                   |

## Harpoon  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Harpoon                   | `<leader>h`                   | `harpoon.ui:toggle_quick_menu`                            | Toggle Harpoon quick menu            |
| Harpoon                   | `<leader>H`                   | Telescope Harpoon menu                                    | Open Harpoon in Telescope            |
| Harpoon                   | `<leader>0`                   | `harpoon:list():add()`                                    | Add current file to Harpoon          |
| Harpoon                   | `<leader>N`                   | `harpoon:list():prev()`                                   | Previous Harpoon file                |
| Harpoon                   | `<leader>n`                   | `harpoon:list():next()`                                   | Next Harpoon file                    |
| Harpoon                   | `<leader>1` – `<leader>9`     | `select(1..9)`                                            | Jump to Harpoon slot 1–9             |

## Indent  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Indent                    | `<leader>ie`                  | `Snacks.indent.enable()`                                  | Enable Snacks indent            |
| Indent                    | `<leader>id`                  | `Snacks.indent.disable()`                                 | Disable Snacks indent           |
| Indent                    | `<leader>iee`                 | `:IBLEnable`                                              | Enable indent-blankline         |
| Indent                    | `<leader>idd`                 | `:IBLDisable`                                             | Disable indent-blankline        |

## LSP  

- `:LspInfo` - Get info on current LSP  [🔌]  
- `:MasonInstall <language_server>` - Use mason to install a language server [🔌 Mason]  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| LSP                       | `gd`                          | `definition`                                              | Go to definition                        |
| LSP                       | `gD`                          | `declaration`                                             | Go to declaration                       |
| LSP                       | `gr`                          | `references`                                              | Find references                         |
| LSP                       | `gi`                          | `implementation`                                          | Go to implementation                    |
| LSP                       | `K`                           | `hover`                                                   | Hover documentation                     |
| LSP                       | `<C-k>`                       | `signature_help`                                          | Signature help                          |
| LSP                       | `<leader>rn`                  | `rename`                                                  | Rename symbol                           |
| LSP                       | `<leader>ca`                  | `code_action`                                             | Code actions                            |
| LSP                       | `<leader>lf`                  | `format`                                                  | Format buffer                           |
| LSP                       | `<leader>lr`                  | `:LspRestart`                                             | Restart LSP                             |
| LSP                       | `<leader>li`                  | `:LspInfo`                                                | LSP information                         |
| LSP                       | `]d` / `[d`                   | `goto_next` / `goto_prev`                                 | Next / Prev diagnostic                  |
| LSP                       | `<leader>dl`                  | `open_float`                                              | Show diagnostic float                   |
| LSP                       | `<leader>dd` / `<leader>de`   | disable/enable diagnostics (buffer)                       |                                   |
| LSP                       | `<leader>l`                   | `lint.try_lint()`                                         | Trigger linting (current file)          |

## Telescope  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Telescope                 | `<leader>ff`                  | `find_files`                                              | Fuzzy find files                        |
| Telescope                 | `<leader>fg`                  | `live_grep`                                               | Live grep (project-wide)                |
| Telescope                 | `<leader>fb`                  | `buffers`                                                 | Fuzzy find open buffers                 |
| Telescope                 | `<leader>fh`                  | `help_tags`                                               | Search help tags                        |
| Telescope                 | `<leader>fc`                  | `command_history`                                         | Search command-line history             |

<C-u>	Scroll up in preview window
<C-d>	Scroll down in preview window
<C-q>	Send all items not filtered to quickfixlist (qflist)

## Vim-Fugitive  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Vim-Fugitive              | `<leader>gs`                  | `:Git`                                                    | Git status                     |
| Vim-Fugitive              | `<leader>gc`                  | `:Git commit`                                             | Git commit                     |
| Vim-Fugitive              | `<leader>gb`                  | `:Git blame`                                              | Git blame                      |
| Vim-Fugitive              | `<leader>gd`                  | `:Gdiffsplit`                                             | Git diff split                 |
| Vim-Fugitive              | `<leader>go`                  | `:GBrowse`                                                | Open file in remote (GitHub)   |
| Vim-Fugitive              | `<leader>gl`                  | `:Gclog`                                                  | Git commit log (current file)  |

# Yazi
[Docs](https://yazi-rs.github.io/docs/quick-start/)  
`ya` - (alias for yazi)  
`yazi` - Blazing fast terminal file manager (Rust-based)  
`yz` - (alias/variant for yazi)  

| Subcategory               | Command                       | Description                                               | Notes                             |
| ---                       | ---                           | ---                                                       | ---                               |
| Yazi                      | `.`                           | toggle hidden filevisibility                              |                                   |
| Yazi                      | `:`                           | run shell command                                         |                                   |
| Yazi                      | `[` / `]`                     | tab switch                                                |                                   |
| Yazi                      | `<C-c>`                       | close tab                                                 |                                   |
| Yazi                      | `a`                           | create a file (end with `/` for dir)                      |                                   |
| Yazi                      | `f`                           | filter files                                              |                                   |
| Yazi                      | `space`                       | select file(s)                                            |                                   |
| Yazi                      | `t`                           | create new tab and 1/2/3/... to switch to specific tab    |                                   |
| Yazi                      | `Tab`                         | show file info                                            |                                   |
| Yazi                      | `z`                           | fuzzy find file                                           |                                   |
| Yazi                      | standard vim commands for movement/searching |                                                           |                                   |
```
