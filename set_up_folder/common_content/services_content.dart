part of '../create_folders.dart';

final class ServicesContent {
  String di(String appName) => '''
import 'package:flutter/material.dart';
import 'package:$appName/common/presentation/widgets/app/my_app.dart';
import 'package:$appName/common/routing/routes.dart';

abstract class DiContainerProvider {
  Widget makeApp();
}

class DiContainer implements DiContainerProvider {
  final MainNavigation _mainNavigation = MainNavigation();

  @override
  Widget makeApp() => MyApp(navigation: _mainNavigation);

  DiContainer();
}
''';
}
