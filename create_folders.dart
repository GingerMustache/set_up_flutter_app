import 'dart:io';

void main() {
  // Define the folder structure
  List<String> folders = [
    'lib/common/application',
    'lib/common/constants',
    'lib/common/data/remote',
    'lib/common/localization/i18n',
    'lib/common/presentation',
    'lib/common/routing',
    'lib/common/services/di_container',
    'lib/common/typography',
    'lib/feature/first',
    'lib/feature/first/bloc',
    'lib/feature/first/constants',
    'lib/feature/first/data',
    'lib/feature/first/presentation',
  ];

  for (var folder in folders) {
    final directory = Directory(folder);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('Created: $folder');
    } else {
      print('Already exists: $folder');
    }
  }

  // Path to the colors.dart file
  Map<String, String> files = {
    '.env': 'URL=',
    'slang.yaml': '''
base_locale: en
input_file_pattern: .i18n.yaml
fallback_strategy: base_locale
input_directory: lib/common/localization/i18n
''',
    'flutter_launcher_icons.yaml': '''
#flutter_icons:
#android: true
#ios: true
#image_path: "assets/images/logo.png"
#adaptive_icon_foreground: "assets/images/logo.png"
#adaptive_icon_background: "#5D4CC2"
#remove_alpha_ios: true
''',
    'lib/common/application/app_settings.dart': '''
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'button_styles.dart';
part 'colors.dart';
part 'decoration.dart';
part 'links.dart';
part 'paddings.dart';
part 'text_styles.dart';
''',
    'lib/common/application/colors.dart': '''
part of "app_settings.dart";

class AppColors {
  static const Color mainWhite = Colors.white;
  static const Color mainBlack = Colors.black;
  static const Color mainGreen = Colors.green;
  static const Color mainBlue = Colors.blue;
  static Color withAlpha = Colors.grey.withAlpha(30);

  const AppColors._();
  static final AppColors _shared = AppColors._sharedInstance();
  AppColors._sharedInstance();
  factory AppColors() => _shared;
}
''',
    'lib/common/application/button_styles.dart': '''
part of "app_settings.dart";
''',
    'lib/common/application/decoration.dart': '''
part of "app_settings.dart";
''',
    'lib/common/application/links.dart': '''
part of "app_settings.dart";


String _base = '{dotenv.env['URL']}';

class BasePaths {
  static final BasePaths _shared = BasePaths._sharedInstance();
  BasePaths._sharedInstance();
  factory BasePaths() => _shared;
  
  static final base = _base;
}
''',
    'lib/common/application/paddings.dart': '''
part of "app_settings.dart";
''',
    'lib/common/application/text_styles.dart': '''
part of "app_settings.dart";

final whiteLarge = _getTextStyle(
  fontSize: 22.0,
  height: 1.2,
  fontWeight: FontWeight.bold,
  color: AppColors.mainWhite,
);

final whiteMedium = _getTextStyle(
  fontSize: 18.0,
  height: 1.2,
  fontWeight: FontWeight.bold,
  color: AppColors.mainWhite,
);

final whiteSmall = _getTextStyle(
  fontSize: 14.0,
  height: 1.2,
  fontWeight: FontWeight.bold,
  color: AppColors.mainWhite,
);

final headlineLarge = _getTextStyleFromThema(
  fontSize: 32.0,
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

final headlineMedium = _getTextStyleFromThema(
  fontSize: 16.0,
  color: AppColors.mainWhite,
);

final headlineSmall = _getTextStyleFromThema(
  fontSize: 14.0,
  color: AppColors.mainWhite,
);

final titleLarge = _getTextStyleFromThema(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

final titleMedium = _getTextStyleFromThema(
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

final titleSmall = _getTextStyleFromThema(
  fontSize: 14.0,
);

final bodyLarge = _getTextStyleFromThema(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

final bodyMedium = _getTextStyleFromThema(
  fontSize: 14.0,
  color: Colors.black,
);

final bodySmall = _getTextStyleFromThema(
  fontSize: 12.0,
  color: Colors.black,
);

TextStyle _getTextStyle({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    fontFamily: 'Montserrat',
    color: color,
  );
}

TextStyle _getTextStyleFromThema({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    color: color ?? Colors.black,
  );
}

''',
  };

  files.map(
    (key, value) {
      final file = File(key);
      if (!file.existsSync()) {
        file.writeAsStringSync(value);
        print('Created: $key');
      } else {
        print('Already exists: $key');
      }
      return MapEntry(key, value);
    },
  );
}
