ZSH_START_TIME=$(date +%s%N)
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH="$PATH:/home/wotton/.local/bin"
DEFAULT_USER="wotton"
DEFAULT_HOST="cheshire"
export EDITOR=vim
export ZDOTDIR=$HOME/.zsh
export PLUGINDIR="$ZDOTDIR/zsh_plugins"
export HISTFILE="$ZDOTDIR/zsh_history" # Location of the history file.
export CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$CACHE_DIR"

# ===== plugin management =====
plug() {
	PLUGIN_NAME="${1#*/}"
	mkdir -p "$PLUGINDIR"
	if [ ! -d "$PLUGINDIR/$PLUGIN_NAME" ]; then
		git clone "https://github.com/$1.git" "$PLUGINDIR/$PLUGIN_NAME"
	fi
	local base="$PLUGINDIR/$PLUGIN_NAME"
	if [ -f "$base/$PLUGIN_NAME.plugin.zsh" ]; then
		source "$base/$PLUGIN_NAME.plugin.zsh"
		return
	fi
	local theme_file
	theme_file=$(find "$base" -maxdepth 1 -name '*.zsh-theme' | head -n 1)
	if [ -n "$theme_file" ]; then
		source "$theme_file"
		return
	fi
	if [ -f "$base/$PLUGIN_NAME" ]; then
		source "$base/$PLUGIN_NAME"
		return
	fi
	echo "Plugin $PLUGIN_NAME not found in expected format." >&2
}

# ===== plugins =====

setopt promptsubst # needed by prompt
# plug "agnoster/agnoster-zsh-theme"
plug "zsh-users/zsh-syntax-highlighting"

# ===== prompt line =====
autoload -Uz vcs_info
# Call vcs_info before each prompt
precmd() { vcs_info }
# Customize prompt
if [[ $USER != $DEFAULT_USER || $HOST != $DEFAULT_HOST ]]; then
	SHOW_USERHOST="%F{green}%n@%m%f "
else
	SHOW_USERHOST=""
fi
PS1='${SHOW_USERHOST}%F{cyan}%~ %F{yellow}${vcs_info_msg_0_} %(?.%F{magenta}.%F{red})❯%f '
# PS1='%F{cyan}%~ %F{yellow}${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '
# Configure vcs_info format
zstyle ':vcs_info:git:*' formats '%b'

# ===== vim =====
# download & source
VIMODEPLUGDIR="$PLUGINDIR/vi-mode"
VIMODEPLUGFILE="$VIMODEPLUGDIR/vi-mode.plugin.zsh"
mkdir -p "$VIMODEPLUGDIR"
if [ ! -d "$VIMODEPLUGDIR" ]; then
	wget -O "$VIMODEPLUGFILE" "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/refs/heads/master/plugins/vi-mode/vi-mode.plugin.zsh"
fi
source "$VIMODEPLUGFILE"
bindkey -v

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

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode
MODE_INDICATOR=""
# MODE_INDICATOR="%F{white}[N]%f"
# INSERT_MODE_INDICATOR="%F{cyan}[I]%f"
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_INSERT=4
# fix slow mode change
KEYTIMEOUT=1
# start in normal mode
# zle-line-init() { zle -K vicmd; }
# zle -N zle-line-init

# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

#normal mode
bindkey -M vicmd '^?' backward-delete-char
bindkey -M vicmd h vi-insert
bindkey -M vicmd i vi-up-line-or-history
bindkey -M vicmd k vi-down-line-or-history
bindkey -M vicmd j vi-backward-char

bindkey -M vicmd hW select-in-blank-word
bindkey -M vicmd ha select-in-shell-word
bindkey -M vicmd hw select-in-word

# visual mode
bindkey -M visual h vi-insert
bindkey -M visual i vi-up-line-or-history
bindkey -M visual k vi-down-line-or-history
bindkey -M visual j vi-backward-char

# obj
bindkey -M visual hW select-in-blank-word
bindkey -M visual ha select-in-shell-word
bindkey -M visual hw select-in-word

# normal mode bindings
# ctrl-backspace: delete previous word
bindkey -M vicmd '^H' backward-kill-word
# ctrl-delete: delete next word
bindkey -M vicmd '\e[3;5~' kill-word
# ctrl-arrows forward/backward
bindkey -M vicmd  "^[[1;5C" forward-word
bindkey -M vicmd "^[[1;5D" backward-word

# ===== completions =====
autoload -U compinit
compinit -C
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

# Completion for otp
_otp_completion() {
  local -a accounts
  accounts=("${(@f)$(otp --list 2>/dev/null)}")
  _describe 'account' accounts
}
compdef _otp_completion otp

# ===== history =====
HISTSIZE=50000          # Maximum number of commands in the history.
SAVEHIST=10000          # Number of commands to save between sessions.
setopt share_history    # Share history between sessions.
setopt histignoredups
setopt HIST_VERIFY      # expand !! instead of running it

# ===== key mappings =====
# ctrl motion stops at / and -
autoload -U select-word-style
select-word-style bash
# ctrl-backspace: delete previous word
bindkey '^H' backward-kill-word
# ctrl-delete: delete next word
bindkey '\e[3;5~' kill-word
# shift-tab - move through the completion menu backwards
bindkey -M emacs "^[[Z" reverse-menu-complete
bindkey -M viins "^[[Z" reverse-menu-complete
# ctrl-arrows forward/backward
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

sudo() {  # block `sudo vim`
	if [[ "$1" == "vim" ]]; then
		echo "🚫 Stop. Use 'sudoedit' or 'se'." >&2
		return 1
	fi
	command sudo "$@"
}

# source aliases
source $HOME/.aliases.sh


parent_process=$(ps -p $PPID -o comm=)
if [[ "$parent_process" == "konsole" ]]; then
	sleep 0.2 # give krohnkite time to tile the terminal
	cbonsai -p
	ZSH_END_TIME=$(date +%s%N)
	elapsed=$(( (ZSH_END_TIME - ZSH_START_TIME) / 1000000 ))
	echo "$elapsed ms"
elif [[ "$parent_process" == "yakuake" ]]; then
	cbonsai -p
# elif [[ "$parent_process" == *termux* ]]; then
# termux parent process: 569XZhilms
else
	jp2a --size=60x48 .at.png
fi
