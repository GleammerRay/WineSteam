#! /bin/bash
cd `dirname $0`
export WINEARCH=win64
export WINE_LARGE_ADDRESS_AWARE=1
export WINESTEAM_BIN="$PWD"
export WINESTEAM_DATA="$HOME/.winesteam"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export NEOTOKYO_EXE="$WINEPREFIX/drive_c/Program Files (x86)/Steam/steamapps/common/NEOTOKYO/hl2.exe"
if [ ! -d "$WINEPREFIX" ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteam.sh" to set up your prefix first.'
  exit
fi
if [ ! -f "$NEOTOKYO_EXE" ]; then
  echo 'F:NEOTOKYO° is not installed.'
  echo 'You need to install NEOTOKYO° before you can patch it.'
  exit
fi
bash "$WINESTEAM_BIN/4gbpatch.sh" "$NEOTOKYO_EXE"
