#!/usr/bin/env bash
set -euo pipefail
md=""
if [[ $1 == --max_depth ]]; then md=$2; shift 2; fi
id=$1; od=$2
mkdir -p "$od"
while IFS= read -r -d '' f; do
  r=${f#"$id"/}
  if [[ -n $md ]]; then
    IFS=/ read -ra a <<< "$r"
    l=${#a[@]}
    if (( l > md )); then
      s=$((l - md))
      a=("${a[@]:s:md}")
    fi
    r=$(IFS=/; echo "${a[*]}")
  else
    r=${r##*/}
  fi
  t="$od/$r"
  mkdir -p "$(dirname "$t")"
  b="${t%.*}"; x="${t##*.}"
  [[ $b == $t ]] && x="" || x=".$x"
  c="$t"; n=1
  while [[ -e $c ]]; do
    c="${b}${n}${x}"
    ((n++))
  done
  cp "$f" "$c"
done < <(find "$id" -type f -print0)
