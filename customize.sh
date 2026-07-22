#!/usr/bin/env bash
# SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
# SPDX-License-Identifier: GPL-2.0-only

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

################################################################################
# Cross-platform sed helper
#
# macOS ships BSD sed; Linux ships GNU sed. BSD sed requires an explicit
# (possibly empty) backup-extension argument for in-place edits. Using a bash
# array keeps the empty extension a real separate argument on macOS instead of
# a literal two-char '' after word-splitting.
################################################################################
OS_TYPE="$(uname -s)"
if [[ "$OS_TYPE" == "Darwin" ]]; then
  SED_I_FLAG=(-i '')
else
  SED_I_FLAG=(-i)
fi

sed_i() {
  sed "${SED_I_FLAG[@]}" "$@"
}

################################################################################
# Logging (self-contained; all output to stderr)
################################################################################
info() { printf 'info: %s\n' "$*" >&2; }
warn() { printf 'warn: %s\n' "$*" >&2; }
fail_with_message() { printf 'error: %s\n' "$*" >&2; exit 1; }

################################################################################
# Escaping helpers
################################################################################
# Escape text for safe insertion into HTML element content.
# Uses sed (not bash ${//}) because bash 5.2's patsub_replacement treats '&' in
# the replacement as the matched text, which mangles the '&' in each entity.
html_escape() {
  printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Escape a value for use inside a JSON double-quoted string.
json_escape() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

# Escape a string for use on the replacement side of a '|'-delimited sed 's'.
sed_escape_repl() {
  printf '%s' "$1" | sed -e 's/[\&|]/\\&/g'
}

################################################################################
# Usage
################################################################################
usage() {
  cat >&2 <<EOF
Usage: $(basename "$0") [options]

Generate a customized copy of the Ring Zero Dome block-page extension under a
build directory, leaving the tracked source untouched. With no options, every
field is prompted interactively; an empty answer keeps the current default.

Options:
  --version v3|v2|both  Manifest version to build (default: v3)
  --name NAME           Extension name (manifest.json)
  --title TEXT          Block page browser-tab title (<title>)
  --heading TEXT        Block page heading (<h1>)
  --message TEXT        Block page message (<p>)
  --logo PATH           Image file to use as the logo (copied over dome-logo.png)
  --favicon PATH        Icon file for the browser tab (copied over favicon.ico)
  --output DIR          Output directory (default: ./build)
  -y, --yes             Non-interactive: use flags/defaults, do not prompt
  -h, --help            Show this help and exit

The powered-by image and its link are never modified.
EOF
}

################################################################################
# Argument parsing
################################################################################
VERSION=""
NAME=""
TITLE=""
HEADING=""
MESSAGE=""
LOGO=""
FAVICON=""
OUTPUT="$SCRIPT_DIR/build"
ASSUME_YES=0

# Track which fields were supplied on the command line (so --yes knows what to
# change and interactive mode can skip prompting for them).
NAME_SET=0; TITLE_SET=0; HEADING_SET=0; MESSAGE_SET=0; VERSION_SET=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) VERSION="$2"; VERSION_SET=1; shift 2 ;;
    --name)    NAME="$2";    NAME_SET=1;    shift 2 ;;
    --title)   TITLE="$2";   TITLE_SET=1;   shift 2 ;;
    --heading) HEADING="$2"; HEADING_SET=1; shift 2 ;;
    --message) MESSAGE="$2"; MESSAGE_SET=1; shift 2 ;;
    --logo)    LOGO="$2";    shift 2 ;;
    --favicon) FAVICON="$2"; shift 2 ;;
    --output)  OUTPUT="$2";  shift 2 ;;
    -y|--yes)  ASSUME_YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*)        usage; fail_with_message "unknown option: $1" ;;
    *)         usage; fail_with_message "unexpected argument: $1" ;;
  esac
done

################################################################################
# Resolve fields (flag wins; else prompt unless --yes; empty answer = keep)
################################################################################
if [[ -z "$VERSION" ]]; then
  if [[ "$ASSUME_YES" -eq 0 ]]; then
    read -r -p "Manifest version to build? [v3/v2/both] (default: v3): " VERSION || true
  fi
  [[ -z "$VERSION" ]] && VERSION="v3"
