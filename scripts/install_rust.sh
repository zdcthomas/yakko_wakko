if cargo 2>/dev/null; then
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
