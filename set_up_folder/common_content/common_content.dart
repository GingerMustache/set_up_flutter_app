part of '../create_folders.dart';

final class CommonContent {
  String get slang => '''
base_locale: en
input_file_pattern: .i18n.yaml
fallback_strategy: base_locale
input_directory: lib/common/localization/i18n
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
