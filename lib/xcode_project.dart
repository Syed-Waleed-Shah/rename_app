import 'dart:io';

import 'package:rename_app/utils.dart';

/// Renames the Xcode project (`Runner.xcodeproj`) and the Xcode workspace
/// (`Runner.xcworkspace`) of a Flutter app.
///
/// Only the project and the workspace are renamed. The `Runner` folder, the
/// `Runner` target and the `Runner` scheme keep their names, because Flutter
/// and this package both rely on them.
class XcodeProject {
  static const String _oldName = 'Runner';

  /// Platform folders (relative to the project root) that contain an Xcode
  /// project.
  static const List<String> platformFolders = ['ios', 'macos'];

  /// Returns an error message when [name] can not be used, otherwise null.
  static String? validateName(String name) {
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(name)) {
      return 'The Xcode project name can only contain letters, numbers, '
          '"_" and "-".';
    }
    if (name.toLowerCase() == _oldName.toLowerCase()) {
      return 'The new Xcode project name must be different from "$_oldName".';
    }
    return null;
  }

  /// Renames the Xcode project and workspace in every platform folder.
  static Future<void> renameAll(String name) async {
    final error = validateName(name);
    if (error != null) {
      Utils.logMessage('❌ $error');
      return;
    }
    for (final folder in platformFolders) {
      await rename(folder, name);
    }
  }

  /// Renames the Xcode project and workspace inside [platformFolder] (for
  /// example `ios`). Returns true when something was renamed.
  static Future<bool> rename(String platformFolder, String name) async {
    final oldProject = '$platformFolder/$_oldName.xcodeproj';
    final newProject = '$platformFolder/$name.xcodeproj';
    final oldWorkspace = '$platformFolder/$_oldName.xcworkspace';
    final newWorkspace = '$platformFolder/$name.xcworkspace';

    final hasOldProject = await Directory(oldProject).exists();
    final hasOldWorkspace = await Directory(oldWorkspace).exists();

    if (!hasOldProject) {
      if (await Directory(newProject).exists()) {
        Utils.logMessage(
            'ℹ️  $platformFolder: Xcode project is already named "$name".');
      } else {
        Utils.printNoConfigFound(platformFolder);
      }
      return false;
    }

    /// Check everything first, so nothing is changed if it can not be finished.
    if (await Directory(newProject).exists() ||
        (hasOldWorkspace && await Directory(newWorkspace).exists())) {
      Utils.logMessage('❌ $platformFolder: "$name.xcodeproj" or '
          '"$name.xcworkspace" already exists, nothing was changed.');
      return false;
    }

    await Directory(oldProject).rename(newProject);

    if (hasOldWorkspace) {
      await Directory(oldWorkspace).rename(newWorkspace);
      await _replaceInFile(
        '$newWorkspace/contents.xcworkspacedata',
        'group:$_oldName.xcodeproj',
        'group:$name.xcodeproj',
      );
    }

    final schemes = Directory('$newProject/xcshareddata/xcschemes');
    if (await schemes.exists()) {
      await for (final entity in schemes.list()) {
        if (entity is File && entity.path.endsWith('.xcscheme')) {
          await _replaceInFile(
            entity.path,
            'container:$_oldName.xcodeproj',
            'container:$name.xcodeproj',
          );
        }
      }
    }

    /// Only comments in this file mention the project name. Xcode updates them
    /// when the project is renamed by hand, so this does the same.
    await _replaceInFile(
      '$newProject/project.pbxproj',
      'PBXProject "$_oldName"',
      'PBXProject "$name"',
    );

    Utils.logMessage(
        '✅ $platformFolder: renamed Xcode project and workspace to "$name"');
    return true;
  }

  /// Replaces [from] with [to] as plain text, so the line endings of the file
  /// (LF or CRLF) are kept exactly as they were.
  static Future<void> _replaceInFile(
      String path, String from, String to) async {
    final file = File(path);
    if (!await file.exists()) {
      return;
    }
    final data = await file.readAsString();
    if (!data.contains(from)) {
      return;
    }
    await file.writeAsString(data.replaceAll(from, to), flush: true);
  }
}
