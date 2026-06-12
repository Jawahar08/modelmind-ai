-- ============================================================
-- V6__create_ai_requests_table.sql
-- Audit trail of every AI provider call for token tracking,
-- billing, debugging, and rate limiting.
-- ============================================================

CREATE TABLE ai_requests (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL,
    schema_id           UUID,
    request_type        VARCHAR(40) NOT NULL,
    provider            VARCHAR(20) NOT NULL,
    model               VARCHAR(100) NOT NULL,
    prompt              TEXT NOT NULL,
    response            TEXT,
    prompt_tokens       INTEGER NOT NULL DEFAULT 0,
    completion_tokens   INTEGER NOT NULL DEFAULT 0,
    latency_ms          INTEGER NOT NULL DEFAULT 0,
    status              VARCHAR(20) NOT NULL,
    error_message       TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_ai_requests_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_ai_requests_schema FOREIGN KEY (schema_id) REFERENCES schemas (id) ON DELETE SET NULL,
    CONSTRAINT chk_ai_requests_type CHECK (request_type IN (
        'SCHEMA_GENERATION', 'SCHEMA_REVIEW', 'NORMALIZATION_ANALYSIS',
        'CHAT', 'SQL_GENERATION', 'DOCUMENTATION'
    )),
    CONSTRAINT chk_ai_requests_provider CHECK (provider IN ('CLAUDE', 'GEMINI', 'OPENAI')),
    CONSTRAINT chk_ai_requests_status CHECK (status IN ('SUCCESS', 'FAILED', 'RETRIED', 'FALLBACK'))
);

CREATE INDEX idx_ai_requests_user_id ON ai_requests (user_id);
CREATE INDEX idx_ai_requests_schema_id ON ai_requests (schema_id) WHERE schema_id IS NOT NULL;
CREATE INDEX idx_ai_requests_created_at ON ai_requests (created_at);
CREATE INDEX idx_ai_requests_user_created ON ai_requests (user_id, created_at);

COMMENT ON TABLE ai_requests IS 'Log of every AI provider call — used for rate limiting, token usage analytics, and debugging';
