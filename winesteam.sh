#! /bin/bash
cd "`dirname "$0"`"
source "./ws_gui.sh"

export WS_RUNNER_PID=""
export WS_CONTROLS_PID=""

user_interrupt() {
  echo "user_interrupt" > "$WINESTEAM_IPC_PATH"
  if [ "x$WINESTEAM_INSTALL_MODE" = "xflatpak" ]; then
    flatpak kill io.github.gleammerray.WineSteam
  fi
  kill $(pgrep -P $WS_CONTROLS_PID)
  kill $(jobs -p)
  if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
    wsNotify "WineSteam stopped."
  fi
  kill -9 $1
  exit
}

trap "user_interrupt $$" SIGINT
trap "user_interrupt $$" SIGTERM
trap "user_interrupt $$" SIGTSTP

wsCleanup() {
  tail --pid=$WS_RUNNER_PID -f /dev/null
  if [ "x$WINESTEAM_INSTALL_MODE" = "xflatpak" ]; then
    flatpak kill io.github.gleammerray.WineSteam
  fi
  kill $(pgrep -P $WS_CONTROLS_PID)
  kill $(jobs -p)
  wsNotify "WineSteam stopped."
  kill $$
}

wsInstallP7zipFull() {
  if command -v "7zz" &> /dev/null ; then
    return 0
  fi
  wsNotify "Installing p7zip-full..."
  cd "$WINESTEAM_PKGS"
  curl -o p7zip.zip -L https://github.com/phoepsilonix/p7zip-full/releases/download/v23.01.4/p7zip-linux-x86_64-musl.zip
  unzip p7zip.zip
  rm p7zip.zip
  if ! command -v "7zz" &> /dev/null ; then
    wsInfo 'wsInstallP7zipFull: Download failed.'
    return 1
  fi
  wsNotify "p7zip-full installed."
}

wsSetup() {
  WS_SETUP_MSG="?: How do you want to install WineSteam?: "
  while true; do
    if [ "$INPUT_BACKEND" = "zenity" ]; then
      ANS="`zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --list --radiolist --height 200 --width 420 --title "WineSteam controls" --text "$WS_SETUP_MSG" --column "" --column "Options" TRUE "Install as a flatpak (recommended)" FALSE "Install normally" FALSE "Cancel installation"`"
      if [ "$ANS" = "Install normally" ]; then
        echo 1
        exit
      elif [ "$ANS" = "Install as a flatpak (recommended)" ]; then
        echo 2
        exit
      else
        echo 0
        exit
      fi
    elif [ "$INPUT_BACKEND" = "kdialog" ]; then
      ANS="`kdialog --geometry 400x150 --icon "$WINESTEAM_BIN/winesteam.png" --title "WineSteam controls" --cancel-label "Exit" --radiolist "$WS_SETUP_MSG" 1 "Install as a flatpak (recommended)" on 2 "Install normally" off 3 "Cancel installation" off`"
      if [ "$ANS" = "1" ]; then
        echo 2
        exit
      elif [ "$ANS" = "2" ]; then
        echo 1
        exit
      else
        echo 0
        exit
      fi
    else
      printf "$WS_SETUP_MSG\n1. Install normally\n2. Install as a flatpak (recommended for Steam Deck)\n"
      read ANS
      if [ "x$ANS" = "x1" ]; then
        echo 1
        exit
      elif [ "x$ANS" = "x2" ]; then
        echo 2
        exit
      else
        echo 0
        exit
      fi
    fi
  done
}

