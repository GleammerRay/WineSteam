#! /bin/bash
cd "`dirname "$0"`"
source "./ws_gui.sh"
eval "`bash read_config.sh`"
if [ "x$1" = "xflatpak" ]; then
  if [ $OLD_WINESTEAM_VERSION = $WINESTEAM_VERSION ]; then
    exit
  fi
  cd "$WINESTEAM_PKGS"
  rm "$PWD/WineSteam.flatpak"
  wsNotify '[1/2] [1/1] Downloading WineSteam flatpak... [⟱]]'
  echo '=========================================================='
  export WS_PROGRESS_TEXT="Downloading WineSteam flatpak..."
  wsGUIProgress curl -o WineSteam.flatpak.gz -L https://github.com/GleammerRay/WineSteam/releases/download/$WINESTEAM_VERSION/DO-NOT-INSTALL-WineSteam.flatpak.gz
  gzip -d WineSteam.flatpak.gz
  if [ ! -f ./WineSteam.flatpak ]; then
      wsInfo 'F: Download failed.'
      exit 1
  fi
  echo '=========================================================='
  wsNotify '[2/2] Installing Winesteam flatpak... '
  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  export WS_PROGRESS_TEXT="Uninstalling old WineSteam flatpak..."
  wsGUIProgress flatpak uninstall --user -y io.github.gleammerray.WineSteam
  export WS_PROGRESS_TEXT="Installing dependencies..."
  wsGUIProgress flatpak install --user -y org.freedesktop.Platform/x86_64/23.08 \
      org.freedesktop.Platform.GL32.default/x86_64/23.08 \
      org.freedesktop.Platform.VAAPI.Intel/x86_64/23.08 \
      org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/23.08 \
      org.freedesktop.Platform.ffmpeg-full/x86_64/23.08 \
      org.freedesktop.Platform.ffmpeg_full.i386/x86_64/23.08 \
      org.winehq.Wine.gecko/x86_64/stable-23.08 \
      org.winehq.Wine.mono/x86_64/stable-23.08 \
      org.winehq.Wine.DLLs.dxvk/x86_64/stable-23.08 \
      org.freedesktop.Platform.Compat.i386/x86_64/23.08
  export WS_PROGRESS_TEXT="Installing WineSteam flatpak..."
  wsGUIProgress flatpak install --user -y ./WineSteam.flatpak
  rm WineSteam.flatpak
  exit
fi
git fetch
git pull
export OLD_WINESTEAM_VERSION=$WINESTEAM_VERSION
if command -v "flatpak" &> /dev/null ; then
  if [ "x`flatpak list | grep "io.github.gleammerray.WineSteam"`" != "x" ]; then
    ./update.sh flatpak
  fi
fi
wsInfo 'All done.'
