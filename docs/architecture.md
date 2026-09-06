# Initial Architecture

CyberFlow AI is designed as a modular, self-hosted automation platform. The initial development stack contains n8n `2.37.10` and PostgreSQL, deployed together with Docker Compose.

## Components

| Component | Responsibility |
| --- | --- |
| Cybersecurity sources | Provide public intelligence inputs to future workflows. |
| n8n | Orchestrates ingestion, processing, approval gates, and later integrations. |
| PostgreSQL | Persists source records, workflow state, deduplication data, approvals, and audit-relevant metadata. |
| AI provider | Assists future scoring, research, drafting, and reply suggestions. API access is configured outside version control. |
| Human approver | Reviews all content before publishing and all suggested comment replies. |
| Publishing integration | A future LinkedIn or Buffer integration performs approved external publishing only. |

## Intended data flow

```text
Cybersecurity sources
  → n8n ingestion
  → PostgreSQL storage
  → deduplication
  → AI scoring
  → research and source verification
  → LinkedIn content draft
  → human approval
  → publishing integration
  → comment monitoring
  → AI reply suggestions
  → human approval
```

Workflow definitions will be organized by domain in `workflows/cyber`, `workflows/linkedin`, and `workflows/comments`. Prompts will be similarly grouped under `prompts/`.

## Boundaries and safeguards

n8n is the orchestration boundary; it does not replace durable storage, so workflow state and domain data belong in PostgreSQL. PostgreSQL has no host port mapping and is reachable only on the Compose network. Secrets are injected from local or deployment environment configuration and are never stored in this repository. n8n uses its built-in user management: create the initial owner through its first-run setup screen rather than using deprecated Basic Auth environment variables. The settings file permission check is enforced, and `TZ` plus `GENERIC_TIMEZONE` set container and workflow time to `Europe/London`. No external publication or comment reply may bypass a human approval step.

Redis and monitoring are intentionally excluded from the initial runtime stack. Their directories reserve a documented location for later phases without adding unnecessary services today.