_wsControls() {
  if [ "$ANS" = "Open WineSteam" ]; then
    echo "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" $WINESTEAM_STEAM_OPTIONS" > "$WINESTEAM_IPC_PATH"
    wsNotify "Opening WineSteam..."
  elif [ "$ANS" = "Launch NEOTOKYO°" ]; then
    echo "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" $WINESTEAM_STEAM_OPTIONS -silent -applaunch 244630" > "$WINESTEAM_IPC_PATH"
    wsNotify "Launching NEOTOKYO°..."
  elif [ "$ANS" = "Install/update GMod9" ]; then
    mkdir -p "$WINEPREFIX/drive_c/Program Files (x86)/Steam/steamapps/sourcemods"
    cd "$WINEPREFIX/drive_c/Program Files (x86)/Steam/steamapps/sourcemods"
    rm -rf gmod9
    wsInstallP7zipFull
    export WS_PROGRESS_TEXT="Downloading GMod9..."
    wsGUIProgress curl -o gmod9.7z -L https://gmod9.com/files/gmod9.7z -A "Mozilla/5.0 (compatible;  MSIE 7.01; Windows NT 5.0)"
    7zz x gmod9.7z -y
    rm gmod9.7z
    if [ -d "$PWD/gmod9" ]; then
      wsInfo "GMod9 installed! Please restart WineSteam to find it in your Steam library."
    else
      wsInfo "Failed to download GMod9."
    fi
  elif [ "$ANS" = "Update WineSteam" ]; then
    wsNotify "Updating WineSteam..."
    "$WINESTEAM_BIN"/update.sh
    wsInfo "WineSteam updated, restart it for changes to take effect."
  elif [ "$ANS" = "Exit WineSteam" ]; then
    if [ "x$WINESTEAM_INSTALL_MODE" = "xflatpak" ]; then
      flatpak kill io.github.gleammerray.WineSteam
      wsNotify "Stopping WineSteam... 【=˶◡˳ ◡˶✿=】ᶻ 𝗓 𐰁"
      return 1
    fi
    echo "user_interrupt" > "$WINESTEAM_IPC_PATH"
    wsNotify "Stopping WineSteam... 【=˶◡˳ ◡˶✿=】ᶻ 𝗓 𐰁"
    return 1
  else
    return 1
  fi
}

wsControls() {
  WS_CONTROLS_MSG="WineSteam is now starting up! Feel free to close this window.\n\nHere you can control your running WineSteam instance."
  while true; do
    if [ "x$FLATPAK_ID" = "xio.github.gleammerray.WineSteam" ]; then
      sleep 100
    elif [ "$INPUT_BACKEND" = "zenity" ]; then
      export ANS="`zenity --window-icon "$WINESTEAM_BIN/winesteam.png" --list --radiolist --height 300 --width 500 --title "WineSteam controls" --text "$WS_CONTROLS_MSG" --column "" --column "Options" TRUE "Open WineSteam" FALSE "Launch NEOTOKYO°" FALSE "Install/update GMod9" FALSE "Update WineSteam" FALSE "Exit WineSteam"`"
      _wsControls
      if [ "x$?" = "x1" ]; then
        return 0
      fi
    elif [ "$INPUT_BACKEND" = "kdialog" ]; then
      export ANS="`kdialog --geometry=500x250 --icon "$WINESTEAM_BIN/winesteam.png" --title "WineSteam controls" --cancel-label "Exit" --radiolist "$WS_CONTROLS_MSG" "Open WineSteam" "Open WineSteam" on "Launch NEOTOKYO°" "Launch NEOTOKYO°" off "Update WineSteam" "Update WineSteam" off "Install/update GMod9" "Install/update GMod9" off "Exit WineSteam" "Exit WineSteam" off`"
      _wsControls
      if [ "x$?" = "x1" ]; then
        return 0
      fi
    fi
  done
}

if ! command -v "unshare" &> /dev/null
then
    wsInfo "F: Package \"util-linux\" package is not installed."
    exit 1
fi

eval "`bash read_config.sh`"

if [ "x$1" != "x" ]; then
  if [ "$1" = "data" ]; then
    echo "$WINESTEAM_DATA"
    exit
  fi
  if [ "$1" = "uninstall" ]; then
    ./uninstall.sh
    exit
  elif [ "$1" = "update" ]; then
    ./update.sh
    exit
  else
    wsNotify "WineSteam: Unknown command: $1"
    exit
  fi
fi

if [ ! -d "$WINESTEAM_DATA" ]; then mkdir -p "$WINESTEAM_DATA"; fi
if [ -d "$PWD/prefix" ]; then mv "$PWD/prefix" "$WINESTEAM_DATA"; fi
if [ -d "$PWD/packages" ]; then mv "$PWD/packages" "$WINESTEAM_DATA"; fi
if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
  if [ "x$WINESTEAM_INSTALL_MODE" = "xflatpak" ]; then
    WS_RUNNER_PID=`flatpak ps --columns=pid,application | grep io.github.gleammerray.WineSteam  | awk  '{print $1}'`
    export WINESTEAM_DATA="`flatpak run io.github.gleammerray.WineSteam data`"
    export WINEPREFIX="$WINESTEAM_DATA/prefix"
    WINEPREFIX_LS="`ls -A "$WINEPREFIX"`"
    export WINESTEAM_RUNNER_PID_PATH="$WINESTEAM_DATA/ws_runner_pid"
    export WINESTEAM_IPC_PATH="$WINESTEAM_DATA/winesteam_ipc.txt"
    if [ "x$WS_RUNNER_PID" != "x" ]; then
      wsControls &
      export WS_CONTROLS_PID=$!
      wsCleanup
      exit
    fi
    wsNotify "Running WineSteam flatpak."
    unshare --user --map-current-user --net --mount "$WINESTEAM_BIN/ws_flatpak_runner.sh" $1 &
    export WS_RUNNER_PID=$!
    sleep 1
    slirp4netns --configure --mtu=65520 --disable-host-loopback $WS_RUNNER_PID tap0 &
    sleep 20
    WS_RUNNER_PID=`flatpak ps --columns=pid,application | grep io.github.gleammerray.WineSteam  | awk  '{print $1}'`
    if [ "x$WINEPREFIX_LS" != "x" ]; then
      wsControls &
      export WS_CONTROLS_PID=$!
    fi
    wsCleanup
    exit
  fi
