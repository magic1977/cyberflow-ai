# CyberFlow AI

CyberFlow AI is a modular, self-hosted AI automation platform. Its first production pipeline turns cybersecurity intelligence into verified, human-approved LinkedIn content and community-engagement suggestions.

## Vision

The platform will collect cybersecurity sources, orchestrate processing with n8n, persist structured data in PostgreSQL, deduplicate and score items with AI assistance, verify sources, and prepare LinkedIn drafts. Publishing and reply suggestions always require human approval.

Future modules may support lead generation, CRM, email, and WhatsApp automation; they are not part of the initial scope.

## Initial architecture

```text
Cybersecurity sources → n8n → PostgreSQL → deduplication → AI scoring
→ research and verification → LinkedIn draft → human approval → publishing
→ comment monitoring → AI reply suggestions → human approval
```

See [docs/architecture.md](docs/architecture.md) for component responsibilities and data flow.

## Technology stack

- Docker Compose for local, reproducible deployments
- n8n for workflow orchestration
- PostgreSQL for persistent structured data
- OpenAI API for future AI-assisted workflow steps
- GitHub for collaboration and change control

LinkedIn, Buffer, Redis, and monitoring integrations are deferred to later phases.

## Status

Phase 0 is in progress: this repository provides the public-safe project foundation and documentation. No production workflows, AI integrations, publishing, or credentials are implemented yet.

## Quick start

1. Copy `.env.example` to `.env`.
2. Replace only the local development placeholders in `.env`; never commit it.
3. Start the development services:

   ```sh
   docker compose up -d
   ```

4. Open n8n at `http://localhost:${N8N_PORT:-5678}`.

The first runnable workflows will be added in later phases.

## Development principles

### Documentation First

Every feature follows this lifecycle:

> Requirements → Architecture / ADR if required → Implementation → Tests → Documentation update → Changelog → Pull Request → Release

A feature is not complete until its documentation is updated. Start with [docs/roadmap.md](docs/roadmap.md), the architecture, and applicable ADRs before writing code.

### Human in the Loop

AI can assist with scoring, research, drafting, and reply suggestions. It must not autonomously publish LinkedIn content or replies. A human approves every external action.

## Documentation

- [Architecture](docs/architecture.md)
- [Roadmap](docs/roadmap.md)
- [Security practices](docs/security.md)
- [Contributing](CONTRIBUTING.md)
- [Security reporting](SECURITY.md)
- [Changelog](CHANGELOG.md)
