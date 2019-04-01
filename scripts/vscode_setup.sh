#!/usr/bin/env bash

set -e

# Can be updated with:
# code --list-extensions

echo "Installing Vscode Extensions"
while read line; do
  code --install-extension "$line"
done < ./scripts/vscode_extensions.txt
