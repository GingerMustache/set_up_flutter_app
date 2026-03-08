part of '../create_folders.dart';

class ConfigsContent {
  String settingConfig(String appName) => '''
import 'package:$appName/common/services/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';

abstract class SettingConfig {
  ThemeMode get currentTheme;
  String get currentLang;
}

class SettingConfigImpl implements SettingConfig {
  @override
  final ThemeMode currentTheme;
  @override

  @override
  final String currentLang;

  SettingConfigImpl({
    required this.currentTheme,
    required this.currentLang,
  });

  static Future<SettingConfigImpl> fromLocalStorage(
    LocalStorageService localStorage,
  ) async {
    final currentLangMode = await localStorage.read(
      SecureKeys.lang.name,
      insteadValue: 'ru',
    );

    final currentThemeMode =
        await localStorage.read(SecureKeys.theme.name) == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light;

    return SettingConfigImpl(
      currentTheme: currentThemeMode,
      currentLang: currentLangMode,
    );
  }
}
''';
}
