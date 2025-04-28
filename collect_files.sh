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

find "$src" -type f -print0 | while IFS= read -r -d '' file; do

  rel=${file#"$src"/}
  IFS=/ read -ra parts <<< "$rel"
  fname=${parts[-1]}
  dircount=$(( ${#parts[@]} - 1 ))

  if [[ -n $md ]]; then
    if (( dircount < md )); then
      keep=$dircount
    else
      keep=$md
    fi
  else
    keep=$dircount
  fi

  if (( keep > 0 )); then
    subdir=$(IFS=/; echo "${parts[@]:0:keep}")
    destdir="$dst/$subdir"
  else
    destdir="$dst"
  fi
  mkdir -p "$destdir"

  base=${fname%.*}
  ext=${fname##*.}
  if [[ $base == $fname ]]; then
    ext=""
  else
    ext=".$ext"
  fi
  dest="$destdir/$fname"
  i=1
  while [[ -e $dest ]]; do
    dest="$destdir/${base}${i}${ext}"
    ((i++))
  done

  cp "$file" "$dest"
done
