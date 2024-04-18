#! /bin/bash
source <(curl -L https://github.com/GleammerRay/WineSteam/blob/main/ws_gui.sh?raw=true)

wsInfo "Please select an installation directory."
WS_INSTALL_DIR=`wsInputDir`
if [ ! -d "$WS_INSTALL_DIR" ]; then
  wsInfo "F: Directory does not exist: $WS_INSTALL_DIR"
  exit 1
fi
cd "$WS_INSTALL_DIR"
git clone --depth=1 https://github.com/GleammerRay/WineSteam
if [ ! -d "$PWD/WineSteam" ]; then
  wsInfo 'F: Download failed.'
  exit 1
fi
cd WineSteam
./winesteam
