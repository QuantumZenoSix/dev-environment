# Some very handy aliases

export ALIASES_LOADED=1

# ____________________ GENERAL ______________________

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias mkdir='mkdir -pv'

# If we have colorized versions of cat and less use those by default
# [[ ccless ]] && alias less='cless'
# [[ ccat ]] && alias cat='ccat'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

## Update cache and upgrade binaries
alias upandup='sudo apt update && sudo apt upgrade'

## Apache
alias apachelogerr='tail -n15 -f /var/log/apache2/error.log'
alias apachelogacc='tail -n15 -f /var/log/apache2/access.log'
alias apacherestart='sudo service apache2 restart'
alias rr="sudo service apache2 restart && echo 'Apache Restarted!'" # Restart Apache2
alias ee="tail -f /var/log/apache2/error.log"
alias e0="tail -f -n 0 /var/log/apache2/error.log" # Tail Apache error log - only show added lines
alias re="rr && ee"     # Restart Apache and tail error log
alias er="watch egrep -i 'DBD::' /var/log/apache2/error.log"        # Tail error log for SQL errors


# Fuzzy-vim
alias fv='nvim $(fzf --height 40% --layout reverse --border)'
alias ff='fzf --height 40% --layout reverse --border'



# -------------------------------------------
# WORKFLOW-SPECIFIC
# -------------------------------------------


# Lazyvim setup
alias nv='NVIM_APPNAME=nvim-lazy nvim'

# SSH/SCP
alias qc='quickconnect'
alias scpdownloads='cd /mnt/c/Users/BobbyValenzuela/OneDrive\ -\ Probax/Documents/SCP-Downloads'
alias ssh_keyupdate="{ eval $(ssh-agent -s) ; } && ssh-add ~/.ssh/id_rsa"

alias reposync_thisdir_to_alpha="reposync . alpha ongoing"

# My Main nvim install is a lazyvim dist - adding an alias to my custom install (~/.config/nvim-custom/)
alias nvim-custom='NVIM_APPNAME="nvim-custom" nvim'

# thefuck alias
# eval $(thefuck --alias redo)

alias ds="ollama run deepseek-r1:14b"
alias cdev="cd $HOME/Documents/Repos/Dev-Environment/"


alias archeck="informant list"
