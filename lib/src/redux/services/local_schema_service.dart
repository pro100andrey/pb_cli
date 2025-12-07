import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';

final class LocalSchemaService {
  const LocalSchemaService._();

  static const fileName = 'local_schema.json';

  static Map<String, dynamic> read({required FilePath inputFile}) {
    if (inputFile.notFound) {
      return {};
    }

    final contents = inputFile.readAsString();
    final schemaMap = jsonDecode(contents) as Map<String, dynamic>;

    return schemaMap;
  }

  static void write({
    required FilePath outputFile,
    required Map<String, dynamic> data,
  }) {
    final json = const JsonEncoder.withIndent('  ').convert(data);

    outputFile.writeAsString(json);
  }
}
