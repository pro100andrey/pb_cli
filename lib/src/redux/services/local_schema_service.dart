import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pocketbase/pocketbase.dart';

final class LocalSchemaService {
  const LocalSchemaService._();

  static const fileName = 'local_schema.json';

  static IList<CollectionModel> read({required FilePath inputFile}) {
    if (inputFile.notFound) {
      return const IListConst([]);
    }

    final contents = inputFile.readAsString();
    final schemaData = jsonDecode(contents) as List;

    return schemaData
        .map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
        .toIList();
  }

  static void write({
    required FilePath outputFile,
    required IList<CollectionModel> data,
  }) {
    final json = const JsonEncoder.withIndent('  ').convert(data);

    outputFile.writeAsString(json);
  }
}
