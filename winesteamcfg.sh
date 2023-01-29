export WINESTEAM_DATA="$HOME/.winesteam"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
if [ ! -d "$WINEPREFIX" ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteam.sh" to set up your prefix first.'
  exit
fi
winecfg
