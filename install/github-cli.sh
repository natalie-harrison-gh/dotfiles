#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "x86_64" ]]; then
  exit 0
fi

readonly RELEASES_URL="https://github.com/cli/cli/releases"
readonly INSTALL_DIR="$HOME/.local/bin"
readonly TARGET="$INSTALL_DIR/gh"

latest_url="$(curl --proto '=https' --tlsv1.2 --fail --silent --show-error \
  --location --retry 3 --retry-delay 1 --output /dev/null \
  --write-out '%{url_effective}' "$RELEASES_URL/latest")"
tag="${latest_url##*/}"
if [[ ! "$tag" =~ ^v([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
  echo "Could not determine the latest GitHub CLI version from $latest_url" >&2
  exit 1
fi
version="${BASH_REMATCH[1]}"

if [[ -x "$TARGET" ]] &&
  [[ "$("$TARGET" --version 2>/dev/null | awk 'NR == 1 { print $3 }')" == "$version" ]]; then
  echo "GitHub CLI $version is already installed in $TARGET"
  exit 0
fi

work_dir="$(mktemp -d "${TMPDIR:-/tmp}/github-cli.XXXXXXXX")"
staged=""
cleanup() {
  rm -rf "$work_dir"
  [[ -z "$staged" ]] || rm -f "$staged"
}
trap cleanup EXIT

archive_name="gh_${version}_macOS_amd64.zip"
checksums_name="gh_${version}_checksums.txt"
download_url="$RELEASES_URL/download/$tag"

curl --proto '=https' --tlsv1.2 --fail --silent --show-error --location \
  --retry 3 --retry-delay 1 --output "$work_dir/$archive_name" \
  "$download_url/$archive_name"
curl --proto '=https' --tlsv1.2 --fail --silent --show-error --location \
  --retry 3 --retry-delay 1 --output "$work_dir/$checksums_name" \
  "$download_url/$checksums_name"

expected_sha="$(awk -v name="$archive_name" \
  '$2 == name { count++; sha = $1 } END { if (count != 1) exit 1; print sha }' \
  "$work_dir/$checksums_name")" || {
  echo "No unique checksum found for $archive_name" >&2
  exit 1
}
if [[ ! "$expected_sha" =~ ^[[:xdigit:]]{64}$ ]]; then
  echo "Invalid checksum for $archive_name" >&2
  exit 1
fi
(
  cd "$work_dir"
  printf '%s  %s\n' "$expected_sha" "$archive_name" | /usr/bin/shasum -a 256 -c -
)

mkdir -p "$work_dir/extracted" "$INSTALL_DIR"
/usr/bin/unzip -q "$work_dir/$archive_name" -d "$work_dir/extracted"
source_bin="$work_dir/extracted/gh_${version}_macOS_amd64/bin/gh"
if [[ ! -f "$source_bin" || -L "$source_bin" ]]; then
  echo "Verified archive did not contain the expected gh binary" >&2
  exit 1
fi
if [[ -d "$TARGET" && ! -L "$TARGET" ]]; then
  echo "Cannot replace directory $TARGET" >&2
  exit 1
fi

staged="$(mktemp "$INSTALL_DIR/.gh.XXXXXXXX")"
/usr/bin/install -m 0755 "$source_bin" "$staged"
if [[ "$("$staged" --version | awk 'NR == 1 { print $3 }')" != "$version" ]]; then
  echo "Downloaded gh binary reported an unexpected version" >&2
  exit 1
fi
mv -f "$staged" "$TARGET"
staged=""
echo "Installed GitHub CLI $version in $TARGET"
