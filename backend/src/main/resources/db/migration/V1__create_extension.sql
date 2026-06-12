-- ============================================================
-- V1__create_extension.sql
-- Enables required PostgreSQL extensions.
-- pgcrypto provides gen_random_uuid() used as default for all PKs.
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;
