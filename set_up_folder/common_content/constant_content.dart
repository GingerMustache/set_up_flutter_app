part of '../create_folders.dart';

final class ConstantsContent {
  String get constants => '''
import 'package:flutter/material.dart';

part 'global.dart';
part 'snacks.dart';
part 'spaces.dart';
''';

  String get global => '''
part of 'constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
''';

  String get spaces => '''
part of 'constants.dart';

class Space {
  Space._();
  static final Space _instance = Space._();
  factory Space() => _instance;

  static const h0 = SizedBox(height: 0.0);
  static const h5 = SizedBox(height: 5.0);
  static const h10 = SizedBox(height: 10.0);
  static const h15 = SizedBox(height: 15.0);
  static const h20 = SizedBox(height: 20.0);
  static const h30 = SizedBox(height: 30.0);
  static const h40 = SizedBox(height: 30.0);
  static const h55 = SizedBox(height: 55.0);
  static const h60 = SizedBox(height: 60.0);

  static const w5 = SizedBox(width: 5.0);
  static const w10 = SizedBox(width: 10.0);
  static const w15 = SizedBox(width: 15.0);
  static const w20 = SizedBox(width: 20.0);
  static const w30 = SizedBox(width: 30.0);
  static const w40 = SizedBox(width: 40.0);
  static const w55 = SizedBox(width: 55.0);
  static const w60 = SizedBox(width: 60.0);
}
''';

  String get snacks => '''
part of 'constants.dart';

class Snack {
  final String text;

  Snack(this.text);

  void success() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.green,
        Icons.check_circle_outlined,
      ),
    );
  }

  void error() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.red,
        Icons.error_outline_outlined,
      ),
    );
  }

  void warning() {
    snackbarKey.currentState?.showSnackBar(
      snackBar(
        text,
        Colors.blueGrey,
        Icons.warning_outlined,
      ),
    );
  }

  SnackBar snackBar(String text, Color color, IconData icon) {
    return SnackBar(
      backgroundColor: color,
      padding: const EdgeInsets.all(20),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Space.h10,
          Flexible(child: Text(text)),
        ],
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
''';
}
