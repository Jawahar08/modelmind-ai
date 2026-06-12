-- ============================================================
-- V8__create_exports_table.sql
-- Records of generated export artifacts (SQL, JSON, PDF, PNG ERD, Markdown).
-- ============================================================

CREATE TABLE exports (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id          UUID NOT NULL,
    schema_id           UUID NOT NULL,
    schema_version_id   UUID,
    requested_by_id     UUID NOT NULL,
    export_type         VARCHAR(20) NOT NULL,
    dialect             VARCHAR(20),
    status              VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    file_url            VARCHAR(1024),
    file_size_bytes     BIGINT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at        TIMESTAMPTZ,

    CONSTRAINT fk_exports_project FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE,
    CONSTRAINT fk_exports_schema FOREIGN KEY (schema_id) REFERENCES schemas (id) ON DELETE CASCADE,
    CONSTRAINT fk_exports_schema_version FOREIGN KEY (schema_version_id) REFERENCES schema_versions (id) ON DELETE SET NULL,
    CONSTRAINT fk_exports_requested_by FOREIGN KEY (requested_by_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT chk_exports_type CHECK (export_type IN ('SQL', 'JSON', 'PDF', 'PNG_ERD', 'MARKDOWN')),
    CONSTRAINT chk_exports_dialect CHECK (dialect IS NULL OR dialect IN ('postgresql', 'mysql', 'sqlserver', 'oracle')),
    CONSTRAINT chk_exports_status CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED'))
);

CREATE INDEX idx_exports_project_id ON exports (project_id);
CREATE INDEX idx_exports_schema_id ON exports (schema_id);
CREATE INDEX idx_exports_requested_by_id ON exports (requested_by_id);
CREATE INDEX idx_exports_status ON exports (status) WHERE status IN ('PENDING', 'PROCESSING');

COMMENT ON TABLE exports IS 'Tracks generation and storage of exportable schema artifacts';
