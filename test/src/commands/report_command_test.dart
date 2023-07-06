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
  group('report', () {
    late FileSystem fileSystem;
    late Logger logger;
    late LicenseHarvestCliCommandRunner commandRunner;

    setUp(() {
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
    });

    test('tells a joke', () async {
      fileSystem.file(
        Uri.parse(p.join(feAnalyzerSharedRootUri, 'LICENSE')),
      )
        ..createSync(recursive: true)
        ..writeAsStringSync(feAnalyzerSharedLicense);

      fileSystem.file(p.join('.dart_tool', 'package_config.json'))
        ..createSync(recursive: true)
        ..writeAsStringSync(packageConfigJsonContent);

      final int exitCode = await commandRunner.run(<String>['report']);

      expect(exitCode, ExitCode.success.code);

      verify(() => logger.info('name;licenses;url_license')).called(1);
      verify(
        () => logger.info(
          '_fe_analyzer_shared;BSD-3-Clause;https://pub.dev/packages/_fe_analyzer_shared/license',
        ),
      ).called(1);
    });
  });
}
