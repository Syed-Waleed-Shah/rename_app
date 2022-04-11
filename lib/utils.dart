import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

class Utils {
  static Future<bool> fileNotExists(String path) async {
    bool exists = await File(path).exists();
    return !exists;
  }

  static Future<void> saveFile(String filePath, String data) async {
    await File(filePath).writeAsString(data, flush: true);
  }

  static Future<void> renameAndroid(String filePath, String appName) async {
    printStartMessage("android");
    String data = await File(filePath).readAsString();
    XmlDocument document = XmlDocument.parse(data);
    var application =
        document.children.first.findAllElements('application').first;
    application.setAttribute('android:label', appName);

    await saveFile(filePath, document.toXmlString());
    printFinishMessage('android');
  }

  static Future<void> renameIOS(String filePath, String appName) async {
    printStartMessage('ios');

    String data = await File(filePath).readAsString();
    XmlDocument document = XmlDocument.parse(data);
    var keys = document
        .findElements('plist')
        .first
        .findElements('dict')
        .first
        .children;

    // Removing xml elements which are generated due to line breaks (this xml parser is creating xml element as 'XmlText' for line breaks)
    keys.removeWhere((element) => element is XmlText);
    for (int i = 0; i < keys.length; i++) {
      // Will be true if google is already configured
      if (keys[i].innerText == 'CFBundleDisplayName') {
        var value = XmlElement(XmlName('string'));
        value.innerText = appName;
        keys.removeAt(i + 1);
        keys.insert(i + 1, value);
      }
    }
    await saveFile(filePath, document.toXmlString(pretty: true));
    printFinishMessage('ios');
  }

  static Future<void> renameWeb(String filePath, String appName) async {
    printStartMessage('web');

    String data = await File(filePath).readAsString();
    Map<String, dynamic> document = jsonDecode(data);
    document.containsKey('name') ? document['name'] = appName : print('');
    document.containsKey('short_name')
        ? document['short_name'] = appName
        : print('');
    var encoder = const JsonEncoder.withIndent("     ");
    String prettified = encoder.convert(document);
    await saveFile(filePath, prettified);
    printFinishMessage('web');
  }

  static Future<void> renameWindows(String filePath, String appName) async {
    printStartMessage('windows');

    String data = await File(filePath).readAsString();
    var appNameLine = RegExp(r'set\(BINARY_NAME.*').firstMatch(data)?.group(0);
    if (appNameLine != null) {
      data = data.replaceAll(appNameLine, """set(BINARY_NAME "$appName")""");
    }
    await saveFile(filePath, data);
    printFinishMessage('windows');
  }

  static void printStartMessage(String platform) {
    print('🟡 STARTED RENAMING <${platform.toUpperCase()}> PROJECT');
  }

  static void printFinishMessage(String platform) {
    print('🟢 FINISHED RENAMING <${platform.toUpperCase()}> PROJECT\n');
  }

  static void printNoConfigFound(String platform) {
    print('🧐 NO CONFIGURATION FOUND FOR <${platform.toUpperCase()}> PROJECT');
  }
}
