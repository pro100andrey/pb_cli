import 'dart:io' as io;

bool terminalIsAttached() {
  final hasTerminal =
      io.IOOverrides.current?.stdout.hasTerminal ?? io.stdout.hasTerminal;

  return hasTerminal;
}
