import 'dart:convert';

import 'package:cli_utils/cli_utils.dart';

import '../types/config.dart';

/// Writes configuration to config.json file.
///
/// Serializes [data] to JSON with pretty printing (2-space indent).

void writeConfig({required ConfigData data, required FilePath file}) {
  final json = const JsonEncoder.withIndent('\t').convert(data);

  file.writeAsString(json);
}

ConfigData readConfig({required FilePath file}) {
  final contents = file.readAsString();
  final configMap = jsonDecode(contents) as Map<ConfigKey, dynamic>;

  return ConfigData.data(configMap);
}
