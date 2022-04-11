library rename_app;

import 'package:rename_app/constants.dart';
import 'package:rename_app/utils.dart';

class RenameApp {
  static Future<void> android(String android) async {
    if (await Utils.fileNotExists(ANDROID_MANIFEST_PATH)) {
      Utils.printNoConfigFound('android');
      return;
    }

    if (android.isEmpty) {
      return;
    }

    await Utils.renameAndroid(ANDROID_MANIFEST_PATH, android);
  }

  static Future<void> ios(String ios) async {
    if (await Utils.fileNotExists(IOS_PLIST_PATH) || ios.isEmpty) {
      Utils.printNoConfigFound('ios');
      return;
    }

    if (ios.isEmpty) {
      return;
    }

    await Utils.renameIOS(IOS_PLIST_PATH, ios);
  }

  static Future<void> web(String web) async {
    if (await Utils.fileNotExists(WEB_MANIFEST_PATH)) {
      Utils.printNoConfigFound('web');
      return;
    }

    if (web.isEmpty) {
      return;
    }

    await Utils.renameWeb(WEB_MANIFEST_PATH, web);
  }

  static void mac(String mac) {}
  static Future<void> windows(String windows) async {
    if (await Utils.fileNotExists(WINDOWS_CMAKE_LISTS_PATH)) {
      Utils.printNoConfigFound('windows');
      return;
    }

    if (windows.isEmpty) {
      return;
    }

    await Utils.renameWindows(WINDOWS_CMAKE_LISTS_PATH, windows);
  }
}
