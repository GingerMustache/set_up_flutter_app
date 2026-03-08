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

class CheckAuthorizationDefault implements CheckAuthorization {
  @override
  Future<bool> isAuth() async => true;
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

  String settingsBloc(String appName) => '''import 'package:bloc/bloc.dart';
import 'package:$appName/common/localization/i18n/strings.g.dart';
import 'package:$appName/common/services/local_storage/secure_storage.dart';
import 'package:$appName/common/configs/setting_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LocalStorageService _localStorage;
  final SettingConfig _settingConfig;
  List<String> get _settingItems => [
    // 'Security',
    // 'Display',
    // 'Help & Support',
    // 'About',
    // 'Logout',
  ];

  SettingsBloc({required LocalStorageService localStorage})
    : _localStorage = localStorage,

      super(SettingsState()) {
    on<SettingChangeLangEvent>(_onChangeLang);
    on<SettingChangeThemeEvent>(_onChangeTheme);
    on<SettingInitEvent>(_onInit);
    on<SettingSearchEvent>(_onSettingSearch);
   
  }

  _onInit(SettingInitEvent event, Emitter<SettingsState> emit) async {
    final currentLang = await _localStorage.read(
      SecureKeys.lang.name,
      insteadValue: 'ru',
    );

    final currentTheme =
        await _localStorage.read(SecureKeys.theme.name) == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light;


    emit(
      state.copyWith(
        lang: currentLang,
        theme: currentTheme,
        settingItems: _settingItems,
      ),
    );
  }

  _onChangeLang(
    SettingChangeLangEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final isRu = event.lang == 'ru';

    await _localStorage.write(key: SecureKeys.lang.name, value: event.lang);
    await LocaleSettings.setLocale(isRu ? AppLocale.ru : AppLocale.en);

    emit(state.copyWith(lang: event.lang, settingItems: _settingItems));
  }

  _onChangeTheme(
    SettingChangeThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _localStorage.write(
      key: SecureKeys.theme.name,
      value: event.theme.name,
    );

    emit(state.copyWith(theme: event.theme));
  }

  _onSettingSearch(
    SettingSearchEvent event,
    Emitter<SettingsState> emit,
  ) async {
    List<String> settings = state.settingItems;

    if (event.query != null && event.query!.isNotEmpty) {
      final List<String> foundSetting =
          settings
              .where((element) => element.contains(event.query ?? ''))
              .toList();

      foundSetting.isEmpty
          ? emit(state.copyWith(settingItems: state.settingItems))
          : emit(state.copyWith(searchItems: foundSetting));
    } else {
      emit(state.copyWith(settingItems: state.settingItems, searchItems: []));
    }
  }
}
''';

  String get settingsEvent => '''part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent extends Equatable {}

class SettingChangeLangEvent extends SettingsEvent {
  final String lang;

  SettingChangeLangEvent({required this.lang});

  @override
  List<Object?> get props => [lang];
}

class SettingChangeThemeEvent extends SettingsEvent {
  final ThemeMode theme;

  SettingChangeThemeEvent({required this.theme});
  @override
  List<Object?> get props => [theme];
}

class SettingInitEvent extends SettingsEvent {
  @override
  List<Object?> get props => [];
}

class SettingSearchEvent extends SettingsEvent {
  final String? query;

  SettingSearchEvent({required this.query});

  @override
  List<Object?> get props => [query];
}
''';

  String get settingsState =>
      '''// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  const SettingsState({
    this.lang = 'en',
    this.theme = ThemeMode.light,

    this.settingItems = const [],
    this.searchItems = const [],
  });

  final String lang;
  final ThemeMode theme;

  final List<String> settingItems;
  final List<String> searchItems;

  @override
  List<Object?> get props => [lang, theme, settingItems, searchItems];

  SettingsState copyWith({
    String? lang,
    ThemeMode? theme,

    List<String>? settingItems,
    List<String>? searchItems,
  }) {
    return SettingsState(
      lang: lang ?? this.lang,
      theme: theme ?? this.theme,
      settingItems: settingItems ?? this.settingItems,
      searchItems: searchItems ?? this.searchItems,
    );
  }
}
''';
}
