# SchemaForge AI — System Architecture

## 1. High-Level Architecture

```mermaid
graph TB
    subgraph Client["Client Layer"]
        Browser["Browser<br/>Next.js 15 App"]
    end

    subgraph Edge["Edge / CDN"]
        Vercel["Vercel Edge Network<br/>Static Assets + SSR"]
    end

    subgraph App["Application Layer"]
        NextAPI["Next.js API Routes<br/>(BFF Layer)"]
        SpringAPI["Spring Boot 3 API<br/>(Render)"]
    end

    subgraph AI["AI Orchestration Layer"]
        Orchestrator["AI Orchestrator Service"]
        Claude["Claude API"]
        Gemini["Gemini API"]
        OpenAI["OpenAI API"]
    end

    subgraph Data["Data Layer"]
        Postgres["PostgreSQL 16<br/>(Neon Serverless)"]
        Redis["Redis Cache<br/>(Rate Limiting / Sessions)"]
    end

    Browser --> Vercel
    Vercel --> NextAPI
    NextAPI -->|REST + JWT| SpringAPI
    SpringAPI --> Postgres
    SpringAPI --> Redis
    SpringAPI --> Orchestrator
    Orchestrator --> Claude
    Orchestrator --> Gemini
    Orchestrator --> OpenAI

    style Browser fill:#1a1a24,stroke:#7c6ff7,color:#e8e8f0
    style Vercel fill:#1a1a24,stroke:#3b82f6,color:#e8e8f0
    style NextAPI fill:#1a1a24,stroke:#22c97a,color:#e8e8f0
    style SpringAPI fill:#1a1a24,stroke:#22c97a,color:#e8e8f0
    style Orchestrator fill:#1a1a24,stroke:#f59e0b,color:#e8e8f0
    style Claude fill:#1a1a24,stroke:#a89bff,color:#e8e8f0
    style Gemini fill:#1a1a24,stroke:#a89bff,color:#e8e8f0
    style OpenAI fill:#1a1a24,stroke:#a89bff,color:#e8e8f0
    style Postgres fill:#1a1a24,stroke:#3b82f6,color:#e8e8f0
    style Redis fill:#1a1a24,stroke:#f05252,color:#e8e8f0
```

### Component Responsibilities

| Layer | Component | Responsibility |
|---|---|---|
| Client | Next.js App | UI rendering, client state (Zustand), data fetching (React Query) |
| Edge | Vercel | Static asset hosting, SSR, edge caching, image optimization |
| Application | Next.js API Routes | Thin proxy/BFF — attaches auth headers, handles SSR data fetching |
| Application | Spring Boot API | Core business logic, auth, persistence, AI orchestration trigger |
| AI | AI Orchestrator | Provider selection, prompt templating, fallback, retry, token tracking |
| Data | PostgreSQL | Primary relational store — users, projects, schemas, versions, etc. |
| Data | Redis | Rate limiting counters, refresh token denylist, AI response cache |

---

## 2. Low-Level Architecture (Backend)

