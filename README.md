# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches.
The app is built using Flutter and Dart, and it is designed primarily to be run in a web
browser.

## Install the essential tools

1. **Terminal**:

    - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**, typing **Terminal**, and pressing **Return**.
    - **Windows** – open the start menu using the **Windows** key. Then enter **cmd** to open the **Command Prompt**. Alternatively, you can use **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version`, in the terminal.
    If this is missing, download the installer from [Git's official site](https://git-scm.com/downloads?utm_source=chatgpt.com).

3. **Package managers**:

    - **Homebrew** (macOS) – verify that you have `brew` installed with `brew --version`; if missing, follow the instructions on the [Homebrew installation page](https://brew.sh/).
    - **Chocolatey** (Windows) – verify that you have `choco` installed with `choco --version`; if missing, follow the instructions on the [Chocolatey installation page](https://chocolatey.org/install).

4. **Flutter SDK** – verify that you have `flutter` installed and it is working with `flutter doctor`; if missing, install it using your package manager:

    - **macOS**: `brew install --cask flutter`
    - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify that you have `code` installed with `code --version`; if missing, use your package manager to install it:

    - **macOS**: `brew install --cask visual-studio-code`
    - **Windows**: `choco install vscode`

## Get the code

### If this is your first time working on this project

Enter the following commands in your terminal to clone the repository and
open it in Visual Studio Code.
You may want to change directory (`cd`) to the directory where you want to clone the
repository first.

```bash
git clone --branch 8 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

### If you have already cloned the repository

Enter the following commands in your terminal to switch to the correct branch.
Remember to `cd` to the directory where you cloned the repository first.

```bash
git fetch origin
git checkout 8
```

## Run the app

Open the integrated terminal in Visual Studio Code by first opening the Command
Palette with **⌘ + Shift + P** (macOS) or **Ctrl + Shift + P** (Windows) and
typing **Terminal: Create New Terminal** then pressing **Enter**.

In the terminal, run the following commands to install the dependencies and run
the app in your web browser:

```bash
flutter pub get
flutter run
```

### Run on different platforms

- **Web browser**: `flutter run -d chrome`
- **Windows desktop**: `flutter run -d windows`
- **Android device/emulator**: `flutter run -d android`

### Run in release mode

For optimal performance, run the app in release mode:

```bash
flutter run --release -d windows
```

## Testing

This app has comprehensive test coverage across three levels:

### Run all tests

```bash
flutter test
```

### Test breakdown

- **Unit tests**: 90 tests covering models, repositories, and view models
- **Widget tests**: Located in `test/` directory
- **Integration tests**: 18 end-to-end tests in `integration_test/app_test.dart`

### Run integration tests

```bash
flutter test integration_test/app_test.dart
```

### Test coverage

Integration tests cover:
- Complete order flow (add to cart, checkout)
- Profile management (save, validation)
- Cart state persistence
- Settings navigation
- Quantity controls and boundaries
- Edge cases (empty cart, multiple items, size toggling)

**Total test coverage**: 108 tests (all passing ✓)

## Build for production

### Android APK

Build release APK for Android:

```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

### Build size comparison

- **Debug APK**: 174.45 MB
- **Release APK**: 81.43 MB (53.32% smaller)

Release builds include:
- AOT compilation for better performance
- Tree-shaking to remove unused code and assets
- Code obfuscation and minification
- Optimized MaterialIcons font (99.8% reduction)

## Get support

Use [the dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806)
to ask your questions and get help from the community.
Please provide as much context as possible, including the error messages you are seeing and
screenshots (you can open Discord in your web browser).
