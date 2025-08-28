# Dart code coverage script for retrofit package
# Usage: dart tool/coverage.sh

dart pub global activate coverage

dart test --coverage=coverage

dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib

echo "Coverage report generated at coverage/lcov.info"
