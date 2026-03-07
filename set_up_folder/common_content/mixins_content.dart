part of '../create_folders.dart';

final class MixinsContent {
  String errorHandlerMixin(String appName) => '''import 'package:$appName/common/services/local_crud/exceptions/crud_exceptions.dart';
import 'package:$appName/common/services/local_crud/local_data_base_error_message_resolver/local_data_base_error_message_resolver.dart';
import 'package:$appName/common/services/share/exceptions/shared_service_exceptions.dart';
import 'package:dartz/dartz.dart';

mixin ErrorHandlerMixin {
  Future<Either<Exception, T>> safeCall<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on LocalDataBaseException catch (e) {
      final resolvedError =
          LocalDataBaseErrorMessageResolver.withResolvedMessage(e);

      return Left(resolvedError);
    } on SharedServiceExceptions catch (e) {
      return Left(e);
    } catch (e) {
      return Left(e as Exception);
    }
  }
}
''';

  String get eventTransformerMixin => '''import 'package:bloc_concurrency/bloc_concurrency.dart';
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
