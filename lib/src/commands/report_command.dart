// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:file/file.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pana/src/license.dart';
import 'package:pana/src/model.dart';
import 'package:path/path.dart' as p;

/// {@template report_command}
///
/// `license_harvest report`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class ReportCommand extends Command<int> {
  /// {@macro report_command}
  ReportCommand({
    required final Logger logger,
    required final FileSystem fileSystem,
  })  : _logger = logger,
        _fileSystem = fileSystem;

  final Logger _logger;
  final FileSystem _fileSystem;

  @override
  String get description => 'Report licenses';

  /// commandName
  static const String commandName = 'report';

  @override
  String get name => commandName;

  static const String _packageConfigJsonName = 'package_config.json';

  @override
  Future<int> run() async {
    _logger.info('name;licenses;url_license');
    final Iterable<MapEntry<String, File>> collection = ((jsonDecode(
      await _fileSystem
          .file(
            p.join(
              _fileSystem.currentDirectory.path,
              argResults!.rest.isNotEmpty ? argResults?.rest.first : '',
              '.dart_tool',
              _packageConfigJsonName,
            ),
          )
          .readAsString(),
    ) as Map<String, dynamic>)['packages'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (final Map<String, dynamic> e) => MapEntry<String, String>(
            e['name'] as String,
            e['rootUri'] as String,
          ),
        )
        .where(
          (final MapEntry<String, String> element) =>
              element.value.startsWith('file:///'),
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
        );
    for (final MapEntry<String, File> element in collection) {
      final List<License> list = await detectLicenseInFile(
        element.value.absolute,
        relativePath: element.value.path,
      );
      final String licenses =
          list.map((final License e) => e.spdxIdentifier).reduce(
                (final String value, final String element) => '$value,$element',
              );
      _logger.info(
        '${element.key};$licenses;https://pub.dev/packages/${element.key}/license',
      );
    }
    return ExitCode.success.code;
  }
}
