#! /bin/bash

export WS_RUNNER_PID=""
export WS_CONTROLS_PID=""

user_interrupt() {
  echo "user_interrupt" > "$WINESTEAM_IPC_PATH"
  kill $(jobs -p)
  kill -9 $$
  exit
}

trap user_interrupt SIGINT
trap user_interrupt SIGTERM
trap user_interrupt SIGTSTP

export NOTIFY_BACKEND=""
export INPUT_BACKEND=""

wsCleanup() {
  wait -n $WS_RUNNER_PID $WS_CONTROLS_PID
  user_interrupt
}

wsNotify() {
  echo "$@"
  if [ "$NOTIFY_BACKEND" = "kdialog" ]; then
    kdialog --icon "$WINESTEAM_BIN/winesteam.png" --title "WineSteam" --passivepopup "\n$@" 7
  fi
  if [ "$NOTIFY_BACKEND" = "notify-send" ]; then
    notify-send --icon "$WINESTEAM_BIN/winesteam.png" "WineSteam" "$@"
  fi
  if [ "$NOTIFY_BACKEND" = "zenity" ]; then
    zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --info --timeout=2 --title "WineSteam" --text="$@"
  fi
}

wsControls() {
  sleep 20
  WS_CONTROLS_MSG="WineSteam is now starting up!\nHere you can control your running WineSteam instance."
  while true; do
    if [ "$INPUT_BACKEND" = "zenity" ]; then
      ANS="`zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --list --radiolist --title "WineSteam controls" --text "$WS_CONTROLS_MSG" --column "" --column "Options" TRUE "Open WineSteam" FALSE "Launch NEOTOKYO°" FALSE "Exit WineSteam"`"
      if [ "$ANS" = "Open WineSteam" ]; then
        echo "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\"" > "$WINESTEAM_IPC_PATH"
        wsNotify "Opening WineSteam..."
      elif [ "$ANS" = "Launch NEOTOKYO°" ]; then
        echo "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" -applaunch 244630" > "$WINESTEAM_IPC_PATH"
        wsNotify "Launching NEOTOKYO°..."
      elif [ "$ANS" = "Exit WineSteam" ]; then
        echo "user_interrupt" > "$WINESTEAM_IPC_PATH"
        wsNotify "Stopping WineSteam... 【=˶◡˳ ◡˶✿=】ᶻ 𝗓 𐰁"
        exit
      fi
    elif [ "$INPUT_BACKEND" = "kdialog" ]; then
      ANS="`kdialog --icon "$WINESTEAM_BIN/winesteam.png" --title "WineSteam controls" --cancel-label "Exit" --radiolist "$WS_CONTROLS_MSG" 1 "Open WineSteam" on 2 "Launch NEOTOKYO°" off 3 "Exit WineSteam" off`"
      if [ "$ANS" = "1" ]; then
        echo "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\"" > "$WINESTEAM_IPC_PATH"
        wsNotify "Opening WineSteam..."
      elif [ "$ANS" = "2" ]; then
        echo "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" -applaunch 244630" > "$WINESTEAM_IPC_PATH"
        wsNotify "Launching NEOTOKYO°..."
      elif [ "$ANS" = "3" ]; then
        echo "user_interrupt" > "$WINESTEAM_IPC_PATH"
        wsNotify "Stopping WineSteam... 【=˶◡˳ ◡˶✿=】ᶻ 𝗓 𐰁"
        exit
      fi
    else
      sleep 100
    fi
  done
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

if ! command -v "winetricks" &> /dev/null
then
    wsNotify "Package \"winetricks\" is not installed."
    exit 1
fi
if ! command -v "unshare" &> /dev/null
then
    wsNotify "Package \"util-linux\" package is not installed."
    exit 1
fi

cd "`dirname "$0"`"
eval "`bash read_config.sh`"
if [ ! -d "$WINESTEAM_DATA" ]; then mkdir -p "$WINESTEAM_DATA"; fi
if [ -d "$PWD/prefix" ]; then mv "$PWD/prefix" "$WINESTEAM_DATA"; fi
if [ -d "$PWD/packages" ]; then mv "$PWD/packages" "$WINESTEAM_DATA"; fi
if [ -d "$WINEPREFIX" ]; then
  unshare --user --map-root-user --net --mount "$WINESTEAM_BIN/ws_runner.sh" "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" -silent" &
  sleep 1
  slirp4netns --configure --mtu=65520 --disable-host-loopback $(cat /tmp/winesteam_pid) tap0 &
  export WS_RUNNER_PID=$!
  wsControls &
  export WS_CONTROLS_PID=$!
  wsCleanup
  exit
fi
echo " ______________________________________________"
echo "|     /     *           /      \        *      |"
echo "|     \     /       \   *      /    *   \      |"
echo "|     /     \   *   /          \    /   /      |"
echo "|        __________           ___________      |"
echo "|       /          \         /           \     |"
echo "|      /   _______  \       /             |    |"
echo "|     /   /       \  \     /    _________/     |"
echo "|    |   /   __    \  \___/    /               |"
echo "|    |  |   /  \    |         /                |"
echo "|    |   \  \__/   /   ___    \                |"
echo "|     \   \       /   /   \    \_________      |"
echo "|      \   \_____/   /     \             \     |"
echo "|       \           /       \             |    |"
echo "|        \_________/         \___________/     |"
echo "|                                              |"
echo "|                                 Steamy Fish  |"
echo "|______________________________________________|"
echo
echo "----------> [ WineSteam installer ] <----------"
if [ "x$WINESTEAM_INSTALL_DXVK" = "x" ]; then
  echo 'Welcome to the WineSteam installer! The installation process takes between 5 and 10 minutes. Before the installation can begin we need to know how to set up the right prefix for you.'

  WINESTEAM_INSTALL_YN="`wsInputYN "?:[0/2]: Do you wish to modify default WineSteam install path? (~/.winesteam) [y/N]: "`"
  WINESTEAM_INSTALL_YN=$(echo ${WINESTEAM_INSTALL_YN:-'n'} | tr '[:upper:]' '[:lower:]')
  if [ "$WINESTEAM_INSTALL_YN" != 'n' ]; then
    WINESTEAM_INSTALL_PATH="`wsInputDir`"
    if [ "x$WINESTEAM_INSTALL_PATH" != "x" ]; then
      if [ "`ls -A "$WINESTEAM_INSTALL_PATH"`" ]; then
        wsNotify "F: Installation path is not empty: $WINESTEAM_INSTALL_PATH"
        exit 1
      fi
      mkdir -p "$WINESTEAM_INSTALL_PATH"
      if [ ! -d "$WINESTEAM_INSTALL_PATH" ]; then
        wsNotify "F: Bad installation path: $WINESTEAM_INSTALL_PATH"
        exit 1
      fi
      echo "WINESTEAM_DATA=\"$WINESTEAM_INSTALL_PATH\"" > "$WINESTEAM_CFG"
    fi
  fi
  cd "`dirname "$0"`"
  eval "`bash read_config.sh`"
  wsNotify "?:[0/2]: Installing to \"$WINESTEAM_INSTALL_PATH\""

  WINESTEAM_INSTALL_DXVK="`wsInputYN "?:[1/2]: DXVK greatly improves performance in all Wine applications. Some hardware/Wine versions/applications don't work well with DXVK. Install DXVK? [Y/n]: "`"
  WINESTEAM_INSTALL_DXVK=$(echo ${WINESTEAM_INSTALL_DXVK:-'y'} | tr '[:upper:]' '[:lower:]')
  if [ "$WINESTEAM_INSTALL_DXVK" != 'n' ]; then
    export WINESTEAM_INSTALL_DXVK='y'
    echo '?:[1/2]: DXVK will be installed.'
  else
    export WINESTEAM_INSTALL_DXVK='n'
    echo '?:[1/2]: Skipping DXVK installation.'
  fi
  
  WINESTEAM_INSTALL_DESKTOP="`wsInputYN '?:[2/2]: Do you wish to install WineSteam into your applications launcher? [Y/n]: '`"
  WINESTEAM_INSTALL_DESKTOP=$(echo ${WINESTEAM_INSTALL_DESKTOP:-'y'} | tr '[:upper:]' '[:lower:]')
  if [ "$WINESTEAM_INSTALL_DESKTOP" != 'n' ]; then
    export WINESTEAM_INSTALL_DESKTOP='y'
    echo '?:[2/2]: Installing launcher icon.'
    bash "$PWD/install_desktop.sh"
    echo '?:[2/2]: Launcher icon installed. You may need to reboot for it to show up.'
  else
    export WINESTEAM_INSTALL_DESKTOP='n'
    echo '?:[2/2]: Skipping launcher icon installation.'
  fi
fi

wsNotify '[0/5] Performing first time setup. [!]'
wsNotify '[1/5] [0/3] Downloading packages. [⟱]'
if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
if [ ! -d "$WINESTEAM_PKGS/bin" ]; then mkdir -p "$WINESTEAM_PKGS/bin"; fi
cd "$WINESTEAM_PKGS"
if [ ! -d ./lutris-GE-Proton8-26-x86_64 ]; then
  wsNotify '[1/5] [1/3] Downloading Wine GE... [⟱]]'
  echo '=========================================================='
  wget https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz
  tar -xvJf wine-lutris-GE-Proton8-26-x86_64.tar.xz
  if [ ! -d ./lutris-GE-Proton8-26-x86_64 ]; then
    wsNotify 'F: Download failed.'
    exit 1
  fi
  rm wine-lutris-GE-Proton8-26-x86_64.tar.xz
  echo '=========================================================='
fi
if [ ! -f ./SteamSetup.exe ]; then
  wsNotify '[1/5] [2/3] Downloading Steam setup... [⟱]]'
  echo '=========================================================='
  wget https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
  if [ ! -f ./SteamSetup.exe ]; then
    wsNotify 'F: Download failed.'
    exit 1
  fi
  echo '=========================================================='
fi
if [ ! -f ./bin/slirp4netns ]; then
  wsNotify '[1/5] [3/3] Downloading slirp4netns... [⟱]]'
  echo '=========================================================='
  wget https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
  curl -o slirp4netns --fail -L https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.3/slirp4netns-$(uname -m)
  chmod +x slirp4netns
  if [ ! -f ./slirp4netns ]; then
    wsNotify 'F: Download failed.'
    exit 1
  fi
  mv slirp4netns ./bin/
  echo '=========================================================='
fi
wsNotify '[2/5] Creating a Wine prefix... [⌂]'
wsInfo "A Wine prefix configuration window will open, please press \"Ok\" if you don't know what to change."
mkdir -p "$WINEPREFIX";
winecfg
winetricks win10
if [ "$WINESTEAM_INSTALL_DXVK" = "y" ]; then
  wsNotify '[3/5] Installing DXVK... [⌂]'
  echo '=========================================================='
  bash "$WINESTEAM_BIN/dxvkpatch.sh"
  echo '=========================================================='
else
  wsNotify '[3/5]: Skipping DXVK installation.'
fi

if [ "$WINESTEAM_WININET" != 'y' ]; then
  wsNotify '[4/5]: Skipping Wininet installation.'
else
  wsNotify '[4/5]: Installing Wininet.'
  echo '=========================================================='
  winetricks wininet
  echo '=========================================================='
  echo '[4/5]: Wininet installed.'
fi
wsNotify '[4/5] Installing allfonts... (this might take a while) [Æ]'
echo '=========================================================='
winetricks allfonts
echo '=========================================================='
wsNotify 'Almost there! 【=˶◕‿↼˶✿=】'
wsNotify '[5/5] Running Steam setup... [🮲🮳]'
unshare --user --map-root-user --net --mount "$WINESTEAM_BIN/ws_runner.sh" "wine \"$WINESTEAM_PKGS/SteamSetup.exe\"" &
sleep 1
slirp4netns --configure --mtu=65520 --disable-host-loopback $(cat /tmp/winesteam_pid) tap0 &
export WS_RUNNER_PID=$!
wsControls &
export WS_CONTROLS_PID=$!
wsCleanup
