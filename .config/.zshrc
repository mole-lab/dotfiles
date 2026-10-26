# --------------------------------------------------
# Live autocompletion (must be sourced FIRST, before compinit)
# --------------------------------------------------

source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Start suggesting after 1 character, with a tiny delay so it feels smooth
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' delay 0.05

# Tab cycles through the menu, Shift+Tab goes backwards
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# Keep Up/Down arrows as normal history navigation
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

# --------------------------------------------------
# Prompt
# --------------------------------------------------

eval "$(starship init zsh)"

# --------------------------------------------------
# eza (monochrome)
# --------------------------------------------------

export EZA_COLORS="uu=bright-black:gu=bright-black:da=bright-black:ur=white:uw=bright-black:ux=white:ue=bright-black:gr=bright-black:gw=bright-black:gx=white:tr=bright-black:fi=white:di=bright-white:ln=bright-black:pi=bright-black:so=bright-black:bd=bright-black:cd=bright-black:or=bright-black:mi=bright-black:ex=white"

alias ls='eza --icons=auto'
alias ll='eza -lah --icons=auto --git'
alias la='eza -a --icons=auto'
alias lt='eza --tree --icons=auto'

# --------------------------------------------------
# Burp Suite (installed in ~/BurpSuite)
# --------------------------------------------------

alias burp='setsid -f ~/BurpSuite/BurpSuite >/dev/null 2>&1'
alias burp-kill='pkill -f burpsuite.jar'

# --------------------------------------------------
# Completion styling
# --------------------------------------------------

# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Grayscale completion colors
zstyle ':completion:*' list-colors \
  '=(#b)*(=0)=38;5;250' \
  '=(#b)*(=1)=38;5;255' \
  '=(#b)*(=2)=38;5;245' \
  '=(#b)*(=3)=38;5;240'

# Dim group headers
zstyle ':completion:*:descriptions' format '%F{8}-- %d --%f'

# --------------------------------------------------
# History
# --------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# --------------------------------------------------
# Autosuggestions
# --------------------------------------------------

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --------------------------------------------------
# Syntax highlighting (keep LAST)
# --------------------------------------------------

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[command]='fg=white'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white'
ZSH_HIGHLIGHT_STYLES[function]='fg=white'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white'
ZSH_HIGHLIGHT_STYLES[path]='fg=245'
ZSH_HIGHLIGHT_STYLES[comment]='fg=240'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=245'

# --------------------------------------------------
# 43PR theme controller
# --------------------------------------------------

theme() { python3 "$HOME/.config/43pr/bin/theme.py" "$@"; }
export PATH="$PATH:$HOME/.local/bin"

# ssh-agent (systemd user socket: ssh-agent.socket)
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# yazi: `y` changes the shell's cwd to where yazi was when it quit
# https://yazi-rs.github.io/docs/quick-start
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

# Weekly update routine: Arch news -> confirm -> yay (repo + AUR, review diffs) -> leftovers
function up() {
	print -P "%F{red}== Arch news since the last update ==%f"
	local news="$(yay -Pw 2>/dev/null)"
	[[ -n "$news" ]] && print -r -- "$news" || echo "(no new news)"
	read -q "?Continue with the update? [y/N] " || { echo; return 1 }
	echo

	# Official repos first, then AUR. For AUR, answer "A" to "Diffs to show?"
	# and check source=, checksums and install scripts before building.
	yay || return

	local pacnew="$(pacdiff -o 2>/dev/null)"
	if [[ -n "$pacnew" ]]; then
		print -P "%F{yellow}== Config files to merge (.pacnew/.pacsave) ==%f"
		print -r -- "$pacnew"
		echo "Merge with: sudo DIFFPROG='nvim -d' pacdiff"
	fi
	# Arch removes the running kernel's modules when the kernel is upgraded
	[[ -d /usr/lib/modules/$(uname -r) ]] || print -P "%F{yellow}Kernel was updated: reboot when convenient.%f"

	# tldr pages (docs only, no sudo)
	tldr --update
}
