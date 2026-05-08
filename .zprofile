# Homebrew（Apple Silicon / Intel 両対応）
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"

# マシン固有の設定（git管理外）
[[ -f ~/.zprofile.local ]] && source ~/.zprofile.local
