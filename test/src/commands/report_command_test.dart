import 'dart:io';

import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:license_harvest_cli/src/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'input.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  late FileSystem fileSystem;
  late _MockLogger logger;
  late LicenseHarvestCliCommandRunner commandRunner;
  setUp(
    () {
      fileSystem = MemoryFileSystem.test(
        style: Platform.isWindows
            ? FileSystemStyle.windows
            : FileSystemStyle.posix,
      );
      logger = _MockLogger();
      commandRunner = LicenseHarvestCliCommandRunner(
        logger: logger,
        fileSystem: fileSystem,
      );
    },
  );
  group('report', () {
    test('with a license file', () async {
      <String, String>{
        p.join(feAnalyzerSharedRootUri, 'LICENSE'): feAnalyzerSharedLicense,
        p.join(nodePreambleRootUri, 'LICENSE'): nodePreambleLicense,
        p.join('.dart_tool', 'package_config.json'): packageConfigJsonContent,
      }.forEach(
        (final String path, final String content) =>
            fileSystem.file(Uri.parse(path))
              ..createSync(recursive: true)
              ..writeAsStringSync(content),
      );

      final int exitCode = await commandRunner.run(<String>['report']);

      expect(exitCode, ExitCode.success.code);

      verify(() => logger.info('name;licenses;url_license'));
      verify(
        () => logger.info(
          '_fe_analyzer_shared;BSD-3-Clause;https://pub.dev/packages/_fe_analyzer_shared/license',
        ),
      );
      verify(
        () => logger.info(
          'node_preamble;BSD-3-Clause,MIT;https://pub.dev/packages/node_preamble/license',
        ),
      );
    });

    test('without a license file', () async {
      fileSystem
          .file(Uri.parse(p.join(feAnalyzerSharedRootUri)))
          .createSync(recursive: true);

      fileSystem.file(p.join('.dart_tool', 'package_config.json'))
        ..createSync(recursive: true)
        ..writeAsStringSync(packageConfigJsonContent);

      final int exitCode = await commandRunner.run(<String>['report']);

      expect(exitCode, ExitCode.success.code);

      verify(() => logger.info('name;licenses;url_license'));
      verifyNever(
        () => logger.info(
          '_fe_analyzer_shared;BSD-3-Clause;https://pub.dev/packages/_fe_analyzer_shared/license',
        ),
      );
    });
  });
}
