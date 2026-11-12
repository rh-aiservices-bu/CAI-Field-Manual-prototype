#!/usr/bin/env sh
# Publication gate (AGENTS.md): the production build must succeed, and the
# only WARN it may emit is the known oink libsass deprecation. Any other WARN
# fails the gate. This is the single implementation used by CI
# (.github/workflows/github-pages.yaml, both build and pr-gate jobs) and is
# safe to run locally:
#
#   scripts/publication-gate.sh [extra hugo args...]
#
# Extra arguments are appended to the hugo command, e.g.:
#   scripts/publication-gate.sh --baseURL "https://example.invalid/site/"

set -eu

log=build-gate.log
trap 'rm -f "$log"' EXIT

# shellcheck disable=SC2086
hugo --cleanDestinationDir --gc --minify --environment production \
    --printPathWarnings "$@" >"$log" 2>&1 || {
    cat "$log"
    echo "::error::Publication gate failed: hugo build error" >&2
    exit 1
}
cat "$log"

if grep -i warn "$log" | grep -qv 'css.Sass: libsass'; then
    echo "::error::Publication gate failed: unexpected WARN output" >&2
    grep -i warn "$log" | grep -v 'css.Sass: libsass' >&2
    exit 1
fi

echo "publication gate OK"
