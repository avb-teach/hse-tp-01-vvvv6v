#!/usr/bin/env bash
set -euo pipefail
md=1
if [[ ${1-} == --max_depth ]]; then md=$2; shift 2; fi
src=$1; dst=$2
mkdir -p "$dst"
find "$src" -type f -print0 | while IFS= read -r -d '' f; do
  rel=${f#"$src"/}
  IFS=/ read -ra p <<< "$rel"
  n=${#p[@]}
  if (( n>md )); then
    start=$((n-md))
    np=( "${p[@]:start:md}" )
  else
    np=( "${p[@]}" )
  fi
  new=$(IFS=/; echo "${np[*]}")
  dest="$dst/$new"
  dir=$(dirname "$dest")
  mkdir -p "$dir"
  name="${np[-1]}"
  base="${name%.*}"
  ext="${name##*.}"
  if [[ $base == $name ]]; then ext=""; else ext=".$ext"; fi
  out="$dir/$name"
  i=1
  while [[ -e $out ]]; do
    out="$dir/${base}${i}${ext}"
    ((i++))
  done
  cp "$f" "$out"
done
