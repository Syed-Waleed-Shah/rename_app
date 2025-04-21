[![Stand With Palestine](https://raw.githubusercontent.com/TheBSD/StandWithPalestine/main/banner-no-action.svg)](https://thebsd.github.io/StandWithPalestine)

# Rename App

### The only flutter package which changes app name for all platforms with sound null safety!

``If you want to autmatically change your flutter app name with a single command then you are at the right pacakge. This package gives you too many flexibilities through too many variants of its commands. Read the details below to know in more details``

- ✊  Dont forget to star the github repo if you found this package useful 😇

Developer : [Syed Waleed Shah](https://www.linkedin.com/in/syed-waleed-shah/ "LinkedIn Profile") ( [LinkedIn](https://www.linkedin.com/in/syed-waleed-shah/ "LinkedIn Profile")  [Github](https://github.com/Syed-Waleed-Shah "Github Profile")  [StackOverflow](https://stackoverflow.com/users/15212735/syed-waleed "StackOverflow Profile") )

Please Contribute : [Github Repository](https://github.com/Syed-Waleed-Shah "Github Repository")

Honourable Contributors:

1. [Finn Drünert](https://github.com/Finnomator "Github Profile") ( [Github](https://github.com/Finnomator "Github Profile") )
2. [nhan7777](https://github.com/nhan7777 "https://github.com/nhan7777") ( [Gitbub](https://github.com/nhan7777) )

## Features 🔥

✅  Rename Android Project

✅  Rename IOS Project

✅  Rename WEB Project

✅  Rename Windows Project

✅  Rename Linux Project

## How To Rename ? 🛠

##### 1) ADD THE PACKAGE TO DEPENDENCIES IN pubspec.yaml

```sh
flutter pub add rename_app
```

OR

```sh
dependencies:
  rename_app: ^latest_version
```

##### 2) PROVIDE THE APP NAME

You can provide app name in the following ways

##### Same name for all apps

```sh
dart run rename_app:main all="My App Name"
```

##### Seperate name for specified platform(s) and same for all others

```sh
dart run rename_app:main android="Anroid Name" ios="IOS Name" others="Others Name"
```

##### Seperate name for each platform

```sh
dart run rename_app:main android="Android Name" ios="IOS Name" web="Web Name" mac="Mac Name" windows="Windows Name" linux="Linux Name"
```

## More Flexibilities 😎

| REQUIREMENT  | COMMAND                                                                                   |
| ------------ | ----------------------------------------------------------------------------------------- |
| All Same     | ``dart run rename_app:main all="App Name"``                                               |
| Only Android | ``dart run rename_app:main android="Android App"``                                        |
| Only IOS     | ``dart run rename_app:main ios="IOS App"``                                                |
| Only WEB     | ``dart run rename_app:main web="Web App"``                                                |
| ONLY Windows | ``dart run rename_app:main windows="Windows App"``                                        |
| ONLY Linux   | ``dart run rename_app:main linux="Linux App"``                                            |
| With Others  | ``dart run rename_app:main android="Android App" ios="IOS App" others="Others App Name"`` |
