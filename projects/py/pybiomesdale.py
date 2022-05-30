#!/bin/env python3

# Downdownload zip for Minecaf from MeFire.

import glob
import io
import os
import platform
import re
import requests
import shutil
import sys
import zipfile

# Get bytes of zip file from URL.
def download(url):
    match = re.search(
        "https://download.*.zip",
        requests.get(url).content.decode()
    ).group()
    return requests.get(match).content

# Get the mods directory.
def get_mods_dir():
    mods_dir = os.path.expanduser("~")
    if platform.system() != "Windows":
        mods_dir += "/.minecraft/mods"
    else:
        mods_dir += "\\AppData\\Roaming\\.minecraft\\mods"
    return mods_dir

# Extract zip file to .minecraft/mods.
def extract(buffer):
    with zipfile.ZipFile(io.BytesIO(buffer)) as file:
        file.extractall(get_mods_dir())

# Delete the files in the mods directory.
def clear():
    mods_dir = get_mods_dir()
    if platform.system() != "Windows":
        mods_dir += "/*"
    else:
        mods_dir += "\\*"
    
    for file_path in glob.glob(mods_dir):
        if os.path.isdir(file_path):
            shutil.rmtree(file_path)
        else:
            os.remove(file_path)

def main():
    if len(sys.argv) > 1:
        url = sys.argv[1]
        try:
            clear()
            print("Downloading...")
            buffer = download(url)
            print("Extracting...")
            extract(buffer)
            print("Done boiiiiii!")
        except:
            print("Something failed. Try again.")
            return 1
    else:
        print("Usage: pybiomesdale [URL]")
    return 0

if __name__ == "__main__":
    sys.exit(main())