```mermaid
graph TB
    subgraph Controllers["Controller Layer"]
        AuthC["AuthController"]
        UserC["UserController"]
        ProjectC["ProjectController"]
        SchemaC["SchemaController"]
        VersionC["VersionController"]
        AiC["AiController"]
        ExportC["ExportController"]
        NotifC["NotificationController"]
        TeamC["TeamController"]
        AnalyticsC["AnalyticsController"]
    end

    subgraph Services["Service Layer"]
        AuthS["AuthService"]
        UserS["UserService"]
        ProjectS["ProjectService"]
        SchemaS["SchemaService"]
        VersionS["VersionService"]
        AiOrchestratorS["AiOrchestratorService"]
        ExportS["ExportService"]
        NotifS["NotificationService"]
        TeamS["TeamService"]
        AnalyticsS["AnalyticsService"]
    end

    subgraph Repos["Repository Layer (Spring Data JPA)"]
        UserR["UserRepository"]
        ProjectR["ProjectRepository"]
        SchemaR["SchemaRepository"]
        VersionR["SchemaVersionRepository"]
        AiR["AiRequestRepository"]
        CommentR["CommentRepository"]
        TeamR["TeamRepository"]
        InviteR["InvitationRepository"]
        ExportR["ExportRepository"]
        NotifR["NotificationRepository"]
        AuditR["AuditLogRepository"]
    end

    subgraph Security["Security Layer"]
        JwtFilter["JwtAuthenticationFilter"]
        JwtService["JwtService"]
        SecurityConfig["SecurityConfig"]
        UserDetailsS["CustomUserDetailsService"]
    end

    subgraph External["External Integrations"]
        ClaudeAPI["Claude API"]
        GeminiAPI["Gemini API"]
        OpenAIAPI["OpenAI API"]
        DB["PostgreSQL"]
    end

    AuthC --> AuthS --> UserR
    AuthC --> JwtService
    UserC --> UserS --> UserR
    ProjectC --> ProjectS --> ProjectR
    SchemaC --> SchemaS --> SchemaR
    SchemaC --> AiOrchestratorS
    VersionC --> VersionS --> VersionR
    AiC --> AiOrchestratorS --> AiR
    AiOrchestratorS --> ClaudeAPI
    AiOrchestratorS --> GeminiAPI
    AiOrchestratorS --> OpenAIAPI
    ExportC --> ExportS --> ExportR
    NotifC --> NotifS --> NotifR
    TeamC --> TeamS --> TeamR
    TeamC --> TeamS --> InviteR
    AnalyticsC --> AnalyticsS --> AuditR

    JwtFilter --> JwtService
    JwtFilter --> UserDetailsS
    SecurityConfig --> JwtFilter

    UserR --> DB
    ProjectR --> DB
    SchemaR --> DB
    VersionR --> DB
    AiR --> DB
    CommentR --> DB
    TeamR --> DB
    InviteR --> DB
    ExportR --> DB
    NotifR --> DB
    AuditR --> DB
```

---

## 3. Service Architecture (Module Map)

```mermaid
graph LR
    subgraph "com.schemaforge"
        auth["auth/<br/>Controller, Service, DTO"]
        security["security/<br/>JWT, Filters, Config"]
        user["user/<br/>Controller, Service, Repo, Entity, DTO, Mapper"]
        project["project/<br/>Controller, Service, Repo, Entity, DTO, Mapper"]
        schema["schema/<br/>Controller, Service, Repo, Entity, DTO, Mapper"]
        version["version/<br/>Controller, Service, Repo, Entity, DTO, Mapper"]
        ai["ai/<br/>Orchestrator, Providers, Prompts"]
        export["export/<br/>Controller, Service, Repo, Entity, DTO"]
        notification["notification/<br/>Controller, Service, Repo, Entity, DTO"]
        team["team/<br/>Controller, Service, Repo, Entity, DTO"]
        analytics["analytics/<br/>Controller, Service, Repo"]
        common["common/<br/>GlobalExceptionHandler, BaseEntity, ApiResponse"]
    end

    auth --> security
    auth --> user
    project --> user
    project --> team
    schema --> project
    schema --> ai
    version --> schema
    export --> schema
    export --> version
    notification --> user
    team --> user
    analytics --> project
    analytics --> ai

    auth --> common
    user --> common
    project --> common
    schema --> common
```

---

## 4. Authentication Flow

```mermaid
sequenceDiagram
    actor User
    participant FE as Next.js Frontend
    participant API as Spring Boot API
    participant JWT as JwtService
    participant DB as PostgreSQL
    participant Redis as Redis (Token Store)

    Note over User,Redis: Registration
    User->>FE: Submit signup form
    FE->>API: POST /api/auth/register
    API->>DB: Check email uniqueness
    API->>DB: Insert user (status=PENDING_VERIFICATION)
    API->>API: Generate verification token
    API->>User: Send verification email
    API-->>FE: 201 Created

    Note over User,Redis: Email Verification
    User->>FE: Click verification link
    FE->>API: GET /api/auth/verify?token=...
    API->>DB: Update user.status = ACTIVE
    API-->>FE: 200 OK

    Note over User,Redis: Login
    User->>FE: Submit login form
    FE->>API: POST /api/auth/login
    API->>DB: Validate credentials (BCrypt)
    API->>JWT: Generate access token (15 min)
    API->>JWT: Generate refresh token (7 days)
    API->>Redis: Store refresh token hash
    API-->>FE: 200 OK { accessToken, refreshToken, user }
    FE->>FE: Store accessToken in memory, refreshToken in httpOnly cookie

    Note over User,Redis: Authenticated Request
    FE->>API: GET /api/projects (Authorization: Bearer <token>)
    API->>JWT: Validate token signature + expiry
    JWT-->>API: Claims (userId, email, role)
    API->>DB: Fetch projects for userId
    API-->>FE: 200 OK { projects }

    Note over User,Redis: Token Refresh
    FE->>API: POST /api/auth/refresh (refreshToken cookie)
    API->>Redis: Validate refresh token hash
    API->>JWT: Generate new access token
    API-->>FE: 200 OK { accessToken }

    Note over User,Redis: Logout
    FE->>API: POST /api/auth/logout
    API->>Redis: Invalidate refresh token
    API-->>FE: 204 No Content
```

