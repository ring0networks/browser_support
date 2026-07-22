#!/usr/bin/env bash
# Produces a release tarball for a given version.
# Usage: scripts/package.sh <version>
#
# Bundles the shippable extension: the two manifest_* directories plus
# README.md, LICENSE and customize.sh. Development/CI files (.git, .github,
# scripts/, cliff.toml, .gitignore, CLAUDE.md, build/) are excluded.
# Manifests are bundled as committed — the release workflow verifies the tag
# matches the committed version beforehand.
#
# SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
# SPDX-License-Identifier: GPL-2.0-only

set -euo pipefail

VERSION="${1:?usage: $0 <version>}"

# Path-safety: the version becomes part of file names.
if [[ ! "$VERSION" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "error: invalid version '$VERSION' (allowed: A-Z a-z 0-9 . _ -)" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

BUNDLE_NAME="ringzero-dome-browser-extension-${VERSION}"
OUT="${BUNDLE_NAME}.tar.gz"

STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT
DEST="$STAGING/$BUNDLE_NAME"
mkdir -p "$DEST"

# Stage the whole tree except VCS/CI metadata and build output.
rsync -a \
  --exclude='.git' \
  --exclude='.github' \
  --exclude='scripts' \
  --exclude='cliff.toml' \
  --exclude='.gitignore' \
  --exclude='CLAUDE.md' \
  --exclude='build' \
  --exclude='*.tar.gz' \
  ./ "$DEST/"

tar -czf "$OUT" -C "$STAGING" "$BUNDLE_NAME"
echo "created $OUT"
