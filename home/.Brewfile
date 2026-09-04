cask_args appdir: "/Applications"

# Moshi is not in homebrew/core. Trust only the formula this setup installs.
tap "rjyo/moshi", trusted: { formula: "moshi-hook" }

# Shell and modern command-line basics.
brew "bash"
brew "bat"
brew "coreutils"
brew "eza"
brew "fd"
brew "findutils"
brew "fzf"
brew "gnu-sed"
brew "htop"
brew "ripgrep"
brew "zoxide"
brew "zsh-autosuggestions"
brew "zsh-fast-syntax-highlighting"

# Git and coding-agent support.
brew "direnv"
brew "gh" if Hardware::CPU.arm?
brew "git"
brew "git-delta"
brew "herdr"
brew "jq"
brew "pkgconf"
brew "shellcheck"
brew "starship"

# Runtime versions come from asdf, not Homebrew. These packages support the
# asdf Node and Ruby plugins and native builds without installing a language
# runtime directly through Homebrew.
brew "asdf"
brew "gawk"
brew "gnupg"
brew "libyaml"
brew "openssl@3"
brew "readline"

# Remote sessions and the Moshi hook. Herdr is the only multiplexer installed.
brew "mosh"
brew "rjyo/moshi/moshi-hook"

cask "1password"
cask "1password-cli"
cask "craft"
cask "dropshare"
cask "ghostty"
cask "google-drive"
cask "iina"
cask "losslesscut"
cask "orbstack"
cask "raycast"
cask "shottr"
cask "spotify"
cask "transmission"
cask "whatsapp"
cask "yaak@beta"
cask "zed"
cask "zen"
cask "zoom"
