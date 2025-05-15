#! /bin/bash
set -eu

function init {
    # Retrieve custom gitconfigs from host
    git config -l --global --include > .devcontainer/.gitconfig.global
    git config -l --local --include > .devcontainer/.gitconfig.local
}

function postStart {
    # Re-configures git global and local configuration with includes
    # https://github.com/microsoft/vscode-remote-release/issues/2084
    for conf in .devcontainer/.gitconfig.global .devcontainer/.gitconfig.local; do
    if [ -f $conf ]; then
        echo "*** Parsing ${conf##.gitconfig.} Git configuration export"
        while IFS='=' read -r key value; do
        case "$key" in
        user.name | user.email | user.signingkey | commit.gpgsign)
            echo "Set Git config ${key}=${value}"
            git config --global "$key" "$value"
            ;;
        esac
        done <"$conf"
        rm -f "$conf"
    fi
    done
}

case ${1:-init} in 
    init)
        init
        ;;
    postStart)
        postStart
        ;;
    *)
        echo "Usage: $0 {init|postStart}"
        exit 1
        ;;
esac
