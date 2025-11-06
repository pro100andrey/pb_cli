extension NestedMapFormatter on StringBuffer {
  /// Appends key-value pairs from a map to the buffer,
  /// handling nested Maps and Lists recursively.
  ///
  /// [currentIndent] tracks the current indentation level.
  void writeNestedMapInfo(
    String header,
    Map<String, dynamic> data, {
    String currentIndent = '',
    String indentStep = '  ',
    String separator = ': ',
  }) {
    writeln('$currentIndent$header');

    final nextIndent = currentIndent + indentStep;

    data.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        writeNestedMapInfo(
          '$key$separator',
          value,
          currentIndent: nextIndent,
          indentStep: indentStep,
          separator: separator,
        );
      } else if (value is List) {
        writeln('$nextIndent$key$separator[List with ${value.length} items]');

        for (var i = 0; i < value.length; i++) {
          final item = value[i];
          if (item is Map<String, dynamic>) {
            writeNestedMapInfo(
              '[$i]',
              item,
              currentIndent: nextIndent + indentStep,
              indentStep: indentStep,
              separator: separator,
            );
          } else {
            writeln('$nextIndent$indentStep[$i]$separator$item');
          }
        }
      } else {
        writeln('$nextIndent$key$separator$value');
      }
    });
  }
}
