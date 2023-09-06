#!/bin/bash
if [ `uname` = Darwin ]
then
  echo macOS detected. Installing from brewfile
  bash ./scripts/brew_setup.sh
elif pacman --version &>/dev/null; then
  echo Pacman deteced. Installing from Pacfile
  bash ./scripts/manjaro_installs.sh
else
  echo No known dependency system found
  exit 1
fi

bash ./scripts/npm_installations.sh
bash ./scripts/pip_installations.sh
