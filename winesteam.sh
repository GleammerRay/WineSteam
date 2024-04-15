#! /bin/bash

user_interrupt() {
  exit
}

trap user_interrupt SIGINT
trap user_interrupt SIGTSTP

export NOTIFY_BACKEND=""

notify() {
  echo "$@"
  if [ "$NOTIFY_BACKEND" = "notify-send" ]; then
    notify-send "WineSteam" "$@"
    exit
  fi
  if [ "$NOTIFY_BACKEND" = "zenity" ]; then
    zenity --info --timeout=1 --title "WineSteam" --text="$@"
    exit
  fi
}

if command -v "zenity" &> /dev/null
then
  export NOTIFY_BACKEND="zenity"
fi
if command -v "notify-send" &> /dev/null
then
  export NOTIFY_BACKEND="notify-send"
fi

if ! command -v "winetricks" &> /dev/null
then
    notify "Package \`winetricks\` is not installed."
    exit 1
fi
if ! command -v "unshare" &> /dev/null
then
    notify "Package \`util-linux\` package is not installed."
    exit 1
fi

cd `dirname "$0"`
export WINEARCH=win64
export WINESTEAM_BIN="$PWD"
export WINESTEAM_DATA="$HOME/.winesteam"
export WINESTEAM_PKGS="$WINESTEAM_DATA/packages"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export WINE_LARGE_ADDRESS_AWARE=1
export WINEDLLOVERRIDES="dxgi,d3d11=b"
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
export PATH="$WINESTEAM_PKGS/lutris-GE-Proton8-26-x86_64/bin:$PATH"
if [ ! -d "$WINESTEM_DATA" ]; then mkdir -p "$WINESTEAM_DATA"; fi
if [ -d "$PWD/prefix" ]; then mv "$PWD/prefix" "$WINESTEAM_DATA"; fi
if [ -d "$PWD/packages" ]; then mv "$PWD/packages" "$WINESTEAM_DATA"; fi
if [ -d "$WINEPREFIX" ]; then
  unshare wine "$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe"
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

  read -p "?:[1/3]: DXVK greatly improves performance in all Wine applications. Some hardware/Wine versions/applications don't work well with DXVK. Install DXVK? [Y/n]: " WINESTEAM_INSTALL_DXVK
WINESTEAM_INSTALL_DXVK=$(echo ${WINESTEAM_INSTALL_DXVK:-'y'} | tr '[:upper:]' '[:lower:]')
  if [ "$WINESTEAM_INSTALL_DXVK" != 'n' ]; then
    export WINESTEAM_INSTALL_DXVK='y'
    echo '?:[1/3]: DXVK will be installed.'
  else
    export WINESTEAM_INSTALL_DXVK='n'
    echo '?:[1/3]: Skipping DXVK installation.'
  fi
  
  read -p '?:[2/3]: Do you wish to install WineSteam into your applications launcher? [Y/n]:' WINESTEAM_INSTALL_DESKTOP

  WINESTEAM_INSTALL_DESKTOP=$(echo ${WINESTEAM_INSTALL_DESKTOP:-'y'} | tr '[:upper:]' '[:lower:]')
  if [ "$WINESTEAM_INSTALL_DESKTOP" != 'n' ]; then
    export WINESTEAM_INSTALL_DESKTOP='y'
    echo '?:[2/3]: Installing launcher icon.'
    bash "$PWD/install_desktop.sh"
    echo '?:[2/3]: Launcher icon installed. You may need to reboot for it to show up.'
  else
    export WINESTEAM_INSTALL_DESKTOP='n'
    echo '?:[2/3]: Skipping launcher icon installation.'
  fi

  read -p '?:[3/3]: By default, FastDL may not work properly in some games when ran via Wine. Installing official `wininet.dll` may fix FastDL, but downloading the archive in which it resides can take a long time. It is recommended to skip this step for now and run `bash wininet.sh` in the WineSteam directory later if you need it, after checking how well your game works. Install Wininet now? [y/N]:' WINESTEAM_WININET

  WINESTEAM_WININET=$(echo ${WINESTEAM_WININET:-'n'} | tr '[:upper:]' '[:lower:]')
  if [ "$WINESTEAM_WININET" != 'y' ]; then
    export WINESTEAM_WININET='n'
    echo '?:[3/3]: Skipping Wininet installation.'
  else
    export WINESTEAM_WININET='y'
    echo '?:[3/3]: Wininet will be installed.'
  fi

fi

notify '[0/5] Performing first time setup. [!]'
notify '[1/5] [0/2] Downloading packages. [⟱]'
if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
cd "$WINESTEAM_PKGS"
if [ ! -d ./lutris-GE-Proton8-26-x86_64 ]; then
  notify '[1/5] [1/2] Downloading Wine GE... [⟱]]'
  echo '=========================================================='
  wget https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz
  tar -xvJf wine-lutris-GE-Proton8-26-x86_64.tar.xz
  if [ ! -d ./lutris-GE-Proton8-26-x86_64 ]; then
    notify 'F: Download failed.'
    exit 1
  fi
  rm wine-lutris-GE-Proton8-26-x86_64.tar.xz
  echo '=========================================================='
fi
if [ ! -f ./SteamSetup.exe ]; then
  notify '[1/5] [2/2] Downloading Steam setup... [⟱]]'
  echo '=========================================================='
  wget https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
  if [ ! -f ./SteamSetup.exe ]; then
    notify 'F: Download failed.'
    exit 1
  fi
  echo '=========================================================='
fi
notify '[2/5] Creating a Wine prefix... [⌂]'
notify "Note: a window will open, please press \`Ok\` if you don't know what to change."
mkdir -p "$WINEPREFIX";
winecfg
winetricks win10
if [ "$WINESTEAM_INSTALL_DXVK" = "y" ]; then
  notify '[3/5] Installing DXVK... [⌂]'
  echo '=========================================================='
  bash "$WINESTEAM_BIN/dxvkpatch.sh"
  echo '=========================================================='
else
  notify '[3/5]: Skipping DXVK installation.'
fi

if [ "$WINESTEAM_WININET" != 'y' ]; then
  notify '[4/5]: Skipping Wininet installation.'
else
  notify '[4/5]: Installing Wininet.'
  echo '=========================================================='
  winetricks wininet
  echo '=========================================================='
  echo '[4/5]: Wininet installed.'
fi
notify '[4/5] Installing allfonts... [Æ]'
echo '=========================================================='
winetricks allfonts
echo '=========================================================='
notify 'Almost there! 【=˶◕‿↼˶✿=】'
notify '[5/5] Running Steam setup... [🮲🮳]'
unshare wine "$WINESTEAM_PKGS/SteamSetup.exe"
