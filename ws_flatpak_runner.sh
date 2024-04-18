cd "`dirname "$0"`"
eval "`bash read_config.sh`"
echo $$ > "$WINESTEAM_FLATPAK_PID_PATH"
sleep 6
printf "nameserver 8.8.8.8\nnameserver 4.4.4.4\n" > "$WINESTEAM_DATA/resolv.conf"
mount --bind "$WINESTEAM_DATA/resolv.conf" /etc/resolv.conf
flatpak run io.github.gleammerray.WineSteam
