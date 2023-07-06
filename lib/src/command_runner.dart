import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_completion/cli_completion.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:license_harvest_cli/src/commands/commands.dart';
import 'package:mason_logger/mason_logger.dart';

/// executableName
const String executableName = 'license_harvest';

/// packageName
const String packageName = 'license_harvest_cli';

/// description
const String description = 'License Harvest';

/// {@template license_harvest_cli_command_runner}
/// A [CommandRunner] for the CLI.
///
/// ```
/// $ license_harvest --version
/// ```
/// {@endtemplate}
class LicenseHarvestCliCommandRunner extends CompletionCommandRunner<int> {
  /// {@macro license_harvest_cli_command_runner}
  LicenseHarvestCliCommandRunner({
    final Logger? logger,
    final FileSystem? fileSystem,
  })  : _logger = logger ?? Logger(),
        _fileSystem = fileSystem ?? const LocalFileSystem(),
        super(executableName, description) {
    // Add root options and flags
    argParser.addFlag(
      'verbose',
      help: 'Noisy logging, including all shell commands executed.',
    );

    // Add sub commands
    addCommand(ReportCommand(logger: _logger, fileSystem: _fileSystem));
  }

  @override
  void printUsage() => _logger.info(usage);

  final Logger _logger;
  final FileSystem _fileSystem;

  @override
  Future<int> run(final Iterable<String> args) async {
    try {
      final ArgResults topLevelResults = parse(args);
      if (topLevelResults['verbose'] == true) {
        _logger.level = Level.verbose;
      }
      return await runCommand(topLevelResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      // On format errors, show the commands error message, root usage and
      // exit with an error code
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      // On usage errors, show the commands usage message and
      // exit with an error code
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(final ArgResults topLevelResults) async {
    // Fast track completion command
    if (topLevelResults.command?.name == 'completion') {
      await super.runCommand(topLevelResults);
      return ExitCode.success.code;
    }

    // Verbose logs
    _logger
      ..detail('Argument information:')
      ..detail('  Top level options:');
    for (final String option in topLevelResults.options) {
      if (topLevelResults.wasParsed(option)) {
        _logger.detail('  - $option: ${topLevelResults[option]}');
      }
    }
    if (topLevelResults.command != null) {
      final ArgResults commandResult = topLevelResults.command!;
      _logger
        ..detail('  Command: ${commandResult.name}')
        ..detail('    Command options:');
      for (final String option in commandResult.options) {
        if (commandResult.wasParsed(option)) {
          _logger.detail('    - $option: ${commandResult[option]}');
        }
      }
    }

    // Run the command or show version
    return super.runCommand(topLevelResults);
  }
}
