part of '../create_folders.dart';

final class MixinsContent {
  String errorHandlerMixin(String appName) => '''
import 'package:dartz/dartz.dart';

mixin ErrorHandlerMixin {
  Future<Either<Exception, T>> safeCall<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
''';

  String get eventTransformerMixin =>
      '''import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

mixin EventTransformerMixin {
  EventTransformer<BlocEventAbstract> debounceRestartable<BlocEventAbstract>() {
    return (events, mapper) => restartable<BlocEventAbstract>().call(
      events.debounceTime(const Duration(milliseconds: 300)),
      mapper,
    );
  }
}
''';
}
