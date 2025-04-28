#!/usr/bin/env bash
set -euo pipefail

md=""
if [[ ${1-} == --max_depth ]]; then
  md=$2
  shift 2
fi
src=$1
dst=$2
mkdir -p "$dst"

if [[ -n $md ]]; then
  find "$src" -maxdepth "$md" -type f -print0 | while IFS= read -r -d '' file; do
    name=$(basename "$file")
    base=${name%.*}
    ext=${name##*.}
    [[ $base == $name ]] && ext="" || ext=".$ext"
    target="$dst/$name"
    i=1
    while [[ -e $target ]]; do
      target="$dst/${base}${i}${ext}"
      ((i++))
    done
    cp "$file" "$target"
  done
else
  find "$src" -type f -print0 | while IFS= read -r -d '' file; do
    name=$(basename "$file")
    base=${name%.*}
    ext=${name##*.}
    [[ $base == $name ]] && ext="" || ext=".$ext"
    target="$dst/$name"
    i=1
    while [[ -e $target ]]; do
      target="$dst/${base}${i}${ext}"
      ((i++))
    done
    cp "$file" "$target"
  done
fi
