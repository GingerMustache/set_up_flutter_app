part of '../create_folders.dart';

final class RoutingContent {
  String routes(String appName) => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$appName/common/constants/constants.dart';
import 'package:$appName/common/presentation/widgets/app/my_app.dart';
import 'package:$appName/common/services/di_container/di_container.dart';
import 'package:$appName/features/first/bloc/bloc/init_screen_bloc.dart';
import 'package:$appName/features/first/presentation/screens/home_screen.dart';
import 'package:$appName/features/first/presentation/screens/init_screen.dart';
import 'package:go_router/go_router.dart';

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
  final ScreenFactory screenFactory;

  MainNavigation({required this.screenFactory});

  @override
  RouterConfig<RouteMatchList> router() => GoRouter(
        initialLocation: mainRoutesPath(MainRoutes.home),
        navigatorKey: navigatorKey,
        routes: <RouteBase>[
          GoRoute(
            name: mainRoutesName(MainRoutes.init),
            path: mainRoutesPath(MainRoutes.init),
            builder: (BuildContext context, GoRouterState state) {
              return screenFactory.makeFirstLvlPage();
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

class ScreenFactory {
  final DiContainer diContainer;

  ScreenFactory({required this.diContainer});

  Widget makeFirstLvlPage() {
    return BlocProvider(
      create: (context) => InitScreenBloc(),
      child:
          InitScreen(checkAuthorization: diContainer.makeCheckAuthorization()),
    );
  }
}
''';
}
