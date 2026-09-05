# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Initial public-safe repository structure, documentation, and local development Compose stack.

### Changed

- Pinned n8n to `2.37.10`, adopted built-in n8n user management, and removed deprecated Basic Auth configuration.
- Configured n8n for `Europe/London`, enforced settings-file permissions, and added an n8n health check.
- Added Docker build-context exclusions and Phase 1 backup, restore, persistence, and startup-health completion criteria.
