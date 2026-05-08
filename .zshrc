# 補完
autoload -U compinit && compinit
setopt prompt_subst
setopt share_history
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# 普通の補完 + スペルミス補正
zstyle ':completion:*' completer _complete _approximate

# emacsのキーバインド
bindkey -e

# alias
alias ls='ls -GF'
alias cd="cdls"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='nvim'
alias vim='nvim'
alias t='tmux'
alias ks='t kill-session'
alias list='t list-session'
alias python='python3'
alias pip='pip3'
alias dart='fvm dart'
alias flutter='fvm flutter'
alias icat="kitty +kitten icat"
alias litellm-usage="curl -s -H \"Authorization: Bearer \$LITELLM_API_KEY\" \"https://litellm.mercari.in/user/info\" | jq \".user_info | {spend, max_budget, ratio: (.spend / .max_budget * 100)}\""

# コマンド履歴
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

fpath=(/usr/local/share/zsh-completions $fpath)
export PATH=~/.local/bin:$PATH
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platforms:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=$HOME/.config
HISTSIZE=100000
SAVEHIST=100000

# 関数
function cdls () { \cd "$@" && ls }
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(starship init zsh)"

# マシン固有の設定・シークレット（git管理外）
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
