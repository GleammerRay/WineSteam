#! /bin/bash

export WINESTEAM_DATA="$HOME/.winesteam"

read -p "?: Are you sure that you want to uninstall WineSteam? You can install it again by running \`bash winesteam.sh\`. [y/N]: " CONFIRM_UNINSTALL
CONFIRM_UNINSTALL=$(echo ${CONFIRM_UNINSTALL:-'n'} | tr '[:upper:]' '[:lower:]')
if [ "$CONFIRM_UNINSTALL" != 'y' ]; then
  export CONFIRM_UNINSTALL='n'
  echo '?: Uninstall cancelled. 【=◡˳ ◡✿=】'
else
  export CONFIRM_UNINSTALL='y'
  echo '?: Uninstalling WineSteam. 【=╥﹏╥✿=】'
  rm -rf "$WINESTEAM_DATA/*"
  rm -rf "$WINESTEAM_DATA"
  SHARE_DIR="$HOME/.local/share"
  APP_DIR="$SHARE_DIR/applications"
  ICONS_DIR="$SHARE_DIR/icons/hicolor/64x64/apps"
  APP_PATH="$APP_DIR/gleam-winesteam.desktop"
  ICON_PATH="$ICONS_DIR/gleam-winesteam.png"
  rm "$ICON_PATH"
  rm "$APP_PATH"
  echo 'Done.'
fi
