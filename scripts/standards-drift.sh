#!/usr/bin/env bash
# Fails when a repository's copy of a shared standards file differs from the canonical copy in delphi-modernizer/.github.
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: standards-drift.sh <standards-checkout> <local-path=canonical-path>..." >&2
  exit 2
fi

standards=$1
shift
failed=0

for pair in "$@"; do
  local_path=${pair%%=*}
  canonical_path=$standards/${pair#*=}

  if [ ! -f "$canonical_path" ]; then
    printf 'unknown canonical file: %s\n' "${pair#*=}" >&2
    exit 2
  fi

  if [ ! -f "$local_path" ]; then
    printf 'missing: %s (copy %s from delphi-modernizer/.github)\n' "$local_path" "${pair#*=}"
    failed=1
    continue
  fi

  if ! diff -u "$canonical_path" "$local_path"; then
    printf 'drift: %s differs from %s in delphi-modernizer/.github\n\n' "$local_path" "${pair#*=}"
    failed=1
  fi
done

exit "$failed"
