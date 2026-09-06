# ADR-001: Use n8n, Docker Compose, and PostgreSQL

- **Status:** Accepted
- **Date:** 2026-09-05

## Context

CyberFlow AI needs a self-hosted foundation for cybersecurity intelligence automation. It requires configurable workflow orchestration, durable structured data, and a portable development and deployment setup.

## Decision

- Use **n8n** for workflow orchestration because it supports visual, modular integration workflows and human approval gates.
- Use **Docker Compose** for portable local development and small self-hosted deployments with explicit service configuration and persistent volumes.
- Use **PostgreSQL** for persistent structured data because it provides reliable relational storage for records, workflow state, approvals, and future audit data.

## Consequences

The initial runtime stack remains small and reproducible. n8n is pinned to `2.37.10`; its built-in user management replaces deprecated Basic Auth environment variables. Docker Compose configures n8n and workflow time for `Europe/London`, enforces settings-file permissions, and exposes only n8n's web port; PostgreSQL remains internal to the Compose network. Workflow logic should be exportable and kept under `workflows/` when introduced, while durable domain data remains in PostgreSQL. Redis, monitoring, and publishing integrations are deferred until their requirements justify their operational cost.
