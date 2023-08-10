#! /bin/bash
cd `dirname $0`
export WINEARCH=win64
export WINESTEAM_BIN="$PWD"
export WINESTEAM_DATA="$HOME/.winesteam"
export WINESTEAM_PKGS="$WINESTEAM_DATA/packages"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export WINE_LARGE_ADDRESS_AWARE=1
export WINEDLLOVERRIDES="dxgi,d3d11=b"
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
if [ ! -d "$WINESTEM_DATA" ]; then mkdir -p "$WINESTEAM_DATA"; fi
if [ -d "$PWD/prefix" ]; then mv "$PWD/prefix" "$WINESTEAM_DATA"; fi
if [ -d "$PWD/packages" ]; then mv "$PWD/packages" "$WINESTEAM_DATA"; fi
if [ -d "$WINEPREFIX" ]; then
  WINESTEAM_USE_NETSPACE=$(cat "$WINESTEAM_DATA/winesteam.cfg" | grep 'WINESTEAM_USE_NETSPACE=' | sed 's/WINESTEAM_USE_NETSPACE=//g')
  IN="$WINESTEAM_USE_NETSPACE"
  arrIN=(${IN//\n/ })
  export WINESTEAM_USE_NETSPACE=${arrIN[0]}
  if [ "x$WINESTEAM_USE_NETSPACE" = "xtrue" ]; then
    bash "$PWD/winesteam_netspace.sh"
    exit
  fi
  wine "$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe"
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

  read -p "?:[1/3]: DXVK greatly improves performance in all wine applications. Some hardware/applications don't work well with DXVK. Not recommended for NEOTOKYO° players (for now). Install DXVK? [y/N]: " WINESTEAM_INSTALL_DXVK
WINESTEAM_INSTALL_DXVK=$(echo ${WINESTEAM_INSTALL_DXVK:-'n'} | tr '[:upper:]' '[:lower:]')
  if [ $WINESTEAM_INSTALL_DXVK != 'y' ]; then
    export WINESTEAM_INSTALL_DXVK='n'
    echo '?:[1/3]: Skipping DXVK installation.'
  else
    export WINESTEAM_INSTALL_DXVK='y'
    echo '?:[1/3]: DXVK will be installed.'
  fi
  
  read -p '?:[2/3]: Do you wish to install WineSteam into your applications launcher? [Y/n]:' WINESTEAM_INSTALL_DESKTOP

  WINESTEAM_INSTALL_DESKTOP=$(echo ${WINESTEAM_INSTALL_DESKTOP:-'y'} | tr '[:upper:]' '[:lower:]')
  if [ $WINESTEAM_INSTALL_DESKTOP != 'n' ]; then
    export WINESTEAM_INSTALL_DESKTOP='y'
    echo '?:[2/3]: Installing launcher icon.'
    bash "$PWD/install_desktop.sh"
    echo '?:[2/3]: Launcher icon installed. You may need to reboot for it to show up.'
  else
    export WINESTEAM_INSTALL_DESKTOP='n'
    echo '?:[2/3]: Skipping launcher icon installation.'
  fi

  read -p "?:[3/3]: Using network namespaces is recommended with WineSteam, but it requires a one-time \`sudo\` authentication for the setup that completes when it runs for the first time. Without using network namespaces, WineSteam will interfere with your native Steam installation and cause it to go offline. Enable WineSteam network namespace? [y/N]:" WINESTEAM_INSTALL_NETSPACE

  WINESTEAM_INSTALL_NETSPACE=$(echo ${WINESTEAM_INSTALL_NETSPACE:-'n'} | tr '[:upper:]' '[:lower:]')
  if [ $WINESTEAM_INSTALL_NETSPACE != 'y' ]; then
    export WINESTEAM_INSTALL_NETSPACE='n'
    echo '?:[3/3]: Skipping WineSteam network namespace installation.'
  else
    export WINESTEAM_INSTALL_NETSPACE='y'
    echo '?:[3/3]: Setting up WineSteam network namespace, you will be queried for your system user password in a moment.'
    echo 'WINESTEAM_USE_NETSPACE=true' >> "$WINESTEAM_DATA/winesteam.cfg"
    bash winesteam_netspace.sh
    exit
  fi
fi

echo '[0/4] Performing first time setup. [!]'
echo '[1/4] Creating a wine prefix... [⌂]'
echo "Note: a window will open, please press \`Ok\` if you don't know what to change."
mkdir -p "$WINEPREFIX";
winecfg
winetricks win10
if [ "$WINESTEAM_INSTALL_DXVK" = "y" ]; then
  echo '[1/4] Installing DXVK... [⌂]'
  echo '=========================================================='
  bash dxvkpatch.sh
  echo '=========================================================='
fi
echo '[2/4] Installing allfonts... [Æ]'
winetricks allfonts
echo '[3/4] [0/1] Downloading packages. [⟱]'
if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
cd "$WINESTEAM_PKGS"
if [ ! -f ./SteamSetup.exe ]; then
  echo '[3/4] [1/1] Downloading Steam setup... [⟱]'
  wget https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
fi
echo 'Almost there! 【=˶◕‿↼˶✿=】'
echo '[4/4] Running Steam setup... [🮲🮳]'
wine "$WINESTEAM_PKGS/SteamSetup.exe"
