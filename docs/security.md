# Security Practices

## Secrets management

Keep secrets in environment configuration or an approved secret manager, never in Git. `.env` files, `secrets/`, and `credentials/` are ignored; `.env.example` contains placeholders only. Use separate credentials for development, staging, and production.

## Least privilege

Create service accounts and integration tokens with only the permissions each workflow needs. Limit database access by role, limit publishing integrations to approved operations, and avoid sharing administrator credentials.

## API key rotation

Record ownership and rotation procedures for every API key. Rotate keys on a regular schedule and immediately after suspected exposure, personnel changes, or integration changes. Revoke replaced keys promptly.

## Backups

Back up PostgreSQL data on a defined schedule, encrypt backups at rest and in transit, and restrict restore access. Regularly test a restore in a non-production environment. Do not commit database dumps to this repository.

## Dependency updates

Review Docker images, n8n, PostgreSQL, and future application dependencies for security updates. Test updates before production deployment and track significant changes in the changelog.

## Future threat modelling

Before adding external integrations, AI actions, or deployment environments, perform threat modelling. Consider data provenance, prompt injection, content manipulation, access control, secret exposure, approval bypass, audit logging, and third-party integration risks.

For vulnerability reporting, see [SECURITY.md](../SECURITY.md).
