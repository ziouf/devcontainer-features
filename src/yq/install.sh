#!/bin/sh
set -e

echo "Installing yq..."

VERSION=${VERSION:-latest}
echo "The version to install is: $VERSION"

# https://github.com/mikefarah/yq/releases

REPOSITORY=mikefarah/yq

if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -s "https://api.github.com/repos/${REPOSITORY}/releases/latest" | grep tag_name | cut -d '"' -f 4)
  echo "Latest version is: $VERSION"
fi

# Trim the leading "v" from the version string
VERSION=${VERSION#v}

# Determine the OS and architecture
case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
  linux*)
    OS="linux"
    ;;
  darwin*)
    OS="darwin"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

case "$(uname -m)" in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64)
    ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Construct the download URL
URL="https://github.com/${REPOSITORY}/releases/download/v${VERSION}/yq_${OS}_${ARCH}"

# Download the binary
echo "Downloading yq from $URL"
curl -L -o /usr/local/bin/yq "$URL"
chmod +x /usr/local/bin/yq

