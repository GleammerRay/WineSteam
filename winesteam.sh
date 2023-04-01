#! /bin/bash
cd `dirname $0`
export WINEARCH=win64
export WINESTEAM_BIN="$PWD"
export WINESTEAM_DATA="$HOME/.winesteam"
export WINESTEAM_PKGS="$WINESTEAM_DATA/packages"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export WINE_LARGE_ADDRESS_AWARE=1
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
if [ ! -d "$WINESTEM_DATA" ]; then mkdir -p "$WINESTEAM_DATA"; fi
if [ -d "$PWD/prefix" ]; then mv "$PWD/prefix" "$WINESTEAM_DATA"; fi
if [ -d "$PWD/packages" ]; then mv "$PWD/packages" "$WINESTEAM_DATA"; fi
if [ -d "$WINEPREFIX" ]; then
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
echo "----------> [ Wine Steam installer ] <----------"
echo '[0/5] Performing first time setup. [!]'
echo '[1/5] Creating a wine prefix... [⌂]'
mkdir -p "$WINEPREFIX";
winecfg
echo '[2/5] Installing Visual C++ runtimes... [⚙]'
bash vcruntimes.sh
echo '[3/5] Installing allfonts... [Æ]'
winetricks allfonts
echo 'Almost there! 【=˶◕‿↼˶✿=】'
echo '[4/5] [0/1] Downloading packages. [⟱]'
if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
cd "$WINESTEAM_PKGS"
if [ ! -f ./SteamSetup.exe ]; then
  echo '[4/5] [1/1] Downloading Steam setup... [⟱]'
  wget https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
fi
echo 'Almost there! 【=˶◕‿↼˶✿=】'
echo '[5/5] Running Steam setup... [🮲🮳]'
wine "$WINESTEAM_PKGS/SteamSetup.exe"
