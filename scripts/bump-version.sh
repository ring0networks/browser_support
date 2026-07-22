#!/usr/bin/env bash
# Bumps the version of both manifests to a given value.
# Usage: scripts/bump-version.sh <X.Y.Z>   (a leading 'v' is tolerated)
#
# Run this before tagging a release, then commit as "chore: release vX.Y.Z"
# and `git tag vX.Y.Z`. The committed manifest version is the source of truth;
# the release workflow verifies the tag matches it.
#
# SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
# SPDX-License-Identifier: GPL-2.0-only

set -euo pipefail

VERSION="${1:?usage: $0 <X.Y.Z>}"
VERSION="${VERSION#v}"

# Chrome manifest versions are 1-4 dot-separated integers.
if [[ ! "$VERSION" =~ ^[0-9]+(\.[0-9]+){0,3}$ ]]; then
  echo "error: invalid version '$VERSION' (expected 1-4 dot-separated integers)" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

for manifest in manifest_v3/manifest.json manifest_v2/manifest.json; do
  sed "s|\"version\": \"[^\"]*\"|\"version\": \"${VERSION}\"|" \
    "$manifest" > "$manifest.tmp"
  mv "$manifest.tmp" "$manifest"
done

echo "bumped manifest_v3 and manifest_v2 to version ${VERSION}"
