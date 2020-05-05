echo installing pip packages

if pip3 2>/dev/null; then
  sudo pip3 install neovim
else
  echo error pip is not installed
  exit 1
fi
