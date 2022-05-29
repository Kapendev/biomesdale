#!/bin/env python3

# Beta script. Not working...

import sys
import io
import re
import platform
import requests
import zipfile

# Get bytes of zip file.
def download(url):
    exp = "https://download.*.zip"
    match = re.search(
        exp,
        requests.get(url).content.decode()
    ).group()
    return requests.get(match).content

# Extract zip file to .minecraft/mods.
def extract(buffer):
    mods_dir = os.path.expanduser("~")
    if platform.system() != "Windows":
        mods_dir += "/.minecraft/mods"
    else:
        mods_dir += "\\AppData\\Roaming\\.minecraft\\mods"
    with zipfile.ZipFile(io.BytesIO(buffer)) as file:
        file.extractall(mods_dir)

def main():
    if len(sys.argv) > 1:
        try:
            print("Downloading...")
            buffer = download(sys.argv[1])
            print("Extracting...")
            extract(buffer)
            print("Done. Yeahhh boiiiiii!")
        except:
            print("Something failed. Try again.")
            return 1
    else:
        print("Usage: pybiomesdale [URL]")
    return 0

if __name__ == "__main__":
    sys.exit(main())
