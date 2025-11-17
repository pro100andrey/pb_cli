import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

import 'string_style.dart';

extension LoggerInfoSectionExt on Logger {
  /// Logs a formatted information section.
  /// [title] is the title of the section.
  /// [items] is a map of key-value pairs to display.
  ///
  void sectionMapped({
    required String title,
    required Map<String, String> items,
    Level level = Level.info,
    int titlePadding = 2,
    int padding = 4,
  }) {
    final maxKeyLength = items.keys.fold(
      0,
      (max, key) => max > key.length ? max : key.length,
    );

    final buffer = StringBuffer()..writeln('${' ' * titlePadding}$title'.bold);

    items.forEach((key, value) {
      final paddedKey = ' ' * padding + key.padRight(maxKeyLength);
      final output = '${paddedKey.dim.bold}: $value';

      buffer.writeln(output);
    });

    final result = buffer.toString().trim();

    stdout.writeln(result);
  }

  void section({
    required String title,
    required List<String> items,
    Level level = Level.info,
    int titlePadding = 2,
    int padding = 4,
  }) {
    if (this.level.index > level.index) {
      return;
    }

    final buffer = StringBuffer()..writeln('${' ' * titlePadding}$title'.bold);

    for (final item in items) {
      buffer.writeln('${' ' * padding}$item');
    }

    final result = buffer.toString().trim();

    stdout.writeln(result);
  }
}
