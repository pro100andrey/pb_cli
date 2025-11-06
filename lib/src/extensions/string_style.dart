import 'package:io/ansi.dart' as ansi;

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

  // Reset style methods
  /// Reset all text styling to default.
  String get resetAll => ansi.resetAll.wrap(this)!;

  /// Reset bold text style only.
  String get resetBold => ansi.resetBold.wrap(this)!;

  /// Reset dim text style only.
  String get resetDim => ansi.resetDim.wrap(this)!;

  /// Reset italic text style only.
  String get resetItalic => ansi.resetItalic.wrap(this)!;

  /// Reset underlined text style only.
  String get resetUnderlined => ansi.resetUnderlined.wrap(this)!;

  /// Reset crossed out text style only.
  String get resetCrossedOut => ansi.resetCrossedOut.wrap(this)!;

  /// Reset blinking text style only.
  String get resetBlink => ansi.resetBlink.wrap(this)!;
}
