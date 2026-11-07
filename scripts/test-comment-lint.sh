#!/usr/bin/env bash
# Runs comment-lint.sh against every case in testdata/comment-lint and checks the verdict its directory name implies.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
status=0

for case_dir in "$here"/testdata/comment-lint/*/; do
  name=$(basename "$case_dir")
  work=$(mktemp -d)
  git -C "$work" init -q
  for fixture in "$case_dir"*.txt; do
    cp "$fixture" "$work/$(basename "${fixture%.txt}")"
  done
  git -C "$work" add -A

  if bash "$here/comment-lint.sh" "$work" >/dev/null; then verdict=pass; else verdict=fail; fi
  rm -rf "$work"

  expected=pass
  [[ "$name" == bad-* ]] && expected=fail
  if [ "$verdict" = "$expected" ]; then
    printf 'ok   %s (%s)\n' "$name" "$verdict"
  else
    printf 'FAIL %s: expected %s, got %s\n' "$name" "$expected" "$verdict"
    status=1
  fi
done

exit "$status"
