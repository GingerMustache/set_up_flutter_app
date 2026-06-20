# set_up_flutter_app

**For AI Agents: See [requirements.md](requirements.md) for complete project context and architecture details when making modifications.**

1. [How to use](#how-to-use)
2. [Add packages](#add-packages)
3. [What will be generated](#what-will-be-generated)
4. [Theme architecture](#theme-architecture)
5. [Makefile commands](#makefile-commands)

## How to use

**IMPORTANT SETUP REQUIREMENTS:**

Place the entire `set_up_flutter_app` folder in your project root (same level as `lib` and `test` folders)

**Project structure should look like:**
```
your_project/
├── lib/
├── test/
├── set_up_flutter_app/    ← Place this folder here
│   ├── set_up_folder/
│   ├── Makefile
│   └── README.md
└── pubspec.yaml
```

### Quick setup (recommended)
```bash
make setup
```
This will automatically:
- Delete old `main.dart` and `.gitignore`
- Install all required packages (pinned versions)
- Generate folder structure and files
- Add `.env` to `pubspec.yaml` assets (replaces the default commented assets block)
- Run `build_runner` to generate code
- Generate translations with slang

### Manual setup
If you prefer to run commands manually:

1. **Delete old files**
```bash
rm lib/main.dart .gitignore
```

2. **Install packages**
```bash
chmod +x set_up_folder/run_pub_add.sh
cd set_up_folder && sh run_pub_add.sh && cd ..
```

3. **Generate project structure**
```bash
cd set_up_folder && dart run create_folders.dart && cd ..
```

4. **Run code generation**
```bash
dart run build_runner build --delete-conflicting-outputs
dart run slang
```

Or run all at once:
```bash
rm lib/main.dart .gitignore && \
chmod +x set_up_folder/run_pub_add.sh && \
cd set_up_folder && sh run_pub_add.sh && dart run create_folders.dart && cd .. && \
dart run build_runner build --delete-conflicting-outputs && \
dart run slang
```

## Makefile commands

All commands should be run from inside the `set_up_flutter_app` folder.

- `make setup` - Complete project setup (deletes old files, installs packages, generates files, patches pubspec assets, runs build_runner and slang)
- `make install` - Install packages only
- `make generate` - Generate folder structure and files only (also patches pubspec assets)
- `make build` - Run build_runner to generate code
- `make slang` - Generate translations with slang
- `make clean` - Clean project and get dependencies
- `make all` - Same as `make setup` (full project setup)

## Add packages

### Using the script (recommended)
```bash
make install
```

Or manually:
```bash
chmod +x set_up_folder/run_pub_add.sh
cd set_up_folder && sh run_pub_add.sh && cd ..
```

### Installed packages (pinned versions)

`run_pub_add.sh` installs:

| Package | Version |
|---------|---------|
| cupertino_icons | ^1.0.8 |
| flutter_localizations | SDK |
| intl | any |
| slang | ^4.16.0 |
| slang_flutter | ^4.16.0 |
| flutter_bloc | ^9.1.1 |
| bloc | ^9.2.1 |
| dio | ^5.9.2 |
| equatable | ^2.0.8 |
| go_router | ^16.0.0 |
| talker_dio_logger | ^4.9.3 |
| talker_flutter | ^4.9.3 |
| flutter_dotenv | ^5.2.1 |
| file_picker | ^10.3.3 |
| sentry_flutter | ^9.7.0 |
| flutter_secure_storage | ^10.3.1 |
| dartz | ^0.10.1 |
| bloc_concurrency | ^0.3.0 |
| rxdart | ^0.28.0 |
| flutter_i18n | ^0.37.1 |
| multi_mode_animated_snack | ^1.0.1 |

Dev dependencies: `build_runner`, `flutter_launcher_icons`, `flutter_native_splash`, `flutter_lints`, `freezed_annotation`

## What will be generated

### Root files
- `.env` — environment variables (`URL`, `SENTRY_DSN`)
- `slang.yaml` — localization config
- `.gitignore`
- `main.dart`
- `flutter_launcher_icons.yaml`
- `pubspec.yaml` — updated with `assets: [.env]` under `flutter`

### Common folders with default files
<pre>
 lib/common/application<br>
            /application/theme/text_style<br>
            /application/theme/color<br>
            /constants<br>
            /data/remote<br>
            /extensions<br>
            /helpers/text_field_validator<br>
            /helpers/json_parser.dart<br>
            /localization/i18n<br>
            /localization/locale<br>
            /mixins<br>
            /presentation/widgets/app<br>
            /presentation/widgets/app/themes<br>
            /presentation/assets_parts<br>
            /routing<br>
            /services/di_container<br>
            /services/error_service<br>
            /services/file_pick/exceptions<br>
            /services/local_storage<br>
    /features/first<br>
                /bloc<br>
                /constants<br>
                /data/models<br>
                /data/providers<br>
                /presentation/screens<br>
                /presentation/parts<br>
    /features/settings<br>
                /bloc<br>
</pre>

### Key generated helpers & mixins

| File | Purpose |
|------|---------|
| `helpers/json_parser.dart` | Safe JSON type coercion (`toInt`, `toBool`, `list`, etc.) |
| `helpers/text_field_validator/text_field_validator.dart` | Form field validation |
| `mixins/error_handler_mixin.dart` | `safeCall` wrapper returning `Either` |
| `mixins/event_transformer_mixin.dart` | BLoC debounce/restartable transformer |
| `mixins/show_snack_bar_mixin.dart` | `AnimatedSnackBar` helper with optional delay |

## Theme architecture

Generated apps use a three-layer theme system. See [THEME_ARCHITECTURE.md](THEME_ARCHITECTURE.md) for the full guide (also copied into `lib/common/application/theme/` when available).

| Layer | Location | Access |
|-------|----------|--------|
| Raw palette | `common/application/colors.dart` | `AppColors` (token definitions only) |
| Design tokens | `common/application/theme/text_style/` | `context.textStyles` |
| Design tokens | `common/application/theme/color/` | `context.color` |
| Material assembly | `common/presentation/widgets/app/themes/` | `AppTheme.lightTheme` / `AppTheme.darkTheme` |

```dart
import 'package:my_app/common/application/theme/text_style/theme_text_style.dart';
import 'package:my_app/common/application/theme/color/theme_color.dart';

Text('Hello', style: context.textStyles.bodySmall);
Container(color: context.color.surface);
```

`MyApp` wires `AppTheme` into `MaterialApp.router` and uses `ThemeColors` for system UI overlay colors.

## Probably errors
- in case
```
* What went wrong:
Execution failed for task ':app:checkDebugDuplicateClasses'.
```
1. Go to settings.gradle
2. Change current line from:

```Groovy
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "7.3.0" apply false
    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
}
```
<br>

to this :

<br>

``` Groovy
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "7.3.0" apply false
    id "org.jetbrains.kotlin.android" version "1.8.22" apply false
}
```
