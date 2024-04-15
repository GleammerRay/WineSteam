#! /bin/bash
cd `dirname "$0"`
eval "`bash read_config.sh`"

if [ ! -d "$WINEPREFIX" ]; then
  echo 'F:Wineprefix not found.'
  echo 'Run "bash winesteam.sh" to set up your prefix first.'
  exit
fi
echo '[0/2] Applying DXVK patch.'
echo '[1/2] [0/1] Downloading packages. [⟱]'
if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
cd "$WINESTEAM_PKGS"
if [ ! -d ./dxvk-2.3.1 ]; then
  echo '[1/2] [1/1] Downloading DXVK... [⟱]'
  wget https://github.com/doitsujin/dxvk/releases/download/v2.3.1/dxvk-2.3.1.tar.gz
  tar -xvzf dxvk-2.3.1.tar.gz
  if [ ! -d ./dxvk-2.3.1 ]; then
    echo 'F: Download failed.'
    exit 1
  fi
  rm dxvk-2.3.1.tar.gz
fi
echo '[2/2] Installing DXVK patch... [◌𝨙]'
cp ./dxvk-2.3.1/x64/*.dll "$WINEPREFIX/drive_c/windows/system32"
cp ./dxvk-2.3.1/x32/*.dll "$WINEPREFIX/drive_c/windows/syswow64"
winecfg
echo 'Done.'
