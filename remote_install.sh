#!/usr/bin/env bash
USER="zdcthomas"
REPO="yakko_wakko"
SOURCE="https://github.com/$USER/$REPO"
TARBALL="$SOURCE/tarball/master"
TARGET="$HOME/$REPO"
TAR_CMD="tar -xzv -C "$TARGET" --strip-components=1 --exclude='{.gitignore}'"
INSTALL_CMD="bash install"

is_executable() {
  type "$1" > /dev/null 2>&1
}

if is_executable "git"; then
  CMD="git clone $SOURCE $TARGET"
elif is_executable "curl"; then
  CMD="curl -#L $TARBALL | $TAR_CMD"
elif is_executable "wget"; then
  CMD="wget --no-check-certificate -O - $TARBALL | $TAR_CMD"
fi

if [ -z "$CMD" ]; then
  echo "No git, curl or wget available. Aborting."
else
  echo "Installing dotfiles..."
  mkdir -p "$TARGET"
  eval "$CMD"
  cd $TARGET
  eval $INSTALL_CMD
fi

