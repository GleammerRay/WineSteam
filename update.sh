#! /bin/bash
cd "`dirname "$0"`"
source "./ws_gui.sh"
eval "`bash read_config.sh`"
if [ "x$1" = "xflatpak" ]; then
  cd "$WINESTEAM_PKGS"
  rm "$PWD/WineSteam.flatpak"
  wsNotify '[1/2] [1/1] Downloading WineSteam flatpak... [⟱]]'
  echo '=========================================================='
  curl -o WineSteam.flatpak.gz -L https://github.com/GleammerRay/WineSteam/releases/download/$WINESTEAM_VERSION/DO-NOT-INSTALL-WineSteam.flatpak.gz
  gzip -d WineSteam.flatpak.gz
  if [ ! -f ./WineSteam.flatpak ]; then
      wsInfo 'F: Download failed.'
      exit 1
  fi
  echo '=========================================================='
  wsNotify '[2/2] Installing Winesteam flatpak... '
  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  flatpak uninstall --user -y io.github.gleammerray.WineSteam
      flatpak install --user -y org.freedesktop.Platform/x86_64/23.08 \
          org.freedesktop.Platform.GL32.default/x86_64/23.08 \
          org.freedesktop.Platform.VAAPI.Intel/x86_64/23.08 \
          org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/23.08 \
          org.freedesktop.Platform.ffmpeg-full/x86_64/23.08 \
          org.freedesktop.Platform.ffmpeg_full.i386/x86_64/23.08 \
          org.winehq.Wine.gecko/x86_64/stable-23.08 \
          org.winehq.Wine.mono/x86_64/stable-23.08 \
          org.winehq.Wine.DLLs.dxvk/x86_64/stable-23.08 \
          org.freedesktop.Platform.Compat.i386/x86_64/23.08 \
          org.freedesktop.Platform.Compat.i386.Debug/x86_64/23.08
  flatpak install --user -y ./WineSteam.flatpak
  rm WineSteam.flatpak
  exit
fi
git fetch
git pull
if [ "x`flatpak list | grep "io.github.gleammerray.WineSteam"`" != "x" ]; then
  ./update.sh flatpak
fi
wsInfo 'All done.'
