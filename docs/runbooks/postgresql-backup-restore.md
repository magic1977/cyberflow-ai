# PostgreSQL Backup and Restore Runbook

This runbook documents the local backup and restore procedure for the CyberFlow AI PostgreSQL database used by n8n.

## Scope

The procedure is intended for the local Docker Compose development stack. It creates a logical SQL backup using `pg_dump`, verifies the backup exists, restores it into a separate test database, verifies restored tables, and then removes the temporary restore-test database.

Do not commit database dumps to Git. The repository `.gitignore` excludes `*.sql`, `*.dump`, `*.sql.gz`, and `*.bak` files.

## Prerequisites

- Run commands from the repository root.
- Docker Compose stack must be running.
- PostgreSQL service must be healthy.
- The local database name and user must match the current development configuration (`cyberflow` / `cyberflow`) unless intentionally changed.

Check service health:

```sh
docker compose ps
```

## 1. Create the local backup directory

```sh
mkdir -p backups
```

## 2. Create a timestamped PostgreSQL backup

Use a single-line command to avoid shell line-continuation mistakes:

```sh
docker compose exec -T postgres pg_dump -U cyberflow -d cyberflow > backups/cyberflow_$(date +%Y%m%d_%H%M%S).sql
```

Important: if the command is split across multiple lines in `zsh`, a backslash (`\`) must be the final character on the line with no blank line after it. Using the single-line form above is preferred.

## 3. Verify the backup file

```sh
ls -lh backups/
```

A successful backup should have a non-zero file size.

Optional quick content check:

```sh
head -n 5 backups/*.sql
```

If an earlier failed attempt created a zero-byte file, remove only that failed file, for example:

```sh
rm backups/cyberflow_YYYYMMDD_HHMMSS.sql
```

## 4. Create a separate restore-test database

Never test restoration by overwriting the active development database.

```sh
docker compose exec postgres createdb -U cyberflow cyberflow_restore_test
```

## 5. Restore the backup into the test database

Replace `BACKUP_FILE.sql` with the actual backup filename:

```sh
cat backups/BACKUP_FILE.sql | docker compose exec -T postgres psql -U cyberflow -d cyberflow_restore_test
```

Example:

```sh
cat backups/cyberflow_20260905_140849.sql | docker compose exec -T postgres psql -U cyberflow -d cyberflow_restore_test
```

The restore should complete without PostgreSQL errors.

## 6. Verify restored tables

```sh
docker compose exec postgres psql -U cyberflow -d cyberflow_restore_test -c "\\dt"
```

The command should return the restored n8n/PostgreSQL tables. This confirms that the backup is readable and can be restored into a clean database.

## 7. Remove the temporary restore-test database

After successful verification:

```sh
docker compose exec postgres dropdb -U cyberflow cyberflow_restore_test
```

## 8. Definition of successful backup/restore test

The test is complete only when all of the following are true:

- [ ] PostgreSQL service is healthy before backup.
- [ ] `pg_dump` completes without errors.
- [ ] Backup file exists and is non-zero in size.
- [ ] A separate `cyberflow_restore_test` database is created.
- [ ] Backup restores without errors.
- [ ] `\\dt` shows restored tables.
- [ ] Restore-test database is removed after verification.
- [ ] No backup file is committed to Git.

## Future production improvements

Before VPS or production deployment, extend this procedure with encrypted off-host backups, retention rules, automated scheduled backups, restore drills, monitoring, and documented recovery objectives (RPO/RTO).
