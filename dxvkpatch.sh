#! /bin/bash
export WINEARCH=win64
export WINEPREFIX=$HOME/.winesteamdxvk/prefix
export WINE_LARGE_ADDRESS_AWARE=1
if [ ! -d prefix ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteamdxvk.sh" to set up your prefix first.'
  exit
fi
echo '[0/2] Applying DXVK patch.'
echo '[1/2] [0/1] Downloading packages. [⟱]'
if [ ! -d ./packages ]; then mkdir ./packages; fi
cd packages
if [ ! -d ./dxvk-2.0 ]; then
  echo '[1/2] [1/1] Downloading DXVK... [⟱]'
  wget https://github.com/doitsujin/dxvk/releases/download/v2.0/dxvk-2.0.tar.gz
  tar -xvzf dxvk-2.0.tar.gz
  rm dxvk-2.0.tar.gz
fi
echo '[2/2] Running DXVK patch... [◌𝨙]'
bash packages/dxvk-2.0/setup_dxvk.sh
echo 'Done.'
