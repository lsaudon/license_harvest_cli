// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pana/src/license.dart';
import 'package:pana/src/model.dart';
import 'package:path/path.dart' as p;

/// A [Command] to exemplify a sub command
///
/// This command reports licenses.
class ReportCommand extends Command<int> {
  /// Constructs a [ReportCommand] with the specified [logger] and [fileSystem].
  ReportCommand({
    required final Logger logger,
    required final FileSystem fileSystem,
  })  : _logger = logger,
        _fileSystem = fileSystem;

  final Logger _logger;
  final FileSystem _fileSystem;

  @override
  String get description => 'Report licenses';

  /// The name of the command.
  static const String commandName = 'report';

  @override
  String get name => commandName;

  static const String _packageConfigJsonName = 'package_config.json';

  @override
  Future<int> run() async {
    _logger.info('name;licenses;url_license');
    final Iterable<MapEntry<String, File>> packageFiles =
        await _getPackageFiles();
    for (final MapEntry<String, File> e in packageFiles) {
      final String licenses = await _getLicenses(e.value);
      _logger
          .info('${e.key};$licenses;https://pub.dev/packages/${e.key}/license');
    }
    return ExitCode.success.code;
  }

  Future<String> _getLicenses(final File file) async {
    final List<License> licenses =
        await detectLicenseInFile(file.absolute, relativePath: file.path);
    return licenses.map((final License e) => e.spdxIdentifier).join(',');
  }

  Future<Iterable<MapEntry<String, File>>> _getPackageFiles() async {
    final String packageConfigPath = p.join(
      _fileSystem.currentDirectory.path,
      argResults!.rest.isNotEmpty ? argResults?.rest.first : '',
      '.dart_tool',
      _packageConfigJsonName,
    );
    final String packageConfigContent =
        await _fileSystem.file(packageConfigPath).readAsString();

    final Map<String, dynamic> packageConfigJson =
        jsonDecode(packageConfigContent) as Map<String, dynamic>;
    final List<dynamic> packages =
        packageConfigJson['packages'] as List<dynamic>;

    return packages
        .cast<Map<String, dynamic>>()
        .map(
          (final Map<String, dynamic> e) => MapEntry<String, String>(
            e['name'] as String,
            e['rootUri'] as String,
          ),
        )
        .where(
          (final MapEntry<String, String> e) => e.value.startsWith('file:///'),
        )
        .map(
          (final MapEntry<String, String> e) => MapEntry<String, Uri>(
            e.key,
            Uri.parse(p.join(e.value, 'LICENSE')),
          ),
        )
        .map(
          (final MapEntry<String, Uri> e) =>
              MapEntry<String, File>(e.key, _fileSystem.file(e.value)),
        )
        .where((final MapEntry<String, File> e) => e.value.existsSync());
  }
}
