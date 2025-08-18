# git
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit --verbose"
alias gca="git commit --verbose --all"
alias gcp="git commit --verbose --patch"
alias gp="git push"
alias gcl="git clone"
alias gco="git checkout"
alias gl="git pull"
alias glr="git pull --rebase"
alias gd="git difftool --no-prompt"
alias gm="git mergetool --no-prompt"
alias gs="git status"
alias gsw="git switch"
alias gswc="git switch -c"
alias gswm="git switch $(git_main_branch)"
alias gswd="git switch $(git_develop_branch)"
alias grs="git restore"
alias grm="git rm"
alias grb="git rebase"
alias grba="git rebase --abort"
alias grbc="git rebase --cobtinue"
alias gm="git merge"
alias gma="git merge --abort"
alias gmc="git merge --cobtinue"
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --cobtinue"

alias kp="flatpak run --command=keepassxc-cli org.keepassxc.KeePassXC"

# misc
alias e='$EDITOR'
alias se='sudoedit'
alias ai='aichat -e'
alias rm="rm -I"
alias py3="python3"
alias pyt="python3"
alias gg="cd"

alias zrc='$EDITOR $HOME/.zshrc'
alias brc '$EDITOR $HOME/.bashrc'
alias vrc='$EDITOR $HOME/.vimrc'
obsidianvrc="$HOME/Obsidian/.obsidian.vimrc"
alias orc='$EDITOR $obsidianvrc'
alias orcdiff='vimdiff $HOME/.vimrc $obsidianvrc'

alias o='xdg-open'
alias s='$EDITOR $HOME/Obsidian/Sketchpad.md'
alias hk='$EDITOR $HOME/Obsidian/Info/Hotkeys.md'
alias :q='exit'
alias q='exit'
alias Q='exit'

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

