#!/usr/bin/env bash
set -euo pipefail
mdirs=-1
if [[ $# -ge 3 && $1 == --max_depth ]]; then
  m=$2
  if ! [[ $m =~ ^[0-9]+$ && $m -ge 1 ]]; then exit 1; fi
  mdirs=$((m-1))
  shift 2
fi
[[ $# -eq 2 ]] || exit 1
in=$1; out=$2
mkdir -p "$out"
find "$in" -type f -print0 | while IFS= read -r -d '' f; do
  rel=${f#"$in"/}
  IFS=/ read -ra p <<< "$rel"
  len=${#p[@]}; fn=${p[len-1]}; dc=$((len-1))
  if (( mdirs>=0 )); then
    if (( dc<=mdirs )); then kd=$dc; si=0; else kd=$mdirs; si=$((dc-kd)); fi
  else
    kd=$dc; si=0
  fi
  if (( kd>0 )); then
    sd=( "${p[@]:si:kd}" )
    sub=$(IFS=/; echo "${sd[*]}")
    dd="$out/$sub"
  else
    dd="$out"
  fi
  mkdir -p "$dd"
  bn=${fn%.*}; ex=${fn##*.}
  [[ $bn == $fn ]] && e="" || e=".$ex"
  dest="$dd/$bn$e"; i=1
  while [[ -e $dest ]]; do dest="$dd/${bn}${i}${e}"; ((i++)); done
  cp "$f" "$dest"
done
