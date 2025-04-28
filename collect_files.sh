#!/bin/bash

copy_file() {
    local src="$1"
    local dest_dir="$2"
    local name=$(basename "$src")
    local base="${name%.*}"
    local ext=""
    
    [[ "$name" == *.* ]] && ext=".${name##*.}"
    [ -n "$ext" ] && base="${name%.$ext}"
    
    local counter=1
    local dest="$dest_dir/$name"
    
    while [[ -e "$dest" ]]; do
        dest="$dest_dir/${base}_$counter$ext"
        ((counter++))
    done
    
    cp -p "$src" "$dest"
}

max_depth=0
input_dir=""
output_dir=""

if [[ "$1" == "--max_depth" ]]; then
    if [[ $# -ne 4 ]]; then
        echo "Usage: $0 [--max_depth <depth>] <input_dir> <output_dir>"
        exit 1
    fi
    max_depth="$2"
    input_dir="$3"
    output_dir="$4"
else
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 [--max_depth <depth>] <input_dir> <output_dir>"
        exit 1
    fi
    input_dir="$1"
    output_dir="$2"
fi

if [[ ! -d "$input_dir" ]]; then
    echo "Input directory does not exist: $input_dir"
    exit 1
fi

mkdir -p "$output_dir"

if [[ $max_depth -gt 0 ]]; then
    find_options=(-maxdepth "$max_depth")
else
    find_options=()
fi

find "$input_dir" -type f "${find_options[@]}" | while IFS= read -r file; do
    copy_file "$file" "$output_dir"
done
