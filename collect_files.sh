#!/usr/bin/env bash
x=$1
y=$2
if ! command -v javac >/dev/null 2>&1; then
  apt-get update && apt-get install -y default-jdk
fi
javac C.java
java C "$x" "$y"
