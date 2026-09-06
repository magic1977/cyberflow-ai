ALTER TABLE cyber_articles
    ADD COLUMN IF NOT EXISTS relevance_score SMALLINT,
    ADD COLUMN IF NOT EXISTS technical_score SMALLINT,
    ADD COLUMN IF NOT EXISTS business_impact SMALLINT,
    ADD COLUMN IF NOT EXISTS linkedin_potential SMALLINT,
    ADD COLUMN IF NOT EXISTS uk_relevance SMALLINT,
    ADD COLUMN IF NOT EXISTS ai_priority TEXT,
    ADD COLUMN IF NOT EXISTS needs_research BOOLEAN,
    ADD COLUMN IF NOT EXISTS ai_reason TEXT,
    ADD COLUMN IF NOT EXISTS scored_at TIMESTAMPTZ;

ALTER TABLE cyber_articles
    ADD CONSTRAINT cyber_articles_relevance_score_check
        CHECK (relevance_score IS NULL OR relevance_score BETWEEN 0 AND 10),
    ADD CONSTRAINT cyber_articles_technical_score_check
        CHECK (technical_score IS NULL OR technical_score BETWEEN 0 AND 10),
    ADD CONSTRAINT cyber_articles_business_impact_check
        CHECK (business_impact IS NULL OR business_impact BETWEEN 0 AND 10),
    ADD CONSTRAINT cyber_articles_linkedin_potential_check
        CHECK (linkedin_potential IS NULL OR linkedin_potential BETWEEN 0 AND 10),
    ADD CONSTRAINT cyber_articles_uk_relevance_check
        CHECK (uk_relevance IS NULL OR uk_relevance BETWEEN 0 AND 10),
    ADD CONSTRAINT cyber_articles_ai_priority_check
        CHECK (ai_priority IS NULL OR ai_priority IN ('low', 'medium', 'high', 'critical'));

CREATE INDEX IF NOT EXISTS idx_cyber_articles_relevance_score
    ON cyber_articles (relevance_score DESC);

CREATE INDEX IF NOT EXISTS idx_cyber_articles_needs_research
    ON cyber_articles (needs_research);

CREATE INDEX IF NOT EXISTS idx_cyber_articles_scored_at
    ON cyber_articles (scored_at DESC);
