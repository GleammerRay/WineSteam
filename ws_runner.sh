#!/bin/bash
echo $$ > /tmp/winesteam_pid
cd "`dirname "$0"`"
eval "`bash read_config.sh`"

user_interrupt() {
  rm "$WINESTEAM_IPC_PATH"
  wineserver -k
  kill 0 &
  kill -9 $$
  exit
}

trap user_interrupt SIGINT
trap user_interrupt SIGTERM
trap user_interrupt SIGTSTP

export WS_RUN_PID=""
wsRunCleanup() {
  wait $WS_RUN_PID
  user_interrupt
}

sleep 6
echo "nameserver 8.8.8.8\n" >> /tmp/resolv.conf
echo "nameserver 4.4.4.4\n" >> /tmp/resolv.conf
mount --bind /tmp/resolv.conf /etc/resolv.conf
eval "$1" &
export WS_RUN_PID=$!

wsMain() {
  while true; do
    if [ -f $WINESTEAM_IPC_PATH ]; then
      IPC="$(cat "$WINESTEAM_IPC_PATH")"
      echo "$IPC"
      eval "$IPC" &
      rm "$WINESTEAM_IPC_PATH"
    fi
    sleep 1
  done
}

wsMain &
wsRunCleanup
