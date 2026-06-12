-- ============================================================
-- V3__create_teams_tables.sql
-- Team workspaces, membership, and pending invitations.
-- ============================================================

CREATE TABLE teams (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL,
    slug        VARCHAR(100) NOT NULL,
    description TEXT,
    owner_id    UUID NOT NULL,
    plan        VARCHAR(20) NOT NULL DEFAULT 'FREE',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_teams_owner FOREIGN KEY (owner_id) REFERENCES users (id) ON DELETE RESTRICT,
    CONSTRAINT chk_teams_plan CHECK (plan IN ('FREE', 'PRO', 'TEAM'))
);

CREATE UNIQUE INDEX idx_teams_slug ON teams (slug);
CREATE INDEX idx_teams_owner_id ON teams (owner_id);

COMMENT ON TABLE teams IS 'Team workspaces for collaborative projects';

-- ------------------------------------------------------------

CREATE TABLE team_members (
    id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id   UUID NOT NULL,
    user_id   UUID NOT NULL,
    role      VARCHAR(20) NOT NULL DEFAULT 'MEMBER',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_team_members_team FOREIGN KEY (team_id) REFERENCES teams (id) ON DELETE CASCADE,
    CONSTRAINT fk_team_members_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT chk_team_members_role CHECK (role IN ('OWNER', 'ADMIN', 'MEMBER', 'VIEWER'))
);

CREATE UNIQUE INDEX uq_team_members_team_user ON team_members (team_id, user_id);
CREATE INDEX idx_team_members_user_id ON team_members (user_id);

COMMENT ON TABLE team_members IS 'Maps users to teams with a role-based permission level';

-- ------------------------------------------------------------

CREATE TABLE invitations (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id       UUID NOT NULL,
    invited_by_id UUID NOT NULL,
    email         VARCHAR(255) NOT NULL,
    role          VARCHAR(20) NOT NULL DEFAULT 'MEMBER',
    token         VARCHAR(255) NOT NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    expires_at    TIMESTAMPTZ NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_invitations_team FOREIGN KEY (team_id) REFERENCES teams (id) ON DELETE CASCADE,
    CONSTRAINT fk_invitations_invited_by FOREIGN KEY (invited_by_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT chk_invitations_role CHECK (role IN ('ADMIN', 'MEMBER', 'VIEWER')),
    CONSTRAINT chk_invitations_status CHECK (status IN ('PENDING', 'ACCEPTED', 'EXPIRED', 'REVOKED'))
);

CREATE UNIQUE INDEX idx_invitations_token ON invitations (token);
CREATE INDEX idx_invitations_team_id ON invitations (team_id);
CREATE INDEX idx_invitations_email ON invitations (LOWER(email));

COMMENT ON TABLE invitations IS 'Pending email invitations to join a team';
