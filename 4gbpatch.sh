#! /bin/bash
cd $HOME
if [ ! -d ./.winesteamdxvk ]; then mkdir ./.winesteamdxvk; fi
cd ./.winesteamdxvk
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
echo '[0/2] Applying 4GB patch.'
echo '[1/2] [0/1] Downloading packages. [⟱]'
if [ ! -d ./packages ]; then mkdir ./packages; fi
cd packages
if [ ! -f 4gb_patch.exe ]; then
  echo '[1/2] [1/1] Downloading 4GB patch... [⟱]'
  wget https://ntcore.com/files/4gb_patch.zip
  unzip 4gb_patch.zip
  rm 4gb_patch.zip
fi
cd ..
echo '[2/2] Running 4GB patch... [🮲🮳]'
wine packages/4gb_patch.exe $1
echo 'Done.'
