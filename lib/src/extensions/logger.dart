import 'package:mason_logger/mason_logger.dart';

import 'string_style.dart';

extension LoggerInfoSectionExt on Logger {
  /// Logs a formatted information section.
  /// [title] is the title of the section.
  /// [items] is a map of key-value pairs to display.
  ///
  void section({
    required String title,
    required Map<String, String> items,
    Level level = Level.info,
  }) {
    final maxKeyLength = items.keys.fold(
      0,
      (max, key) => max > key.length ? max : key.length,
    );

    final buffer = StringBuffer()..writeln(title.bold);

    items.forEach((key, value) {
      final paddedKey = key.padRight(maxKeyLength);
      final output = '${paddedKey.dim.bold}: $value';

      buffer.writeln(output);
    });

    final result = buffer.toString().trim();

    info(result);
  }
}
