part of '../create_folders.dart';

final class LocalizationContent {
  String get stringEn => '''
title: title

## ==== Экраны ====

screen:
  home:
    all: all
  firstSCreen:
    all: first
''';
  String get stringRu => '''
title: title

## ==== Экраны ====

screen:
  home:
    all: всу
  firstSCreen:
    all: первый
''';

  String locale(String appName) => '''import 'dart:ui';

import 'package:$appName/common/localization/i18n/strings.g.dart';
import 'package:$appName/common/services/local_storage/secure_storage.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';

class LocaleClass {
  LocaleClass._();

  static String _currentLang = 'ru';
  static String get currentLang => _currentLang;

  static const Locale lngRu = Locale('ru');
  static const Locale lngEn = Locale('en');

  static String lngCode(context) {
    String code = FlutterI18n.currentLocale(context).toString();

    return code.isEmpty ? 'ru' : code.substring(0, 2);
  }

  static Future<FlutterI18nDelegate> initLocaleDelegate() async {
    _initLocale();
    String? langLocal = await SecureStorage().read(SecureKeys.lang.name);

    return FlutterI18nDelegate(
      translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'en',
        basePath: 'assets/locale',
        decodeStrategies: [JsonDecodeStrategy()],
        forcedLocale: langLocal == '' ? null : Locale(langLocal),
      ),
    );
  }

  static Future<void> _initLocale() async {
    String lc = '';

    lc = await SecureStorage().read(SecureKeys.lang.name);

    if (lc.isEmpty) {
      final deviceLocale = await LocaleSettings.useDeviceLocale();
      lc = deviceLocale.languageCode;

      if (!['ru', 'en'].contains(lc)) lc = 'ru';
      await SecureStorage().write(key: SecureKeys.lang.name, value: lc);
    }
    _setLocale(lc);
    _currentLang = lc;
  }

  static void _setLocale(String lc) => switch (lc) {
    'en' => LocaleSettings.setLocale(AppLocale.en),
    'ru' => LocaleSettings.setLocale(AppLocale.ru),
    _ => LocaleSettings.setLocale(AppLocale.ru),
  };
}
''';
}
