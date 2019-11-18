#!/bin/bash

if [[ $(command -v brew) == "" ]];
then
  echo "You need homebrew! \n Installing now!"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
else
  echo "Homebrew installation detected!"
fi

if ! brew info cask &>/dev/null; 
then
  echo "You also need to tap cask!"
  brew tap caskroom/cask;
else
  echo "You are already tapped into cask!"
fi

cd

echo "Installing everything you need from homebrew"
brew bundle install
