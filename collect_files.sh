#!/usr/bin/env bash
if [[ $1 == --max_depth ]]; then md=$2; shift 2; fi
id=$1; od=$2
mkdir -p "$od"
while IFS= read -r f; do
  r=${f#"$id"/}
  if [[ -n $md ]]; then
    d=$(awk -F/ '{print NF-1}'<<<"$r")
    if (( d<=md )); then p="$r"; else
      h=$(echo "$r"|cut -d/ -f1-"$md")
      p="$h/$(basename "$r")"
    fi
  else
    p=$(basename "$r")
  fi
  t="$od/$p"
  mkdir -p "$(dirname "$t")"
  bname=$(basename "$t")
  b=${bname%.*}; e=${bname##*.}; [[ $b == $e ]]&&e=""||e=".$e"
  dp=$(dirname "$t")
  c="$t"; n=1
  while [[ -e $c ]]; do c="$dp/${b}${n}${e}"; ((n++)); done
  cp "$f" "$c"
done < <(find "$id" -type f)
