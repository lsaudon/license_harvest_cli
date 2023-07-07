import 'dart:io';

import 'package:file/memory.dart';
import 'package:license_harvest_cli/src/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'input.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('report', () {
    test('with a license file', () async {
      final MemoryFileSystem fileSystem = MemoryFileSystem.test(
        style: Platform.isWindows
            ? FileSystemStyle.windows
            : FileSystemStyle.posix,
      );

      fileSystem.file(Uri.parse(p.join(feAnalyzerSharedRootUri, 'LICENSE')))
        ..createSync(recursive: true)
        ..writeAsStringSync(feAnalyzerSharedLicense);

      fileSystem.file(p.join('.dart_tool', 'package_config.json'))
        ..createSync(recursive: true)
        ..writeAsStringSync(packageConfigJsonContent);

      final _MockLogger logger = _MockLogger();
      final int exitCode = await LicenseHarvestCliCommandRunner(
        logger: logger,
        fileSystem: fileSystem,
      ).run(<String>['report']);

      expect(exitCode, ExitCode.success.code);

      verify(() => logger.info('name;licenses;url_license'));
      verify(
        () => logger.info(
          '_fe_analyzer_shared;BSD-3-Clause;https://pub.dev/packages/_fe_analyzer_shared/license',
        ),
      );
    });

    test('without a license file', () async {
      final MemoryFileSystem fileSystem = MemoryFileSystem.test(
        style: Platform.isWindows
            ? FileSystemStyle.windows
            : FileSystemStyle.posix,
      );

      fileSystem
          .file(Uri.parse(p.join(feAnalyzerSharedRootUri)))
          .createSync(recursive: true);

      fileSystem.file(p.join('.dart_tool', 'package_config.json'))
        ..createSync(recursive: true)
        ..writeAsStringSync(packageConfigJsonContent);

      final _MockLogger logger = _MockLogger();
      final int exitCode = await LicenseHarvestCliCommandRunner(
        logger: logger,
        fileSystem: fileSystem,
      ).run(<String>['report']);

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
