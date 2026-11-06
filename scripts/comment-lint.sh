#!/usr/bin/env bash
# Enforces COMMENTS.md on the C#, Java, Python, shell and PowerShell sources git tracks under the given root.
set -euo pipefail

cd "${1:-.}"

mapfile -t sources < <(
  git ls-files -- '*.cs' '*.java' '*.py' '*.sh' '*.ps1' '*.psm1' |
    grep -vE '(^|/)(gen|generated|obj|bin|target|node_modules)/' || true
)
[ "${#sources[@]}" -eq 0 ] && exit 0

failed=0

fail() {
  [ -z "$2" ] && return 0
  printf '%s\n%s\n\n' "$1" "$2"
  failed=1
}

with_extension() {
  local extension
  for extension in "$@"; do
    printf '%s\n' "${sources[@]}" | grep -E "\.${extension}\$" || true
  done
}

history_words='\b(used to|no longer|the old|until now|previously)\b'

mapfile -t slash_sources < <(with_extension cs java)
mapfile -t hash_sources < <(with_extension py sh ps1 psm1)

history=$(
  {
    [ "${#slash_sources[@]}" -gt 0 ] && grep -nE "(^|[^:])//.*${history_words}" "${slash_sources[@]}"
    [ "${#hash_sources[@]}" -gt 0 ] && grep -nE "(^|[[:space:]])#.*${history_words}" "${hash_sources[@]}"
  } || true
)
fail "Comments describe the current code; history belongs in the pull request or an ADR (COMMENTS.md rule 2):" \
  "$history"

# Attributes and annotations between the comment and the declaration are part of the declaration.
declarations=$(
  with_extension cs | while IFS= read -r file; do
    awk -v F="$file" '
      /^[ \t]*\/\/[^\/]/ { if (!run) start = FNR; run = 1; next }
      run && /^[ \t]*(\[|(public|internal|private|protected|static|sealed|partial|abstract|virtual|override|async|namespace|record|class|interface|enum|struct|file|readonly|required)[ \t])/ {
        print F ":" start
      }
      { run = 0 }' "$file"
  done
  with_extension java | while IFS= read -r file; do
    awk -v F="$file" '
      /^[ \t]*\/\/([^\/]|$)/ { if (!run) start = FNR; run = 1; next }
      run && /^[ \t]*(@[A-Za-z]|(public|protected|private|static|final|abstract|sealed|non-sealed|default|synchronized|native|class|interface|enum|record)[ \t])/ {
        print F ":" start
      }
      { run = 0 }' "$file"
  done
)
fail "A comment on a declaration is /// (C#) or Javadoc (Java), never // (COMMENTS.md, Shape):" "$declarations"

paragraphs=$(
  with_extension cs java | while IFS= read -r file; do
    awk -v F="$file" '
      /^[ \t]*\/\/([^\/]|$)/ { if (!run) start = FNR; run++; next }
      { if (run >= 3) print F ":" start " (" run " lines)"; run = 0 }
      END { if (run >= 3) print F ":" start " (" run " lines)" }' "$file"
  done
  with_extension py sh ps1 psm1 | while IFS= read -r file; do
    awk -v F="$file" '
      /^[ \t]*#!/ { run = 0; next }
      /^[ \t]*#/ { if (!run) start = FNR; run++; next }
      { if (run >= 3) print F ":" start " (" run " lines)"; run = 0 }
      END { if (run >= 3) print F ":" start " (" run " lines)" }' "$file"
  done
)
fail "A comment runs to three lines or more; move it to docs/ or an ADR and leave one line (COMMENTS.md rule 4):" \
  "$paragraphs"

exit "$failed"
