#!/bin/env sh

# Update the readme.

projects_dir='./projects'
readme='./README.md'

main() {
    echo '# Biomesdale

Download mods for Minecraft from MediaFire with your favorite programming language.
It downloads a zip file from MediaFire and extracts the content in .minecraft/mods.

## Languages
' > $readme

    for project_name in $(ls $projects_dir); do
        echo "- $project_name" >> $readme
    done
    echo >> $readme
    exit 0
}

main
