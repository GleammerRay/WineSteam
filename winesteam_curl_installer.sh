#! /bin/bash
source <(curl -L https://github.com/GleammerRay/WineSteam/blob/main/ws_gui.sh?raw=true)
mkdir -p "$HOME/.winesteam"
if [ -f "$HOME/.winesteam/install_path.txt" ]; then
  export INSTALL_PATH=$(cat "$HOME/.winesteam/install_path.txt")
  if [ -f "$INSTALL_PATH/winesteam" ]; then
    "$INSTALL_PATH/winesteam"
    exit
  fi
  rm "$HOME/.winesteam/install_path.txt"
fi
#wsInfo "Please select an installation directory."
#WS_INSTALL_DIR=`wsInputDir`
WS_INSTALL_DIR="$HOME/.winesteam"
mkdir $WS_INSTALL_DIR
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
echo "$PWD" > "$HOME/.winesteam/install_path.txt"
./winesteam
