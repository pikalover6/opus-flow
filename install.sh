#!/usr/bin/env bash
set -euo pipefail

OPUS_REPO="https://github.com/pikalover6/opus-flow.git"
CODEX_PLUGIN_REPO="https://github.com/openai/codex-plugin-cc.git"
OPUS_HOME="${OPUS_FLOW_HOME:-$HOME/.local/share/opus-flow}"
DEPS_HOME="${OPUS_FLOW_DEPS_HOME:-$HOME/.local/share/opus-flow-deps}"
CODEX_PLUGIN_HOME="$DEPS_HOME/codex-plugin-cc"
BIN_DIR="$HOME/.local/bin"
LAUNCHER="$BIN_DIR/opus-flow"

fail() {
  echo "opus-flow: $*" >&2
  exit 1
}

for cmd in git claude; do
  command -v "$cmd" >/dev/null 2>&1 || fail "missing required command: $cmd"
done

sync_repo() {
  local url="$1"
  local dir="$2"
  local label="$3"

  if [ -d "$dir/.git" ]; then
    echo "Updating $label..."
    git -C "$dir" pull --ff-only
  else
    echo "Installing $label..."
    mkdir -p "$(dirname "$dir")"
    git clone --depth 1 "$url" "$dir"
  fi
}

sync_repo "$OPUS_REPO" "$OPUS_HOME" "Opus Flow"
sync_repo "$CODEX_PLUGIN_REPO" "$CODEX_PLUGIN_HOME" "OpenAI Codex Claude Code plugin"

if ! command -v codex >/dev/null 2>&1; then
  command -v npm >/dev/null 2>&1 || fail "Codex CLI is missing and npm is not available. Install Codex, then run this installer again."
  echo "Installing Codex CLI..."
  npm install -g @openai/codex
fi

mkdir -p "$BIN_DIR"
cat > "$LAUNCHER" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

OPUS_HOME="${OPUS_FLOW_HOME:-$HOME/.local/share/opus-flow}"
CODEX_PLUGIN="${OPUS_FLOW_CODEX_PLUGIN_HOME:-$HOME/.local/share/opus-flow-deps/codex-plugin-cc/plugins/codex}"

[ -d "$OPUS_HOME/.claude-plugin" ] || {
  echo "opus-flow: plugin not found at $OPUS_HOME" >&2
  exit 1
}

[ -d "$CODEX_PLUGIN/.claude-plugin" ] || {
  echo "opus-flow: Codex plugin not found at $CODEX_PLUGIN" >&2
  exit 1
}

exec claude \
  --plugin-dir "$OPUS_HOME" \
  --plugin-dir "$CODEX_PLUGIN" \
  "$@"
EOF
chmod +x "$LAUNCHER"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  ZSHRC="$HOME/.zshrc"
  if ! grep -Fq '# opus-flow path' "$ZSHRC" 2>/dev/null; then
    {
      echo
      echo '# opus-flow path'
      echo 'export PATH="$HOME/.local/bin:$PATH"'
    } >> "$ZSHRC"
  fi
  PATH_NOTE="Run: exec zsh"
else
  PATH_NOTE="Launcher is already on PATH."
fi

cat <<EOF

Opus Flow installed.

$PATH_NOTE

Then:
  cd /path/to/a/project
  opus-flow

First session:
  /codex:setup

Vanilla Claude Code remains:
  claude
EOF
