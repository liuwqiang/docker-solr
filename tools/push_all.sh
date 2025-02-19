#!/bin/bash
#
# Push all images
#
# Usage: push_all.sh

set -euo pipefail
TOP_DIR="$(readlink -f "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/..")"
cd "$TOP_DIR"

IMAGE="dockersolr/docker-solr"

full_version_variants=$(awk --field-separator ':' '{print $2}' "$TOP_DIR/TAGS")
for full_version_variant in $full_version_variants; do
  readarray -t tags < <(awk --field-separator ':' '$2 == "'"$full_version_variant"'" {print $3}' "$TOP_DIR/TAGS")

  ./tools/push.sh "$IMAGE:$full_version_variant"
  for tag in ${tags[*]}; do
    ./tools/push.sh "$IMAGE:$tag"
  done
done