fi
if [ -d "$WINEPREFIX" ]; then
  if [ -f "$WINESTEAM_RUNNER_PID_PATH" ]; then
    export WS_RUNNER_PID=$(cat "$WINESTEAM_RUNNER_PID_PATH")
    if [ "x$WS_RUNNER_PID" = "x" ]; then
      rm "$WINESTEAM_RUNNER_PID_PATH"
    elif [ -d "/proc/$WS_RUNNER_PID" ]; then
      wsControls &
      export WS_CONTROLS_PID=$!
      wsCleanup
      exit
    else
      rm "$WINESTEAM_RUNNER_PID_PATH"
    fi
  fi
  if [ "x$FLATPAK_ID" = "xio.github.gleammerray.WineSteam" ]; then
    bash "$WINESTEAM_BIN/ws_runner.sh" "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" $WINESTEAM_STEAM_OPTIONS -silent" &
  else
    unshare --user --map-root-user --net --mount "$WINESTEAM_BIN/ws_runner.sh" "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" $WINESTEAM_STEAM_OPTIONS -silent" &
  fi
  export WS_RUNNER_PID=$!
  sleep 1
  if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
    slirp4netns --configure --mtu=65520 --disable-host-loopback $WS_RUNNER_PID tap0 &
  fi
  sleep 20
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
  if [ -f "$WINESTEAM_CFG" ]; then
    rm "$WINESTEAM_CFG"
  fi
  wsNotify 'Welcome to the WineSteam installer! The installation process takes between 5 and 10 minutes. Before the installation can begin we need to know how to set up the right prefix for you.'

  if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
    export WINESTEAM_INSTALL_MODE="`wsSetup`"
    if [ "$WINESTEAM_INSTALL_MODE" = "0" ]; then
      wsInfo "Installation cancelled."
      exit
    elif [ "$WINESTEAM_INSTALL_MODE" = "1" ]; then
      wsNotify "Installing WineSteam normally."
      if ! command -v "winetricks" &> /dev/null
      then
        wsNotify "Package \"winetricks\" is not installed."
        exit 1
      fi
    elif [ "$WINESTEAM_INSTALL_MODE" = "2" ]; then
      if ! command -v "flatpak" &> /dev/null
      then
        wsInfo "F: Package \"flatpak\" package is not installed."
        exit 1
      fi
      wsNotify "Installing WineSteam as a flatpak."

      WINESTEAM_INSTALL_DESKTOP="`wsInputYN '?: Do you wish to install WineSteam into your applications launcher? [Y/n]: '`"
      WINESTEAM_INSTALL_DESKTOP=$(echo ${WINESTEAM_INSTALL_DESKTOP:-'y'} | tr '[:upper:]' '[:lower:]')
      if [ "$WINESTEAM_INSTALL_DESKTOP" != 'n' ]; then
        export WINESTEAM_INSTALL_DESKTOP='y'
        wsNotify '?: Installing launcher icon.'
        bash "$PWD/install_desktop.sh"
        wsNotify '?: Launcher icon installed. You may need to reboot for it to show up.'
      else
        export WINESTEAM_INSTALL_DESKTOP='n'
        wsNotify '?: Skipping launcher icon installation.'
      fi

      if [ ! -d "$WINESTEAM_PKGS" ]; then
        mkdir -p "$WINESTEAM_PKGS/bin"
      fi
      cd "$WINESTEAM_PKGS"
      rm "$PWD/WineSteam.flatpak"
      wsNotify '[1/2] [0/2] Downloading packages. [⟱]'
      wsNotify '[1/2] [1/2] Downloading WineSteam flatpak... [⟱]]'
      echo '=========================================================='
      curl -o WineSteam.flatpak.gz -L https://github.com/GleammerRay/WineSteam/releases/download/$WINESTEAM_VERSION/DO-NOT-INSTALL-WineSteam.flatpak.gz
      gzip -d WineSteam.flatpak.gz
      if [ ! -f ./WineSteam.flatpak ]; then
          wsInfo 'F: Download failed.'
          exit 1
      fi
      echo '=========================================================='
      if ! command -v "slirp4netns" &> /dev/null ; then
        wsNotify '[1/2] [2/2] Downloading slirp4netns... [⟱]]'
        echo '=========================================================='
        curl -o slirp4netns -L https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.3/slirp4netns-$(uname -m)
        chmod +x slirp4netns
        if [ ! -f ./slirp4netns ]; then
          wsInfo 'F: Download failed.'
          exit 1
        fi
        mv slirp4netns ./bin/
        echo '=========================================================='
      fi
      wsNotify '[2/2] Installing Winesteam flatpak... '
      flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      flatpak uninstall --user -y io.github.gleammerray.WineSteam
      flatpak install --user -y org.freedesktop.Platform/x86_64/23.08 \
          org.freedesktop.Platform.GL32.default/x86_64/23.08 \
          org.freedesktop.Platform.VAAPI.Intel/x86_64/23.08 \
          org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/23.08 \
          org.freedesktop.Platform.ffmpeg-full/x86_64/23.08 \
          org.freedesktop.Platform.ffmpeg_full.i386/x86_64/23.08 \
          org.winehq.Wine.gecko/x86_64/stable-23.08 \
          org.winehq.Wine.mono/x86_64/stable-23.08 \
          org.winehq.Wine.DLLs.dxvk/x86_64/stable-23.08 \
          org.freedesktop.Platform.Compat.i386/x86_64/23.08
      flatpak install --user -y ./WineSteam.flatpak
      rm WineSteam.flatpak
      echo "WINESTEAM_INSTALL_MODE=\"flatpak\"" >> "$WINESTEAM_CFG"
      unshare --user --map-current-user --net --mount "$WINESTEAM_BIN/ws_flatpak_runner.sh" &
      export WS_RUNNER_PID=$!
      sleep 1
      ./bin/slirp4netns --configure --mtu=65520 --disable-host-loopback $WS_RUNNER_PID tap0 &
      wsCleanup
      exit
    fi
  fi

  if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
    WINESTEAM_INSTALL_YN="`wsInputYN "?:[0/2]: Do you wish to modify default WineSteam install path? (~/.winesteam) [y/N]: "`"
    WINESTEAM_INSTALL_YN=$(echo ${WINESTEAM_INSTALL_YN:-'n'} | tr '[:upper:]' '[:lower:]')
    if [ "$WINESTEAM_INSTALL_YN" != 'n' ]; then
      export WINESTEAM_INSTALL_PATH="`wsInputDir`/WineSteam"
      if [ "x$WINESTEAM_INSTALL_PATH" = "x" ]; then
        wsInfo "Installation cancelled."
        exit
      else
        mkdir -p "$WINESTEAM_INSTALL_PATH"
        if [ "`ls -A "$WINESTEAM_INSTALL_PATH"`" ]; then
          wsInfo "F: Installation path is not empty: $WINESTEAM_INSTALL_PATH"
          exit 1
        fi
        if [ ! -d "$WINESTEAM_INSTALL_PATH" ]; then
          wsInfo "F: Bad installation path: $WINESTEAM_INSTALL_PATH"
          exit 1
        fi
        echo "WINESTEAM_DATA=\"$WINESTEAM_INSTALL_PATH\"" >> "$WINESTEAM_CFG"
      fi
    fi
    cd "`dirname "$0"`"
    eval "`bash read_config.sh`"
  fi
  wsNotify "?:[0/2]: Installing to \"$WINESTEAM_DATA\""

  WINESTEAM_INSTALL_DXVK="`wsInputYN "?:[1/2]: DXVK greatly improves performance in all Wine applications. Some hardware/Wine versions/applications don't work well with DXVK. Install DXVK? [Y/n]: "`"
  WINESTEAM_INSTALL_DXVK=$(echo ${WINESTEAM_INSTALL_DXVK:-'y'} | tr '[:upper:]' '[:lower:]')
  if [ "$WINESTEAM_INSTALL_DXVK" != 'n' ]; then
    export WINESTEAM_INSTALL_DXVK='y'
    wsNotify '?:[1/2]: DXVK will be installed.'
  else
    export WINESTEAM_INSTALL_DXVK='n'
    wsNotify '?:[1/2]: Skipping DXVK installation.'
  fi
  
  if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
    WINESTEAM_INSTALL_DESKTOP="`wsInputYN '?:[2/2]: Do you wish to install WineSteam into your applications launcher? [Y/n]: '`"
    WINESTEAM_INSTALL_DESKTOP=$(echo ${WINESTEAM_INSTALL_DESKTOP:-'y'} | tr '[:upper:]' '[:lower:]')
    if [ "$WINESTEAM_INSTALL_DESKTOP" != 'n' ]; then
      export WINESTEAM_INSTALL_DESKTOP='y'
      wsNotify '?:[2/2]: Installing launcher icon.'
      bash "$PWD/install_desktop.sh"
      wsNotify '?:[2/2]: Launcher icon installed. You may need to reboot for it to show up.'
    else
      export WINESTEAM_INSTALL_DESKTOP='n'
      wsNotify '?:[2/2]: Skipping launcher icon installation.'
    fi
  fi
