# flutter_application_test

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 开发环境
```bash
flutter doctor 

Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.32.8, on macOS 14.6 23G80 darwin-arm64, locale zh-Hans-CN)
[✓] Android toolchain - develop for Android devices (Android SDK version 36.0.0)
[✗] Xcode - develop for iOS and macOS
    ✗ Xcode installation is incomplete; a full installation is necessary for iOS and macOS development.
      Download at: https://developer.apple.com/xcode/
      Or install Xcode via the App Store.
      Once installed, run:
        sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
        sudo xcodebuild -runFirstLaunch
    ✗ CocoaPods not installed.
        CocoaPods is a package manager for iOS or macOS platform code.
        Without CocoaPods, plugins will not work on iOS or macOS.
        For more info, see https://flutter.dev/to/platform-plugins
      For installation instructions, see https://guides.cocoapods.org/using/getting-started.html#installation
[✓] Chrome - develop for the web
[✓] Android Studio (version 2025.1)
[✓] VS Code (version 1.103.1)
```

## 运行项目
```bash
flutter clean
flutter pub get
flutter run


# 若项目时间长了,可先
# 清空缓存
# flutter pub cache clean
# 然后再运行 flutter pub get
# 不排除固定一些依赖版本
```