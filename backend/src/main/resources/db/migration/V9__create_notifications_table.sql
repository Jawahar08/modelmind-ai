-- ============================================================
-- V9__create_notifications_table.sql
-- In-app notifications delivered to users.
-- ============================================================

CREATE TABLE notifications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL,
    type            VARCHAR(40) NOT NULL,
    title           VARCHAR(255) NOT NULL,
    message         TEXT NOT NULL,
    metadata_json   JSONB NOT NULL DEFAULT '{}'::jsonb,
    read            BOOLEAN NOT NULL DEFAULT false,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT chk_notifications_type CHECK (type IN (
        'SCHEMA_GENERATED', 'COMMENT_ADDED', 'TEAM_INVITATION', 'EXPORT_READY', 'MENTION'
    ))
);

CREATE INDEX idx_notifications_user_id ON notifications (user_id);
CREATE INDEX idx_notifications_user_read ON notifications (user_id, read);
CREATE INDEX idx_notifications_created_at ON notifications (created_at);

COMMENT ON TABLE notifications IS 'In-app notification feed for users';
COMMENT ON COLUMN notifications.metadata_json IS 'Extra payload, e.g. {"projectId": "...", "schemaId": "..."}';
