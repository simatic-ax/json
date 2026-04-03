# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `AsyncDeserializer` class for asynchronous JSON parsing
- `IAsyncDeserializer` interface for async parsing contract
- Support for parsing large JSON structures across multiple PLC cycles
- Cancellation support for async parsing operations
- 16 unit tests for AsyncDeserializer functionality

### Changed
- Updated apax.yml to reference changelog.md in the files section

## [0.0.0-placeholder] - YYYY-MM-DD

### Added
- Initial release with JSON serialization and deserialization
