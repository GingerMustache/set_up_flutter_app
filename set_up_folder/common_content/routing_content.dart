part of '../create_folders.dart';

final class RoutingContent {
  String routes(String appName) => '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:$appName/common/constants/constants.dart';
import 'package:$appName/common/presentation/widgets/app/my_app.dart';
import 'package:$appName/features/first/presentation/screens/home_screen.dart';
import 'package:$appName/features/first/presentation/screens/init_screen.dart';

enum MainRoutes { home, init }

String mainRoutesName(MainRoutes name) => switch (name) {
      MainRoutes.init => 'InitScreen',
      MainRoutes.home => 'HomeScreen',
    };

String mainRoutesPath(MainRoutes name) => switch (name) {
      MainRoutes.init => '/',
      MainRoutes.home => '/home',
    };

class MainNavigation implements MyAppNavigation {
  @override
  final GoRouter router = GoRouter(
    initialLocation: mainRoutesPath(MainRoutes.home),
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
       GoRoute(
         name: mainRoutesName(MainRoutes.init),
         path: mainRoutesPath(MainRoutes.init),
         builder: (BuildContext context, GoRouterState state) {
           return const InitScreen();
         },
       ),
      GoRoute(
        name: mainRoutesName(MainRoutes.home),
        path: mainRoutesPath(MainRoutes.home),
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}
''';
}
