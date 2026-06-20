part of '../create_folders.dart';

final class ApplicationContent {
  String get part => 'part of "app_settings.dart";';

  String get appSettings => '''
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'button_styles.dart';
part 'colors.dart';
part 'decoration.dart';
part 'links.dart';
part 'paddings.dart';
''';

  String get colors => '''
part of "app_settings.dart";

class AppColors {
  AppColors._();

  static const Color mainWhite = Colors.white;
  static const Color steam = Color(0xFFDDDDDD);
  static const Color mainGray = Color(0xfff2f4f6);
  static const Color subGrey = Color(0xFF9CA3AF);
  static const Color darkGrey = Color(0xff6B7280);
  static const Color mainBlack = Colors.black;
  static const Color subBlack = Color(0xff1A1A1A);
  static const Color suBlack = Color(0xff2A2A2A);
  static const Color mainGreen = Colors.green;
  static const Color mainRed = Color.fromARGB(255, 255, 102, 0);
  static const Color errorRed = Color.fromARGB(255, 181, 8, 8);
  static const Color mainBlue = Colors.blue;
  static const Color mainLightGold = Color.fromARGB(255, 250, 234, 143);
  static Color withAlpha = Colors.grey.withAlpha(30);
}
''';

  String get links => '''
part of "app_settings.dart";

String _base = '\${dotenv.env['URL']}';

class BasePaths {
  static final base = _base;
  
  BasePaths._();
  static final BasePaths _instance = BasePaths._();
  factory BasePaths() => _instance;
}
''';
}
