part of '../create_folders.dart';

final class ServicesContent {
  String di(String appName) => '''
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:$appName/common/helpers/text_field_validator/text_field_validator.dart';
import 'package:$appName/common/presentation/widgets/app/my_app.dart';
import 'package:$appName/common/routing/routes.dart';
import 'package:$appName/features/first/presentation/screens/init_screen.dart';

abstract class DiContainerProvider {
  Widget makeApp(FlutterI18nDelegate flutterI18nDelegate);
  TextValidatorService makeTextValidatorService();
}

class DiContainer implements DiContainerProvider {
  ScreenFactory _makeScreenFactory() => ScreenFactory(diContainer: this);
  MyAppNavigation _makeRouter() =>
      MainNavigation(screenFactory: _makeScreenFactory());
  
  @override
  TextValidatorService makeTextValidatorService() => TextValidatorService();
  @override
  Widget makeApp(FlutterI18nDelegate flutterI18nDelegate) => MyApp(
    navigation: _makeRouter(),
    flutterI18nDelegate: flutterI18nDelegate,
  );
  CheckAuthorization makeCheckAuthorization() => CheckAuthorizationDefault();

  DiContainer();
}

''';

  String errorService(String appName) => '''import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class _SentryConfig {
  static FutureOr<void> options(SentryFlutterOptions options) {
    options.dsn = dotenv.env['SENTRY_DSN'];
    options.tracesSampleRate = 0.2; // Performance monitoring
    options.profilesSampleRate = 0.2; // Optional profiling
    options.debug = false;
  }
}

class MainErrorService {
  static MainErrorService? _instance;
  late final Talker _talker;

  MainErrorService._();

  get talker => _talker;

  static MainErrorService get instance {
    _instance ??= MainErrorService._();
    return _instance!;
  }

  void initialize() {
    _talker = TalkerFlutter.init();

    FlutterError.onError = (FlutterErrorDetails details) {
      _reportError(details.exception, details.stack ?? StackTrace.current);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _reportError(error, stack);
      return true;
    };

    _talker.info('Init ErrorService ');
  }

  Future<void> _reportError(dynamic error, StackTrace stackTrace) async {
    if (kDebugMode) {
      _talker.handle(error, stackTrace);
    }
  }

  Future<void> reportError(dynamic error, [StackTrace? stackTrace]) async {
    await _reportError(error, stackTrace ?? StackTrace.current);
  }

  void runGuarded(void Function() body) async {
    SentryWidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: '.env');

    await SentryFlutter.init(
      _SentryConfig.options,
      appRunner: () async {
        body();
        (error, stackTrace) => _reportError(error, stackTrace);
      },
    );
  }
}
''';

  String filePickService(String appName) =>
      '''import 'package:$appName/common/services/file_pick/exceptions/file_pick_service_exceptions.dart';
import 'package:file_picker/file_picker.dart';

abstract final class FilePickService {
  Future<FilePickerResult?> pickSingleFile({List<String>? allowedExtensions});
  Future<FilePickerResult?> pickMultipleFiles({
    List<String>? allowedExtensions,
  });
  Future<FilePickerResult?> pickJsonFile();
}

final class NetFilePickServiceImpl implements FilePickService {
  static final NetFilePickServiceImpl _instance =
      NetFilePickServiceImpl._internal();

  NetFilePickServiceImpl._internal();

  factory NetFilePickServiceImpl() => _instance;

  @override
  Future<FilePickerResult?> pickSingleFile({
    List<String>? allowedExtensions,
  }) async {
    try {
      return await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );
    } catch (e) {
      throw FilePickException();
    }
  }

  @override
  Future<FilePickerResult?> pickMultipleFiles({
    List<String>? allowedExtensions,
  }) async {
    try {
      return await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );
    } catch (e) {
      throw FilePickException();
    }
  }

  @override
  Future<FilePickerResult?> pickJsonFile() async {
    try {
      return await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
    } catch (e) {
      throw FilePickException();
    }
  }
}
''';

  String get filePickServiceExceptions =>
      '''abstract class FilePickServiceExceptions implements Exception {}

class FilePickException implements FilePickServiceExceptions {}
''';

  String get secureStorage =>
      '''import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StorageError { secureStorageError }

enum SecureKeys { lang, theme, brightness }

abstract final class LocalStorageService {
  Future<Map<String, String>> readAll();
  Future<void> deleteAll();
  Future<String> read(String key, {String insteadValue = ''});
  Future<void> delete({required String key});
  Future<void> write({required String key, required String value});
  Future<bool> containsKey({required String key});
}

final class SecureStorage implements LocalStorageService {
  static final SecureStorage _instance = SecureStorage._internal();

  late final FlutterSecureStorage _storage;

  SecureStorage._internal() {
    _storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }
  factory SecureStorage() => _instance;

  final bool errorFlag = false;

  @override
  Future<Map<String, String>> readAll() async {
    var map = <String, String>{};

    try {
      map = await _storage.readAll();
    } catch (e, stackTrace) {
      errorAction(e, stackTrace);
    }
    return map;
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e, stackTrace) {
      errorAction(e, stackTrace);
    }
  }

  /// use instead value, when result must not be empty
  @override
  Future<String> read(String key, {String insteadValue = ''}) async {
    String value = '';
    if (!errorFlag) {
      try {
        value = (await _storage.read(key: key)) ?? insteadValue;
        throw Exception('bad SecureStore test');
      } catch (e, stackTrace) {
        errorAction(e, stackTrace);
      }
    }
    return value;
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e, stackTrace) {
      errorAction(e, stackTrace);
    }
  }

  @override
  Future<void> write({required String key, required String value}) async {
    if (!errorFlag) {
      try {
        await _storage.write(key: key, value: value);
        throw Exception('bad SecureStore test');
      } catch (e, stackTrace) {
        errorAction(e, stackTrace);
      }
    }
  }

  @override
  Future<bool> containsKey({required String key}) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e, stackTrace) {
      errorAction(e, stackTrace);

      return false;
    }
  }

  static IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  void errorAction(Object e, StackTrace stackTrace) {
    // talker.error(e);
    // AppMetrica.reportErrorWithGroup(
    //   'SecureStorage',
    //   errorDescription: AppMetricaErrorDescription(
    //     stackTrace,
    //     message: 'Error - \$e',
    //   ),
    // );
    // setErrorFlag(true);
  }

  // void setErrorFlag(bool value) => runInAction(() => errorFlag.value = value);
}
''';
}
