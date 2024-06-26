#!/bin/bash
cd "`dirname "$0"`"
eval "`bash read_config.sh`"
echo $$ > "$WINESTEAM_RUNNER_PID_PATH"
rm "$WINESTEAM_IPC_PATH"

user_interrupt() {
  rm "$WINESTEAM_IPC_PATH"
  wineserver -w &
  wineserver -k
  wait $!
  kill $(jobs -p)
  kill -9 $1
  exit
}

trap "user_interrupt $$" SIGINT
trap "user_interrupt $$" SIGTERM
trap "user_interrupt $$" SIGTSTP

export WS_MAIN_PID=""

wsRunCleanup() {
  wineserver -w &
  wait -n $WS_MAIN_PID $!
  user_interrupt $$
}

sleep 6
printf "nameserver 8.8.8.8\nnameserver 4.4.4.4\n" > "$WINESTEAM_DATA/resolv.conf"
mount --bind "$WINESTEAM_DATA/resolv.conf" /etc/resolv.conf
eval "$1" &

wsMain() {
  while true; do
    if [ -f $WINESTEAM_IPC_PATH ]; then
      IPC="$(cat "$WINESTEAM_IPC_PATH")"
      if [ "$IPC" = "user_interrupt" ]; then
        rm "$WINESTEAM_IPC_PATH"
        exit
      fi
      eval "$IPC" &
      rm "$WINESTEAM_IPC_PATH"
    fi
    sleep 1
  done
}

wsMain $$ &
export WS_MAIN_PID=$!
sleep 1
wsRunCleanup
