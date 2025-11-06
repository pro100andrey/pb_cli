/// Utility class for formatting and creating CLI messages.
///
/// This class provides helper methods for creating consistent,
/// well-formatted messages throughout the CLI application.
library;

import '../extensions/string_style.dart';

// ignore_for_file: avoid_classes_with_only_static_members
abstract final class Console {
  /// Creates a progress message for batch operations.
  ///
  /// Example:
  /// ```dart
  /// Cli.progress(50, 100, 'Fetching records');
  /// // 'Fetching records: 50/100 (50%)'
  /// ```
  static String progress(int current, int total, String action) {
    final percentage = (total == 0) ? 0.0 : ((current / total) * 100);

    return '$action: $current/$total (${percentage.toStringAsFixed(1)}%)';
  }

  /// Creates an error message with context.
  ///
  /// Example:
  /// ```dart
  /// Cli.error('Connection failed', context: 'Unable to reach server');
  /// // 'Error: Connection failed\nDetails: Unable to reach server'
  /// ```
  static String error(
    String message, {
    String? context,
    String? suggestion,
    int messagePadding = 0,
    int initialPadding = 2,
    int suggestionPadding = 2,
  }) {
    String pad(String text, int spaces) =>
        ' ' * spaces + text.replaceAll('\n', '\n${' ' * spaces}');

    final buffer = StringBuffer(pad(message.red, messagePadding));
    if (context != null) {
      buffer.write('\n Details: ${pad(context, initialPadding)}');
    }
    if (suggestion != null) {
      buffer.write('\n Suggestion: ${pad(suggestion, suggestionPadding)}');
    }

    return buffer.toString();
  }

  /// Creates a success message with optional details.
  ///
  /// Example:
  /// ```dart
  /// Cli.success('Setup completed', details: '5 collections configured');
  /// // '✓ Setup completed\n  5 collections configured'
  /// ```
  static String success(String message, {String? details}) {
    final buffer = StringBuffer('${'✓'.green} $message');
    if (details != null) {
      buffer.write('\n  $details');
    }

    return buffer.toString();
  }

  /// Creates a list of items with bullet points.
  ///
  /// Example:
  /// ```dart
  /// Cli.bulletList(['Item 1', 'Item 2']);
  /// // • Item 1
  /// // • Item 2
  /// ```
  static String bulletList(List<String> items, {String bullet = '•'}) =>
      items.map((item) => '$bullet $item').join('\n');

  /// Creates a table from headers and rows.
  ///
  /// Example:
  /// ```dart
  /// Cli.table(
  ///   headers: ['Name', 'Status'],
  ///   rows: [['users', 'synced'], ['posts', 'pending']],
  /// );
  /// ```
  static String table({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    // Calculate column widths
    final columnWidths = List.generate(headers.length, (i) {
      var maxWidth = headers[i].plain.length;

      for (final row in rows) {
        if (i < row.length) {
          final plainRow = row[i].plain;
          if (plainRow.length > maxWidth) {
            maxWidth = plainRow.length;
          }
        }
      }

      return maxWidth;
    });

    final buffer = StringBuffer();

    // Headers
    for (var i = 0; i < headers.length; i++) {
      final text = headers[i];
      final plainLen = text.plain.length;
      buffer.write('$text${' ' * (columnWidths[i] - plainLen + 2)}');
    }

    buffer.writeln();

    // Separator
    for (final width in columnWidths) {
      buffer.write('─' * (width + 2));
    }

    buffer.writeln();

    // Rows
    for (final row in rows) {
      for (var i = 0; i < headers.length; i++) {
        final text = i < row.length ? row[i] : '';
        final plainLen = text.plain.length;
        buffer.write('$text${' ' * (columnWidths[i] - plainLen + 2)}');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
