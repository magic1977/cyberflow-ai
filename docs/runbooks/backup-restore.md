# CyberFlow AI — Backup and Restore Runbook

## Purpose

This runbook documents the tested backup and restore procedures for the CyberFlow AI platform.

Current platform components:

- Docker Compose
- n8n
- PostgreSQL
- Docker named volumes

Local backups are stored in `backups/` and MUST NOT be committed to Git.

---

## 1. PostgreSQL Backup

Create the local backup directory:

```bash
mkdir -p backups
```

Create a PostgreSQL dump using the database configuration from the PostgreSQL container:

```bash
docker compose exec -T postgres sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' > backups/cyberflow_backup.sql
```

Verify that the backup exists and has a reasonable size:

```bash
ls -lh backups/cyberflow_backup.sql
```

Do not commit this file to Git.

---

## 2. PostgreSQL Restore Test

Restoration MUST be tested against a temporary database rather than the active CyberFlow database.

Create the temporary database:

```bash
docker compose exec postgres sh -c 'createdb -U "$POSTGRES_USER" cyberflow_restore_test'
```

Restore the dump:

```bash
cat backups/cyberflow_backup.sql | docker compose exec -T postgres sh -c 'psql -U "$POSTGRES_USER" -d cyberflow_restore_test'
```

Verify restored tables:

```bash
docker compose exec postgres sh -c 'psql -U "$POSTGRES_USER" -d cyberflow_restore_test -c "\dt"'
```

After successful verification, remove the temporary database:

```bash
docker compose exec postgres sh -c 'dropdb -U "$POSTGRES_USER" cyberflow_restore_test'
```

The active `cyberflow` database is not modified during this test.

---

## 3. n8n Workflow Backup

PostgreSQL backup provides disaster recovery for the n8n database.

Individual n8n workflows are additionally exported as JSON for version control and easier recovery.

Export all workflows inside the n8n container:

```bash
docker compose exec n8n n8n export:workflow --backup --output=/home/node/.n8n/workflow-backup/
```

Create a temporary host directory if required:

```bash
mkdir -p workflows/backups
```

Copy exported workflows from the container:

```bash
docker compose cp n8n:/home/node/.n8n/workflow-backup/. workflows/backups/
```

Workflow exports intended for version control should be reviewed and moved into the appropriate repository directory.

Current structure:

```text
workflows/
├── tests/
├── ingestion/
├── scoring/
├── research/
├── publishing/
└── comments/
```

Example validated workflow:

```text
workflows/tests/openai-postgres-e2e.json
```

---

## 4. Secret Check Before Git Commit

Exported n8n workflows MUST be inspected before being committed to the public repository.

Check for common secret fields:

```bash
grep -Ein '"apiKey"|"password"|"secret"|"token"|"authorization"|"bearer"|"accessToken"|"refreshToken"' workflows/**/*.json
```

Credential references containing IDs or credential names may exist in workflow JSON.

Actual values such as the following MUST NOT be committed:

- OpenAI API keys
- database passwords
- access tokens
- refresh tokens
- authorization headers
- encryption keys
- `.env` contents

The initial OpenAI → PostgreSQL workflow export was manually checked and contained credential references only, not credential secrets.

---

## 5. Backup Layers

CyberFlow AI uses two complementary backup mechanisms.

### Layer 1 — PostgreSQL Backup

Protects the n8n database and application state and provides disaster-recovery capability.

### Layer 2 — Version-Controlled Workflow JSON

Provides:

- workflow history
- Git versioning
- code review
- change tracking
- individual workflow recovery

Both mechanisms should be maintained.

---

## 6. Security Rules

- Never commit `.env`.
- Never commit `backups/`.
- Never commit database passwords.
- Never commit API keys.
- Never publish raw PostgreSQL dumps.
- Review exported workflow JSON before every commit.
- Test database restoration using a temporary database.
- Keep PostgreSQL inaccessible directly from the public network.
- Store credentials using n8n credential management rather than inside workflow nodes.

---

## 7. Validation Status

The following procedures have been manually validated on the CyberFlow AI development environment:

- [x] PostgreSQL container healthy
- [x] n8n container healthy
- [x] n8n `/healthz` endpoint operational
- [x] PostgreSQL persistent storage operational
- [x] n8n persistent storage operational
- [x] PostgreSQL backup created successfully
- [x] PostgreSQL restore tested using a temporary database
- [x] n8n workflow export successful
- [x] workflow copied from Docker storage to host
- [x] exported workflow checked for obvious secrets
- [x] OpenAI API credential operational
- [x] PostgreSQL credential operational
- [x] OpenAI → PostgreSQL end-to-end workflow operational

---

## 8. Current Recovery Principle

A CyberFlow AI platform component is not considered backed up merely because a backup file exists.

A backup is considered valid only when its restoration procedure has also been tested.

This runbook should be updated whenever the platform architecture or backup procedure changes.
