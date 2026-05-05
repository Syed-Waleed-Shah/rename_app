[![Stand With Palestine](https://raw.githubusercontent.com/TheBSD/StandWithPalestine/main/banner-no-action.svg)](https://thebsd.github.io/StandWithPalestine)

# Rename App

### The only flutter package which changes app name for all platforms with sound null safety!

``If you want to autmatically change your flutter app name with a single command then you are at the right pacakge. This package gives you too many flexibilities through too many variants of its commands. Read the details below to know in more details``

- ✊  Dont forget to star the github repo if you found this package useful 😇

Developer : [Syed Waleed Shah](https://www.linkedin.com/in/syed-waleed-shah/ "LinkedIn Profile") ( [LinkedIn](https://www.linkedin.com/in/syed-waleed-shah/ "LinkedIn Profile")  [Github](https://github.com/Syed-Waleed-Shah "Github Profile")  [StackOverflow](https://stackoverflow.com/users/15212735/syed-waleed "StackOverflow Profile") )

Please Contribute : [Github Repository](https://github.com/Syed-Waleed-Shah "Github Repository")

Honourable Contributors:

1. [Finn Drünert](https://github.com/Finnomator "Github Profile") ( [Github](https://github.com/Finnomator "Github Profile") )
2. [nhan7777](https://github.com/nhan7777 "https://github.com/nhan7777") ( [Github](https://github.com/nhan7777) )
3. [Harsh Yadav](https://github.com/harshyadavDeveloper "Github Profile") ( [Github](https://github.com/harshyadavDeveloper "Github Profile") )

## Features 🔥

✅  Rename Android Project

✅  Rename IOS Project

✅  Rename WEB Project

✅  Rename Windows Project

✅  Rename Linux Project

## What rename_app does

`rename_app` is a command-line helper you run against a **Flutter app project**. From the **project root** (the folder where your app’s `pubspec.yaml` lives), it edits the platform files that expose the launcher / UI **display name**. For example: Android (`AndroidManifest.xml` label), iOS (`Info.plist` and variants when present), Web (`manifest.json`), Windows runner sources, and Linux application metadata.

It does **not** automatically change strings inside your Dart code (such as `MaterialApp(title: …)`): that stays up to you. For each platform, if the expected config file is missing or you pass an empty name for that platform, that platform is skipped and a short message may be logged.

Arguments like `android="..."` only update Android; omitting others leaves those platforms untouched. **`all="..."`** and **`config_name.name`** apply the **same name** across Android, iOS, Web, Windows, and Linux in one shot.

macOS renaming is currently not wired in the tool (`mac` CLI is listed for compatibility).

## How To Rename ? 🛠

##### 1) ADD THE PACKAGE TO YOUR pubspec.yaml

You only need the package to run `dart run rename_app:main`, so **`dev_dependency` is typical** for an app:

```sh
dart pub add rename_app --dev
```

Alternatively, add `rename_app` under `dependencies:` if your workflow prefers that.

##### 2) PROVIDE THE APP NAME

Run commands from your **Flutter project directory** (`pubspec.yaml` must exist there). Names are arbitrary display strings — use quoting on the CLI when they contain spaces.

You can supply the app name in two complementary ways:

**A — From pubspec.yaml (no CLI arguments)**

Add a **`config_name`** block at the top level of **`pubspec.yaml`** (alongside `name:`, `description:`, etc.):

```yaml
config_name:
  name: "My App"
```

- **`name` must be a string.** If `config_name.name` is present, running **with zero arguments**:

  ```sh
  dart run rename_app:main
  ```

  is equivalent to **`dart run rename_app:main all="My App"`** — same name for Android, iOS, Web, Windows, and Linux.
- **`pubspec.yaml` must parse as YAML.** If the block is missing, `name` is missing/wrong type, or reading the file fails, the tool prints the help message and exits (same as older versions without `config_name`).
- **CLI always wins:** as soon as you pass **any** argument (for example `all="..."` or `android="..."`), **`config_name` is not used** for that invocation.

**B — From the CLI (explicit arguments)**

Same name for **all** supported platforms:

##### Same name for all apps

```sh
dart run rename_app:main all="My App Name"
```

##### Separate name for specified platform(s) and same for all others

```sh
dart run rename_app:main android="Android Name" ios="IOS Name" others="Others Name"
```

##### Separate name for each platform

```sh
dart run rename_app:main android="Android Name" ios="IOS Name" web="Web Name" mac="Mac Name" windows="Windows Name" linux="Linux Name"
```

## More Flexibilities 😎

| REQUIREMENT  | COMMAND                                                                                   |
| ------------ | ----------------------------------------------------------------------------------------- |
| From pubspec | Add `config_name.name`, then ``dart run rename_app:main`` (no arguments)                |
| All Same     | ``dart run rename_app:main all="App Name"``                                               |
| Only Android | ``dart run rename_app:main android="Android App"``                                        |
| Only IOS     | ``dart run rename_app:main ios="IOS App"``                                                |
| Only WEB     | ``dart run rename_app:main web="Web App"``                                                |
| ONLY Windows | ``dart run rename_app:main windows="Windows App"``                                        |
| ONLY Linux   | ``dart run rename_app:main linux="Linux App"``                                            |
| With Others  | ``dart run rename_app:main android="Android App" ios="IOS App" others="Others App Name"`` |
