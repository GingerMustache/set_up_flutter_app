part of '../create_folders.dart';

final class PresentationContent {
  String app(String appName) =>
      '''
import 'package:multi_mode_animated_snack/multi_mode_animated_snack.dart' show AnimatedSnackBar, AppearanceMode;
import 'package:$appName/common/configs/setting_config.dart';
import 'package:$appName/common/constants/constants.dart';
import 'package:$appName/features/settings/bloc/settings_bloc.dart';
// need to run
// dart run build_runner build
// dart run slang
import 'package:$appName/common/localization/i18n/strings.g.dart';

import 'package:$appName/common/application/theme/color/theme_color.dart';
import 'package:$appName/common/presentation/widgets/app/themes/base_theme.dart'
    show AppTheme;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart'
    show FlutterI18n, FlutterI18nDelegate;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

abstract class MyAppNavigation {
  RouterConfig<RouteMatchList> router();
}

class MyApp extends StatelessWidget {
  final MyAppNavigation navigation;
  final SettingConfig settingConfig;
  final FlutterI18nDelegate flutterI18nDelegate;

  const MyApp({
    super.key,
    required this.navigation,
    required this.flutterI18nDelegate,
    required this.settingConfig,
  });

  void systemColor(ThemeMode theme) {
    final isDark = theme == ThemeMode.dark;
    final colors = isDark ? ThemeColors.dark : ThemeColors.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: colors.scaffoldBackground,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: colors.navigationBar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) debugPrintRebuildDirtyWidgets = true;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) => previous.theme != current.theme,
      builder: (context, state) {
        systemColor(state.theme);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: snackbarKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: !state.startApp ? settingConfig.currentTheme : state.theme,
          routerConfig: navigation.router(),
          locale: TranslationProvider.of(context).flutterLocale,
          builder: (context, child) {
            FlutterI18n.rootAppBuilder();
            return Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) {
                    AnimatedSnackBar.initialize(
                      context,
                      appearanceMode: AppearanceMode.top,
                    );
                    return child!;
                  },
                ),
              ],
            );
          },

          localizationsDelegates: [
            flutterI18nDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ru'), Locale('en')],
        );
      },
    );
  }
}

''';

  String get appIcons => '''class AppIcons {
  AppIcons._();
  static const String _basePath = 'assets/icons/';
  static const String _shopsPath = 'assets/icons/shops/';

  static const String find = '\${_basePath}search.svg';
  static const String barcode = '\${_basePath}barcode.svg';
  static const String bookmark = '\${_basePath}bookmark.svg';

  // shops logo
  static const String sparShop = '\${_shopsPath}spar_shop.svg';
  static const String fiveShop = '\${_shopsPath}5_shop.svg';
  static const String magnetShop = '\${_shopsPath}magnet_shop.svg';
  static const String perectrestokShop = '\${_shopsPath}perectrestok_shop.svg';
  static const String dixyShop = '\${_shopsPath}dixy_shop.svg';
  static const String kbShop = '\${_shopsPath}k_b_shop.svg';
  static const String lentaShop = '\${_shopsPath}lenta_shop.svg';
  static const String metroShop = '\${_shopsPath}metro_shop.svg';
  static const String okShop = '\${_shopsPath}ok_shop.svg';
  static const String ashanShop = '\${_shopsPath}ashan_shop.svg';
  static const String vkusVilShop = '\${_shopsPath}vkus_vil_shop.svg';
  static const String sportmasterShop = '\${_shopsPath}sportmaster_shop.svg';
}
''';

  String get lightTheme => '''
part of 'base_theme.dart';

const _lightColors = ThemeColors.light;

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'Tektur',
  scaffoldBackgroundColor: _lightColors.scaffoldBackground,
  indicatorColor: _lightColors.indicator,
  iconTheme: IconThemeData(color: _lightColors.icon),
  appBarTheme: AppBarTheme(
    color: _lightColors.appBarBackground,
    titleTextStyle: TextStyle(
      color: _lightColors.appBarTitle,
      fontSize: 18.0,
    ),
  ),
  extensions: [ThemeTextStyles.light, _lightColors],
);
''';

  String get darkTheme => '''
part of 'base_theme.dart';

const _darkColors = ThemeColors.dark;

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'Tektur',
  scaffoldBackgroundColor: _darkColors.scaffoldBackground,
  indicatorColor: _darkColors.indicator,
  iconTheme: IconThemeData(color: _darkColors.icon),
  appBarTheme: AppBarTheme(
    color: _darkColors.appBarBackground,
    titleTextStyle: TextStyle(
      color: _darkColors.appBarTitle,
      fontSize: 18.0,
    ),
    iconTheme: IconThemeData(color: _darkColors.icon),
  ),
  extensions: [ThemeTextStyles.dark, _darkColors],
);
''';

  String baseTheme(String appName) =>
      '''
import 'package:$appName/common/application/theme/color/theme_color.dart';
import 'package:$appName/common/application/theme/text_style/theme_text_style.dart';
import 'package:flutter/material.dart';

part 'dark_theme.dart';
part 'light_theme.dart';

/// Facade for light and dark [ThemeData] presets.
class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = lightThemeData;
  static final ThemeData darkTheme = darkThemeData;
}
''';
}
