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
echo '[0/2] Applying DXVK patch.'
echo '[1/2] [0/1] Downloading packages. [⟱]'
if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
cd "$WINESTEAM_PKGS"
if [ ! -d ./proton-7.0-6e ]; then
  echo '[1/2] [1/1] Downloading DXVK... [⟱]'
  wget https://github.com/ValveSoftware/Proton/archive/refs/tags/proton-7.0-6e.tar.gz
  tar -xvzf proton-7.0-6e.tar.gz
  rm proton-7.0-6e.tar.gz
fi
echo '[2/2] Running DXVK patch... [◌𝨙]'
bash ./dxvk-2.0/setup_dxvk.sh install
echo 'Done.'
