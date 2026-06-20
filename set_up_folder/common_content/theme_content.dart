part of '../create_folders.dart';

final class ThemeContent {
  String themeTextStyle(String appName) =>
      '''
import 'package:$appName/common/application/app_settings.dart';
import 'package:flutter/material.dart';

part 'theme_text_style_extension.dart';

/// Theme-aware typography tokens exposed via [BuildContext.textStyles].
final class ThemeTextStyles extends ThemeExtension<ThemeTextStyles> {
  const ThemeTextStyles({
    required this.displayMedium,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyMedium,
    required this.bodySmall,
    required this.displaySmall,
    required this.labelSmall,
  });

  final TextStyle displayMedium;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle displaySmall;
  final TextStyle labelSmall;

  static TextStyle _tekturStyle({
    required double fontSize,
    required FontWeight weight,
    double? letterSpacing,
  }) {
    return TextStyle(
      // fontFamily: 'Tektur',
      fontSize: fontSize,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );
  }

  static final _tekturBase = ThemeTextStyles(
    displayMedium: _tekturStyle(
      fontSize: 20,
      weight: FontWeight.bold,
      letterSpacing: 2.5,
    ),
    headlineLarge: _tekturStyle(fontSize: 32, weight: FontWeight.w500),
    headlineMedium: _tekturStyle(fontSize: 22, weight: FontWeight.w500),
    headlineSmall: _tekturStyle(fontSize: 18, weight: FontWeight.w500),
    titleLarge: _tekturStyle(fontSize: 20, weight: FontWeight.w400),
    titleMedium: _tekturStyle(fontSize: 18, weight: FontWeight.w400),
    titleSmall: _tekturStyle(fontSize: 16, weight: FontWeight.w400),
    bodyMedium: _tekturStyle(fontSize: 18, weight: FontWeight.w400),
    bodySmall: _tekturStyle(fontSize: 16, weight: FontWeight.w400),
    displaySmall: _tekturStyle(fontSize: 16, weight: FontWeight.w600),
    labelSmall: _tekturStyle(fontSize: 12, weight: FontWeight.w400),
  );

  static final light = ThemeTextStyles(
    displayMedium: _tekturBase.displayMedium.darkGrey,
    headlineLarge: _tekturBase.headlineLarge.mainBlack,
    headlineMedium: _tekturBase.headlineMedium.mainBlack,
    headlineSmall: _tekturBase.headlineSmall.mainBlack,
    titleLarge: _tekturBase.titleLarge.mainBlack,
    titleMedium: _tekturBase.titleMedium.mainBlack,
    titleSmall: _tekturBase.titleSmall.mainBlack,
    bodyMedium: _tekturBase.bodyMedium.darkGrey,
    bodySmall: _tekturBase.bodySmall.subGrey,
    displaySmall: _tekturBase.displaySmall.darkGrey,
    labelSmall: _tekturBase.labelSmall.mainBlack,
  );

  static final dark = ThemeTextStyles(
    displayMedium: _tekturBase.displayMedium.mainWhite,
    headlineLarge: _tekturBase.headlineLarge.mainWhite,
    headlineMedium: _tekturBase.headlineMedium.mainWhite,
    headlineSmall: _tekturBase.headlineSmall.mainWhite,
    titleLarge: _tekturBase.titleLarge.mainWhite,
    titleMedium: _tekturBase.titleMedium.mainWhite,
    titleSmall: _tekturBase.titleSmall.mainGray,
    bodyMedium: _tekturBase.bodyMedium.darkGrey,
    bodySmall: _tekturBase.bodySmall.darkGrey,
    displaySmall: _tekturBase.displaySmall.darkGrey,
    labelSmall: _tekturBase.labelSmall.mainWhite,
  );

  @override
  ThemeTextStyles copyWith({
    TextStyle? displayMedium,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? displaySmall,
    TextStyle? labelSmall,
  }) {
    return ThemeTextStyles(
      displayMedium: displayMedium ?? this.displayMedium,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      displaySmall: displaySmall ?? this.displaySmall,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  @override
  ThemeTextStyles lerp(ThemeExtension<ThemeTextStyles>? other, double t) {
    if (other is! ThemeTextStyles) {
      return this;
    }

    return ThemeTextStyles(
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      displaySmall: TextStyle.lerp(displaySmall, other.displaySmall, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }
}
''';

  String get themeTextStyleExtension => '''
part of 'theme_text_style.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get mainBlack => copyWith(color: AppColors.mainBlack);

  TextStyle get mainWhite => copyWith(color: AppColors.mainWhite);

  TextStyle get darkGrey => copyWith(color: AppColors.darkGrey);

  TextStyle get subGrey => copyWith(color: AppColors.subGrey);

  TextStyle get mainGray => copyWith(color: AppColors.mainGray);

  TextStyle ls25() => copyWith(letterSpacing: 2.5);

  TextStyle ls2() => copyWith(letterSpacing: 2);
}

extension ThemeTextStylesExtension on BuildContext {
  ThemeTextStyles get textStyles =>
      Theme.of(this).extension<ThemeTextStyles>()!;
}
''';

