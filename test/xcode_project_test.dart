import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rename_app/xcode_project.dart';

/// Writes a file with Windows line endings (CRLF), like `flutter create` does
/// on Windows, so the tests can check that line endings are kept.
void _write(String path, List<String> lines) {
  final file = File(path)..createSync(recursive: true);
  file.writeAsStringSync('${lines.join('\r\n')}\r\n');
}

/// Creates a small fake `ios` or `macos` folder with the files that mention
/// the Xcode project name in a real Flutter project.
void _createPlatformFolder(String folder) {
  _write('$folder/Runner.xcworkspace/contents.xcworkspacedata', [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<Workspace',
    '   version = "1.0">',
    '   <FileRef',
    '      location = "group:Runner.xcodeproj">',
    '   </FileRef>',
    '   <FileRef',
    '      location = "group:Pods/Pods.xcodeproj">',
    '   </FileRef>',
    '</Workspace>',
  ]);
  _write('$folder/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme', [
    '<BuildableReference',
    '   BuildableName = "Runner.app"',
    '   BlueprintName = "Runner"',
    '   ReferencedContainer = "container:Runner.xcodeproj">',
    '</BuildableReference>',
  ]);
  _write('$folder/Runner.xcodeproj/project.pbxproj', [
    '\t\t\tbuildConfigurationList = 1 /* Build configuration list for PBXProject "Runner" */;',
    '\t\t2 /* Build configuration list for PBXProject "Runner" */ = {',
  ]);
  _write('$folder/Runner/Info.plist', ['<plist>Runner</plist>']);
}

void main() {
  late Directory tempDir;
  late String ios;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('rename_app_xcode_test');
    ios = '${tempDir.path}/ios';
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('renames the project and workspace and updates their references',
      () async {
    _createPlatformFolder(ios);

    final renamed = await XcodeProject.rename(ios, 'MyApp');

    expect(renamed, isTrue);
    expect(Directory('$ios/Runner.xcodeproj').existsSync(), isFalse);
    expect(Directory('$ios/Runner.xcworkspace').existsSync(), isFalse);
    expect(Directory('$ios/MyApp.xcodeproj').existsSync(), isTrue);
    expect(Directory('$ios/MyApp.xcworkspace').existsSync(), isTrue);

    final workspace =
        File('$ios/MyApp.xcworkspace/contents.xcworkspacedata').readAsStringSync();
    expect(workspace, contains('group:MyApp.xcodeproj'));
    expect(workspace, isNot(contains('group:Runner.xcodeproj')));
    // Other projects in the workspace (like CocoaPods) are not touched.
    expect(workspace, contains('group:Pods/Pods.xcodeproj'));

    final scheme = File(
            '$ios/MyApp.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme')
        .readAsStringSync();
    expect(scheme, contains('container:MyApp.xcodeproj'));
    expect(scheme, isNot(contains('container:Runner.xcodeproj')));
    // The target and product names are not changed.
    expect(scheme, contains('BlueprintName = "Runner"'));
    expect(scheme, contains('BuildableName = "Runner.app"'));

    final pbxproj =
        File('$ios/MyApp.xcodeproj/project.pbxproj').readAsStringSync();
    expect(pbxproj, contains('PBXProject "MyApp"'));
    expect(pbxproj, isNot(contains('PBXProject "Runner"')));
  });

  test('keeps the CRLF line endings of the files it edits', () async {
    _createPlatformFolder(ios);

    await XcodeProject.rename(ios, 'MyApp');

    final files = [
      '$ios/MyApp.xcworkspace/contents.xcworkspacedata',
      '$ios/MyApp.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme',
      '$ios/MyApp.xcodeproj/project.pbxproj',
    ];
    for (final path in files) {
      final data = File(path).readAsStringSync();
      expect(data, contains('\r\n'), reason: path);
      expect(data.contains(RegExp(r'(?<!\r)\n')), isFalse, reason: path);
    }
  });

  test('does not touch the Runner folder', () async {
    _createPlatformFolder(ios);

    await XcodeProject.rename(ios, 'MyApp');

    expect(File('$ios/Runner/Info.plist').existsSync(), isTrue);
    expect(File('$ios/Runner/Info.plist').readAsStringSync(),
        '<plist>Runner</plist>\r\n');
  });

  test('changes nothing when the new name is already used', () async {
    _createPlatformFolder(ios);
    Directory('$ios/MyApp.xcodeproj').createSync();

    final renamed = await XcodeProject.rename(ios, 'MyApp');

    expect(renamed, isFalse);
    expect(Directory('$ios/Runner.xcodeproj').existsSync(), isTrue);
    expect(Directory('$ios/Runner.xcworkspace').existsSync(), isTrue);
  });

  test('does nothing when there is no Xcode project to rename', () async {
    Directory(ios).createSync(recursive: true);

    expect(await XcodeProject.rename(ios, 'MyApp'), isFalse);
  });

  test('does nothing when the project was already renamed', () async {
    _createPlatformFolder(ios);
    await XcodeProject.rename(ios, 'MyApp');

    expect(await XcodeProject.rename(ios, 'MyApp'), isFalse);
    expect(Directory('$ios/MyApp.xcodeproj').existsSync(), isTrue);
  });

  test('only accepts names that are safe to use', () {
    expect(XcodeProject.validateName('MyApp'), isNull);
    expect(XcodeProject.validateName('my_app-2'), isNull);

    expect(XcodeProject.validateName(''), isNotNull);
    expect(XcodeProject.validateName('My App'), isNotNull);
    expect(XcodeProject.validateName('a/b'), isNotNull);
    expect(XcodeProject.validateName('Runner'), isNotNull);
    expect(XcodeProject.validateName('runner'), isNotNull);
  });
}
