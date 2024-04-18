#! /bin/bash

export NOTIFY_BACKEND=""
export INPUT_BACKEND=""

cd "`dirname "$0"`"
source "./ws_gui.sh"
eval "`bash read_config.sh`"

if [ "$1" = "-y" ]; then
  export CONFIRM_UNINSTALL='y'
else
  export CONFIRM_UNINSTALL="`wsInputYN "?: Are you sure that you want to uninstall WineSteam? You can install it again by running \\\"bash winesteam.sh\\\". [y/N]: "`"
fi
CONFIRM_UNINSTALL=$(echo ${CONFIRM_UNINSTALL:-'n'} | tr '[:upper:]' '[:lower:]')
if [ "$CONFIRM_UNINSTALL" != 'y' ]; then
  export CONFIRM_UNINSTALL='n'
  wsNotify '?: Uninstall cancelled. 【=◡˳ ◡✿=】'
else
  export CONFIRM_UNINSTALL='y'
  wsNotify '?: Uninstalling WineSteam. 【=╥﹏╥✿=】'
  flatpak run io.github.gleammerray.WineSteam uninstall -y
  flatpak uninstall --user -y io.github.gleammerray.WineSteam
  rm -rf "$WINESTEAM_DATA"
  rm "$WINESTEAM_CFG"
  SHARE_DIR="$HOME/.local/share"
  APP_DIR="$SHARE_DIR/applications"
  ICONS_DIR="$SHARE_DIR/icons/hicolor/64x64/apps"
  APP_PATH="$APP_DIR/gleam-winesteam.desktop"
  ICON_PATH="$ICONS_DIR/gleam-winesteam.png"
  rm "$ICON_PATH"
  rm "$APP_PATH"
  wsInfo 'Done.'
fi