  String themeColor(String appName) =>
      '''
import 'package:$appName/common/application/app_settings.dart';
import 'package:flutter/material.dart';

part 'theme_color_extension.dart';

/// Semantic, theme-aware color tokens exposed via [BuildContext.color].
final class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.scaffoldBackground,
    required this.icon,
    required this.surface,
    required this.error,
    required this.primary,
    required this.secondary,
    required this.onPrimary,
    required this.onSecondary,
    required this.onSurface,
    required this.outline,
    required this.surfaceTint,
    required this.surfaceContainerHighest,
    required this.secondaryContainer,
    required this.indicator,
    required this.appBarBackground,
    required this.appBarTitle,
    required this.navigationBar,
  });

  final Color scaffoldBackground;
  final Color icon;
  final Color surface;
  final Color error;
  final Color primary;
  final Color secondary;
  final Color onPrimary;
  final Color onSecondary;
  final Color onSurface;
  final Color outline;
  final Color surfaceTint;
  final Color surfaceContainerHighest;
  final Color secondaryContainer;
  final Color indicator;
  final Color appBarBackground;
  final Color appBarTitle;
  final Color navigationBar;

  static const light = ThemeColors(
    scaffoldBackground: AppColors.mainWhite,
    icon: AppColors.mainBlack,
    surface: AppColors.mainWhite,
    error: AppColors.errorRed,
    primary: AppColors.mainGray,
    secondary: Color(0xFFc7513b),
    onPrimary: AppColors.mainBlack,
    onSecondary: AppColors.mainWhite,
    onSurface: AppColors.mainBlack,
    outline: AppColors.subGrey,
    surfaceTint: AppColors.mainBlack,
    surfaceContainerHighest: AppColors.mainBlack,
    secondaryContainer: Color.fromARGB(255, 255, 206, 191),
    indicator: AppColors.mainBlack,
    appBarBackground: AppColors.mainWhite,
    appBarTitle: AppColors.mainWhite,
    navigationBar: AppColors.mainWhite,
  );

  static const dark = ThemeColors(
    scaffoldBackground: Color.fromARGB(255, 67, 67, 67),
    icon: AppColors.darkGrey,
    surface: Color.fromARGB(255, 88, 47, 47),
    error: AppColors.errorRed,
    primary: AppColors.suBlack,
    secondary: Color.fromARGB(255, 107, 16, 0),
    onPrimary: AppColors.mainGreen,
    onSecondary: AppColors.mainRed,
    onSurface: AppColors.mainWhite,
    outline: AppColors.darkGrey,
    surfaceTint: AppColors.mainWhite,
    surfaceContainerHighest: Color.fromARGB(255, 252, 210, 210),
    secondaryContainer: Color.fromARGB(255, 36, 20, 20),
    indicator: AppColors.mainBlue,
    appBarBackground: Color.fromARGB(255, 75, 14, 0),
    appBarTitle: AppColors.darkGrey,
    navigationBar: Color.fromARGB(255, 75, 14, 0),
  );

  @override
  ThemeColors copyWith({
    Color? scaffoldBackground,
    Color? icon,
    Color? surface,
    Color? error,
    Color? primary,
    Color? secondary,
    Color? onPrimary,
    Color? onSecondary,
    Color? onSurface,
    Color? outline,
    Color? surfaceTint,
    Color? surfaceContainerHighest,
    Color? secondaryContainer,
    Color? indicator,
    Color? appBarBackground,
    Color? appBarTitle,
    Color? navigationBar,
  }) {
    return ThemeColors(
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      icon: icon ?? this.icon,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onSurface: onSurface ?? this.onSurface,
      outline: outline ?? this.outline,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      indicator: indicator ?? this.indicator,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      navigationBar: navigationBar ?? this.navigationBar,
    );
  }

  @override
  ThemeColors lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t)!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      secondaryContainer:
          Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      indicator: Color.lerp(indicator, other.indicator, t)!,
      appBarBackground:
          Color.lerp(appBarBackground, other.appBarBackground, t)!,
      appBarTitle: Color.lerp(appBarTitle, other.appBarTitle, t)!,
      navigationBar: Color.lerp(navigationBar, other.navigationBar, t)!,
    );
  }
}
''';

  String get themeColorExtension => '''
part of 'theme_color.dart';

extension ThemeColorsExtension on BuildContext {
  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;
}
''';
}
