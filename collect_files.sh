#!/usr/bin/env bash
if [[ $1 == --max_depth ]]; then md=$2; shift 2; fi
id=$1; od=$2
mkdir -p "$od"
while IFS= read -r f; do
  rel=${f#$id/}
  if [[ -n $md ]]; then
    depth=$(awk -F/ '{print NF}' <<< "$rel")
    if (( depth<=md )); then mkdir -p "$od/$(dirname "$rel")"; dest="$od/$rel"; else b=$(basename "$f"); dest="$od/$b"; fi
  else
    b=$(basename "$f"); dest="$od/$b"
  fi
  d=$(dirname "$dest")
  bn=$(basename "$dest")
  base=${bn%.*}; ext=${bn##*.}
  [[ $base == $ext ]] && ext="" || ext=".$ext"
  n=1; cur="$dest"
  while [[ -e $cur ]]; do
    cur="$d/${base}${n}${ext}"
    ((n++))
  done
  cp "$f" "$cur"
done < <(find "$id" -type f)
