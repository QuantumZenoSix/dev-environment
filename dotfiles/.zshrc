# ────────────────────────────────────────────────
# PATH UPDATES
# ────────────────────────────────────────────────

# export MANPATH="/usr/local/man:$MANPATH"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Add $HOME/bin if it hasn't been already added
[[ ":$PATH:" == *":$HOME/bin:"* ]] || PATH="$PATH:$HOME/bin"

# Add $HOME/.local/bin if it hasn't been already added
[[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || PATH="$PATH:$HOME/.local/bin"

# Add path for go installs
export PATH="$PATH:$HOME/go/bin"

# Add /usr/local/go/bin to PATH in case you have a later version here
export PATH=/usr/local/go/bin:$PATH

# Add /opt/Applications/ to $PATH
export PATH=/opt/Applications/:$PATH

# Add .local/bin to PATH
export PATH="$HOME/.local/bin":$PATH
export PATH="$HOME/.local/lib":$PATH

# NVIM to use binary PATH in /opt if it exists there
if [[ -s /opt/nvim-linux64/bin/nvim && ! -s /usr/local/bin/nvim ]]; then
    export PATH="/opt/nvim-linux64/bin":$PATH
elif [[ -s /opt/nvim-linux-x86_64/bin/nvim && ! -s /usr/local/bin/nvim ]]; then
    export PATH="/opt/nvim-linux-x86_64/bin":$PATH
elif [[ -s /usr/local/bin/nvim ]]; then
    export PATH="/usr/local/bin":$PATH
fi

# Go to use binary PATH in /usr/local/bin if it exists there
if [[ -s /usr/local/bin/go ]]; then
    alias go="/usr/local/bin/go"
fi

# Tmux to use binary PATH in /usr/local/bin if it exists there
if [[ -s /usr/local/bin/tmux ]]; then
    alias tmux="/usr/local/bin/tmux -2"
fi

##### Google Cloud SDK
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/bobby_vz/sandbox/google-cloud-sdk/path.zsh.inc' ]; then . '/home/bobby_vz/sandbox/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/bobby_vz/sandbox/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/bobby_vz/sandbox/google-cloud-sdk/completion.zsh.inc'; fi



# ────────────────────────────────────────────────
# SHELL VARIABLE UPDATES
# ────────────────────────────────────────────────

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
else
    export EDITOR='vim'
  export EDITOR='nvim'
fi

# SET CUSTOM MANPAGER APP
export MANPAGER='vim +MANPAGER -'

# Set base for posting
export POSTING_ROOT=/home/bobby/posting/
export POSTING_EDITOR=vim

# LOAD ANY SAVED KEYS
# > Claude
if [[ -s $HOME/.claude/.credentials.json ]]; then
    CLAUDE_TOKEN=$(jq '.[] | .accessToken' $HOME/.claude/.credentials.json 2> /dev/null )
    if [[ ! -z "${CLAUDE_TOKEN}" ]]; then
        export ANTHROPIC_API_KEY=${CLAUDE_TOKEN//\"/}
    fi
fi


# This ensures that tmux always starts with 256-color support - good for vim/neovim
alias tmux="tmux -2"
# export TERM=screen-256color
# Works better with vim
export TERM=xterm-256color

# NODE VERSION MANAGER
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ────────────────────────────────────────────────
# LOAD PROMPT AND SHELL ENVIRONMENT
# ────────────────────────────────────────────────

# 1, Load functions to handle prompt/shell env loadouts
[[ -s ~/.zsh_customizations ]] && source ~/.zsh_customizations

# 2. Set prompt (needs to run before shell environment)
if [[ $BLASTOFF == 1 ]]; then
    enable_starship_prompt
elif [[ $POSHY == 1 ]]; then
    enable_ohmyposh
else
    enable_powerline_prompt
fi


# 3. Enable Shell Environment (ohmyzsh)
configure_ohmyzsh


# ────────────────────────────────────────────────
# LOAD CONF/ENV FILES
# ────────────────────────────────────────────────
# Runs after shell env loads

# Force other bash files to load
[[ -s ~/.creds.env ]] && source ~/.creds.env
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.bash_pbx ]] && source ~/.bash_pbx
[[ -s ~/.bash_git ]] && source ~/.bash_git
[[ -s ~/.bash_utils ]] && source ~/.bash_utils
# [[ -s ~/.oh-my-zsh/oh-my-zsh.sh ]] && source ~/.oh-my-zsh/oh-my-zsh.sh




# ────────────────────────────────────────────────
# NIX PKG MANAGER BIN PATH
# ────────────────────────────────────────────────
# Nix bin paths should not preceed the default pkg manager's location of a pkg
# This needs to stay near the bottom to ensure PATH has latest updates and I can append nix path 
export PATH="$PATH:${HOME}/.nix-profile/bin"



# Mount SSHFS dirs as needed
# SSHFS_MOUNT_COUNT=$(ps aux | grep -i sftp | grep -v grep | wc -l )
# [[ ${SSHFS_MOUNT_COUNT} -eq 0 ]] && sudo sshfs alpha:/home/control-io/ /home/bobby/alpha -oIdentityFile=/home/bobby/.ssh/pbx-pems/<key>.pem


# Load other bash files if not loaded
#[[ ${ALIASES_LOADED} -ne 1 && -s ~/.bash_aliases ]] && source ~/.bash_aliases
#[[ ${PBX_LOADED} -ne 1 && -s ~/.bash_pbx ]] && source ~/.bash_pbx
#[[ ${GIT_LOADED} -ne 1 && -s ~/.bash_git ]] && source ~/.bash_git
#[[ ${UTILS_LOADED} -ne 1 && -s ~/.bash_utils ]] && source ~/.bash_utils




