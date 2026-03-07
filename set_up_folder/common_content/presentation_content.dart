part of '../create_folders.dart';

final class PresentationContent {
  String app(String appName) => '''
import 'package:$appName/common/application/app_settings.dart';
import 'package:$appName/common/constants/constants.dart';
// need to run
// dart run build_runner build
// dart run slang
import 'package:$appName/common/localization/i18n/strings.g.dart';

import 'package:$appName/common/presentation/widgets/themes/base_theme.dart'
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
  final FlutterI18nDelegate flutterI18nDelegate;

  const MyApp({
    super.key,
    required this.navigation,
    required this.flutterI18nDelegate,
  });

  void systemColor(ThemeMode theme) {
    final isDark = theme == ThemeMode.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDark ? AppColors.mainBlack : AppColors.mainWhite,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDark ? AppColors.mainBlack : AppColors.mainWhite,
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
          themeMode: state.theme,
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

  String lightTheme(String appName) =>
      '''import 'package:$appName/common/application/app_settings.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyleFromTheme({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
  double? letterSpacing,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
    color: color ?? AppColors.mainBlack,
  );
}

const Color lightSecondaryColor = Color(0xFFc7513b);
const Color lightOnPrimaryColor = Colors.black;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.mainWhite,
  useMaterial3: true,
  fontFamily: 'Tektur',
  indicatorColor: AppColors.mainBlack,
  iconTheme: const IconThemeData(color: AppColors.mainBlack),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0),
    color: AppColors.mainWhite,
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.mainGray,
    secondary: lightSecondaryColor,
    onPrimary: lightOnPrimaryColor,
    onSecondary: Colors.white,
    surfaceContainerHighest: AppColors.mainBlack,
    surface: Colors.white,
    secondaryContainer: Color.fromARGB(255, 255, 206, 191),
  ),
  textTheme: TextTheme(
    displayMedium: _getTextStyleFromTheme(
      fontSize: 20.0,
      letterSpacing: 2.5,
      color: AppColors.darkGrey,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: _getTextStyleFromTheme(
      fontSize: 32.0,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: _getTextStyleFromTheme(
      fontSize: 22.0,
      color: AppColors.mainBlack,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: _getTextStyleFromTheme(
      fontSize: 18.0,
      color: AppColors.mainBlack,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: _getTextStyleFromTheme(
      fontSize: 20.0,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: _getTextStyleFromTheme(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: _getTextStyleFromTheme(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: _getTextStyleFromTheme(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: AppColors.darkGrey,
    ),
    bodySmall: _getTextStyleFromTheme(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.subGrey,
    ),
    displaySmall: _getTextStyleFromTheme(
      fontSize: 16.0,
      color: AppColors.darkGrey,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: _getTextStyleFromTheme(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    ),
  ),
);
''';

  String darkTheme(String appName) =>
      '''import 'package:$appName/common/application/app_settings.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyleFromTheme({
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  Color? color,
  double? letterSpacing,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
    color: color ?? AppColors.mainBlack,
  );
}

const Color darkPrimaryColor = Color.fromARGB(255, 75, 14, 0);
const Color darkSecondaryColor = Color.fromARGB(255, 107, 16, 0);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 67, 67, 67),
  useMaterial3: true,
  fontFamily: 'Tektur',
  indicatorColor: AppColors.mainBlue,
  iconTheme: const IconThemeData(color: AppColors.darkGrey),
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(color: AppColors.darkGrey, fontSize: 18.0),
    color: darkPrimaryColor,
    iconTheme: IconThemeData(color: AppColors.darkGrey),
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.suBlack,
    secondary: darkSecondaryColor,
    onPrimary: Colors.green,
    onSecondary: Colors.red,
    surfaceContainerHighest: Color.fromARGB(255, 252, 210, 210),
    surface: Color.fromARGB(255, 88, 47, 47),
    secondaryContainer: Color.fromARGB(255, 36, 20, 20),
  ),
  textTheme: TextTheme(
    displayMedium: _getTextStyleFromTheme(
      fontSize: 20.0,
      letterSpacing: 2,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: _getTextStyleFromTheme(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: _getTextStyleFromTheme(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: _getTextStyleFromTheme(
      fontSize: 20.0,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: _getTextStyleFromTheme(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: _getTextStyleFromTheme(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.mainGray,
    ),
    bodyMedium: _getTextStyleFromTheme(
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
      color: AppColors.darkGrey,
    ),
    bodySmall: _getTextStyleFromTheme(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.darkGrey,
    ),
    displaySmall: _getTextStyleFromTheme(
      fontSize: 16.0,
      color: AppColors.darkGrey,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: _getTextStyleFromTheme(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    ),
  ),
);
''';

  String baseTheme(String appName) =>
      '''import 'package:$appName/common/presentation/widgets/themes/dark_theme.dart';
import 'package:$appName/common/presentation/widgets/themes/light_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = lightTheme;
  static final ThemeData darkTheme = darkTheme;
}
''';
}
