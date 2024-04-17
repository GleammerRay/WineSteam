#! /bin/bash
cd "`dirname "$0"`"

export WINESTEAM_HOME=""
if [ "x$XDG_DATA_HOME" = "x" ]; then
  export WINESTEAM_HOME=$HOME
else
  export WINESTEAM_HOME=$XDG_DATA_HOME
fi
export WINESTEAM_DATA="$WINESTEAM_HOME/.winesteam"
export WINESTEAM_CFG="$WINESTEAM_DATA/winesteam.cfg"

if [ -d "$WINESTEAM_DATA" ]; then
  export WINESTEAM_DATA=$(cat "$WINESTEAM_DATA/winesteam.cfg" | grep 'WINESTEAM_DATA=')
  if [ "x$WINESTEAM_DATA" != "x" ]; then
    eval "export $WINESTEAM_DATA"
  fi
fi
if [ "x$WINESTEAM_DATA" = "x" ]; then
  export WINESTEAM_DATA="$WINESTEAM_HOME/.winesteam"
fi

export WINESTEAM_PKGS="$WINESTEAM_DATA/packages"
echo "export WINEARCH=win64"
echo "export WINESTEAM_CFG=\"$WINESTEAM_CFG\""
echo "export WINESTEAM_BIN=\"$PWD\""
echo "export WINESTEAM_DATA=\"$WINESTEAM_DATA\""
echo "export WINESTEAM_TMP=\"$WINESTEAM_DATA/tmp\""
echo "export WINESTEAM_PKGS=\"$WINESTEAM_DATA/packages\""
echo "export WINEPREFIX=\"$WINESTEAM_DATA/prefix\""
echo "export WINE_LARGE_ADDRESS_AWARE=1"
echo "export FREETYPE_PROPERTIES=\"truetype:interpreter-version=35\""
echo "export PATH=\"$WINESTEAM_PKGS/bin:$WINESTEAM_PKGS/lutris-GE-Proton8-26-x86_64/bin:$PATH\""
echo "export WINESTEAM_RUNNER_PID_PATH=\"$WINESTEAM_DATA/ws_runner_pid\""
echo "export WINESTEAM_IPC_PATH=\"$WINESTEAM_DATA/winesteam_ipc.txt\""
