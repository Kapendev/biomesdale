#!/bin/env sh

path="$HOME/.minecraft/mods"
filepath="$path/mods.zip"

[ -z "$1" ] && echo "$0 (URL Address)" && exit
echo 'UwU > Downloading < UwU'
rm -f "$path/"*.jar
curl "$(curl $1 | grep -o 'https://download.*.zip')" > "$filepath"
echo 'UwU > Extracting < UwU'
unzip -d "$path" "$filepath"
rm "$filepath"
echo 'UwU > Done < UwU'
