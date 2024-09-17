part of '../create_folders.dart';

final class ServicesContent {
  String di(String appName) => '''
import 'package:flutter/material.dart';
import 'package:$appName/common/presentation/widgets/app/my_app.dart';
import 'package:$appName/common/routing/routes.dart';
import 'package:$appName/feature/first/presentation/screens/init_screen.dart';

abstract class DiContainerProvider {
  Widget makeApp();
}

class DiContainer implements DiContainerProvider {
  ScreenFactory _makeScreenFactory() => ScreenFactory(diContainer: this);
  MyAppNavigation _makeRouter() =>
      MainNavigation(screenFactory: _makeScreenFactory());

  @override
  Widget makeApp() => MyApp(navigation: _makeRouter());
  CheckAuthorization makeCheckAuthorization() => CheckAuthorizationDefault();

  DiContainer();
}

''';
}
