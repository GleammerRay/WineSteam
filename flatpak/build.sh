flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
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
flatpak-builder --force-clean --user --install build-dir io.github.gleammerray.WineSteam.yml
