import modules;

ubyte[] download(string url) {
    auto msg = "Wrong URL address.";
    try {
        auto content = get(url);
        auto urlReg = regex("https://download.*.zip");
        auto match = matchFirst(content, urlReg);
        if (match) {
            return get!(AutoProtocol, ubyte)(match[0]);
        } else {
            throw new CurlException(msg);
        }
    } catch (CurlException e) {
        throw new CurlException(msg);
    }
}

void extract(ubyte[] data, string path) {
    foreach (name; dirEntries(path, SpanMode.shallow)) {
        remove(name);
    }

    auto zip = new ZipArchive(data);
    foreach (name, am; zip.directory) {
        write(path ~ name, zip.expand(am));
    }
}

void main(string[] args) {
    if (args.length != 2) {
        writeln(args[0], " (URL address)");
    } else {
        string path;
        version (Posix) {
            path = expandTilde("~/.minecraft/mods/");
        }
        version (Windows) {
            const auto user = "C:\\Users\\" ~ environment.get("USERNAME");
            path = user ~ "\\AppData\\Roaming\\.minecraft\\mods\\";
        }

        if (exists(path)) {
            try {
                writeln("Downloading...");
                auto content = download(args[1]);
                writeln("Extracting...");
                extract(content, path);
                writeln("Done.");
            } catch (CurlException e) {
                writeln(e.msg);
            }
        } else {
            writeln("\"", path, "\" doesn't exist.");
        }
    }
}
