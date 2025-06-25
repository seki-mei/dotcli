alias v='vim'
alias sv='sudoedit'
alias ai='aichat -e'
alias rm="rm -I"
alias py3="python3"
alias pyt="python3"
alias keydit="sudo -E vim /etc/keyd/default.conf"
alias keydreload="sudo keyd reload"
alias keydsys="sudo /usr/bin/systemctl restart keyd"

alias zrc='vim $HOME/.zshrc'
alias brc 'vim $HOME/.bashrc'
alias vrc='vim $HOME/.vimrc'
obsidianvrc="$HOME/Obsidian/.obsidian.vimrc"
alias orc='vim $obsidianvrc'
alias orcdiff='vimdiff $HOME/.vimrc $obsidianvrc'
alias s='vim $HOME/Obsidian/Sketchpad.md'
alias hk='vim $HOME/Obsidian/Info/Hotkeys.md'
alias :q='exit'
alias q='exit'
alias Q='exit'

# git
alias g="git"
alias gcl="git clone"
alias gc="git commit --verbose"
alias gca="git commit --verbose --all"
alias gp="git push --verbose --all"

# color support
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# modified commands
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias less='less -i'
alias mkdir='mkdir -pv'
alias ping='ping -c 3'
alias feh='feh --scale-down --auto-zoom'
alias ..='cd ..'

# privileged access
if [ $UID -ne 0 ]; then
    alias sudo='sudo ' # passes aliases over to root when using sudo
fi

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# ls
alias ls='ls -hF --color=auto --group-directories-first'
alias la='ls -A'
alias ll='ls -lh'
alias l='ls -alh'
alias lr='ls -R'

