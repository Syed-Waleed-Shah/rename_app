library rename_app;

import 'package:rename_app/constants.dart';
import 'package:rename_app/utils.dart';

class RenameApp {
  static Future<void> android(String android) async {
    if (await Utils.fileNotExists(androidManifestFile)) {
      Utils.printNoConfigFound('android');
      return;
    }

    if (android.isEmpty) {
      return;
    }

    await Utils.renameAndroid(androidManifestFile, android);
  }

  static Future<void> ios(String ios) async {
    List<String> iosPlistFiles = [
      iosPlistPath,
      iosDebugPlistPath,
      iosReleasePlistPath
    ];
    if (await Utils.filesNotExists(iosPlistFiles) || ios.isEmpty) {
      Utils.printNoConfigFound('ios');
      return;
    }

    if (ios.isEmpty) {
      return;
    }

    await Utils.renameAllIOS(iosPlistFiles, ios);
  }

  static Future<void> web(String web) async {
    if (await Utils.fileNotExists(webManifestPath)) {
      Utils.printNoConfigFound('web');
      return;
    }

    if (web.isEmpty) {
      return;
    }

    await Utils.renameWeb(webManifestPath, web);
  }

  static void mac(String mac) {}
  static Future<void> windows(String windows) async {
    if (await Utils.fileNotExists(windowsMainCppPath)) {
      Utils.printNoConfigFound('windows');
      return;
    }

    if (windows.isEmpty) {
      return;
    }

    await Utils.renameWindows(windowsMainCppPath, windows);
  }

  static Future<void> linux(String linux) async {
    if (await Utils.fileNotExists(linuxApplicationPath)) {
      Utils.printNoConfigFound('linux');
      return;
    }

    if (linux.isEmpty) {
      return;
    }

    await Utils.renameLinux(linuxApplicationPath, linux);
  }
}
