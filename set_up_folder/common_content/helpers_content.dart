part of '../create_folders.dart';

final class HelpersContent {
  String get textFieldValidator => '''class TextValidatorService {
  String? emptyCheck(String? value) =>
      value == null || value.trim().isEmpty ? 'Field cannot be empty' : null;
}
''';
}
