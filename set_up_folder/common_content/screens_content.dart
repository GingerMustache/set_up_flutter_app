part of '../create_folders.dart';

final class ScreensContent {
  String get event => '''
part of 'init_screen_bloc.dart';

@immutable
sealed class InitScreenEvent {}

''';

  String get state => '''
part of 'init_screen_bloc.dart';

@immutable
sealed class InitScreenState {}

final class InitScreenInitial extends InitScreenState {}
''';

  String get bloc => '''
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'init_screen_event.dart';
part 'init_screen_state.dart';

class InitScreenBloc extends Bloc<InitScreenEvent, InitScreenState> {
  InitScreenBloc() : super(InitScreenInitial()) {
    on<InitScreenEvent>((event, emit) {
    });
  }
}
''';

  String get homeScreen => '''
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
''';
  String initScreen(String appName) => '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:$appName/common/application/app_settings.dart';
import 'package:$appName/common/routing/routes.dart';

abstract interface class CheckAuthorization {
  Future<bool> isAuth();
}

class InitScreen extends StatefulWidget {
  const InitScreen({super.key, required this.checkAuthorization});
  final CheckAuthorization checkAuthorization;

  @override
  InitScreenState createState() => InitScreenState();
}

class InitScreenState extends State<InitScreen> {
  late Future<bool> _data;

  InitScreenState();

  @override
  void initState() {
    super.initState();
    _data = widget.checkAuthorization.isAuth();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: _data.then((value) {
          value
              ? context.goNamed(mainRoutesName(MainRoutes.home))
              : print('need to implement SignInScreen');
          return true;
        }),
        builder: (context, AsyncSnapshot<bool> snapshot) => Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
              color: AppColors.mainBlack,
            )),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
      }
''';
}
