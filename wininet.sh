#! /bin/bash
cd "`dirname "$0"`"
eval "`bash read_config.sh`"
if [ ! -d "$WINEPREFIX" ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteam.sh" to set up your prefix first.'
  exit
fi
winetricks wininet
