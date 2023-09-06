#!/bin/bash
exec < /dev/tty

DOTFILE_DIR="yakko_wakko"
SCRIPT_SUBDIR="scripts"

function good_exit () {
  echo "..."
  # exit 0
  break
}

function runIt() {
  echo "---Would you like to run $1?(Y/n) " 
  while read -p "---Would you like to install homebrew packages?(Y/n) " yn; do
      case $yn in
          [Yy] ) echo "running $1"; source "$HOME/$DOTFILE_DIR/$SCRIPT_SUBDIR/$1"; break;;
          [Nn] ) echo "---Got it"; break;;
          * ) echo "---Please answer y(es) or n(o):" && continue;
      esac
  done
}

scripts=(
  "brew_setup.sh"
  "iterm_setup.sh"
  "macos_setup.sh"
  "file_structure_setup.sh"
  "npm_installations.sh"
)

for script in "${scripts[@]}"
do
  runIt $script
done

exec <&-
