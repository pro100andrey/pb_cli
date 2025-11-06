import 'dart:io';

import 'package:io/io.dart';

Future<String> getDartVersionOutput() async {
  final manager = ProcessManager();
  final spawn = await manager.spawn('dart', ['--version'], runInShell: true);

  final output = StringBuffer();
  spawn.stdout.transform(const SystemEncoding().decoder).listen(output.write);
  spawn.stderr.transform(const SystemEncoding().decoder).listen(output.write);

  await spawn.exitCode;

  return output.toString().trim();
}
