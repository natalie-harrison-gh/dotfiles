# Homebrew uses /opt/homebrew on Apple Silicon and /usr/local on Intel. Prefer
# the prefix matching this shell's architecture, then fall back to PATH.
_brew_bin=""
case "$(uname -m)" in
  arm64)  [ -x /opt/homebrew/bin/brew ] && _brew_bin="/opt/homebrew/bin/brew" ;;
  x86_64) [ -x /usr/local/bin/brew ] && _brew_bin="/usr/local/bin/brew" ;;
esac
if [ -z "$_brew_bin" ] && command -v brew >/dev/null 2>&1; then
  _brew_bin="$(command -v brew)"
elif [ -z "$_brew_bin" ] && [ -x /opt/homebrew/bin/brew ]; then
  _brew_bin="/opt/homebrew/bin/brew"
elif [ -z "$_brew_bin" ] && [ -x /usr/local/bin/brew ]; then
  _brew_bin="/usr/local/bin/brew"
fi
[ -n "$_brew_bin" ] && eval "$("$_brew_bin" shellenv)"
unset _brew_bin

export PATH="$HOME/.local/bin:$HOME/.bin:$HOME/bin:$PATH"
