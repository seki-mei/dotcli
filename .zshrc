ZSH_START_TIME=$(date +%s%N)
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$PATH:/home/wotton/.local/bin"
DEFAULT_USER="wotton"
DEFAULT_HOST="cheshire"
export EDITOR=nvim
export ZDOTDIR=$HOME/.zsh
export PLUGINDIR="$ZDOTDIR/zsh_plugins"
export HISTFILE="$ZDOTDIR/zsh_history"
export CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZSH_COMPDUMP="$CACHE_DIR/zcompdump"

if [ "$EDITOR" = "vim" ]; then
	if [ "$HOST" = "cheshire" ]; then
		export MANPAGER="$EDITOR -M +MANPAGER -"
	elif [ "$HOST" = "localhost" ]; then
		export MANPAGER="$EDITOR -M +MANPAGER"
	fi
elif [ "$EDITOR" = "nvim" ]; then
	export MANPAGER="$EDITOR +Man!"
else
	export MANPAGER="less -R"
fi

mkdir -p "$PLUGINDIR"
mkdir -p "$CACHE_DIR"

# ===== prompt line
setopt promptsubst # needed by prompt
autoload -Uz vcs_info
# Call vcs_info before each prompt
precmd() { vcs_info }
# Customize prompt
if [[ $USER != $DEFAULT_USER || $HOST != $DEFAULT_HOST ]]; then
	SHOW_USERHOST="%F{green}%n@%m%f "
else
	SHOW_USERHOST=""
fi

