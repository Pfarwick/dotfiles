# oh-my-zsh setup
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME='pygmalion'
plugins=(git vi-mode osx docker z)
source $ZSH/oh-my-zsh.sh

# personal config
export MANWIDTH=78
setopt NO_CLOBBER
KEYTIMEOUT=1

# history settings
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS

# plugins
if which direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi
if which rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
  source /usr/local/share/chtf/chtf.sh
  chtf 0.11.3
fi
. /home/pfarwick/tools/z/z.sh
# fzf configuration
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" 2> /dev/null'
export FZF_TMUX=1

# don't use fzf-tmux integration inside neovim terminal
[[ -e "$NVIM_LISTEN_ADDRESS" ]] && unset FZF_TMUX

# use the vi navigation keys (hjkl) besides cursor keys in menu completion
bindkey -M menuselect 'h' vi-backward-char        # left
bindkey -M menuselect 'k' vi-up-line-or-history   # up
bindkey -M menuselect 'l' vi-forward-char         # right
bindkey -M menuselect 'j' vi-down-line-or-history # bottom

# aliases
mkcd() {
  if (( ARGC != 1 )); then
    printf 'usage: mkcd <new-directory>\n'
    return 1;
  fi
  if [[ ! -d "$1" ]]; then
    command mkdir -p "$1"
  else
    printf '`%s'\'' already exists: cd-ing.\n' "$1"
  fi
  builtin cd "$1"
}
alias rg="rg --type-add 'tf:*.tf' --type-add 'tfvars:*.tfvars'"
alias ls='exa'
alias l='ls --long'
alias la='ls --long --all'
alias lt='ls --tree --long'
alias gpoh='git push -u origin HEAD'
alias del="$EDITOR .envrc.local; direnv reload"
alias de='direnv edit'
alias dr='direnv reload'

gocache() {
  local pkgpath
  if [[ $# -eq 0 ]]; then
    pkgpath=(./...)
  else
    pkgpath="$@"
  fi

  go list -f '{{range .TestImports}}{{ printf "%s\n" .}}{{end}}{{range .Deps}}{{ printf "%s\n" .}}{{end}}' "${pkgpath[@]}" | xargs go install
}

# fzf and z magic
if alias z &> /dev/null; then
  unalias z
fi
z() {
  if [[ $# -eq 0 ]]; then
    local dir="$(_z 2>&1 | sed 's/^[0-9.]* *//'| fzf --tac)"
    cd "$dir"
  else
    _z "$@" 2>&1
  fi
}
