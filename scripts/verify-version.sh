#!/usr/bin/env bash
# Verifies that both manifests carry the version implied by a release tag.
# Usage: scripts/verify-version.sh <vX.Y.Z>
#
# Used by the release workflow to fail fast when a tag does not match the
# committed manifest version (the source of truth). A leading 'v' and a
# pre-release suffix (e.g. -test) are stripped before comparing.
#
# SPDX-FileCopyrightText: (c) 2026 Ring Zero Desenvolvimento de Software LTDA
# SPDX-License-Identifier: MIT

set -euo pipefail

TAG="${1:?usage: $0 <vX.Y.Z>}"
EXPECTED="${TAG#v}"
EXPECTED="${EXPECTED%%-*}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

rc=0
for manifest in manifest_v3/manifest.json manifest_v2/manifest.json; do
  got="$(sed -nE 's/.*"version": *"([^"]+)".*/\1/p' "$manifest" | head -1)"
  if [[ "$got" != "$EXPECTED" ]]; then
    echo "error: $manifest has version '$got', expected '$EXPECTED' (from tag '$TAG')" >&2
    rc=1
  fi
done

if [[ "$rc" -eq 0 ]]; then
  echo "ok: both manifests are at version ${EXPECTED}"
fi
exit "$rc"
