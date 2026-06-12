<div align="center">
  <h1>⚡ SchemaForge AI</h1>
  <p><strong>Transform Plain English Into Production-Ready Database Schemas</strong></p>
  <p>
    <img src="https://img.shields.io/badge/Next.js-15-black?logo=next.js" />
    <img src="https://img.shields.io/badge/Spring_Boot-3.3-green?logo=spring" />
    <img src="https://img.shields.io/badge/TypeScript-5-blue?logo=typescript" />
    <img src="https://img.shields.io/badge/PostgreSQL-16-blue?logo=postgresql" />
    <img src="https://img.shields.io/badge/AI-Claude_Sonnet-purple?logo=anthropic" />
    <img src="https://img.shields.io/badge/license-MIT-green" />
  </p>
  <p>
    <a href="#demo">View Demo</a> · <a href="#features">Features</a> · <a href="#setup">Setup</a> · <a href="#deployment">Deploy</a>
  </p>
</div>

---

## What is SchemaForge AI?

SchemaForge AI is an AI-powered database design platform that converts natural language system descriptions into normalized, production-ready database schemas.

Describe your system in plain English:

> *"Build a hospital management system with doctors, patients, appointments, prescriptions, wards, and billing."*

SchemaForge AI returns:
- ✅ Normalized table definitions with fields, types, constraints
- ✅ Entity relationships with cardinality
- ✅ PostgreSQL / MySQL / SQL Server / Oracle DDL scripts
- ✅ Interactive Mermaid.js ER diagrams
- ✅ 1NF → BCNF normalization analysis
- ✅ AI schema review with recommendations
- ✅ Chat assistant that explains design decisions

---

## Features

| Feature | Description |
|---|---|
| **AI Schema Generation** | Claude Sonnet analyzes requirements and designs normalized schemas |
| **Multi-dialect SQL** | Generate DDL for PostgreSQL, MySQL, SQL Server, Oracle |
| **ER Diagrams** | Mermaid.js crow's-foot entity relationship diagrams |
| **Schema Review** | Detect missing relationships, normalization issues, naming problems |
| **Normalization Analysis** | Visual 1NF / 2NF / 3NF / BCNF compliance report |
| **AI Chat Assistant** | Ask questions about your schema with full context awareness |
| **Project Management** | Save, organize, and revisit generated schemas |
| **SQL Export** | Copy or download DDL scripts instantly |

---

## Tech Stack

### Frontend
- **Next.js 15** — App router, React Server Components
- **TypeScript 5** — Full type safety
- **Tailwind CSS** — Utility-first styling
- **shadcn/ui** — Accessible component primitives
- **Mermaid.js** — ER diagram rendering
- **Zustand** — Lightweight state management
- **React Query** — Server state and caching

### Backend
- **Spring Boot 3.3** — REST API framework
- **Java 21** — Virtual threads, records, pattern matching
- **Spring Security + JWT** — Authentication and authorization
- **Spring Data JPA** — Database access layer
- **PostgreSQL** — Primary database

### AI
- **Anthropic Claude Sonnet** — Schema generation, chat assistant, schema review
- **Structured JSON prompting** — Reliable schema extraction

### Infrastructure
- **Vercel** — Frontend hosting
- **Render** — Backend hosting
- **Neon** — Serverless PostgreSQL

---

## Project Structure

```
schemaforge-ai/
├── frontend/                    # Next.js 15 application
│   ├── src/
│   │   ├── app/                 # App router pages
│   │   │   ├── (auth)/          # Login, signup pages
│   │   │   ├── dashboard/       # Main dashboard
│   │   │   ├── generator/       # Schema generator
│   │   │   ├── projects/        # Project management
│   │   │   ├── sql/             # SQL export
│   │   │   ├── erd/             # ER diagram viewer
│   │   │   ├── normalization/   # Normalization analysis
│   │   │   └── chat/            # AI chat assistant
│   │   ├── components/
│   │   │   ├── ui/              # shadcn/ui base components
│   │   │   ├── layout/          # Sidebar, topbar, shell
│   │   │   ├── schema/          # Schema-specific components
│   │   │   └── shared/          # Shared components
│   │   ├── lib/                 # API client, utilities
│   │   ├── store/               # Zustand state stores
│   │   ├── hooks/               # Custom React hooks
│   │   └── types/               # TypeScript type definitions
│   ├── public/                  # Static assets
│   └── package.json
│
├── backend/                     # Spring Boot 3 API
│   └── src/main/java/com/schemaforge/
│       ├── controller/          # REST controllers
│       ├── service/             # Business logic
│       ├── repository/          # JPA repositories
│       ├── model/
│       │   ├── entity/          # JPA entities
│       │   └── dto/             # Request/Response DTOs
│       ├── security/            # JWT, Spring Security
│       └── config/              # App configuration
│
├── docs/                        # Architecture diagrams, API docs
├── .github/workflows/           # CI/CD pipelines
└── docker-compose.yml           # Local development
```

---

## Getting Started

### Prerequisites

- Node.js 20+
- Java 21+
- Maven 3.9+
- PostgreSQL 16+ (or Docker)
- Anthropic API key

### Quick start with Docker

```bash
git clone https://github.com/YOUR_USERNAME/schemaforge-ai.git
cd schemaforge-ai

# Copy environment files
cp frontend/.env.example frontend/.env.local
cp backend/.env.example backend/.env

# Add your Anthropic API key to frontend/.env.local
# NEXT_PUBLIC_ANTHROPIC_API_KEY=sk-ant-...

# Start everything
docker-compose up --build
```

Open [http://localhost:3000](http://localhost:3000)

### Manual setup

**Frontend:**
```bash
cd frontend
npm install
cp .env.example .env.local
# Edit .env.local with your keys
npm run dev
```

**Backend:**
```bash
cd backend
cp .env.example .env
# Edit .env with your database credentials
mvn spring-boot:run
```

---

## Environment Variables

### Frontend (`frontend/.env.local`)
```env
NEXT_PUBLIC_API_URL=http://localhost:8080
NEXT_PUBLIC_ANTHROPIC_API_KEY=sk-ant-your-key-here
```

### Backend (`backend/.env`)
```env
DATABASE_URL=jdbc:postgresql://localhost:5432/schemaforge
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_password
JWT_SECRET=your-jwt-secret-min-256-bits
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

---

## Deployment

### Frontend → Vercel

```bash
cd frontend
npx vercel --prod
```

Set environment variables in Vercel dashboard.

### Backend → Render

1. Connect GitHub repo to Render
2. Set root directory to `backend/`
3. Build command: `mvn clean package -DskipTests`
4. Start command: `java -jar target/schemaforge-*.jar`
5. Add environment variables

### Database → Neon

1. Create a project at [neon.tech](https://neon.tech)
2. Copy the connection string
3. Set `DATABASE_URL` in backend environment

---

## API Documentation

The backend exposes a REST API documented with OpenAPI/Swagger.

When running locally: [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)

Key endpoints:

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/auth/signup` | Register new user |
| `POST` | `/api/auth/login` | Authenticate, receive JWT |
| `POST` | `/api/schema/generate` | Generate schema from description |
| `POST` | `/api/schema/review` | AI review of existing schema |
| `GET` | `/api/projects` | List user's projects |
| `POST` | `/api/projects` | Save a project |
| `DELETE` | `/api/projects/:id` | Delete a project |
| `POST` | `/api/chat` | Chat with AI about schema |

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">
  <p>Built with ❤️ using <a href="https://www.anthropic.com">Anthropic Claude</a></p>
</div>
#   m o d e l m i n d - a i  
 