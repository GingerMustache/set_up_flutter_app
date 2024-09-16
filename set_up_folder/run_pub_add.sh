#!/bin/bash

# Text to be executed
text="flutter pub add 
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
dev:flutter_lints"

# Execute the text
echo "$text" | xargs -n1 flutter pub add