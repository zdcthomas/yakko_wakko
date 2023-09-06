#!/bin/bash
echo installing npm packages

PACKAGES=(
  elm-oracle
  @elm-tooling/elm-language-server
  neovim
)

if npm 2>/dev/null; then
  npm update -g
  npm install -g ${PACKAGES[@]}
else
  echo error: npm is not installed
  exit 1
fi
