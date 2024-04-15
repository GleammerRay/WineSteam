cd "`dirname "$0"`"
eval "$1"
while true; do
  read ANS
  eval "$ANS"
done
