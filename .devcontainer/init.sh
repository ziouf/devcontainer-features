#! /bin/bash
set -eu

# Retrieve custom gitconfigs from host
git config -l --global --include > .devcontainer/.gitconfig.global
git config -l --local --include > .devcontainer/.gitconfig.local
