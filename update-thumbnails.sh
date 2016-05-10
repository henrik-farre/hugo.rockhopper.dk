#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

SIZE="176x176"
BG_COLOR="#f4f4f4"

cd static/uploads/

for FILE in *.{jpg,png}; do
  convert "${FILE}" -resize "${SIZE}" -background "${BG_COLOR}" -gravity center -extent "${SIZE}" "thumbnails/${FILE}"
done
