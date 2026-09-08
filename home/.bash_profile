# shellcheck shell=bash
# Native Apple Silicon Homebrew.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$HOME/.bin:$HOME/bin:$PATH"
