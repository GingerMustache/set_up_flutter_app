part of '../create_folders.dart';

class ConfigsContent {
  String settingConfig(String appName) => '''import 'package:$appName/common/services/brightness_control/brightness_control_service.dart';
import 'package:$appName/common/services/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';

abstract class SettingConfig {
  ThemeMode get currentTheme;
  BrightnessMode get currentBrightness;
  String get currentLang;
}

class SettingConfigImpl implements SettingConfig {
  @override
  final ThemeMode currentTheme;
  @override
  final BrightnessMode currentBrightness;
  @override
  final String currentLang;

  SettingConfigImpl({
    required this.currentTheme,
    required this.currentBrightness,
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

    final currentBrightnessMode =
        await localStorage.read(SecureKeys.brightness.name) == 'handle'
            ? BrightnessMode.handle
            : BrightnessMode.auto;

    return SettingConfigImpl(
      currentTheme: currentThemeMode,
      currentBrightness: currentBrightnessMode,
      currentLang: currentLangMode,
    );
  }
}
''';
}
