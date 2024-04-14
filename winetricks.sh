export WINEARCH=win64
export WINE_LARGE_ADDRESS_AWARE=1
export WINESTEAM_DATA="$HOME/.winesteam"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export PATH="$WINESTEAM_PKGS/lutris-GE-Proton8-26-x86_64/bin:$PATH"
winetricks
