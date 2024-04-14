#! /bin/bash

export WINESTEAM_DATA="$HOME/.winesteam"

read -p "?: Are you sure that you want to uninstall WineSteam? You can install it again by running \`bash winesteam.sh\`. [y/N]: " CONFIRM_UNINSTALL
CONFIRM_UNINSTALL=$(echo ${CONFIRM_UNINSTALL:-'n'} | tr '[:upper:]' '[:lower:]')
if [ "$CONFIRM_UNINSTALL" != 'y' ]; then
  export CONFIRM_UNINSTALL='n'
  echo '?: Uninstall cancelled. 【=◡˳ ◡✿=】'
else
  export CONFIRM_UNINSTALL='y'
  echo '?: Uninstalling WineSteam. 【=╥﹏╥✿=】'
  rm -rf "$WINESTEAM_DATA"
  echo 'Done.'
fi
