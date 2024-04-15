#! /bin/bash

export NOTIFY_BACKEND=""
export INPUT_BACKEND=""

wsNotify() {
  echo "$@"
  if [ "$NOTIFY_BACKEND" = "kdialog" ]; then
    kdialog --title "WineSteam" --passivepopup "\n$@" 7
  fi
  if [ "$NOTIFY_BACKEND" = "notify-send" ]; then
    notify-send "WineSteam" "$@"
  fi
  if [ "$NOTIFY_BACKEND" = "zenity" ]; then
    zenity --info --timeout=2 --title "WineSteam" --text="$@"
  fi
}

wsInputYN() {
  if [ "$INPUT_BACKEND" = "zenity" ]; then
    ANS=`zenity --info --title "WineSteam" --text "$@" --ok-label "Yes" --extra-button "No"`
    if [ "$ANS" = "No" ]; then
      echo "n"
    else
      echo "y"
    fi
  elif [ "$INPUT_BACKEND" = "kdialog" ]; then
    `kdialog --title "WineSteam" --yesno "$@"`
    if [ "$?" = "0" ]; then
      echo "y"
    else
      echo "n"
    fi
  else
    read -p "$@" ANS
    echo "$ANS"
  fi
}

wsInfo() {
  echo "$@"
  if [ "$INPUT_BACKEND" = "zenity" ]; then
    zenity --info --title "WineSteam" --text "$@"
  elif [ "$INPUT_BACKEND" = "kdialog" ]; then
    kdialog --title "WineSteam" --msgbox "$@"
  fi
}

if command -v "zenity" &> /dev/null
then
  export NOTIFY_BACKEND="zenity"
  export INPUT_BACKEND="zenity"
fi
if command -v "notify-send" &> /dev/null
then
  export NOTIFY_BACKEND="notify-send"
fi
if command -v "kdialog" &> /dev/null
then
  export NOTIFY_BACKEND="kdialog"
  export INPUT_BACKEND="kdialog"
fi

export WINESTEAM_DATA="$HOME/.winesteam"

CONFIRM_UNINSTALL=`wsInputYN "?: Are you sure that you want to uninstall WineSteam? You can install it again by running \"bash winesteam.sh\". [y/N]: "`
CONFIRM_UNINSTALL=$(echo ${CONFIRM_UNINSTALL:-'n'} | tr '[:upper:]' '[:lower:]')
if [ "$CONFIRM_UNINSTALL" != 'y' ]; then
  export CONFIRM_UNINSTALL='n'
  wsNotify '?: Uninstall cancelled. 【=◡˳ ◡✿=】'
else
  export CONFIRM_UNINSTALL='y'
  wsNotify '?: Uninstalling WineSteam. 【=╥﹏╥✿=】'
  rm -rf `readlink -f "$WINESTEAM_DATA"`
  rm "$WINESTEAM_DATA"
  SHARE_DIR="$HOME/.local/share"
  APP_DIR="$SHARE_DIR/applications"
  ICONS_DIR="$SHARE_DIR/icons/hicolor/64x64/apps"
  APP_PATH="$APP_DIR/gleam-winesteam.desktop"
  ICON_PATH="$ICONS_DIR/gleam-winesteam.png"
  rm "$ICON_PATH"
  rm "$APP_PATH"
  wsInfo 'Done.'
fi
