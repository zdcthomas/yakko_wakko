#!/bin/bash
if [ `uname` = Darwin ]
then
  echo macOS detected. Setting up macOS settings
  bash ./macos_setup.sh
elif pacman --version &>/dev/null; then
  echo Pacman deteced.
  echo No preferences file rn.
else
  echo No known dependency system found
  exit 1
fi

