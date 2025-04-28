#!/usr/bin/env bash
set -euo pipefail
md=1
declare -a pos
while (($#)); do
  case $1 in
    --max_depth) md=$2; shift 2 ;;
    *) pos+=("$1"); shift ;;
  esac
done
src=${pos[0]}; dst=${pos[1]}
mkdir -p "$dst"
find "$src" -type f -print0 | while IFS= read -r -d '' f; do
  r=${f#"$src"/}
  IFS=/ read -ra a <<< "$r"
  n=${#a[@]}
  if (( md>0 && n>md )); then
    s=$((n-md))
    b=("${a[@]:s:md}")
  else
    b=("${a[@]}")
  fi
  pp=$(IFS=/; echo "${b[*]}")
  dir=$(dirname "$pp")
  td="$dst/$dir"
  mkdir -p "$td"
  name=${b[-1]}
  bn=${name%.*}; ex=${name##*.}
  [[ $bn == $name ]] && ext="" || ext=".$ex"
  out="$td/$bn$ext"; i=1
  while [[ -e $out ]]; do
    out="$td/${bn}${i}${ext}"
    ((i++))
  done
  cp "$f" "$out"
done
