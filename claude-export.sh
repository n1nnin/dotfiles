#!/bin/zsh
# Claude Code 設定エクスポートスクリプト（旧PCで実行）
# 出力先: ~/Desktop/claude-config.tar.gz

set -e

OUTPUT=~/Desktop/claude-config.tar.gz
CLAUDE_DIR=~/.claude

echo "=== Claude Code 設定エクスポート ==="
echo ""

# エクスポート対象のファイル・ディレクトリ
INCLUDES=(
  "$CLAUDE_DIR/CLAUDE.md"
  "$CLAUDE_DIR/settings.json"
  "$CLAUDE_DIR/nontan-notification.sh"
  "$CLAUDE_DIR/plan-kit.conf"
  "$CLAUDE_DIR/hooks"
  "$CLAUDE_DIR/skills"
  "$CLAUDE_DIR/commands"
  "$CLAUDE_DIR/plugins/config.json"
  "$CLAUDE_DIR/plugins/installed_plugins.json"
)

# projects/ 以下の memory ディレクトリだけを追加
MEMORY_DIRS=()
while IFS= read -r dir; do
  MEMORY_DIRS+=("$dir")
done < <(find "$CLAUDE_DIR/projects" -type d -name "memory" 2>/dev/null)

# 一時ディレクトリに集める
TMP_DIR=$(mktemp -d)
TMP_CLAUDE="$TMP_DIR/.claude"
mkdir -p "$TMP_CLAUDE"

# 通常ファイル
for item in "${INCLUDES[@]}"; do
  if [[ -e "$item" ]]; then
    rel="${item#$HOME/}"
    dest="$TMP_DIR/$rel"
    mkdir -p "$(dirname "$dest")"
    cp -r "$item" "$dest"
    echo "✓ $rel"
  fi
done

# memory ディレクトリ
for mem_dir in "${MEMORY_DIRS[@]}"; do
  rel="${mem_dir#$HOME/}"
  dest="$TMP_DIR/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -r "$mem_dir" "$dest"
  echo "✓ $rel"
done

# tarball 作成
tar -czf "$OUTPUT" -C "$TMP_DIR" .
rm -rf "$TMP_DIR"

echo ""
echo "✅ エクスポート完了: $OUTPUT"
echo ""
echo "次のステップ:"
echo "  1. ~/Desktop/claude-config.tar.gz を新PCに転送（AirDropなど）"
echo "  2. 新PCで: zsh claude-import.sh"
