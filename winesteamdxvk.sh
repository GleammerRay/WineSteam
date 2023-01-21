#! /bin/bash
export WINEARCH=win64
export WINEPREFIX=$PWD/prefix
export WINE_LARGE_ADDRESS_AWARE=1
if [ -d ./prefix ]; then
  wine "prefix/drive_c/Program Files (x86)/Steam/steam.exe"
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
echo "-------> [ Wine Steam DXVK installer ] <-------"
echo '[0/5] Performing first time setup. [!]'
echo '[1/5] Creating a wine prefix... [⌂]'
mkdir ./prefix;
winecfg
echo '[2/5] Installing allfonts... [Æ]'
winetricks allfonts
echo '[3/5] [0/1] Downloading packages. [⟱]'
if [ ! -d ./packages ]; then mkdir ./packages; fi
cd packages
if [ ! -f ./SteamSetup.exe ]; then
  echo '[3/5] [1/1] Downloading Steam setup... [⟱]'
  wget https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe
fi
cd ..
echo 'Almost there! 【=˶◕‿↼˶✿=】'
read -p '?:Apply DXVK patch? [Y/n]: ' APPLY_DXVK_PATCH
APPLY_DXVK_PATCH=$(echo ${APPLY_DXVK_PATCH:-'y'} | tr '[:upper:]' '[:lower:]')
if [ ! $APPLY_DXVK_PATCH = 'n' ]; then
  echo '[4/5]'
  echo
  bash dxvkpatch.sh
  echo
fi
echo '[5/5] Running Steam setup... [🮲🮳]'
wine packages/SteamSetup.exe
