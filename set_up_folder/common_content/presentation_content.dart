part of '../create_folders.dart';

final class PresentationContent {
  String get app => '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:app_name/common/application/app_settings.dart';
import 'package:app_name/common/constants/constants.dart';
import 'package:app_name/common/localization/i18n/strings.g.dart';

abstract class MyAppNavigation {
  RouterConfig<RouteMatchList> get router;
}

class MyApp extends StatelessWidget {
  final MyAppNavigation navigation;

  const MyApp({
    Key? key,
    required this.navigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        useMaterial3: true,
        indicatorColor: AppColors.mainBlack,
        iconTheme: const IconThemeData(
          color: AppColors.mainBlack,
        ),
      ),
      routerConfig: navigation.router,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
''';
}
