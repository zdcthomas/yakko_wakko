#!/bin/bash

sudo pacman -Syu
path="$(cat ../pacfile.txt)"
echo file here
echo "$(cat ./pacfile.txt)"
sudo pacman -S --needed --noconfirm - < ./scripts/pacfile.txt

# rbenv~/yakko_wakko/pacfile.txt
# wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash
# pacmatmate.confn -S pyenv --noconfirm
