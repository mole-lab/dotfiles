#!/usr/bin/env bash
# Apply a SilentSDDM layout from this folder: ./sddm-layout.sh a|b
set -euo pipefail

THEME=/usr/share/sddm/themes/silent
DIR="$(cd "$(dirname "$0")" && pwd)"

case "${1:-}" in
  a|b) ;;
  *) echo "usage: $(basename "$0") a|b"; exit 1 ;;
esac

sudo install -m 644 "$DIR/tomie-a.conf" "$DIR/tomie-b.conf" "$THEME/configs/"
sudo sed -i "s|^ConfigFile=.*|ConfigFile=configs/tomie-$1.conf|" "$THEME/metadata.desktop"
grep ConfigFile "$THEME/metadata.desktop"
