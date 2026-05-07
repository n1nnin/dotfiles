#!/bin/zsh
# New Mac Setup Script
# 使い方: zsh setup.sh

set -e

echo "=========================================="
echo "  New Mac Setup"
echo "=========================================="
echo ""

# --- Step 1: SSH Key ---
echo "## Step 1: SSH Key 生成"
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  mkdir -p ~/.ssh && chmod 700 ~/.ssh
  ssh-keygen -t ed25519 -C "k-hattori@mercari.com" -f ~/.ssh/id_ed25519
  echo ""
  echo "👇 この公開鍵を GitHub に登録してください:"
  echo "   https://github.com/settings/keys"
  echo ""
  cat ~/.ssh/id_ed25519.pub
  echo ""
  read "?GitHub に登録したら Enter を押してください..."
else
  echo "✓ SSH鍵はすでに存在します"
fi

# --- Step 2: Homebrew ---
echo ""
echo "## Step 2: Homebrew インストール"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon
  [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  # Intel
  [[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
else
  echo "✓ Homebrew はすでにインストール済みです"
fi

# --- Step 3: dotfiles clone ---
echo ""
echo "## Step 3: dotfiles クローン"
if [[ ! -d ~/dotfiles ]]; then
  git clone git@github.com:n1nnin/dotfiles.git ~/dotfiles
  cd ~/dotfiles && git submodule update --init --recursive
  echo "✓ dotfiles クローン完了"
else
  echo "✓ dotfiles はすでに存在します"
fi

# --- Step 4: Brewfile ---
echo ""
echo "## Step 4: Homebrew パッケージインストール"
echo "注意: kouzoh/tap のインストールには HOMEBREW_GITHUB_API_TOKEN が必要です"
echo "      ~/.zshrc.local に設定後、手動で 'brew bundle install --file=~/dotfiles/Brewfile' を実行してください"
echo ""
read "run_brew?今すぐ実行しますか？ (y/N): "
if [[ "$run_brew" =~ ^[Yy]$ ]]; then
  brew bundle install --file=~/dotfiles/Brewfile
else
  echo "スキップしました（後で実行: brew bundle install --file=~/dotfiles/Brewfile）"
fi

# --- Step 5: symlinks ---
echo ""
echo "## Step 5: シンボリックリンク作成"

ln -sf ~/dotfiles/.zshrc ~/.zshrc
echo "✓ ~/.zshrc"

mkdir -p ~/.config
for dir in karabiner kitty lazygit nvim powerline powerline-shell; do
  if [[ -d ~/dotfiles/.config/$dir ]]; then
    ln -sfn ~/dotfiles/.config/$dir ~/.config/$dir
    echo "✓ ~/.config/$dir"
  fi
done

# --- Step 6: .zshrc.local ---
echo ""
echo "## Step 6: ~/.zshrc.local 作成（シークレット用）"
if [[ ! -f ~/.zshrc.local ]]; then
  cat > ~/.zshrc.local << 'LOCALEOF'
# マシン固有の設定・シークレット — git管理外（絶対にコミットしない）

# --- API tokens (要設定) ---
export HOMEBREW_GITHUB_API_TOKEN=
export SLACK_USER_TOKEN=
export LITELLM_API_KEY=
export DANGER_GITHUB_HOST=https://github.com/
export DANGER_GITHUB_API_BASE_URL=https://github.com/api/v3/
export DANGER_OCTOKIT_VERIFY_SSL=true
export DANGER_GITHUB_API_TOKEN=

# --- マシン固有のパス (必要に応じて調整) ---
export PATH=/usr/local/mecab/bin:$PATH
export PATH=$HOME/google-cloud-sdk/bin:$PATH
export JAVA_HOME=$HOME/Applications/"Android Studio.app"/Contents/jbr/Contents/Home
export PATH=$PATH:$JAVA_HOME/bin

# powerline (インストール後にコメントアウト解除)
# . /Library/Frameworks/Python.framework/Versions/3.13/lib/python3.13/site-packages/powerline/bindings/zsh/powerline.zsh
LOCALEOF
  echo "✓ ~/.zshrc.local 作成（トークンを設定してください）"
else
  echo "✓ ~/.zshrc.local はすでに存在します"
fi

# --- Step 7: .gitconfig ---
echo ""
echo "## Step 7: ~/.gitconfig 作成"
if [[ ! -f ~/.gitconfig ]]; then
  cat > ~/.gitconfig << 'GITEOF'
[user]
	name = n1nnin
	email = k-hattori@mercari.com
	signingkey = ~/.ssh/id_ed25519
[url "git@github.com:"]
	insteadOf = https://github.com/
[core]
	editor = nvim
[alias]
	push-f = push --force-with-lease
[gpg]
	format = ssh
[commit]
	gpgsign = true
GITEOF
  echo "✓ ~/.gitconfig 作成"
else
  echo "✓ ~/.gitconfig はすでに存在します"
fi

# --- Step 8: Claude Code ブートストラップ ---
echo ""
echo "## Step 8: Claude Code ブートストラップ設定"
mkdir -p ~/.claude
if [[ ! -f ~/.claude/CLAUDE.md ]] || grep -q "Bootstrap CLAUDE.md" ~/.claude/CLAUDE.md 2>/dev/null; then
  cp ~/dotfiles/CLAUDE_bootstrap.md ~/.claude/CLAUDE.md
  echo "✓ ~/.claude/CLAUDE.md（ブートストラップ版）配置完了"
  echo "  → Claude Code を起動すると、のんたんが自動で復元してくれます"
else
  echo "✓ ~/.claude/CLAUDE.md はすでに存在します（スキップ）"
fi

# --- 完了 ---
echo ""
echo "=========================================="
echo "  セットアップ完了！"
echo "=========================================="
echo ""
echo "残作業:"
echo "  1. ~/.zshrc.local のトークンを設定"
echo "     - HOMEBREW_GITHUB_API_TOKEN (GitHub PAT: repo, read:packages)"
echo "     - SLACK_USER_TOKEN          (Slack User OAuth Token)"
echo "     - LITELLM_API_KEY           (LiteLLM API Key)"
echo "  2. brew bundle install --file=~/dotfiles/Brewfile  (Step 4 をスキップした場合)"
echo "  3. source ~/.zshrc で設定を読み込む"
echo "  4. claude-config.tar.gz を旧PCからAirDropで ~/Desktop に転送"
echo "  5. Claude Code をインストール: https://claude.ai/download"
echo "     起動するとのんたんが自動で設定を復元してくれます 💜"
