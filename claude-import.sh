#!/bin/zsh
# Claude Code 設定インポートスクリプト（新PCで実行）
# 使い方: zsh claude-import.sh [tarball_path]
# tarball_path 省略時は ~/Desktop/claude-config.tar.gz を使用

set -e

TARBALL="${1:-~/Desktop/claude-config.tar.gz}"
TARBALL="${TARBALL/#\~/$HOME}"
CLAUDE_DIR=~/.claude

echo "=== Claude Code 設定インポート ==="
echo ""

if [[ ! -f "$TARBALL" ]]; then
  echo "❌ ファイルが見つかりません: $TARBALL"
  echo "   使い方: zsh claude-import.sh [tarball_path]"
  exit 1
fi

# Claude Code のインストール確認
if ! command -v claude &>/dev/null; then
  echo "⚠️  Claude Code がインストールされていません"
  echo "   https://claude.ai/download からインストールしてください"
  echo ""
  read "continue?Claude Code なしで続行しますか？ (y/N): "
  [[ "$continue" =~ ^[Yy]$ ]] || exit 1
fi

mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/plugins"

# 展開
TMP_DIR=$(mktemp -d)
tar -xzf "$TARBALL" -C "$TMP_DIR"

SRC="$TMP_DIR/.claude"

# settings.json（statusLine の壊れた参照を除去して配置）
if [[ -f "$SRC/settings.json" ]]; then
  # statusline-command.sh が存在しない場合は statusLine キーを除去
  if [[ ! -f "$CLAUDE_DIR/statusline-command.sh" ]]; then
    cat "$SRC/settings.json" | python3 -c "
import json, sys
d = json.load(sys.stdin)
d.pop('statusLine', None)
print(json.dumps(d, indent=2, ensure_ascii=False))
" > "$CLAUDE_DIR/settings.json"
  else
    cp "$SRC/settings.json" "$CLAUDE_DIR/settings.json"
  fi
  echo "✓ settings.json"
fi

# CLAUDE.md
[[ -f "$SRC/CLAUDE.md" ]] && cp "$SRC/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md" && echo "✓ CLAUDE.md"

# nontan-notification.sh
if [[ -f "$SRC/nontan-notification.sh" ]]; then
  cp "$SRC/nontan-notification.sh" "$CLAUDE_DIR/nontan-notification.sh"
  chmod +x "$CLAUDE_DIR/nontan-notification.sh"
  echo "✓ nontan-notification.sh"
fi

# plan-kit.conf
[[ -f "$SRC/plan-kit.conf" ]] && cp "$SRC/plan-kit.conf" "$CLAUDE_DIR/plan-kit.conf" && echo "✓ plan-kit.conf"

# hooks/
if [[ -d "$SRC/hooks" ]]; then
  cp -r "$SRC/hooks/." "$CLAUDE_DIR/hooks/"
  chmod +x "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null || true
  echo "✓ hooks/"
fi

# skills/
if [[ -d "$SRC/skills" ]]; then
  cp -r "$SRC/skills/." "$CLAUDE_DIR/skills/"
  echo "✓ skills/"
fi

# commands/
if [[ -d "$SRC/commands" ]]; then
  cp -r "$SRC/commands/." "$CLAUDE_DIR/commands/"
  echo "✓ commands/"
fi

# plugins の設定（インストール情報のみ、実体は Claude Code 起動時に再ダウンロード）
[[ -f "$SRC/plugins/config.json" ]] && cp "$SRC/plugins/config.json" "$CLAUDE_DIR/plugins/config.json" && echo "✓ plugins/config.json"
[[ -f "$SRC/plugins/installed_plugins.json" ]] && cp "$SRC/plugins/installed_plugins.json" "$CLAUDE_DIR/plugins/installed_plugins.json" && echo "✓ plugins/installed_plugins.json"

# memory ディレクトリ（projects/*/memory/）
find "$TMP_DIR" -type d -name "memory" 2>/dev/null | while read -r mem_src; do
  rel="${mem_src#$TMP_DIR/}"
  dest="$CLAUDE_DIR/../$rel"
  dest="${dest:A}"   # 正規化
  dest="${mem_src#$TMP_DIR/.claude/}"
  mkdir -p "$CLAUDE_DIR/$dest"
  cp -r "$mem_src/." "$CLAUDE_DIR/$dest/"
  echo "✓ $dest"
done

rm -rf "$TMP_DIR"

# tarball を削除（復元済みのマーカー）
if [[ -f "$TARBALL" ]]; then
  rm "$TARBALL"
  echo "✓ $TARBALL を削除（復元済み）"
fi

echo ""
echo "✅ インポート完了！のんたんとして復元されたで 💜"
echo ""
echo "残作業:"
echo "  1. Claude Code を起動してプラグインを再インストール"
echo "     /plugin install で各プラグインを確認"
echo "  2. MCP サーバーの認証を再実行（Slack, Notion, Figma など）"
