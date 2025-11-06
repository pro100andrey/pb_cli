import 'dart:io';

import 'package:pb_cli/pb_cli.dart';

Future<void> main(List<String> args) async {
  final exitCode = await run(args);

  exit(exitCode);
}