autoload -Uz vcs_info
precmd() {
    vcs_info
    if [[ ${vcs_info_msg_0_} == main* ]]; then
        vcs_info_msg_0_="✯${vcs_info_msg_0_#main}"
    fi
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%b%u%c'
zstyle ':vcs_info:git:*' actionformats '%b|%a%u%c'
zstyle ':vcs_info:git:*' unstagedstr '°'
zstyle ':vcs_info:git:*' stagedstr '+'
PS1='${SHOW_USERHOST}%F{cyan}%2~ %F{yellow}${vcs_info_msg_0_} %(?.%F{magenta}.%F{red})❯%f '

#===== vim and keybinds
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
bindkey -v
KEYTIMEOUT=1 # fix slow mode change

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
	for c in {a,h}{\',\",\`}; do
		bindkey -M $m $c select-quoted
	done
done
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
	for c in {a,h}${(s..)^:-'()[]{}<>bB'}; do
	  bindkey -M $m $c select-bracketed
	done
done

# ctrl motion stops at / and -
autoload -U select-word-style bash
select-word-style bash
# normal mode
bindkey -M vicmd Y vi-yank-eol
bindkey -M vicmd h vi-insert
bindkey -M vicmd i up-line
bindkey -M vicmd k down-line
bindkey -M vicmd j vi-backward-char
# visual mode
bindkey -M visual h vi-insert
bindkey -M visual i up-line
bindkey -M visual k down-line
bindkey -M visual j vi-backward-char
# obj
bindkey -M vicmd hW select-in-blank-word
bindkey -M vicmd ha select-in-shell-word
bindkey -M vicmd hw select-in-word
bindkey -M visual hW select-in-blank-word
bindkey -M visual ha select-in-shell-word  # select argument
bindkey -M visual hw select-in-word
# normal mode bindings
bindkey -M vicmd '^?' backward-delete-char # backspace
bindkey -M vicmd '^H' backward-kill-word   # ctrl-backspace
bindkey          '^H' backward-kill-word
bindkey -M vicmd '\e[3;5~' kill-word       # ctrl-delete
bindkey          '\e[3;5~' kill-word
bindkey -M vicmd "^[[1;5C" forward-word    # ctrl-right
bindkey          "^[[1;5C" forward-word
bindkey -M vicmd "^[[1;5D" backward-word   # ctrl-left
bindkey          "^[[1;5D" backward-word
# backspace
bindkey -M emacs '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
# delete
bindkey -M emacs '^[[3~' delete-char
bindkey -M vicmd '^[[3~' delete-char
bindkey -M viins '^[[3~' delete-char
# end
bindkey -M emacs '^[[F' end-of-line
bindkey -M vicmd '^[[F' end-of-line
bindkey -M viins '^[[F' end-of-line
bindkey -M visual '^[[F' end-of-line
# home
bindkey -M emacs '^[[H' beginning-of-line
bindkey -M vicmd '^[[H' beginning-of-line
bindkey -M viins '^[[H' beginning-of-line
bindkey -M visual '^[[H' beginning-of-line
# shift-tab
bindkey -M emacs "^[[Z" reverse-menu-complete
bindkey -M viins "^[[Z" reverse-menu-complete
# c-n
bindkey -M emacs "^N" menu-complete
bindkey -M viins "^N" menu-complete
# c-p
bindkey -M emacs "^P" reverse-menu-complete
bindkey -M viins "^P" reverse-menu-complete
# surround
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cz change-surround
bindkey -M vicmd dz delete-surround
bindkey -M vicmd yz add-surround
bindkey -M visual Y add-surround

#===== fzf
# load fzf
autoload -Uz is-at-least
fzf_version=$(fzf --version | awk '{print $1}')
source <(fzf --zsh)

if command fd --version >/dev/null; then
	export FZF_DEFAULT_COMMAND='fd --hidden --exclude ".git" --exclude "*cache*" --exclude "*Cache*"'
	export FZF_CTRL_T_COMMAND='fd --type file --hidden --exclude ".git" --exclude "*cache*" --exclude "*Cache*"'
	export FZF_ALT_C_COMMAND='fd --type directory --hidden --exclude ".git" --exclude "*cache*" --exclude "*Cache*"'
else
	echo fzf find fallback
	export FZF_DEFAULT_COMMAND='find . \( ! -path "*/.git/*" \) \( ! -path "*cache*" \) \( ! -path "*Cache*" \)'
	export FZF_CTRL_T_COMMAND='find . -type f \( ! -path "*/.git/*" \) \( ! -path "*cache*" \) \( ! -path "*Cache*" \)'
	export FZF_ALT_C_COMMAND='find . -type d \( ! -path "*/.git/*" \) \( ! -path "*cache*" \) \( ! -path "*Cache*" \)'
fi

export FZF_ALT_C_OPTS=" --preview 'tree -C {}'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=plain --line-range=:50 {}'"
export FZF_DEFAULT_OPTS="--multi --height 50% --scroll-off=999 --border=double --reverse --info=inline-right --marker='● ' --prompt='❯' --separator='' --scrollbar='' --color=pointer:blue,marker:white,prompt:magenta,border:white,gutter:black,hl:cyan,hl+:magenta"
export FZF_COMPLETION_TRIGGER='@'

edit-with-fzf() {
    LBUFFER="${LBUFFER}e "
    zle fzf-file-widget
}
zle -N edit-with-fzf

bindkey '^E' edit-with-fzf
bindkey -M emacs '^@' fzf-file-widget
bindkey -M vicmd '^@' fzf-file-widget
bindkey -M viins '^@' fzf-file-widget

bindkey -M emacs '^[ ' fzf-cd-widget
bindkey -M vicmd '^[ ' fzf-cd-widget
bindkey -M viins '^[ ' fzf-cd-widget

bindkey -M emacs '^[^@' fzf-history-widget
bindkey -M vicmd '^[^@' fzf-history-widget
bindkey -M viins '^[^@' fzf-history-widget

#===== completions
autoload -U compinit
compinit -C -d "$ZSH_COMPDUMP"
# arrow key menu for completions
zstyle ':completion:*' menu select
# case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# colorize completions using default `ls` colors
zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# complete . and .. special directories
zstyle ':completion:*' special-dirs true
# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit
# Enable completion for files starting with an underscore
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' file-patterns '*'

#===== history
HISTSIZE=50000          # Maximum number of commands in history.
SAVEHIST=10000          # Number of commands to save between sessions.
setopt share_history    # Share history between sessions.
setopt histignoredups
setopt HIST_VERIFY      # expand !! instead of running it
setopt HIST_IGNORE_SPACE # don't save to history commands with leading space

#===== custom commands and aliases
# block `sudo vim`
sudo() {
	if [[ "$1" == "vim" || "$1" == "nvim" ]]; then
		echo "🚫 Stop. Use 'sudoedit' or 'se'." >&2
		return 1
	fi
	command sudo "$@"
}
# source aliases
source $HOME/.aliases.sh

#===== end of setup
export MAN_POSIXLY_CORRECT=1 # man complains otherwise
# zsh-syntax-highlighting
ZSH_HL="$PLUGINDIR/zsh-syntax-highlighting"
if [ ! -d "$ZSH_HL" ]; then
	git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_HL"
fi
source "$ZSH_HL/zsh-syntax-highlighting.plugin.zsh"

# banner and timer
parent_process=$(ps -p $PPID -o comm=)
if [[ "$parent_process" == "konsole" ]]; then
	sleep 0.2 # give krohnkite time to tile the terminal
	cbonsai -p
	ZSH_END_TIME=$(date +%s%N)
	elapsed=$(( (ZSH_END_TIME - ZSH_START_TIME) / 1000000 ))
	# echo "$elapsed ms"
elif [[ "$parent_process" == "yakuake" ]]; then
	cbonsai -p
else
	# jp2a --size=60x48 .at.png
	# figlet -f block "@PP"
	figlet "welcome"
	ls -a
fi
