library rename_app;

import 'dart:io';

import 'package:rename_app/constants.dart';
import 'package:rename_app/rename_app.dart';
import 'package:rename_app/utils.dart';
import 'package:rename_app/xcode_project.dart';
import 'package:yaml/yaml.dart';

String? android;
String? ios;
String? web;
String? mac;
String? windows;
String? linux;
void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    final pubspecFile = File('pubspec.yaml');

    if (pubspecFile.existsSync()) {
      try {
        final content = pubspecFile.readAsStringSync();
        final yamlMap = loadYaml(content);

        final configName = yamlMap['config_name']?['name'];
        if (configName != null && configName is String) {
          Utils.logMessage("Using config_name from pubspec.yaml: $configName");
          arguments = ['all=$configName'];
        } else {
          Utils.logMessage(help);
          return;
        }
      } catch (e) {
        Utils.logMessage(help);
        return;
      }
    } else {
      Utils.logMessage(help);
      return;
    }
  }

  /// `xcode=<name>` renames the Xcode project and workspace. It is taken out
  /// of the arguments here, so it also works together with `all=<name>`.
  String? xcodeName;
  for (final arg in arguments) {
    if (arg.startsWith('xcode=')) {
      xcodeName = arg.substring('xcode='.length);
    }
  }
  arguments = arguments.where((arg) => !arg.startsWith('xcode=')).toList();

  if (xcodeName != null && arguments.isEmpty) {
    await XcodeProject.renameAll(xcodeName);
    return;
  }

  parseArguments(arguments);
  Utils.logMessage('📱 Android App Name: $android');
  Utils.logMessage('📱 IOS App Name: $ios');
  Utils.logMessage('💻 Web App Name: $web');
  // Utils.logMessage('🖥 MAC App Name: $mac');
  Utils.logMessage('💻 Windows App Name: $windows');
  Utils.logMessage('💻 Linux App Name: $linux\n\n');

  await RenameApp.android(android ?? '');
  await RenameApp.ios(ios ?? '');
  await RenameApp.web(web ?? '');
  // await RenameApp.mac(mac ?? '');
  await RenameApp.windows(windows ?? '');
  await RenameApp.linux(linux ?? '');

  if (xcodeName != null) {
    await XcodeProject.renameAll(xcodeName);
  }

  Utils.logMessage(
    "--------------------------------\n✅  RENAMED APPS SUCCESSFULLY!\n--------------------------------",
  );
}

void parseArguments(List<String> args) {
  for (var arg in args) {
    List<String> splitted = arg.split('=');
    if (splitted.length != 2) {
      Utils.logMessage(help);
      return;
    }
    if (splitted.first == "all") {
      android = splitted.last;
      ios = splitted.last;
      web = splitted.last;
      mac = splitted.last;
      windows = splitted.last;
      linux = splitted.last;
      return;
    }
    if (splitted.first == "android") {
      android = splitted.last;
    }
    if (splitted.first == "ios") {
      ios = splitted.last;
    }
    if (splitted.first == "web") {
      web = splitted.last;
    }
    if (splitted.first == "mac") {
      mac = splitted.last;
    }
    if (splitted.first == "windows") {
      windows = splitted.last;
    }
    if (splitted.first == "linux") {
      linux = splitted.last;
    }
    if (splitted.first == "others") {
      android = android ?? splitted.last;
      ios = ios ?? splitted.last;
      web = web ?? splitted.last;
      mac = mac ?? splitted.last;
      windows = windows ?? splitted.last;
      linux = linux ?? splitted.last;
    }
  }
}
