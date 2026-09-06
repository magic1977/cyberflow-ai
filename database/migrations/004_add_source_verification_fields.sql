ALTER TABLE cyber_articles
    ADD COLUMN IF NOT EXISTS verified BOOLEAN,
    ADD COLUMN IF NOT EXISTS verification_confidence NUMERIC(4,3),
    ADD COLUMN IF NOT EXISTS primary_source_found BOOLEAN,
    ADD COLUMN IF NOT EXISTS independent_confirmation_count SMALLINT,
    ADD COLUMN IF NOT EXISTS best_source_url TEXT,
    ADD COLUMN IF NOT EXISTS best_source_name TEXT,
    ADD COLUMN IF NOT EXISTS claims_supported JSONB,
    ADD COLUMN IF NOT EXISTS claims_unconfirmed JSONB,
    ADD COLUMN IF NOT EXISTS verification_summary TEXT,
    ADD COLUMN IF NOT EXISTS verified_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_cyber_articles_verified
    ON cyber_articles (verified);

CREATE INDEX IF NOT EXISTS idx_cyber_articles_verification_confidence
    ON cyber_articles (verification_confidence DESC);
