CREATE TABLE IF NOT EXISTS linkedin_drafts (
    id BIGSERIAL PRIMARY KEY,
    article_id BIGINT REFERENCES cyber_articles(id) ON DELETE SET NULL,
    headline TEXT NOT NULL,
    post_text TEXT NOT NULL,
    hashtags JSONB NOT NULL DEFAULT '[]'::jsonb,
    source_name TEXT,
    source_url TEXT,
    image_url TEXT,
    status TEXT NOT NULL DEFAULT 'pending_approval',
    approval_action TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    approved_at TIMESTAMPTZ,
    published_at TIMESTAMPTZ
);

ALTER TABLE linkedin_drafts
    ADD CONSTRAINT linkedin_drafts_status_check
    CHECK (status IN (
        'pending_approval',
        'approved',
        'rewrite_requested',
        'skipped',
        'published',
        'error'
    ));

CREATE INDEX IF NOT EXISTS idx_linkedin_drafts_status
    ON linkedin_drafts(status);

CREATE INDEX IF NOT EXISTS idx_linkedin_drafts_article_id
    ON linkedin_drafts(article_id);
