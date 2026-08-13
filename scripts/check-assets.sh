#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026, SinoLink Deutschland
# Author: Aravinth Panch <ara@aracreate.group>
# Description: This file contains the static-site check that every asset and page path referenced from src/ resolves on disk

set -uo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../src" && pwd)"
missing=0
checked=0

# Pull every local path out of an HTML or CSS file:
#   HTML: src="…", href="…", data-poster-url="…", data-video-urls="…", content="…"
#   CSS : url(…)
extract_paths() {
  local file="$1"
  case "$file" in
    *.css)
      grep -o "url(['\"]\?[^)'\"]*['\"]\?)" "$file" \
        | sed -E "s/^url\(['\"]?//; s/['\"]?\)$//"
      ;;
    *)
      grep -oE '(src|href|data-poster-url|data-video-urls|content)="[^"]*"' "$file" \
        | sed -E 's/^[a-z-]+="//; s/"$//' \
        | tr ',' '\n'
      ;;
  esac
}

while IFS= read -r file; do
  base_dir="$(dirname "$file")"
  while IFS= read -r ref; do
    # Skip anything that is not a local file reference.
    [ -z "$ref" ] && continue
    case "$ref" in
      http://*|https://*|//*|data:*|mailto:*|tel:*|\#*|javascript:*) continue ;;
    esac
    ref="${ref%%\#*}"          # drop fragment
    ref="${ref%%\?*}"          # drop query string
    [ -z "$ref" ] && continue
    # Only check things that look like files we ship.
    case "$ref" in
      *.html|*.css|*.js|*.png|*.jpg|*.jpeg|*.svg|*.ico|*.webp|*.mp4|*.woff2|*.woff|*.xml|*.txt) ;;
      *) continue ;;
    esac

    if [ "${ref#/}" != "$ref" ]; then
      target="$SRC_DIR$ref"    # root-relative: resolve against the document root
    else
      target="$base_dir/$ref"
    fi

    checked=$((checked + 1))
    if [ ! -f "$target" ]; then
      echo "MISSING  ${file#"$SRC_DIR"/} -> $ref"
      missing=$((missing + 1))
    fi
  done < <(extract_paths "$file")
done < <(find "$SRC_DIR" -type f \( -name '*.html' -o -name '*.css' \))

echo "----------------------------------------------------------------"
echo "Checked $checked references, $missing missing."
[ "$missing" -eq 0 ] || exit 1
echo "All asset references resolve."
