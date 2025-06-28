/// Constants file for file paths.

/// Help string
const help =
    """XXX PLEASE PROVIDE THE APP NAME XXX\n\nYou can provide app name in the following ways\n1) Same name for all apps\n\t>  flutter pub run rename_app:main all="My App Name"\n2) Seperate name for specified platform(s) and same for all others\n\t> flutter pub run rename_app:main android="Anroid Name" ios="IOS Name" others="Others Name"\n3) Seperate name for each platform\n\t> flutter pub run rename_app:main android="Android Name" ios="IOS Name" web="Web Name" mac="Mac Name" windows="Windows Name" """;
/// File path of AndroidManifest.xml
const androidManifestFile = "android/app/src/main/AndroidManifest.xml";
/// File path of Info.plist
const iosPlistPath = "ios/Runner/Info.plist";
/// File path of Info-Debug.plist
const iosDebugPlistPath = "ios/Runner/Info-Debug.plist";
/// File path of Info-Release.plist
const iosReleasePlistPath = "ios/Runner/Info-Release.plist";
/// File path of web/maniafest.json for web.
const webManifestPath = "web/manifest.json";
/// File path of windows/runner/main.cpp for windows.
const windowsMainCppPath = "windows/runner/main.cpp";
/// File path of linux/runner/my_application.cc for linux.
const linuxApplicationPath = "linux/runner/my_application.cc";