---

## 5. AI Processing Flow

```mermaid
sequenceDiagram
    actor User
    participant FE as Frontend
    participant SC as SchemaController
    participant SS as SchemaService
    participant AO as AiOrchestratorService
    participant PT as PromptTemplateService
    participant Provider as AI Provider (Claude/Gemini/OpenAI)
    participant DB as PostgreSQL
    participant Redis as Redis (Rate Limit)

    User->>FE: Enter "Build an e-commerce system..."
    FE->>SC: POST /api/schemas/generate
    SC->>Redis: Check rate limit for userId
    alt Rate limit exceeded
        Redis-->>SC: limit exceeded
        SC-->>FE: 429 Too Many Requests
    else OK
        SC->>SS: generateSchema(request)
        SS->>AO: orchestrate(SCHEMA_GENERATION, description)
        AO->>PT: buildPrompt(SCHEMA_GENERATION_TEMPLATE, vars)
        PT-->>AO: rendered prompt

        AO->>Provider: send(prompt) [primary: Claude]
        alt Provider success
            Provider-->>AO: JSON schema response
        else Provider error / timeout
            AO->>AO: retry (max 2, exponential backoff)
            alt Retries exhausted
                AO->>Provider: send(prompt) [fallback: Gemini]
                Provider-->>AO: JSON schema response
            end
        end

        AO->>AO: parse + validate JSON against schema contract
        AO->>DB: INSERT ai_requests (provider, tokens, latency, status)
        AO-->>SS: GeneratedSchema DTO

        SS->>DB: INSERT schemas (project_id, payload jsonb)
        SS->>DB: INSERT schema_versions (version=1, snapshot)
        SS-->>SC: SchemaResponse
        SC-->>FE: 200 OK { schema, sql, erDiagram, analysis }
    end
```

---

## 6. Deployment Architecture

```mermaid
graph TB
    subgraph GitHub["GitHub Repository"]
        Repo["schemaforge-ai monorepo"]
        Actions["GitHub Actions<br/>build / test / deploy"]
    end

    subgraph VercelInfra["Vercel"]
        VercelBuild["Vercel Build<br/>(frontend/)"]
        VercelCDN["Edge Network + CDN"]
        VercelEnv["Environment Variables<br/>NEXT_PUBLIC_API_URL<br/>ANTHROPIC_API_KEY"]
    end

    subgraph RenderInfra["Render"]
        RenderBuild["Docker Build<br/>(backend/)"]
        RenderService["Web Service<br/>schemaforge-api"]
        RenderEnv["Environment Variables<br/>DATABASE_URL<br/>JWT_SECRET<br/>AI API Keys"]
    end

    subgraph NeonInfra["Neon"]
        NeonDB["Serverless PostgreSQL<br/>Autoscaling + Branching"]
        NeonBranch["Preview Branches<br/>per PR"]
    end

    Repo -->|push to main| Actions
    Actions -->|deploy| VercelBuild
    Actions -->|deploy| RenderBuild
    VercelBuild --> VercelCDN
    VercelCDN -.->|env| VercelEnv
    RenderBuild --> RenderService
    RenderService -.->|env| RenderEnv
    RenderService -->|JDBC| NeonDB
    Actions -->|flyway migrate| NeonDB
    Repo -->|PR opened| NeonBranch

    VercelCDN -->|HTTPS REST| RenderService

    style Repo fill:#1a1a24,stroke:#7c6ff7,color:#e8e8f0
    style Actions fill:#1a1a24,stroke:#22c97a,color:#e8e8f0
    style VercelCDN fill:#1a1a24,stroke:#3b82f6,color:#e8e8f0
    style RenderService fill:#1a1a24,stroke:#3b82f6,color:#e8e8f0
    style NeonDB fill:#1a1a24,stroke:#f59e0b,color:#e8e8f0
```

### 6.1 Vercel (Frontend)

