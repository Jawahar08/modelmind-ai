-- ============================================================
-- V4__create_projects_table.sql
-- A project is the top-level workspace for one database design effort.
-- ============================================================

CREATE TABLE projects (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id    UUID NOT NULL,
    team_id     UUID,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    dialect     VARCHAR(20) NOT NULL DEFAULT 'postgresql',
    status      VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    tags        JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at  TIMESTAMPTZ,

    CONSTRAINT fk_projects_owner FOREIGN KEY (owner_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_projects_team FOREIGN KEY (team_id) REFERENCES teams (id) ON DELETE SET NULL,
    CONSTRAINT chk_projects_dialect CHECK (dialect IN ('postgresql', 'mysql', 'sqlserver', 'oracle')),
    CONSTRAINT chk_projects_status CHECK (status IN ('ACTIVE', 'ARCHIVED'))
);

CREATE INDEX idx_projects_owner_id ON projects (owner_id);
CREATE INDEX idx_projects_team_id ON projects (team_id) WHERE team_id IS NOT NULL;
CREATE INDEX idx_projects_status ON projects (status);
CREATE INDEX idx_projects_not_deleted ON projects (owner_id, updated_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_projects_tags ON projects USING GIN (tags);

COMMENT ON TABLE projects IS 'Top-level workspace containing one or more generated schemas';
COMMENT ON COLUMN projects.deleted_at IS 'Soft-delete marker; NULL means active';