fi

wsNotify '[0/5] Performing first time setup. [!]'
wsNotify '[1/5] [0/4] Downloading packages. [⟱]'
if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
if [ ! -d "$WINESTEAM_PKGS/bin" ]; then mkdir -p "$WINESTEAM_PKGS/bin"; fi
cd "$WINESTEAM_PKGS"
if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
  if [ ! -d ./lutris-GE-Proton8-26-x86_64 ]; then
    wsNotify '[1/5] [1/4] Downloading Wine GE... [⟱]]'
    echo '=========================================================='
    curl -o wine-lutris-GE-Proton8-26-x86_64.tar.xz -L https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz
    tar -xvJf wine-lutris-GE-Proton8-26-x86_64.tar.xz
    if [ ! -d ./lutris-GE-Proton8-26-x86_64 ]; then
      wsInfo 'F: Download failed.'
      exit 1
    fi
    rm wine-lutris-GE-Proton8-26-x86_64.tar.xz
    echo '=========================================================='
  fi
fi
if [ ! -f ./SteamSetup.exe ]; then
  wsNotify '[1/5] [3/4] Downloading Steam setup... [⟱]]'
  echo '=========================================================='
  curl -o SteamSetup.exe -L https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
  if [ ! -f ./SteamSetup.exe ]; then
    wsInfo 'F: Download failed.'
    exit 1
  fi
  echo '=========================================================='
