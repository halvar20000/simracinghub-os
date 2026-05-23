#!/usr/bin/bash
#
# SimRacing Hub OS — Claude Desktop setup helper
#
# Downloads and installs the community-built Claude Desktop for Linux
# (the AppImage from the aaddrick/claude-desktop-debian project) into your
# home folder, and adds a launcher to your applications menu.
#
# IMPORTANT: There is no official Claude Desktop for Linux. This installs an
# UNOFFICIAL, community-maintained build. It is not provided, supported or
# endorsed by Anthropic. You can also just use Claude in Firefox at
# https://claude.ai — no install needed.

set -euo pipefail

REPO="aaddrick/claude-desktop-debian"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/simracinghub-os/claude-desktop"
APPIMAGE="$INSTALL_DIR/claude-desktop.AppImage"
DESKTOP_FILE="$HOME/.local/share/applications/simracinghub-claude-desktop.desktop"

echo "======================================================"
echo "   SimRacing Hub OS  —  Claude Desktop setup"
echo "======================================================"
echo
echo "  This installs an UNOFFICIAL, community-built Claude Desktop"
echo "  for Linux. It is not provided or endorsed by Anthropic."
echo "  (You can also just use Claude in Firefox at claude.ai.)"
echo
read -rp "Press Enter to continue, or Ctrl+C to cancel."
echo

# --- Step 1: find the latest AppImage ---------------------------------------
echo "[1/3] Finding the latest Claude Desktop release..."
API="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest")"
URL="$(printf '%s' "$API" | grep -oE 'https://[^"]+\.AppImage' | grep -Ei 'x86_64|amd64' | head -n1 || true)"
if [[ -z "$URL" ]]; then
    URL="$(printf '%s' "$API" | grep -oE 'https://[^"]+\.AppImage' | head -n1 || true)"
fi

if [[ -z "$URL" ]]; then
    echo
    echo "  Could not find an AppImage automatically."
    echo "  Opening the releases page so you can download it yourself."
    xdg-open "https://github.com/$REPO/releases/latest" >/dev/null 2>&1 || true
    read -rp "Press Enter to close."
    exit 1
fi
echo "      $URL"
echo

# --- Step 2: download -------------------------------------------------------
echo "[2/3] Downloading Claude Desktop (this may take a minute)..."
mkdir -p "$INSTALL_DIR"
curl -fL --progress-bar "$URL" -o "$APPIMAGE"
chmod +x "$APPIMAGE"
echo

# --- Step 3: create the launcher --------------------------------------------
echo "[3/3] Adding the launcher to your applications menu..."
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Claude Desktop
Comment=Claude Desktop — unofficial community build
Exec=$APPIMAGE --appimage-extract-and-run
Terminal=false
Categories=Utility;Network;
EOF

echo
echo "======================================================"
echo "  Claude Desktop is installed — look for it in your apps."
echo "  Run 'Install Claude Desktop' again any time to update."
echo "======================================================"
read -rp "Press Enter to close."
