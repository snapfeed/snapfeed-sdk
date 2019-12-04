import 'dart:async';
import 'dart:io';

const libSourceDirs = ['lib', 'tool'];
const exampleSourceDirs = ['example/lib'];
const sourceDirs = [...libSourceDirs, ...exampleSourceDirs];

Future<void> main(List<String> args) async {
  stdout.writeln('Reformatting project with dartfmt');

  final Process dartfmt = await Process.start(
      'dartfmt', ['--set-exit-if-changed', '-w', '--fix', ...sourceDirs]);

  // Consume streams, otherwise the system doesn't release them
  stderr.addStream(dartfmt.stderr);
  stdout.addStream(dartfmt.stdout
      // help dartfmt formatting
      .map((it) => String.fromCharCodes(it))
      .where((it) => !it.contains('Unchanged'))
      .map(reformatDartFmtStdout)
      .map((it) => it.codeUnits));

  // wait for process to complete
  final reformatExit = await dartfmt.exitCode;

  stdout.writeln('');
  if (reformatExit == 0) {
    stdout.writeln('All files are correctly formatted');
  } else {
    stdout.writeln('Error: Some files require reformatting with dartfmt');
    stdout.writeln('run: ./flutterw pub run tool/reformat.dart');
  }
  exit(reformatExit);
}

String reformatDartFmtStdout(String line) {
  if (line.startsWith('Formatting directory')) {
    return line.replaceFirst('Formatting directory ', '');
  }
  return '- $line';
}
