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
  final ApplicationContent application = ApplicationContent();
  final CommonContent common = CommonContent();
  final ConstantsContent constants = ConstantsContent();

  Map<String, String> files = {
    // common
    '.env': 'URL=',
    'slang.yaml': common.slang,
    'flutter_launcher_icons.yaml': common.flutterLauncherIcons,

    // application
    'lib/common/application/app_settings.dart': application.appSettings,
    'lib/common/application/colors.dart': application.colors,
    'lib/common/application/text_styles.dart': application.textStyles,
    'lib/common/application/links.dart': application.links,
    'lib/common/application/button_styles.dart': application.part,
    'lib/common/application/decoration.dart': application.part,
    'lib/common/application/paddings.dart': application.part,

    // constants
    'lib/common/constants/constants.dart': constants.constants,
    'lib/common/constants/global.dart': constants.global,
    'lib/common/constants/snacks.dart': constants.snacks,
    'lib/common/constants/spaces.dart': constants.spaces,
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

final class ConstantsContent {
  String get constants => '''
import 'package:flutter/material.dart';

part 'global.dart';
part 'snacks.dart';
part 'spaces.dart';
''';

  String get global => '''
part of 'constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
''';

  String get spaces => '''
part of 'constants.dart';

class Space {
  Space._();
  static final Space _instance = Space._();
  factory Space() => _instance;

  static const h0 = SizedBox(height: 0.0);
  static const h5 = SizedBox(height: 5.0);
  static const h10 = SizedBox(height: 10.0);
  static const h15 = SizedBox(height: 15.0);
  static const h20 = SizedBox(height: 20.0);
  static const h30 = SizedBox(height: 30.0);
  static const h40 = SizedBox(height: 30.0);
  static const h55 = SizedBox(height: 55.0);
  static const h60 = SizedBox(height: 60.0);

  static const w5 = SizedBox(width: 5.0);
  static const w10 = SizedBox(width: 10.0);
  static const w15 = SizedBox(width: 15.0);
  static const w20 = SizedBox(width: 20.0);
  static const w30 = SizedBox(width: 30.0);
  static const w40 = SizedBox(width: 40.0);
  static const w55 = SizedBox(width: 55.0);
  static const w60 = SizedBox(width: 60.0);
}
''';

  String get snacks => '''
part of 'constants.dart';

class Snack {
  final String text;

  Snack(this.text);

  void success() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.green,
        Icons.check_circle_outlined,
      ),
    );
  }

  void error() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.red,
        Icons.error_outline_outlined,
      ),
    );
  }

  void warning() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.blueGrey,
        Icons.warning_outlined,
      ),
    );
  }

  SnackBar snackBar(String text, Color color, IconData icon) {
    return SnackBar(
      backgroundColor: color,
      padding: const EdgeInsets.all(20),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Space.h10,
          Flexible(child: Text(text)),
        ],
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
''';
}

final class ApplicationContent {
  String get part => 'part of "app_settings.dart";';

  String get appSettings => '''
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'button_styles.dart';
part 'colors.dart';
part 'decoration.dart';
part 'links.dart';
part 'paddings.dart';
part 'text_styles.dart';
''';

  String get colors => '''
part of "app_settings.dart";

class AppColors {
  static const Color mainWhite = Colors.white;
  static const Color mainBlack = Colors.black;
  static const Color mainGreen = Colors.green;
  static const Color mainBlue = Colors.blue;
  static Color withAlpha = Colors.grey.withAlpha(30);

  AppColors._();
  static final AppColors _instance = AppColors._();
  factory AppColors() => _instance;
  }
''';

  String get links => '''
part of "app_settings.dart";


String _base = '{dotenv.env['URL']}';

class BasePaths {
  static final base = _base;
  
  BasePaths._();
  static final BasePaths _instance = BasePaths._();
  factory BasePaths() => _instance;
}
''';

  String get textStyles => '''
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
''';
}
