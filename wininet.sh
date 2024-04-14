#! /bin/bash
export WINEARCH=win64
export WINESTEAM_DATA="$HOME/.winesteam"
export WINESTEAM_PKGS="$WINESTEAM_DATA/packages"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export WINE_LARGE_ADDRESS_AWARE=1
if [ ! -d "$WINEPREFIX" ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteam.sh" to set up your prefix first.'
  exit
fi
winetricks wininet
