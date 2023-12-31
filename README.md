# license_harvest_cli

[![License: MIT][license_badge]][license_link]

Generated by the [Very Good CLI][very_good_cli_link] 🤖

License Harvest.

---

## Getting Started 🚀

If the CLI application is available on [pub](https://pub.dev), activate globally via:

```sh
dart pub global activate license_harvest_cli
```

Or locally via:

```sh
dart pub global activate --source=path <path to this package>
```

## Usage

```sh
# Report command
license_harvest report example

# Show usage help
license_harvest --help
```

## Example

```sh
license_harvest report example

name;licenses;url_license
_fe_analyzer_shared;BSD-3-Clause;https://pub.dev/packages/_fe_analyzer_shared/license
analyzer;BSD-3-Clause;https://pub.dev/packages/analyzer/license
args;BSD-3-Clause;https://pub.dev/packages/args/license
async;BSD-3-Clause;https://pub.dev/packages/async/license
boolean_selector;BSD-3-Clause;https://pub.dev/packages/boolean_selector/license
collection;BSD-3-Clause;https://pub.dev/packages/collection/license
convert;BSD-3-Clause;https://pub.dev/packages/convert/license
coverage;BSD-3-Clause;https://pub.dev/packages/coverage/license
crypto;BSD-3-Clause;https://pub.dev/packages/crypto/license
dart_internal;BSD-3-Clause;https://pub.dev/packages/dart_internal/license
file;BSD-3-Clause;https://pub.dev/packages/file/license
frontend_server_client;BSD-3-Clause;https://pub.dev/packages/frontend_server_client/license
glob;BSD-3-Clause;https://pub.dev/packages/glob/license
http_multi_server;BSD-3-Clause;https://pub.dev/packages/http_multi_server/license
http_parser;BSD-3-Clause;https://pub.dev/packages/http_parser/license
io;BSD-3-Clause;https://pub.dev/packages/io/license
js;BSD-3-Clause;https://pub.dev/packages/js/license
lints;BSD-3-Clause;https://pub.dev/packages/lints/license
logging;BSD-3-Clause;https://pub.dev/packages/logging/license
matcher;BSD-3-Clause;https://pub.dev/packages/matcher/license
meta;BSD-3-Clause;https://pub.dev/packages/meta/license
mime;BSD-3-Clause;https://pub.dev/packages/mime/license
node_preamble;BSD-3-Clause,MIT;https://pub.dev/packages/node_preamble/license
package_config;BSD-3-Clause;https://pub.dev/packages/package_config/license
path;BSD-3-Clause;https://pub.dev/packages/path/license
pool;BSD-3-Clause;https://pub.dev/packages/pool/license
pub_semver;BSD-3-Clause;https://pub.dev/packages/pub_semver/license
shelf;BSD-3-Clause;https://pub.dev/packages/shelf/license
shelf_packages_handler;BSD-3-Clause;https://pub.dev/packages/shelf_packages_handler/license
shelf_static;BSD-3-Clause;https://pub.dev/packages/shelf_static/license
shelf_web_socket;BSD-3-Clause;https://pub.dev/packages/shelf_web_socket/license
source_map_stack_trace;BSD-3-Clause;https://pub.dev/packages/source_map_stack_trace/license
source_maps;BSD-3-Clause;https://pub.dev/packages/source_maps/license
source_span;BSD-3-Clause;https://pub.dev/packages/source_span/license
stack_trace;BSD-3-Clause;https://pub.dev/packages/stack_trace/license
stream_channel;BSD-3-Clause;https://pub.dev/packages/stream_channel/license
string_scanner;BSD-3-Clause;https://pub.dev/packages/string_scanner/license
term_glyph;BSD-3-Clause;https://pub.dev/packages/term_glyph/license
test;BSD-3-Clause;https://pub.dev/packages/test/license
test_api;BSD-3-Clause;https://pub.dev/packages/test_api/license
test_core;BSD-3-Clause;https://pub.dev/packages/test_core/license
typed_data;BSD-3-Clause;https://pub.dev/packages/typed_data/license
vm_service;BSD-3-Clause;https://pub.dev/packages/vm_service/license
watcher;BSD-3-Clause;https://pub.dev/packages/watcher/license
web_socket_channel;BSD-3-Clause;https://pub.dev/packages/web_socket_channel/license
webkit_inspection_protocol;BSD-3-Clause;https://pub.dev/packages/webkit_inspection_protocol/license
yaml;MIT;https://pub.dev/packages/yaml/license
```

## Running Tests with coverage 🧪

To run all unit tests use the following command:

```sh
dart pub global activate coverage
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov)
.

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

---

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
