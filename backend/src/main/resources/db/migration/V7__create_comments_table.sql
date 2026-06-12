-- ============================================================
-- V7__create_comments_table.sql
-- Threaded comments on projects/schemas, optionally referencing
-- a specific table or field for collaboration.
-- ============================================================

CREATE TABLE comments (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id          UUID NOT NULL,
    schema_id           UUID,
    user_id             UUID NOT NULL,
    parent_comment_id   UUID,
    content             TEXT NOT NULL,
    entity_reference    VARCHAR(255),
    resolved            BOOLEAN NOT NULL DEFAULT false,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_comments_project FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_schema FOREIGN KEY (schema_id) REFERENCES schemas (id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_parent FOREIGN KEY (parent_comment_id) REFERENCES comments (id) ON DELETE CASCADE,
    CONSTRAINT chk_comments_content_not_empty CHECK (LENGTH(TRIM(content)) > 0)
);

CREATE INDEX idx_comments_project_id ON comments (project_id);
CREATE INDEX idx_comments_schema_id ON comments (schema_id) WHERE schema_id IS NOT NULL;
CREATE INDEX idx_comments_parent_comment_id ON comments (parent_comment_id) WHERE parent_comment_id IS NOT NULL;
CREATE INDEX idx_comments_user_id ON comments (user_id);

COMMENT ON TABLE comments IS 'Threaded discussion on a project or schema, optionally anchored to a table/field';
COMMENT ON COLUMN comments.entity_reference IS 'Optional anchor, e.g. table:orders or field:orders.customer_id';
