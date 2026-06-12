-- ============================================================
-- V5__create_schemas_tables.sql
-- Generated database design artifacts and their version history.
-- ============================================================

CREATE TABLE schemas (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id                  UUID NOT NULL,
    system_name                 VARCHAR(255) NOT NULL,
    description                 TEXT,
    normalization_target        VARCHAR(10) NOT NULL DEFAULT '3nf',
    tables_json                 JSONB NOT NULL DEFAULT '[]'::jsonb,
    relationships_json          JSONB NOT NULL DEFAULT '[]'::jsonb,
    normalization_notes_json    JSONB NOT NULL DEFAULT '[]'::jsonb,
    analysis_items_json         JSONB NOT NULL DEFAULT '[]'::jsonb,
    status                      VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    current_version             INTEGER NOT NULL DEFAULT 1,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_schemas_project FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE,
    CONSTRAINT chk_schemas_norm_target CHECK (normalization_target IN ('2nf', '3nf', 'bcnf')),
    CONSTRAINT chk_schemas_status CHECK (status IN ('DRAFT', 'FINAL'))
);

CREATE INDEX idx_schemas_project_id ON schemas (project_id);
CREATE INDEX idx_schemas_tables_json ON schemas USING GIN (tables_json);
CREATE INDEX idx_schemas_relationships_json ON schemas USING GIN (relationships_json);

COMMENT ON TABLE schemas IS 'AI-generated database schema for a project, stored as structured JSON';
COMMENT ON COLUMN schemas.tables_json IS 'Array of SchemaTable objects: [{name, description, fields[], indexes[]}]';
COMMENT ON COLUMN schemas.relationships_json IS 'Array of SchemaRelationship objects: [{from, to, type, description}]';

-- ------------------------------------------------------------

CREATE TABLE schema_versions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schema_id       UUID NOT NULL,
    version_number  INTEGER NOT NULL,
    snapshot_json   JSONB NOT NULL,
    change_summary  VARCHAR(500),
    created_by_id   UUID NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_schema_versions_schema FOREIGN KEY (schema_id) REFERENCES schemas (id) ON DELETE CASCADE,
    CONSTRAINT fk_schema_versions_created_by FOREIGN KEY (created_by_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT chk_schema_versions_number CHECK (version_number >= 1)
);

CREATE UNIQUE INDEX uq_schema_versions_schema_version ON schema_versions (schema_id, version_number);
CREATE INDEX idx_schema_versions_schema_id ON schema_versions (schema_id);

COMMENT ON TABLE schema_versions IS 'Immutable point-in-time snapshots of a schema, enabling diff and rollback';
