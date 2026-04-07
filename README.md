# Dev Environment

My entire dev environment setup via one command.  

<br />

```bash
bash -c "$(wget https://codeberg.org/QuantumZenoSix/Dev-Environment/raw/branch/main/scripts/utils/start.sh -O -)"
```  


<br />

Cli Preview   

```sh
What would you like to install/configure?

1) CLI - All
2) CLI - Apps
3) CLI - Dotfiles
4) CLI - Nvim config
5) DSK - Pop! OS
6) DSK - Cachy OS
7) Quit
Select an option (1-7) →

```

<br />


<br />


<br />

__What each option gives you__


| Option            | Base Applications   | Configuration files  | Neovim Config  | Desktop apps | Gaming tools + enchancements        |
| ---               | ---                 | ---                  | ---            | ---          | ---                                 |
| CLI - All         | ✅                 | ✅                   | ✅            | ❌           | ❌                                  |
| CLI - Apps        | ✅                 | ❌                   | ❌            | ❌           | ❌                                  |
| CLI - Dotfiles    | ❌                 | ✅                   | ✅            | ❌           | ❌                                  |
| CLI - Nvim Config | ✅                 | ❌                   | ❌            | ❌           | ❌                                  |
| DSK - Pop! OS     | ✅                 | ✅                   | ✅            | ✅           | ✅                                  |
| DSK - Cachy OS    | ✅                 | ✅                   | ✅            | ✅           | ✅                                  |

<br />

_Note: This is designed for Arch Linux/Arch-based distros though I've done some work on the debian side as well (all options should be functional though more testing has been done on the arch side)._

<br />

## ⚙️ What do the configuration files give me?

- Customized Vim/Neovim configuration (includes a [colorscheme](https://github.com/QuantumZenoSix/gothic-cyberpunk.vim) I made)
- Customized Tmux configuration
- Spotify player tmux integration
- Specialized bash aliases, functions, and zsh extras.
- Customized Wezterm configuration
- Oh-my-zsh shell environment and and customized prompt


I've added bash functions to allow the changing between three prompt customizers: powerline10k, starship, and ohmyposh (all running with ohmyzsh enabled).  
Each can be further configured manually or using any of their respective presets.  

![Prompt Switching](./assets/prompt_changer.gif)

Absolutely unecessary, but fun.  

<br />

## ❄️ How are configuration files managed once installed?
This repo will be cloned and saved as `~/.config/home-manager`.  
Upon installation you'll have the option to manage config files via Nix.  

Choosing yes installs nix and uses the provided home.nix flake to sync your config files in `~/.config/home-manager/dotfiles` to their respective locations.  

Choosing no runs a simple copy command to copy the files in `~/.config/home-manager/dotfiles` to their respective locations.  

Note: I didn't hardcode a username in the home.nix flake. The username will auto-populate based on the user who's logged in. Meaning, anyone can fork this repo, edit the home.nix flake and it should still work.  


The `home.nix` uses the legacy system of just copying the dotfiles instead of the declarative approach.  
I plan on making it declarative, but until then this will do - also makes it easier to fork the repo and edit the `home.nix` file I suppose.  


## ❔ What apps are included?

<br />

📱 __Base Applications__

A full list of base applications lives here: [Arch Install List](./pkg_lists/arch_base.txt)  

<br />

You can can add/remove from that list to determine which apps will be installed as well.  
Near the end of the file you'll see a line that reads  `NOTE-AUR: Processing AUR pkgs from this point on`.  
Include any packages that need to be installed from the AUR after that line; yay is installed automatically.  

<br />


📲 __Desktop Applications__  

For a full list, check out the cachy os script here: [Desktop.sh](./scripts/cachy_os_setup/desktop.sh)  

<br />

_General_
- Brave
- LibreOffice
- Obsidian
- Steam



_Dev_
- Docker
- Postman
- Thonny
- Wezterm
- Wireshark


_Media_
- Audacity
- MPV
- Gimp + Inkscape
- OBS
- Spotify
- VLC

_Social_
- Discord
- Signal
- Telegram

<br />


_Note: Some apps like vim/neovim are already included as part of the base applications. This section is more GUI focused_

<br />

## 🎮 What gaming enhancements are included with the 'DSK' desktop-oriented options?

The desktop os assumed here is Cachy OS.  

In addition to installing common desktop applications, the `desktop.sh` script does the following:
- Runs a GPU status check
- Installs common codecs, firmware, utilities
- Installs mangohud, goverlay, gamemode, vkbasalt, gamescope, winetricks, bottles, and more.
- Security/performance optimizations (apparmor, ufw, tlp, snapper)

Beyond that, the `housekeeping.sh` script does the following:
- Full system update
- Installs media codecs
- Updates flatpaks
- SSD/NVMe trim
- Cleanup (cache, orphans, journal, thumbnails, etc)
- Refresh font-cache + redetct hardware

<br />

## 🛠️ Will this support other distros besides Arch btw?

Yes, some work has already been done in the debian distro family (which now appears in the list) with the Pop! OS as the chosen desktop-oriented distro in this regard.  
More work is to be done for this, but have made it a priority as it's fairly functionality as is (though it lacks modularity as I don't have an entry in the `./pkg_lists` dir as of yet.
Fedora, maybe one day.

<br />

## Important Keybinds  

<br />


| Key    | Description |
| --- |--|  
| `up`  | Pull down latest nix home manager changes and apply them (`git pull` + `home-manager switch`) |  
| `nix_remove_home_manager`  | Removes nix home-manager and it's managed files .|  
| `cf`  | 'Command Finder' fuzzy finds all of my custom bash functions .|  
| `cachy-update`-n  | See latest Arch news pre-update. |  

More keybinds in my workflow: [keybinds](./key_bindings.md)

<br />

__Common Pacman keys__  

| Key    | Description |
| --- |--|  
| `Syu`  | Update system |  
| `Rns`  | Remove package|  
| `Ssq`  | Query repo for pkg (`Ss` for just the name) |  


<br />

### Info on Niri

Note: If using Niri, check out this noctalia-based custom sddm theme
https://github.com/mahaveergurjar/sddm/tree/noctalia  

And of course - astronaut
https://github.com/Keyitdev/sddm-astronaut-theme

Great FAQ: https://github.com/niri-wm/niri/wiki/FAQ

Kanshi for multi-monitor profiles
https://wiki.archlinux.org/title/Kanshi

