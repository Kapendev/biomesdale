#!/bin/env sh

mods_dir="$HOME/.minecraft/mods"
temp="$mods_dir/temp.zip"

main() {
    url="$1"
    [ -z "$url" ] && echo "shbiomesdale [URL Address]" && exit
    for mod in $mods_dir/* ; do rm -rf $mod ; done
    echo '-.- > Downloading...'
    curl -# "$(curl -s $url | grep -o https://download.*.zip)" > "$temp"
    echo 'UwU > Extracting...'
    unzip -q "$temp" -d "$mods_dir"
    rm "$temp"
    echo 'OwO > Done!'
}

main "$1"
