#! /bin/bash
cd `dirname $0`
chmod +x winesteam.sh

function installToHome {
  SHARE_DIR="$HOME/.local/share"
  APP_DIR="$SHARE_DIR/applications"
  ICONS_DIR="$SHARE_DIR/icons/hicolor/64x64/apps"
  APP_PATH="$APP_DIR/gleam-winesteam.desktop"
  ICON_PATH="$ICONS_DIR/gleam-winesteam.png"
  mkdir -p "$ICONS_DIR"
  if [ -f "$ICON_PATH" ]; then rm "$ICON_PATH"; fi
  cp winesteam.png "$ICON_PATH"
  mkdir -p "$APP_DIR"
  if [ -f "$APP_PATH" ]; then rm "$APP_PATH"; fi
  cp winesteam.desktop "$APP_PATH"
  sed -i "s/Icon=winesteam/Icon=gleam-winesteam/" "$APP_PATH"
  sed -i "s|Exec=winesteam.sh|Exec=$PWD/winesteam.sh|" "$APP_PATH"
  chmod +x "$APP_PATH"
}

installToHome