fi

case "$VERSION" in
  v3)   VERSION_DIRS=("manifest_v3") ;;
  v2)   VERSION_DIRS=("manifest_v2") ;;
  both) VERSION_DIRS=("manifest_v3" "manifest_v2") ;;
  *)    fail_with_message "invalid --version '$VERSION' (expected v3, v2 or both)" ;;
esac

# For text fields, prompt only when interactive and not already given by flag.
if [[ "$ASSUME_YES" -eq 0 ]]; then
  [[ "$NAME_SET"    -eq 0 ]] && read -r -p "Extension name (leave empty to keep default): " NAME    && [[ -n "$NAME" ]]    && NAME_SET=1
  [[ "$TITLE_SET"   -eq 0 ]] && read -r -p "Block page tab title (empty = keep): "        TITLE   && [[ -n "$TITLE" ]]   && TITLE_SET=1
  [[ "$HEADING_SET" -eq 0 ]] && read -r -p "Block page heading (empty = keep): "          HEADING && [[ -n "$HEADING" ]] && HEADING_SET=1
  [[ "$MESSAGE_SET" -eq 0 ]] && read -r -p "Block page message (empty = keep): "          MESSAGE && [[ -n "$MESSAGE" ]] && MESSAGE_SET=1
  if [[ -z "$LOGO" ]]; then
    read -r -p "Path to a new logo image (empty = keep): " LOGO || true
  fi
  if [[ -z "$FAVICON" ]]; then
    read -r -p "Path to a new favicon (empty = keep): " FAVICON || true
  fi
fi

# Validate the image paths up front so we fail before writing anything.
if [[ -n "$LOGO" && ! -r "$LOGO" ]]; then
  fail_with_message "logo file not found or not readable: $LOGO"
fi
if [[ -n "$FAVICON" && ! -r "$FAVICON" ]]; then
  fail_with_message "favicon file not found or not readable: $FAVICON"
fi

################################################################################
# Pre-compute escaped replacements
################################################################################
NAME_REPL=""
[[ "$NAME_SET"    -eq 1 ]] && NAME_REPL="$(sed_escape_repl "$(json_escape "$NAME")")"
TITLE_REPL=""
[[ "$TITLE_SET"   -eq 1 ]] && TITLE_REPL="$(sed_escape_repl "$(html_escape "$TITLE")")"
HEADING_REPL=""
[[ "$HEADING_SET" -eq 1 ]] && HEADING_REPL="$(sed_escape_repl "$(html_escape "$HEADING")")"
MESSAGE_REPL=""
[[ "$MESSAGE_SET" -eq 1 ]] && MESSAGE_REPL="$(sed_escape_repl "$(html_escape "$MESSAGE")")"

################################################################################
# Build each selected version
################################################################################
for dir in "${VERSION_DIRS[@]}"; do
  src="$SCRIPT_DIR/$dir"
  dst="$OUTPUT/$dir"

  [[ -d "$src" ]] || fail_with_message "source directory missing: $src"

  rm -rf "$dst"
  mkdir -p "$dst"
  cp -R "$src/." "$dst/"

  manifest="$dst/manifest.json"
  page="$dst/block_page.html"

  [[ "$NAME_SET"    -eq 1 ]] && sed_i "s|\"name\": \".*\"|\"name\": \"$NAME_REPL\"|" "$manifest"
  [[ "$TITLE_SET"   -eq 1 ]] && sed_i "s|<title>.*</title>|<title>$TITLE_REPL</title>|" "$page"
  [[ "$HEADING_SET" -eq 1 ]] && sed_i "s|<h1>.*</h1>|<h1>$HEADING_REPL</h1>|" "$page"
  [[ "$MESSAGE_SET" -eq 1 ]] && sed_i "s|<p>.*</p>|<p>$MESSAGE_REPL</p>|" "$page"
  [[ -n "$LOGO" ]]          && cp "$LOGO" "$dst/dome-logo.png"
  [[ -n "$FAVICON" ]]       && cp "$FAVICON" "$dst/favicon.ico"

  info "built $dst"
done

info "done. Load the build unpacked via chrome://extensions (Developer mode -> Load unpacked)."
