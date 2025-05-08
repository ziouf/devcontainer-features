#!/bin/bash

# This test file will be executed against one of the scenarios devcontainer.json test that
# includes the 'color' feature with "greeting": "hello" option.

set -e

LATEST_VERSION="$(git ls-remote --tags https://github.com/tailwindlabs/tailwindcss | grep -oP "[0-9]+\\.[0-9]+\\.[0-9]+" | sort -V | tail -n 1)"

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "version" bash -c "tailwindcss --version | grep '$LATEST_VERSION'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
