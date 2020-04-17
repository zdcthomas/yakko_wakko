#!/bin/bash

npm update -g

PACKAGES=(
  elm-oracle
  @elm-tooling/elm-language-server
  neovim
)

npm install -g ${PACKAGES[@]}
