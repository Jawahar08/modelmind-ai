-- ============================================================
-- V10__create_audit_logs_table.sql
-- System-wide, immutable audit trail for security and compliance.
-- ============================================================

CREATE TABLE audit_logs (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID,
    action              VARCHAR(60) NOT NULL,
    entity_type         VARCHAR(40) NOT NULL,
    entity_id           UUID,
    before_state_json   JSONB,
    after_state_json    JSONB,
    ip_address          VARCHAR(45),
    user_agent          VARCHAR(512),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs (user_id) WHERE user_id IS NOT NULL;
CREATE INDEX idx_audit_logs_entity ON audit_logs (entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs (created_at);
CREATE INDEX idx_audit_logs_action ON audit_logs (action);

COMMENT ON TABLE audit_logs IS 'Immutable record of security-relevant and data-changing actions across the system';
COMMENT ON COLUMN audit_logs.entity_id IS 'Primary key of the affected entity, polymorphic across entity_type';
