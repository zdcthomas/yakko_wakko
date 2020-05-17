echo installing pip packages

if python3 2>/dev/null; then
  python3 -m pip install --user --upgrade pynvim
else
  echo error python3 is not installed
  exit 1
fi
