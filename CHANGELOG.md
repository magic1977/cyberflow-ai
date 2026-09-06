# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Initial public-safe repository structure, documentation, and local development Compose stack.
- Added `docs/runbooks/postgresql-backup-restore.md` with the tested local PostgreSQL backup, isolated restore-test, verification, and cleanup procedure.
- Added PostgreSQL migrations for cybersecurity ingestion, vulnerability intelligence, AI scoring, source verification, LinkedIn drafts, and LinkedIn publication identifiers.
- Added BleepingComputer cybersecurity ingestion with deduplication and PostgreSQL persistence.
- Added OpenAI-based cybersecurity relevance scoring and configurable relevance gating.
- Added Brave Search research and AI-assisted source verification with confidence scoring.
- Added verified-claims-only LinkedIn content generation.
- Added article Open Graph image discovery and retrieval.
- Added PostgreSQL-backed LinkedIn draft persistence.
- Added Gmail-based Human-in-the-Loop approval before publication.
- Added LinkedIn OAuth 2.0 member authentication and image upload through the LinkedIn Images API.
- Added LinkedIn post publishing through the LinkedIn Posts API.
- Added publication verification using HTTP `201` and the LinkedIn `x-restli-id` response header.
- Added persistence of LinkedIn post IDs and publication timestamps.
- Added explicit publication error handling.
- Added a sanitized, public-safe export of the BleepingComputer-to-LinkedIn workflow.
- Added architecture documentation for the Human-in-the-Loop LinkedIn publishing pipeline.

### Changed

- Pinned n8n to `2.37.10`, adopted built-in n8n user management, and removed deprecated Basic Auth configuration.
- Configured n8n for `Europe/London`, enforced settings-file permissions, and added an n8n health check.
- Added Docker build-context exclusions and Phase 1 backup, restore, persistence, and startup-health completion criteria.
- Advanced CyberFlow AI from the initial platform foundation to a validated end-to-end cybersecurity-to-LinkedIn publishing pipeline.
- Updated project status to reflect operational OpenAI and LinkedIn integrations while keeping credentials local and outside version control.
