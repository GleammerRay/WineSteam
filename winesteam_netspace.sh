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
  sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip link del "$WINESTEAM_VFACE"
  sudo /bin/ip netns del "$WINESTEAM_NETNS"
  exit
}

trap on_exit SIGINT
trap on_exit SIGTSTP

SUDOERS_CONTENT=$(cat << EOF
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/bin/mkdir -p /etc/netns/$WINESTEAM_NETNS
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/bin/bash -c /usr/bin/echo nameserver 8.8.8.8 > /etc/netns/$WINESTEAM_NETNS/resolv.conf
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip link del $WINESTEAM_VFACE
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip link add link *
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip link set $WINESTEAM_VFACE netns $WINESTEAM_NETNS
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip addr *
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip route *
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns del $WINESTEAM_NETNS
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns add $WINESTEAM_NETNS
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns exec $WINESTEAM_NETNS /usr/sbin/ip link del $WINESTEAM_VFACE
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns exec $WINESTEAM_NETNS /usr/sbin/ip link set dev lo up
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns exec $WINESTEAM_NETNS /usr/sbin/ip link set dev $WINESTEAM_VFACE up
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns exec $WINESTEAM_NETNS /usr/sbin/ip addr *
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns exec $WINESTEAM_NETNS /usr/sbin/ip route *
%winesteam-netspace ALL=(ALL) NOPASSWD: /usr/sbin/ip netns exec $WINESTEAM_NETNS /usr/bin/sudo -u $USER *
EOF
)

CUR_SUDOERS_CONTENT="x$(cat /etc/sudoers.d/winesteam_netspace)"
if [ "$CUR_SUDOERS_CONTENT" != "x$SUDOERS_CONTENT" ]; then
  echo "I:WineSteam network namespace is not set up properly."
  echo "I:Performing first time setup..."
  /usr/bin/echo -e "$SUDOERS_CONTENT" | /usr/bin/sudo /usr/bin/tee /etc/sudoers.d/winesteam_netspace
  sudo groupadd winesteam-netspace
  sudo usermod -a -G winesteam-netspace $USER
fi

sudo /usr/bin/mkdir -p "/etc/netns/$WINESTEAM_NETNS"
sudo /usr/bin/bash -c "/usr/bin/echo nameserver 8.8.8.8 > /etc/netns/$WINESTEAM_NETNS/resolv.conf"
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip link del "$WINESTEAM_VFACE"
sudo /usr/sbin/ip netns del "$WINESTEAM_NETNS"
sudo /usr/sbin/ip netns add "$WINESTEAM_NETNS"
sudo /usr/sbin/ip link del "$WINESTEAM_VFACE"
sudo /usr/sbin/ip link add link "$WINESTEAM_NETFACE" "$WINESTEAM_VFACE" type ipvlan mode l2
sudo /usr/sbin/ip link set "$WINESTEAM_VFACE" netns "$WINESTEAM_NETNS"
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip link set dev lo up
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip link set dev "$WINESTEAM_VFACE" up
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip addr add "$WINESTEAM_IP"/24 dev "$WINESTEAM_VFACE"
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip route del default
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip route add default via "$WINESTEAM_GW" dev "$WINESTEAM_VFACE" src "$WINESTEAM_IP" metric 1
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/bin/sudo -u "$USER" WINESTEAM_USE_NETSPACE="false" WINESTEAM_INSTALL_DXVK="$WINESTEAM_INSTALL_DXVK" bash "$PWD"/winesteam.sh
sudo /usr/sbin/ip netns exec "$WINESTEAM_NETNS" /usr/sbin/ip link del "$WINESTEAM_VFACE"
sudo /usr/sbin/ip netns del "$WINESTEAM_NETNS"

echo 'WINESTEAM_USE_NETSPACE=true' > "$WINESTEAM_DATA/winesteam.cfg"
