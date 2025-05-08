#!/bin/sh
set -e

echo "Installing natscli..."

VERSION=${VERSION:-latest}
echo "The version to install is: $VERSION"


REPOSITORY=nats-io/natscli

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
URL="https://github.com/${REPOSITORY}/releases/download/v${VERSION}/nats-${VERSION}-${OS}-${ARCH}.zip"

# Download the binary
echo "Downloading natscli from $URL"
curl -L -o /tmp/natscli.zip "$URL"

# Unzip the binary
echo "Unzipping natscli..."
unzip -o /tmp/natscli.zip nats-${VERSION}-${OS}-${ARCH}/nats -d /usr/local/bin/
ln -s /usr/local/bin/nats-${VERSION}-${OS}-${ARCH}/nats /usr/local/bin/nats
chmod +x /usr/local/bin/nats

# Clean up
echo "Cleaning up..."
rm -f /tmp/natscli.zip
