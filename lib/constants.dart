const HELP =
    """XXX PLEASE PROVIDE THE APP NAME XXX\n\nYou can provide app name in the following ways\n1) Same name for all apps\n\t>  flutter pub run rename_app:main all="My App Name"\n2) Seperate name for specified platform(s) and same for all others\n\t> flutter pub run rename_app:main android="Anroid Name" ios="IOS Name" others="Others Name"\n3) Seperate name for each platform\n\t> flutter pub run rename_app:main android="Android Name" ios="IOS Name" web="Web Name" mac="Mac Name" windows="Windows Name" """;

const ANDROID_MANIFEST_PATH = "android/app/src/main/AndroidManifest.xml";
const IOS_PLIST_PATH = "ios/Runner/Info.plist";
const WEB_MANIFEST_PATH = "web/manifest.json";
const WINDOWS_CMAKE_LISTS_PATH = "windows/CMakeLists.txt";
