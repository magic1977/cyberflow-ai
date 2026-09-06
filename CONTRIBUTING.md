# Contributing to CyberFlow AI

Thank you for contributing. Keep changes focused and safe for a public repository.

## Documentation First workflow

Before implementation, document the requirement and update architecture documentation or add an ADR when the decision has lasting technical impact. Each feature must include appropriate tests, documentation updates, a `CHANGELOG.md` entry, and a pull request.

## Pull requests

- Keep each pull request focused on one change.
- Do not commit `.env` files, credentials, database dumps, or real service data.
- Preserve the Human-in-the-Loop requirement for external publishing and replies.
- Use the pull request template and explain validation performed.
- Update documentation and the changelog whenever behavior changes.

## Development

Copy `.env.example` to `.env` and set development-only values before using Docker Compose. See the README and the documentation in `docs/` before introducing a new module.