fi
if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
  if ! command -v "slirp4netns" &> /dev/null ; then
    wsNotify '[1/5] [4/4] Downloading slirp4netns... [⟱]]'
    echo '=========================================================='
    curl -o slirp4netns -L https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.3/slirp4netns-$(uname -m)
    chmod +x slirp4netns
    if [ ! -f ./slirp4netns ]; then
      wsInfo 'F: Download failed.'
      exit 1
    fi
    mv slirp4netns ./bin/
    echo '=========================================================='
  fi
fi
wsNotify '[2/5] Creating a Wine prefix... [⌂]'
mkdir -p "$WINEPREFIX";
wine wineboot
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
  wsNotify '[4/5]: Wininet installed.'
fi
wsNotify '[4/5] Installing fonts... [Æ]'
echo '=========================================================='
winetricks courier tahoma verdana trebuchet lucida
echo '=========================================================='
wsNotify 'Almost there! 【=˶◕‿↼˶✿=】'
wsNotify '[5/5] Running Steam setup... [🮲🮳]'
wine "$WINESTEAM_PKGS/SteamSetup.exe" /S
wsNotify 'All done! 【=◕∇◕✿=】'
wsNotify 'Starting WineSteam...'
if [ "x$FLATPAK_ID" = "xio.github.gleammerray.WineSteam" ]; then
  bash "$WINESTEAM_BIN/ws_runner.sh" "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" $WINESTEAM_STEAM_OPTIONS -silent" &
else
  unshare --user --map-root-user --net --mount "$WINESTEAM_BIN/ws_runner.sh" "wine \"$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe\" $WINESTEAM_STEAM_OPTIONS -silent" &
fi
export WS_RUNNER_PID=$!
sleep 1
if [ "x$FLATPAK_ID" != "xio.github.gleammerray.WineSteam" ]; then
  slirp4netns --configure --mtu=65520 --disable-host-loopback $WS_RUNNER_PID tap0 &
fi
wsControls &
export WS_CONTROLS_PID=$!
wsCleanup
