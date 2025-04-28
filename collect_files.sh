#!/usr/bin/env bash
set -euo pipefail
md=""
if [[ $1 == --max_depth ]]; then md=$2; shift 2; fi
in=$1; out=$2
mkdir -p "$out"
while IFS= read -r -d '' f; do
  rel=${f#"$in"/}
  if [[ -n $md ]]; then
    IFS=/ read -ra parts <<< "$rel"
    len=${#parts[@]}
    dirs=$((len-1))
    if (( dirs > md )); then
      head=("${parts[@]:0:md}")
      file=${parts[len-1]}
      rel=$(IFS=/; echo "${head[*]}")/"$file"
    fi
  else
    rel=${rel##*/}
  fi
  dst="$out/$rel"
  mkdir -p "$(dirname "$dst")"
  base=${dst%.*}; ext=${dst##*.}
  [[ $base == $dst ]] && ext="" || ext=".$ext"
  n=1; cur=$dst
  while [[ -e $cur ]]; do
    cur="${base}${n}${ext}"
    ((n++))
  done
  cp "$f" "$cur"
done < <(find "$in" -type f -print0)
