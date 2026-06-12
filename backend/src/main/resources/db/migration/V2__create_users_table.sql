-- ============================================================
-- V2__create_users_table.sql
-- Core identity table for authentication and profile data.
-- ============================================================

CREATE TABLE users (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email                       VARCHAR(255) NOT NULL,
    password_hash               VARCHAR(255) NOT NULL,
    full_name                   VARCHAR(255) NOT NULL,
    avatar_url                  VARCHAR(512),
    role                        VARCHAR(20)  NOT NULL DEFAULT 'USER',
    status                      VARCHAR(30)  NOT NULL DEFAULT 'PENDING_VERIFICATION',
    email_verification_token   VARCHAR(255),
    password_reset_token        VARCHAR(255),
    password_reset_expires_at  TIMESTAMPTZ,
    ai_credits                  INTEGER      NOT NULL DEFAULT 100,
    created_at                  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ  NOT NULL DEFAULT now(),

    CONSTRAINT chk_users_role   CHECK (role IN ('USER', 'ADMIN')),
    CONSTRAINT chk_users_status CHECK (status IN ('PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED'))
);

CREATE UNIQUE INDEX idx_users_email ON users (LOWER(email));
CREATE INDEX idx_users_status ON users (status);
CREATE INDEX idx_users_email_verification_token ON users (email_verification_token) WHERE email_verification_token IS NOT NULL;
CREATE INDEX idx_users_password_reset_token ON users (password_reset_token) WHERE password_reset_token IS NOT NULL;

COMMENT ON TABLE users IS 'Application users — authentication, profile, and AI credit balance';
COMMENT ON COLUMN users.ai_credits IS 'Remaining AI generation credits; decremented on each successful AI request';
