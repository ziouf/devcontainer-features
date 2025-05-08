#!/bin/sh
set -e

echo "Installing packages..."

PACKAGES=${PACKAGES:-empty}

if [ "$PACKAGES" = "empty" ]; then
  echo "No packages to install."
  exit 0
fi

# Replace comma by spaces
PACKAGES=$(echo "$PACKAGES" | tr ',' ' ')

# Detect which package manager is available on the system
if command -v apt-get >/dev/null 2>&1; then
  PACKAGE_MANAGER="apt-get"
elif command -v apk >/dev/null 2>&1; then
  PACKAGE_MANAGER="apk"
elif command -v dnf >/dev/null 2>&1; then
  PACKAGE_MANAGER="dnf"
elif command -v yum >/dev/null 2>&1; then
  PACKAGE_MANAGER="yum"
elif command -v pacman >/dev/null 2>&1; then
  PACKAGE_MANAGER="pacman"
elif command -v zypper >/dev/null 2>&1; then
  PACKAGE_MANAGER="zypper"
else
  echo "No supported package manager found."
  exit 1
fi

# Install packages based on the detected package manager
case $PACKAGE_MANAGER in
  apt-get)
    apt-get update -qq
    apt-get install -y $PACKAGES
    ;;
  apk)
    apk add --no-cache $PACKAGES
    ;;
  dnf)
    dnf install -y $PACKAGES
    ;;
  yum)
    yum install -y $PACKAGES
    ;;
  pacman)
    pacman -Syu --noconfirm $PACKAGES
    ;;
  zypper)
    zypper install -y $PACKAGES
    ;;
  *)
    echo "Unsupported package manager: $PACKAGE_MANAGER"
    exit 1
    ;;
esac
