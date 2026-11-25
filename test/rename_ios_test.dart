import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rename_app/utils.dart';
import 'package:xml/xml.dart';

const _header = '<?xml version="1.0" encoding="UTF-8"?>\n'
    '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" '
    '"http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n';

String _plist(Map<String, String> entries) {
  final body = entries.entries
      .map((e) => '\t<key>${e.key}</key>\n\t<string>${e.value}</string>')
      .join('\n');
  return '$_header<plist version="1.0">\n<dict>\n$body\n</dict>\n</plist>\n';
}

/// Returns the string value that follows [key] in the plist's top level dict.
String? _valueOf(String plistXml, String key) {
  final dict = XmlDocument.parse(plistXml)
      .findElements('plist')
      .first
      .findElements('dict')
      .first;
  final items = dict.children.whereType<XmlElement>().toList();
  for (var i = 0; i < items.length - 1; i++) {
    if (items[i].name.local == 'key' && items[i].innerText == key) {
      return items[i + 1].innerText;
    }
  }
  return null;
}

void main() {
  late Directory tempDir;
  late String plistPath;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('rename_app_ios_test');
    plistPath = '${tempDir.path}${Platform.pathSeparator}Info.plist';
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('changes CFBundleDisplayName and leaves CFBundleName untouched',
      () async {
    File(plistPath).writeAsStringSync(_plist({
      'CFBundleDisplayName': 'Example',
      'CFBundleName': 'example',
      'CFBundleIdentifier': r'$(PRODUCT_BUNDLE_IDENTIFIER)',
    }));

    await Utils.renameIOS(plistPath, 'My New App');

    final result = File(plistPath).readAsStringSync();
    expect(_valueOf(result, 'CFBundleDisplayName'), 'My New App');
    expect(_valueOf(result, 'CFBundleName'), 'example');
    expect(_valueOf(result, 'CFBundleIdentifier'),
        r'$(PRODUCT_BUNDLE_IDENTIFIER)');
  });

  test(r'keeps CFBundleName as $(PRODUCT_NAME) when it uses the variable',
      () async {
    File(plistPath).writeAsStringSync(_plist({
      'CFBundleDisplayName': 'Example',
      'CFBundleName': r'$(PRODUCT_NAME)',
    }));

    await Utils.renameIOS(plistPath, 'My New App');

    final result = File(plistPath).readAsStringSync();
    expect(_valueOf(result, 'CFBundleName'), r'$(PRODUCT_NAME)');
  });

  test('adds CFBundleDisplayName when the plist does not have one', () async {
    File(plistPath).writeAsStringSync(_plist({
      'CFBundleName': 'example',
    }));

    await Utils.renameIOS(plistPath, 'My New App');

    final result = File(plistPath).readAsStringSync();
    expect(_valueOf(result, 'CFBundleDisplayName'), 'My New App');
    expect(_valueOf(result, 'CFBundleName'), 'example');
  });
}
