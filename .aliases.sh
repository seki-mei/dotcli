# git
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit --verbose"
alias gca="git commit --verbose --all"
alias gcap="git commit --verbose --all && git push"
alias gcl="git clone"
alias gco="git checkout"
alias gpatch="git commit --verbose --patch"
alias gcpatch="git commit --verbose --patch"
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gd="git difftool --no-prompt"
alias gl="git pull"
alias glr="git pull --rebase"
alias gm="git mergetool --no-prompt"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gp="git push"
alias grb="git rebase"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grm="git rm"
alias grs="git restore"
alias grss="git restore --staged"
alias gunadd="git restore --staged"
alias gs="git status"
alias gsw="git switch"
alias gswc="git switch -c"
alias gswm="git switch main"

# misc
alias e='$EDITOR'
alias se='sudoedit'
alias ai='aichat -e'
alias zyp='zypper'
alias py3="python3"
alias pyt="python3"
alias py="python3"
alias gg="cd"
alias wlc="wl-copy"
alias wlp="wl-paste"
alias tmxc="termux-clipboard-set"
alias tmxp="termux-clipboard-get"

# using $HOME/settings/home/
# because we want vim-fugitive to find .git/
SETTINGSHOME="$HOME/settings/home"
alias zrc="$EDITOR $SETTINGSHOME/.zshrc"
alias vrc="$EDITOR $SETTINGSHOME/.vimrc"
OBSIDIANVRC="$HOME/obsidian/.vimrc"
alias orc="$EDITOR $OBSIDIANVRC"
alias orcdiff="vimdiff $SETTINGSHOME/.vimrc $OBSIDIANVRC"
alias playbackstart="pactl load-module module-loopback latency_msec=30"
alias playbackstop="pactl unload-module module-loopback"

alias o='xdg-open'
alias hk='$EDITOR $HOME/obsidian/Hotkeys.md'
alias st="$EDITOR '/data/data/com.termux/files/home/shared_storage/obsidian/⌂ Tasklog.md'"
alias :q='exit'
alias q='exit'
alias Q='exit'

# color support
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
alias htop='htop --tree'
alias history='fc -lt "%F %T"'
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

