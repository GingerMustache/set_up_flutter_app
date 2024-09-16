part of '../create_folders.dart';

final class CommonContent {
  String get gitignore => '''
#main
.env
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/
*.code-workspace

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Web related
lib/generated_plugin_registrant.dart

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

keystore.jks
key.properties

# FVM Version Cache
.fvm/

''';
  String get slang => '''
base_locale: en
input_file_pattern: .i18n.yaml
fallback_strategy: base_locale
input_directory: lib/common/localization/i18n
''';

  String main(String appName) => '''
import 'package:flutter/material.dart';
// need to run dart run build_runner build
import 'package:$appName/common/localization/i18n/strings.g.dart';
import 'package:$appName/common/services/di_container/di_container.dart';

void main() async {
  final DiContainerProvider diContainer = DiContainer();
  WidgetsFlutterBinding.ensureInitialized();
  final app = diContainer.makeApp();

  runApp(TranslationProvider(child: app));
}
''';

  String get flutterLauncherIcons => '''
#flutter_icons:
#android: true
#ios: true
#image_path: "assets/images/logo.png"
#adaptive_icon_foreground: "assets/images/logo.png"
#adaptive_icon_background: "#5D4CC2"
#remove_alpha_ios: true
''';
}
