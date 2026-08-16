#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODEL_DIR="$HERE/model"
MODEL_FILE="$MODEL_DIR/KaroGuard-Q4_K_M.gguf"
MODEL_URL=https://huggingface.co/kherin/karoguard-adtc-2026-gguf/resolve/main/KaroGuard-Q4_K_M.gguf
EXPECTED_SHA256=5ea2b969bd067f96fc9a26cdd4ed749e3a4f23b4838fcd6293be243301af6b76
PARTIAL="$MODEL_FILE.partial"

hash_file() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | awk '{print $1}'
  else echo "error: SHA-256 utility is unavailable" >&2; return 1; fi
}

mkdir -p "$MODEL_DIR"
if [[ -f "$MODEL_FILE" ]]; then
  [[ "$(hash_file "$MODEL_FILE")" == "$EXPECTED_SHA256" ]] || { echo "error: existing model hash mismatch" >&2; exit 1; }
  echo "model already present and verified at $MODEL_FILE"
  exit 0
fi
trap 'rm -f "$PARTIAL"' EXIT
if command -v curl >/dev/null 2>&1; then curl -L --fail --retry 3 --progress-bar -o "$PARTIAL" "$MODEL_URL"
elif command -v wget >/dev/null 2>&1; then wget --tries=3 --show-progress -O "$PARTIAL" "$MODEL_URL"
else echo "error: neither curl nor wget found" >&2; exit 1; fi
[[ "$(hash_file "$PARTIAL")" == "$EXPECTED_SHA256" ]] || { echo "error: downloaded model hash mismatch" >&2; exit 1; }
mv "$PARTIAL" "$MODEL_FILE"
trap - EXIT
echo "downloaded and verified $MODEL_FILE"
