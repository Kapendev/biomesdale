import 'dart:io' show Platform;
import 'package:dartbiomesdale/dartbiomesdale.dart';

void main(List<String> arguments) async {
  var name = Platform.localHostname;
  var modsDir = getModsDir();
  if (arguments.length == 1) {
    try {
      clear(modsDir);
      print('Downloading...');
      var file = await download(arguments[0]);
      print('Extractiing...');
      extract(file, modsDir);
      print('Done! Thank you $name for using this script.');
    } catch (e) {
      print('Something failed. Try again.');
    }
  } else {
    print('Usage: dartbiomesdale [URL]');
  }
}
