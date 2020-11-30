# 補完
autoload -U compinit && compinit
setopt prompt_subst
setopt share_history
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
powerline-daemon -q

# 普通の補完 + スペルミス補正
zstyle ':completion:*' completer _complete _approximate

# emacsのキーバインド 
bindkey -e

#alias
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
export PATH=/usr/local/mecab/bin:$PATH
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:${ANDROID_HOME}/platforms:${ANDROID_HOME}/tools
export PATH=$PATH:${ANDROID_HOME}/platform-tools
export PATH=$PATH:$HOME/Applications/"Android Studio.app"/Contents/jbr/Contents/Home/bin
export JAVA_HOME=$HOME/Applications/"Android Studio.app"/Contents/jbr/Contents/Home
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
export LANG=ja_JP.UTF-8
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/google-cloud-sdk/bin:$PATH
export DANGER_GITHUB_HOST=https://github.com/
export DANGER_GITHUB_API_BASE_URL=https://github.com/api/v3/
export DANGER_OCTOKIT_VERIFY_SSL=true
export DANGER_GITHUB_API_TOKEN={}
export HOMEBREW_GITHUB_API_TOKEN=59a507caa58bb70d6e613a20e5566eb03a33ace3
export XDG_CONFIG_HOME=$HOME/.config
HISTSIZE=100000
SAVEHIST=100000

. /Library/Frameworks/Python.framework/Versions/3.13/lib/python3.13/site-packages/powerline/bindings/zsh/powerline.zsh

# 関数
function cdls () { \cd "$@" && ls }
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

#function powerline_precmd() {
#    PS1="$(powerline-shell --shell zsh $?)"
#}
#
#function install_powerline_precmd() {
#  for s in "${precmd_functions[@]}"; do
#    if [ "$s" = "powerline_precmd" ]; then
#      return
#    fi
#  done
#  precmd_functions+=(powerline_precmd)
#}
#
#if [ "$TERM" != "linux" -a -x "$(command -v powerline-shell)" ]; then
#    install_powerline_precmd
#fi
