#! /bin/bash
export WINEARCH=win64
export WINE_LARGE_ADDRESS_AWARE=1
export WINEPREFIX=$PWD/prefix
export NEOTOKYO_EXE="prefix/drive_c/Program Files (x86)/Steam/steamapps/common/NEOTOKYO/hl2.exe"
if [ ! -d prefix ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteamdxvk.sh" to set up your prefix first.'
  exit
fi
if [ ! -f "$NEOTOKYO_EXE" ]; then
  echo 'F:NEOTOKYO° is not installed.'
  echo 'You need to install NEOTOKYO° before you can patch it.'
  exit
fi
bash 4gbpatch.sh "$NEOTOKYO_EXE"
