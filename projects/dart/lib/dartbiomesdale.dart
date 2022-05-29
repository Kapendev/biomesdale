import 'dart:io' show Platform, Directory;
import 'dart:typed_data' show Uint8List;
import 'package:archive/archive_io.dart' as archive;
import 'package:http/http.dart' as http;

Future<Uint8List> download(String url) async {
  try {
    var response1 = await http.get(Uri.parse(url));
    var exp = RegExp('https://download.*.zip');
    var matches = exp.allMatches(response1.body);
    var zipUrl = matches.first.group(0) ?? '';
    return (http.readBytes(Uri.parse(zipUrl)));
  } catch (e) {
    rethrow;
  }
}

String getModsDir() {
  String dir = '';
  if (Platform.isLinux || Platform.isMacOS) {
    dir = '${Platform.environment['HOME']}/.minecraft/mods';
  } else if (Platform.isWindows) {
    dir =
        '${Platform.environment['USERPROFILE']}\\AppData\\Roaming\\.minecraft\\mods';
  }
  return dir;
}

void clear(String dir) {
  for (var file in Directory(dir).listSync()) {
    file.delete(recursive: true);
  }
}

void extract(Uint8List bytes, String dir) async {
  if (await Directory(dir).exists()) {
    var zip = archive.ZipDecoder().decodeBytes(bytes);
    archive.extractArchiveToDisk(zip, dir);
  } else {
    throw Exception();
  }
}
