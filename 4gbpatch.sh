#! /bin/bash
export PWD_BAK="$PWD"
# export WINESTEAM_DATA="$HOME/.winesteam"
export WINESTEAM_PKGS="$WINESTEAM_DATA/packages"
if [ -z "$1" ]; then
  echo 'F:No executable specified.'
  echo 'Please provide a path to the executable that you want to patch.'
  exit
fi
if [ ! -f "$1" ]; then
  echo 'F:File does not exist.'
  echo 'Please provide a valid path to the executable.'
  exit
fi

read -p "Are you sure? [N/Y] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo '[0/2] Applying 4GB patch.'
  echo '[1/2] [0/1] Downloading packages. [⟱]'
  if [ ! -d "$WINESTEAM_PKGS" ]; then mkdir -p "$WINESTEAM_PKGS"; fi
 cd "$WINESTEAM_PKGS"
 if [ ! -f 4gb_patch.exe ]; then
  echo '[1/2] [1/1] Downloading 4GB patch... [⟱]'
  wget https://ntcore.com/files/4gb_patch.zip
  unzip 4gb_patch.zip
  rm 4gb_patch.zip
 fi
  echo '[2/2] Running 4GB patch... [🮲🮳]'
  cd "$PWD_BAK"
  wine "$WINESTEAM_PKGS/4gb_patch.exe" "$1"
  echo 'Done.'
else exit
fi
