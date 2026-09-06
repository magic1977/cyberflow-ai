# CyberFlow AI — Data Model

## Purpose

This document defines the initial PostgreSQL data model used by the CyberFlow AI cybersecurity intelligence ingestion pipeline.

The ingestion layer must preserve original source information before AI analysis or content generation takes place.

## cyber_sources

Stores trusted cybersecurity information sources.

| Column | Type | Description |
|---|---|---|
| id | BIGSERIAL PRIMARY KEY | Internal source identifier |
| name | TEXT NOT NULL UNIQUE | Source name |
| source_type | TEXT NOT NULL | rss, api, json, html |
| base_url | TEXT | Main source URL |
| feed_url | TEXT | Feed/API endpoint |
| enabled | BOOLEAN NOT NULL DEFAULT TRUE | Enable/disable ingestion |
| priority | SMALLINT DEFAULT 5 | Source priority |
| created_at | TIMESTAMPTZ DEFAULT NOW() | Creation timestamp |
| updated_at | TIMESTAMPTZ DEFAULT NOW() | Last update |

## cyber_articles

Stores cybersecurity intelligence collected from configured sources.

| Column | Type | Description |
|---|---|---|
| id | BIGSERIAL PRIMARY KEY | Internal article identifier |
| source_id | BIGINT NOT NULL | Reference to cyber_sources |
| external_id | TEXT | Source-specific identifier |
| title | TEXT NOT NULL | Original title |
| url | TEXT NOT NULL | Original article/advisory URL |
| published_at | TIMESTAMPTZ | Original publication date |
| discovered_at | TIMESTAMPTZ DEFAULT NOW() | First seen by CyberFlow |
| raw_summary | TEXT | Original summary/description |
| raw_content | TEXT | Original content when available |
| content_hash | TEXT | Hash used for deduplication |
| processing_status | TEXT DEFAULT 'new' | Pipeline state |
| created_at | TIMESTAMPTZ DEFAULT NOW() | Database insertion time |
| updated_at | TIMESTAMPTZ DEFAULT NOW() | Last update |

## Relationships

One cybersecurity source can provide many articles.

```text
cyber_sources
     |
     | 1:N
     v
cyber_articles
```

## Deduplication

CyberFlow must avoid processing the same intelligence item multiple times.

Initial deduplication mechanisms:

1. unique canonical URL
2. external source identifier when available
3. content hash as secondary protection

AI must not be used as the primary deduplication mechanism.

## Processing States

Initial supported states:

- new
- queued
- processing
- processed
- rejected
- error

Future pipeline stages may introduce additional states.

## Design Principle

Raw source information must be stored before AI processing.

The ingestion layer must not rewrite, summarize or interpret source information.

Later stages will perform:

- deduplication
- AI relevance scoring
- source verification
- research enrichment
- LinkedIn content generation
- human approval
- publishing
