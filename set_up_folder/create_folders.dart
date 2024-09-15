import 'dart:io';

part 'common_content/common_content.dart';
part 'common_content/localization_content.dart';
part 'common_content/constant_content.dart';
part 'common_content/application_content.dart';

void main() {
  // Define the folder structure
  List<String> folders = [
    '../lib/common/application',
    '../lib/common/constants',
    '../lib/common/data/remote',
    '../lib/common/localization/i18n',
    '../lib/common/presentation',
    '../lib/common/routing',
    '../lib/common/services/di_container',
    '../lib/common/typography',
    '../lib/feature/first',
    '../lib/feature/first/bloc',
    '../lib/feature/first/constants',
    '../lib/feature/first/data',
    '../lib/feature/first/presentation',
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
  final LocalizationContent localization = LocalizationContent();

  Map<String, String> files = {
    // common
    '../.env': 'URL=',
    '../slang.yaml': common.slang,
    '../flutter_launcher_icons.yaml': common.flutterLauncherIcons,

    // application
    '../lib/common/application/app_settings.dart': application.appSettings,
    '../lib/common/application/colors.dart': application.colors,
    '../lib/common/application/text_styles.dart': application.textStyles,
    '../lib/common/application/links.dart': application.links,
    '../lib/common/application/button_styles.dart': application.part,
    '../lib/common/application/decoration.dart': application.part,
    '../lib/common/application/paddings.dart': application.part,

    // constants
    '../lib/common/constants/constants.dart': constants.constants,
    '../lib/common/constants/global.dart': constants.global,
    '../lib/common/constants/snacks.dart': constants.snacks,
    '../lib/common/constants/spaces.dart': constants.spaces,

    // localization
    '../lib/common/localization/i18n/strings_en.i18n.yaml': localization.string,
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
