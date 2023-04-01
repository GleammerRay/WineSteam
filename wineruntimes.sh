 #! /bin/bash
export WINEARCH=win64
export WINESTEAM_DATA="$HOME/.winesteam"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export WINE_LARGE_ADDRESS_AWARE=1
if [ ! -d "$WINEPREFIX" ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteam.sh" to set up your prefix first.'
  exit
fi

echo '[1/1] Downloading and installing C++ runtime patch. You might be prompted to go through several installations, just click through them. [⟱]'
winetricks -q vcrun2003
winetricks -q vcrun2005
winetricks -q vcrun2008
winetricks -q vcrun2010
winetricks -q vcrun2012
#installing 2015 and 2013 version just in case
winetricks -q vcrun2013
winetricks -q vcrun2015
echo 'Done.'