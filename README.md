# set_up_flutter_app
1.[How to use](#how-to-use)<br>
2.[Add packages](#add-packages)<br>
3.[What will be generated](#what-will-be-generated)<br>

## How to use
- add folder set_up_folder to main dir
- delete main.dart, .gitignore
- add packages ([Add packages](#add-packages))
- run create_folder.dart file
```
dart run create_folder.dart
```

## Add packages
- run in terminal
```
chmod +x run_pub_add.sh
sh run_pub_add.sh
```
or 

```
flutter pub add 
flutter_localizations --sdk=flutter
intl:any
slang 
slang_flutter 
go_router 
flutter_bloc 
bloc 
dio 
talker_dio_logger 
talker_flutter 
flutter_dotenv 
flutter_secure_storage 
freezed

dev:build_runner 
dev:flutter_launcher_icons
dev:flutter_native_splash
dev:flutter_lints 
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
            /remote<br>
            /localization/i18n<br>
            /presentation<br>
            /routing<br>
            /services/di_container<br>
            /typography<br>
    /feature/first<br>
                /bloc<br>
                /constants<br>
                /data<br>
                        /models<br>
                        /providers<br>
                /presentation<br>
                        /screen<br>
                        /parts<br>
</pre>

