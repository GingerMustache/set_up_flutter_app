# set_up_flutter_app
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

Or run all at once:
```bash
rm lib/main.dart .gitignore && \
chmod +x set_up_folder/run_pub_add.sh && \
cd set_up_folder && sh run_pub_add.sh && dart run create_folders.dart && cd ..
```

## Add packages
Run in terminal:
```bash
chmod +x set_up_folder/run_pub_add.sh
cd set_up_folder && sh run_pub_add.sh
```

Or manually:
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
  dev:build_runner \
  dev:flutter_launcher_icons \
  dev:flutter_native_splash \
  dev:flutter_lints \
  dev:freezed_annotation
```

## Makefile commands

- `make setup` - Complete project setup (install packages + generate files)
- `make install` - Install packages only
- `make generate` - Generate folder structure and files only
- `make build` - Run build_runner
- `make slang` - Generate translations
- `make clean` - Clean and get dependencies
- `make all` - Full setup with build_runner and slang

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
            /remote<br>
            /localization/i18n<br>
            /presentation<br>
            /routing<br>
            /services/di_container<br>
            /typography<br>
    /features/first<br>
                /bloc<br>
                /constants<br>
                /data<br>
                        /models<br>
                        /providers<br>
                /presentation<br>
                        /screen<br>
                        /parts<br>
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
