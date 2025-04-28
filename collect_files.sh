#!/usr/bin/env bash
set -euo pipefail
md=""
if [[ ${1-} == --max_depth ]]; then md=$2; shift 2; fi
id=$1; od=$2
mkdir -p "$od"
find "$id" -type f -print0 | while IFS= read -r -d '' f; do
  r=${f#"$id"/}
  if [[ -n $md ]]; then
    IFS=/ read -ra a <<< "$r"
    n=${#a[@]}
    file=${a[n-1]}
    dcount=$((n-1))
    if (( dcount > md )); then
      keep=$md
    else
      keep=$dcount
    fi
    if (( keep > 0 )); then
      dirs=( "${a[@]:0:keep}" )
      rel="$(IFS=/; echo "${dirs[*]}")/$file"
    else
      rel="$file"
    fi
  else
    rel=${r##*/}
  fi
  dst="$od/$rel"
  mkdir -p "$(dirname "$dst")"
  base=${dst%.*}; ext=${dst##*.}
  if [[ $base == $dst ]]; then ext=""; else ext=".$ext"; fi
  cur="$dst"; i=1
  while [[ -e $cur ]]; do
    cur="${base}${i}${ext}"
    ((i++))
  done
  cp "$f" "$cur"
done
