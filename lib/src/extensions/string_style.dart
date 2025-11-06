import 'package:io/ansi.dart' as ansi;

/// Regular expression to match ANSI escape codes.
final _ansiRegex = RegExp(r'\x1B\[[0-9;]*[A-Za-z]');

/// Extension that adds styling capabilities to String objects using ANSI codes.
///
/// Example usage:
/// ```dart
/// print('Hello World'.white.bold.underlined);
/// print('Error message'.red.bold);
/// ```
extension StringStyleExt on String {
  // Apply red foreground color.
  String get red => ansi.red.wrap(this)!;

  /// Apply light red foreground color.
  String get lightRed => ansi.lightRed.wrap(this)!;

  /// Apply green foreground color.
  String get green => ansi.green.wrap(this)!;

  /// Apply light green foreground color.
  String get lightGreen => ansi.lightGreen.wrap(this)!;

  /// Apply blue foreground color.
  String get blue => ansi.blue.wrap(this)!;

  /// Apply light blue foreground color.
  String get lightBlue => ansi.lightBlue.wrap(this)!;

  /// Apply yellow foreground color.
  String get yellow => ansi.yellow.wrap(this)!;

  /// Apply light yellow foreground color.
  String get lightYellow => ansi.lightYellow.wrap(this)!;

  /// Apply cyan foreground color.
  String get cyan => ansi.cyan.wrap(this)!;

  /// Apply light cyan foreground color.
  String get lightCyan => ansi.lightCyan.wrap(this)!;

  /// Apply magenta foreground color.
  String get magenta => ansi.magenta.wrap(this)!;

  /// Apply light magenta foreground color.
  String get lightMagenta => ansi.lightMagenta.wrap(this)!;

  /// Apply black foreground color.
  String get black => ansi.black.wrap(this)!;

  /// Apply white foreground color.
  String get white => ansi.lightGray.wrap(this)!;

  /// Apply gray foreground color.
  String get gray => ansi.darkGray.wrap(this)!;

  /// Apply light gray foreground color.
  String get lightGray => ansi.lightGray.wrap(this)!;

  // Background colors with "on" prefix
  /// Apply red background color.
  String get onRed => ansi.backgroundRed.wrap(this)!;

  /// Apply light red background color.
  String get onLightRed => ansi.backgroundLightRed.wrap(this)!;

  /// Apply green background color.
  String get onGreen => ansi.backgroundGreen.wrap(this)!;

  /// Apply light green background color.
  String get onLightGreen => ansi.backgroundLightGreen.wrap(this)!;

  /// Apply blue background color.
  String get onBlue => ansi.backgroundBlue.wrap(this)!;

  /// Apply light blue background color.
  String get onLightBlue => ansi.backgroundLightBlue.wrap(this)!;

  /// Apply yellow background color.
  String get onYellow => ansi.backgroundYellow.wrap(this)!;

  /// Apply light yellow background color.
  String get onLightYellow => ansi.backgroundLightYellow.wrap(this)!;

  /// Apply cyan background color.
  String get onCyan => ansi.backgroundCyan.wrap(this)!;

  /// Apply light cyan background color.
  String get onLightCyan => ansi.backgroundLightCyan.wrap(this)!;

  /// Apply magenta background color.
  String get onMagenta => ansi.backgroundMagenta.wrap(this)!;

  /// Apply light magenta background color.
  String get onLightMagenta => ansi.backgroundLightMagenta.wrap(this)!;

  /// Apply black background color.
  String get onBlack => ansi.backgroundBlack.wrap(this)!;

  /// Apply white background color.
  String get onWhite => ansi.backgroundLightGray.wrap(this)!;

  // Direct style methods
  /// Apply bold text style.
  String get bold => ansi.styleBold.wrap(this)!;

  /// Apply dim (faint) text style.
  String get dim => ansi.styleDim.wrap(this)!;

  /// Apply italic text style.
  String get italic => ansi.styleItalic.wrap(this)!;

  /// Apply underlined text style.
  String get underlined => ansi.styleUnderlined.wrap(this)!;

  /// Apply crossed out text style.
  String get crossedOut => ansi.styleCrossedOut.wrap(this)!;

  /// Apply blinking text style.
  String get blink => ansi.styleBlink.wrap(this)!;

  /// Remove all ANSI styles from the string.
  String get plain => replaceAll(_ansiRegex, '');

  /// Check if the string has no ANSI styles applied.
  bool get isPlain => !_ansiRegex.hasMatch(this);
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
    if (maxLength <= 20) {
      return this;
    }

    final maxVisibleLength = maxLength - ellipsis.length;
    final len = length;
    var visibleLength = 0;
    var truncateIndex = length;
    var inAnsiCode = false;
    var hasAnsi = false;

    for (var i = 0; i < len; i++) {
      final unit = codeUnitAt(i);

      if (unit == 0x1B) {
        // ESC
        inAnsiCode = true;
        hasAnsi = true;
        continue;
      }

      if (inAnsiCode) {
        if (unit == 0x6D) {
          // 'm'
          inAnsiCode = false;
        }
        continue;
      }

      if (visibleLength >= maxVisibleLength) {
        truncateIndex = i;
        break;
      }

      visibleLength++;
    }

    if (visibleLength <= maxVisibleLength && truncateIndex == len) {
      return this;
    }

    final truncated = substring(0, truncateIndex);
    return '$truncated$ellipsis${hasAnsi ? '\x1B[0m' : ''}';
  }

  /// Wraps the string to the specified [width], respecting word boundaries
  /// and ignoring the length of ANSI escape codes.
  ///
  /// This ensures that the visible width of each line does not exceed the
  /// limit.
  String wrap(int width) {
    int calculateVisibleLength(String text) {
      var visibleLength = 0;
      var inAnsiCode = false;

      for (var i = 0; i < text.length; i++) {
        final unit = text.codeUnitAt(i);

        if (unit == 0x1B) {
          // ESC (Start of ANSI code)
          inAnsiCode = true;
          continue;
        }

        if (inAnsiCode) {
          if (unit == 0x6D) {
            // 'm' (End of standard SGR code)
            inAnsiCode = false;
          }
          continue;
        }

        visibleLength++;
      }
      return visibleLength;
    }

    if (calculateVisibleLength(this) <= width) {
      return this;
    }

    final buffer = StringBuffer();
    var currentLine = '';

    // Split the string by spaces. We assume ANSI codes, if present, are
    // entirely contained within these "words" or are standalone.
    final words = split(' ');

    for (final word in words) {
      final wordVisibleLength = calculateVisibleLength(word);
      final currentLineVisibleLength = calculateVisibleLength(currentLine);

      if (currentLine.isEmpty) {
        // Start of the line
        currentLine = word;
      } else if ((currentLineVisibleLength + wordVisibleLength + 1) <= width) {
        // Current line + space + word fits within the visible width
        currentLine += ' $word';
      } else {
        // It doesn't fit, move current line to buffer and start new line with
        //the word
        buffer.writeln(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      buffer.write(currentLine);
    }

    return buffer.toString();
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
