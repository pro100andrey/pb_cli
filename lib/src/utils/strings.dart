/// Common strings and messages used throughout the CLI application.
///
/// This class provides centralized access to all user-facing strings,
/// making it easier to maintain consistency and support localization.
///
library;

import '../extensions/string_style.dart';
// ignore_for_file: avoid_classes_with_only_static_members

abstract final class S {
  static const String appName = 'pb_cli';

  static const String appDescription =
      'A utility for synchronizing PocketBase schemas and data.';

  // Commands
  static const String setupCommand = 'setup';
  static const String pushCommand = 'push';
  static const String pullCommand = 'pull';

  // Command descriptions
  static const setupDescription =
      'Setup the local environment for managing PocketBase schema and data.';

  static const pushDescription =
      'Pushes the local PocketBase schema and seed data to the remote '
      'instance.';

  static const pullDescription =
      'Pulls the remote PocketBase schema and collection data into local JSON '
      'files.';

  // Options/Flags/Abbr/Helps/Defaults

  static const String dirOptionName = 'dir';
  static const String dirOptionAbbr = 'd';
  static const dirOptionHelp =
      'The local working directory for storing the PocketBase schema, config, '
      'and seed data files.';

  static const String batchSizeOptionName = 'batch-size';
  static const String batchSizeOptionAbbr = 'b';
  static const pullBatchSizeOptionHelp =
      'Number of records to fetch per batch. Maximum is 500.';
  static const pushBatchSizeOptionHelp =
      'Number of records to create per batch. Maximum is 50.';
  static const String pushBatchSizeOptionDefault = '20';
  static const String pullBatchSizeOptionDefault = '100';

  static const String verboseFlagName = 'verbose';
  static const String verboseFlagAbbr = 'v';
  static const String verboseFlagHelp = 'Enable verbose logging.';

  static const String truncateFlagName = 'truncate';
  static const String truncateFlagAbbr = 't';
  static const String truncateFlagHelp =
      'Whether to truncate existing collections before import.';

  // Info Messages
  static String startSetupForDir(String dir) =>
      'Starting setup for directory: ${dir.yellow.underlined}';
}

/// Extension methods for common string operations in CLI context.
extension StringCliExtensions on String {
  /// Truncates the string to the specified length and adds ellipsis if needed.
  ///
  /// Example:
  /// ```dart
  /// 'Very long string'.truncate(10); // 'Very lon...'
  /// ```
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) {
      return this;
    }

    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Wraps the string to fit within the specified width.
  ///
  /// Example:
  /// ```dart
  /// 'A very long line of text'.wrap(10);
  /// // 'A very\nlong line\nof text'
  /// ```
  String wrap(int width) {
    if (length <= width) {
      return this;
    }

    final buffer = StringBuffer();
    var currentLine = '';

    for (final word in split(' ')) {
      if (currentLine.isEmpty) {
        currentLine = word;
      } else if ((currentLine.length + word.length + 1) <= width) {
        currentLine += ' $word';
      } else {
        buffer.writeln(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      buffer.write(currentLine);
    }

    return buffer.toString();
  }

  /// Pads the string with spaces to center it within the specified width.
  ///
  /// Example:
  /// ```dart
  /// 'Hello'.center(11); // '   Hello   '
  /// ```
  String center(int width, {String padding = ' '}) {
    if (length >= width) {
      return this;
    }

    final totalPadding = width - length;
    final leftPadding = totalPadding ~/ 2;
    final rightPadding = totalPadding - leftPadding;

    return '${padding * leftPadding}$this${padding * rightPadding}';
  }

  /// Creates a box around the string using ASCII characters.
  ///
  /// Example:
  /// ```dart
  /// 'Hello'.box();
  /// // ┌───────┐
  /// // │ Hello │
  /// // └───────┘
  /// ```
  String box({
    int padding = 1,
    String topLeft = '┌',
    String topRight = '┐',
    String bottomLeft = '└',
    String bottomRight = '┘',
    String horizontal = '─',
    String vertical = '│',
  }) {
    final lines = split('\n');
    final maxLength = lines
        .map((l) => l.length)
        .reduce((a, b) => a > b ? a : b);
    final width = maxLength + (padding * 2);

    final buffer = StringBuffer()
      ..writeln('$topLeft${horizontal * width}$topRight');

    for (final line in lines) {
      final paddedLine = line.padRight(maxLength);
      buffer.writeln(
        '$vertical${' ' * padding}$paddedLine${' ' * padding}$vertical',
      );
    }

    buffer.write('$bottomLeft${horizontal * width}$bottomRight');

    return buffer.toString();
  }
}
