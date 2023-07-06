import 'package:cli_completion/cli_completion.dart';
import 'package:license_harvest_cli/src/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  group('LicenseHarvestCliCommandRunner', () {
    late Logger logger;
    late LicenseHarvestCliCommandRunner commandRunner;

    setUp(() {
      logger = _MockLogger();

      commandRunner = LicenseHarvestCliCommandRunner(logger: logger);
    });

    test('can be instantiated without an explicit analytics/logger instance',
        () {
      final LicenseHarvestCliCommandRunner commandRunner =
          LicenseHarvestCliCommandRunner();
      expect(commandRunner, isNotNull);
      expect(commandRunner, isA<CompletionCommandRunner<int>>());
    });

    group('--verbose', () {
      test('enables verbose logging', () async {
        final int result = await commandRunner.run(<String>['--verbose']);
        expect(result, equals(ExitCode.success.code));

        verify(() => logger.detail('Argument information:')).called(1);
        verify(() => logger.detail('  Top level options:')).called(1);
        verify(() => logger.detail('  - verbose: true')).called(1);
        verifyNever(() => logger.detail('    Command options:'));
      });
    });
  });
}
