#! /bin/bash
cd $(dirname $0)

export WINEESYNC=1
export WINEARCH=win64
export WINESTEAM_BIN="$PWD"
export WINESTEAM_DATA="$HOME/.winesteam"
export WINESTEAM_PKGS="$WINESTEAM_DATA/packages"
export WINEPREFIX="$WINESTEAM_DATA/prefix"
export WINE_LARGE_ADDRESS_AWARE=1
export FREETYPE_PROPERTIES="truetype:interpreter-version=35"
export WINESTEAM_NETFACE=$(ip -o link show | awk '{print $2,$9}' | grep UP | sed 's/: UP//g')
export WINESTEAM_GW=$(route -n | grep 'UG [ t]' | awk ' {print $2}')
IN="$WINESTEAM_GW"
arrIN=(${IN//\n/ })
export WINESTEAM_GW=${arrIN[0]}
IN="$WINESTEAM_GW"
arrIN=(${IN//./ })
export WINESTEAM_IP=${arrIN[0]}.${arrIN[1]}.${arrIN[2]}.232
export WINESTEAM_VFACE=winesteam_vi0
export WINESTEAM_NETNS=winesteam_ns0

on_exit() {
  sudo /bin/ip netns del "$WINESTEAM_NETNS"
  exit
}

SUDOERS_CONTENT=$(cat << EOF
$USER ALL=(ALL) NOPASSWD: /usr/bin/bash -c /usr/bin/echo nameserver 8.8.8.8 > /etc/netns/$WINESTEAM_NETNS/resolv.conf
$USER ALL=(ALL) NOPASSWD: /bin/ip link del $WINESTEAM_VFACE
$USER ALL=(ALL) NOPASSWD: /bin/ip link add link *
$USER ALL=(ALL) NOPASSWD: /bin/ip link set $WINESTEAM_VFACE netns $WINESTEAM_NETNS
$USER ALL=(ALL) NOPASSWD: /bin/ip addr *
$USER ALL=(ALL) NOPASSWD: /bin/ip route *
$USER ALL=(ALL) NOPASSWD: /bin/ip netns del $WINESTEAM_NETNS
$USER ALL=(ALL) NOPASSWD: /bin/ip netns add $WINESTEAM_NETNS
$USER ALL=(ALL) NOPASSWD: /bin/ip netns exec $WINESTEAM_NETNS /usr/bin/ip link *
$USER ALL=(ALL) NOPASSWD: /bin/ip netns exec $WINESTEAM_NETNS /usr/bin/ip addr *
$USER ALL=(ALL) NOPASSWD: /bin/ip netns exec $WINESTEAM_NETNS /usr/bin/ip route *
$USER ALL=(ALL) NOPASSWD: /bin/ip netns exec $WINESTEAM_NETNS /usr/bin/sudo -u $USER *
EOF
)

CUR_SUDOERS_CONTENT="x$(cat /etc/sudoers.d/winesteam_netspace)"
if [ "$CUR_SUDOERS_CONTENT" != "x$SUDOERS_CONTENT" ]; then
  echo "I:WineSteam network namespace is not set up properly."
  echo "I:Performing first time setup..."
  /usr/bin/echo -e "$SUDOERS_CONTENT" | /usr/bin/sudo /usr/bin/tee /etc/sudoers.d/winesteam_netspace
fi

trap on_exit SIGINT
trap on_exit SIGTSTP

sudo /usr/bin/bash -c "/usr/bin/echo nameserver 8.8.8.8 > /etc/netns/$WINESTEAM_NETNS/resolv.conf"
sudo /bin/ip netns del "$WINESTEAM_NETNS"
sudo /bin/ip netns add "$WINESTEAM_NETNS"
sudo /bin/ip link del "$WINESTEAM_VFACE"
sudo /bin/ip link add link "$WINESTEAM_NETFACE" "$WINESTEAM_VFACE" type ipvlan mode l2
sudo /bin/ip link set "$WINESTEAM_VFACE" netns "$WINESTEAM_NETNS"
sudo /bin/ip netns exec "$WINESTEAM_NETNS" /usr/bin/ip link set dev lo up
sudo /bin/ip netns exec "$WINESTEAM_NETNS" /usr/bin/ip link set dev "$WINESTEAM_VFACE" up
sudo /bin/ip netns exec "$WINESTEAM_NETNS" /usr/bin/ip addr add "$WINESTEAM_IP"/24 dev "$WINESTEAM_VFACE"
sudo /bin/ip netns exec "$WINESTEAM_NETNS" /usr/bin/ip route del default
sudo /bin/ip netns exec "$WINESTEAM_NETNS" /usr/bin/ip route add default via "$WINESTEAM_GW" dev "$WINESTEAM_VFACE" src "$WINESTEAM_IP" metric 1
sudo /bin/ip netns exec "$WINESTEAM_NETNS" /usr/bin/sudo -u "$USER" bash "$PWD"/winesteam.sh
sudo /bin/ip netns del "$WINESTEAM_NETNS"