- **Build**: `npm run build` from `frontend/` directory, root directory set to `frontend`
- **Output**: Next.js standalone build, deployed to Vercel Edge Network
- **Environments**: `production` (main branch), `preview` (PRs)
- **Env vars**: `NEXT_PUBLIC_API_URL`, `ANTHROPIC_API_KEY` (server-side only, used in API routes)
- **Domains**: `app.schemaforge.ai` (production), `*.vercel.app` (previews)

### 6.2 Render (Backend)

- **Build**: Docker build using `backend/Dockerfile`, multi-stage Maven build → JRE 21 runtime
- **Service type**: Web Service, auto-deploy on push to `main`
- **Health check**: `GET /actuator/health`
- **Env vars**: `DATABASE_URL`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`, `OPENAI_API_KEY`, `REDIS_URL`, `CORS_ALLOWED_ORIGINS`
- **Scaling**: Horizontal autoscaling 1–3 instances based on CPU

### 6.3 Neon (PostgreSQL)

- **Project**: `schemaforge-ai-prod`
- **Branching**: Each PR creates an isolated database branch for integration tests
- **Migrations**: Flyway runs automatically on backend startup (`spring.flyway.enabled=true`)
- **Connection pooling**: PgBouncer (Neon pooled connection string) used by the Spring Boot HikariCP pool

---

## 7. Folder Structure (Repository Root)

```
schemaforge-ai/
├── frontend/                              # Next.js 15 application
│   ├── src/
│   │   ├── app/
│   │   │   ├── (marketing)/
│   │   │   │   └── page.tsx               # Landing page
│   │   │   ├── (auth)/
│   │   │   │   ├── login/page.tsx
│   │   │   │   └── register/page.tsx
│   │   │   ├── (app)/
│   │   │   │   ├── dashboard/page.tsx
│   │   │   │   ├── projects/
│   │   │   │   │   ├── page.tsx
│   │   │   │   │   └── [id]/page.tsx
│   │   │   │   ├── schemas/[id]/page.tsx
│   │   │   │   ├── settings/page.tsx
│   │   │   │   └── profile/page.tsx
│   │   │   ├── api/                       # Next.js API routes (BFF)
│   │   │   ├── layout.tsx
│   │   │   └── globals.css
│   │   ├── components/
│   │   │   ├── ui/                        # shadcn/ui primitives
│   │   │   ├── layout/                    # Navbar, Sidebar, Shell
│   │   │   ├── landing/                   # Hero, FeatureCards, Pricing
│   │   │   ├── schema/                    # SchemaEditor, ERDiagramViewer, SchemaChat
│   │   │   ├── dashboard/                 # AnalyticsCards, ProjectTable
│   │   │   └── shared/
│   │   ├── lib/                           # api client, utils, constants
│   │   ├── store/                         # Zustand stores
│   │   ├── hooks/                         # custom hooks
│   │   └── types/                         # TS types
│   ├── public/
│   ├── Dockerfile
│   ├── package.json
│   ├── tsconfig.json
│   ├── tailwind.config.ts
│   └── next.config.ts
│
├── backend/                                # Spring Boot 3 application
│   ├── src/main/java/com/schemaforge/
│   │   ├── auth/                          # AuthController, AuthService, DTOs
│   │   ├── security/                      # JwtService, JwtFilter, SecurityConfig
│   │   ├── user/                          # User module (full stack)
│   │   ├── project/                       # Project module (full stack)
│   │   ├── schema/                        # Schema module (full stack)
│   │   ├── version/                       # SchemaVersion module (full stack)
│   │   ├── ai/                            # AI orchestration, providers, prompts
│   │   ├── export/                        # Export module (full stack)
│   │   ├── notification/                  # Notification module (full stack)
│   │   ├── team/                          # Team & Invitation module (full stack)
│   │   ├── analytics/                     # Analytics module
│   │   ├── common/                        # Shared base classes, exception handling
│   │   └── SchemaForgeApplication.java
│   ├── src/main/resources/
│   │   ├── application.yml
│   │   ├── application-dev.yml
│   │   ├── application-prod.yml
│   │   └── db/migration/                  # Flyway migrations (V1__*.sql ...)
│   ├── src/test/java/com/schemaforge/
│   ├── Dockerfile
│   └── pom.xml
│
├── docs/
│   ├── 01-architecture.md
│   ├── 02-database-design.md
│   ├── 03-api-documentation.md
│   └── 04-deployment-guide.md
│
├── .github/workflows/
│   ├── build.yml
│   ├── test.yml
│   └── deploy.yml
│
├── docker-compose.yml
├── .gitignore
└── README.md
```
