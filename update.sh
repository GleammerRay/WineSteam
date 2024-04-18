#! /bin/bash
cd "`dirname "$0"`"
source "./ws_gui.sh"
eval "`bash read_config.sh`"
if [ "x$1" = "xflatpak" ]; then
  cd "$WINESTEAM_PKGS"
  rm "$PWD/WineSteam.flatpak"
  wsNotify '[1/2] [1/1] Downloading WineSteam flatpak... [⟱]]'
  echo '=========================================================='
  curl -o WineSteam.flatpak.gz -L https://github.com/GleammerRay/WineSteam/releases/download/v0.1.1/DO-NOT-INSTALL-WineSteam.flatpak.gz
  gzip -d WineSteam.flatpak.gz
  if [ ! -f ./WineSteam.flatpak ]; then
      wsInfo 'F: Download failed.'
      exit 1
  fi
  echo '=========================================================='
  wsNotify '[2/2] Installing Winesteam flatpak... '
  flatpak uninstall --user -y io.github.gleammerray.WineSteam
  flatpak install --user -y ./WineSteam.flatpak
  rm WineSteam.flatpak
  exit
fi
git fetch
git pull
if [ "x`flatpak list | grep "io.github.gleammerray.WineSteam"`" != "x" ]; then
  ./update.sh flatpak
fi
