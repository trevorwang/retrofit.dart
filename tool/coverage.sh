#!/bin/bash
# Dart code coverage script for retrofit package
# Usage: bash tool/coverage.sh

set -e

echo "Activating coverage package..."
dart pub global activate coverage

echo "Running tests with coverage collection..."
dart test --coverage=coverage

echo "Creating coverage directory if it doesn't exist..."
mkdir -p coverage

echo "Formatting coverage to lcov..."
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib

echo "Coverage report generated at coverage/lcov.info"
