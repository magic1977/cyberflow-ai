-- CyberFlow AI
-- Migration 001: Cybersecurity ingestion tables

BEGIN;

CREATE TABLE IF NOT EXISTS cyber_sources (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    source_type TEXT NOT NULL,
    base_url TEXT,
    feed_url TEXT,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    priority SMALLINT NOT NULL DEFAULT 5,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS cyber_articles (
    id BIGSERIAL PRIMARY KEY,
    source_id BIGINT NOT NULL
        REFERENCES cyber_sources(id)
        ON DELETE RESTRICT,

    external_id TEXT,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    published_at TIMESTAMPTZ,
    discovered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    raw_summary TEXT,
    raw_content TEXT,
    content_hash TEXT,

    processing_status TEXT NOT NULL DEFAULT 'new',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT cyber_articles_url_unique UNIQUE (url),

    CONSTRAINT cyber_articles_processing_status_check
        CHECK (
            processing_status IN (
                'new',
                'queued',
                'processing',
                'processed',
                'rejected',
                'error'
            )
        )
);

CREATE INDEX IF NOT EXISTS idx_cyber_articles_source_id
    ON cyber_articles(source_id);

CREATE INDEX IF NOT EXISTS idx_cyber_articles_published_at
    ON cyber_articles(published_at DESC);

CREATE INDEX IF NOT EXISTS idx_cyber_articles_processing_status
    ON cyber_articles(processing_status);

CREATE INDEX IF NOT EXISTS idx_cyber_articles_content_hash
    ON cyber_articles(content_hash);


-- Seed baseline cybersecurity sources required by ingestion workflows.
INSERT INTO cyber_sources (
    name,
    source_type,
    base_url,
    feed_url,
    priority
)
VALUES
    (
        'BleepingComputer',
        'rss',
        'https://www.bleepingcomputer.com',
        'https://www.bleepingcomputer.com/feed/',
        5
    ),
    (
        'CISA KEV',
        'api',
        'https://www.cisa.gov',
        'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json',
        10
    )
ON CONFLICT (name) DO NOTHING;

COMMIT;
