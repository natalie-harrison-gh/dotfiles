#!/bin/sh
# Source before provisioning to reject unsupported systems before any changes.
if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
  echo "These dotfiles require an Apple Silicon Mac running a native arm64 shell. Disable Rosetta for your terminal and try again." >&2
  exit 1
fi
