# set_up_flutter_app

**For AI Agents: See [requirements.md](requirements.md) for complete project context and architecture details when making modifications.**

1. [How to use](#how-to-use)
2. [Add packages](#add-packages)
3. [What will be generated](#what-will-be-generated)
4. [Makefile commands](#makefile-commands)

## How to use

### Quick setup (recommended)
```bash
make setup
```
This will automatically:
- Delete old main.dart and .gitignore
- Install all required packages
- Generate folder structure and files
- Run build_runner to generate code
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

All commands should be run from the project root directory.

- `make setup` - Complete project setup (deletes old files, installs packages, generates files, runs build_runner and slang)
- `make install` - Install packages only
- `make generate` - Generate folder structure and files only
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

### Manual package installation
```bash
flutter pub add \
  flutter_localizations --sdk=flutter \
  intl:any \
  slang \
  slang_flutter \
  go_router \
  flutter_bloc \
  bloc \
  dio \
  talker_dio_logger \
  talker_flutter \
  flutter_dotenv \
  flutter_secure_storage \
  freezed \
  dartz \
  bloc_concurrency \
  rxdart \
  equatable \
  dev:build_runner \
  dev:flutter_launcher_icons \
  dev:flutter_native_splash \
  dev:flutter_lints \
  dev:freezed_annotation
```

## What will be generated
- .env
- slang.yaml
- .gitignore
- main.dart
- flutter_launcher_icons.yaml
- Common folders with default files:
<pre>
 lib/common/application<br>
            /constants<br>
            /data/remote<br>
            /extensions<br>
            /helpers/text_field_validator<br>
            /localization/i18n<br>
            /localization/locale<br>
            /mixins<br>
            /presentation/widgets/app<br>
            /presentation/widgets/themes<br>
            /presentation/assets_parts<br>
            /routing<br>
            /services/di_container<br>
            /services/error_service<br>
            /services/file_pick/exceptions<br>
            /services/local_storage<br>
            /typography<br>
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
<br>

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
