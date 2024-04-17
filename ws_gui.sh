export NOTIFY_BACKEND=""
export INPUT_BACKEND=""

wsNotify() {
  echo "$@"
  if [ "$NOTIFY_BACKEND" = "kdialog" ]; then
    kdialog --icon "$WINESTEAM_BIN/winesteam.png" --title "WineSteam" --passivepopup "\n$@" 7
  fi
  if [ "$NOTIFY_BACKEND" = "notify-send" ]; then
    notify-send --icon "$WINESTEAM_BIN/winesteam.png" "WineSteam" "$@"
  fi
  if [ "$NOTIFY_BACKEND" = "zenity" ]; then
    zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --notification --title "WineSteam" --text="$@"
  fi
}

wsInputYN() {
  if [ "$INPUT_BACKEND" = "zenity" ]; then
    ANS="`zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --info --title "WineSteam" --text "$@" --ok-label "Yes" --extra-button "No"`"
    if [ "$ANS" = "No" ]; then
      echo "n"
    else
      echo "y"
    fi
  elif [ "$INPUT_BACKEND" = "kdialog" ]; then
    kdialog --icon "$WINESTEAM_BIN/winesteam.png" --title "WineSteam" --yesno "$@"
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

wsInputDir() {
  if [ "$INPUT_BACKEND" = "zenity" ]; then
    ANS="`zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --file-selection --directory --title "WineSteam"`"
    echo "$ANS"
  elif [ "$INPUT_BACKEND" = "kdialog" ]; then
    kdialog --icon "$WINESTEAM_BIN/winesteam.png" --getexistingdirectory
  else
    read -p "Enter directory path:" ANS
    echo "`readlink -f "$ANS"`"
  fi
}

wsInfo() {
  echo "$@"
  if [ "$INPUT_BACKEND" = "zenity" ]; then
    zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --info --title "WineSteam" --text "$@"
  elif [ "$INPUT_BACKEND" = "kdialog" ]; then
    kdialog --icon "$WINESTEAM_BIN/winesteam.png" --title "WineSteam" --msgbox "$@"
  fi
}

if command -v "notify-send" &> /dev/null; then
  export NOTIFY_BACKEND="notify-send"
fi
if command -v "kdialog" &> /dev/null; then
  export NOTIFY_BACKEND="kdialog"
  export INPUT_BACKEND="kdialog"
fi
if command -v "zenity" &> /dev/null; then
  if [ ! "x$DESKTOP_SESSION" = "xplasma" ]; then
    export NOTIFY_BACKEND="zenity"
    export INPUT_BACKEND="zenity"
  fi
fi
