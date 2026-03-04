# Fluxa — Architecture

## Goal
Fluxa is a personal and family finance system focused on:
- Income and expense tracking
- CSV and OFX imports
- Secure data handling
- Scalable architecture for a future SaaS and mobile app

## Repositories / Apps
This repository is organized as a lightweight monorepo:

- `apps/web`: Frontend (initially a static login screen, later the full UI)
- `apps/api`: Backend API (authentication and business rules)
- `fluxa_db`: SQL assets, drafts, and DB-related materials
- `docs`: Project documentation

## High-level Flow (MVP)
1. User opens the web app (`apps/web`)
2. Web app sends login/register requests to the API (`apps/api`)
3. API validates credentials and issues a session/token
4. Web app stores the token (or session cookie) and calls protected endpoints
5. API accesses the database(s) and returns data to the web app

## Security Principles (MVP)
- Never store passwords in plain text (use hashing)
- Use environment variables for secrets (`.env`)
- Do not commit `.env` to GitHub
- Validate and sanitize inputs on the API
- Apply least privilege on DB users

## Future (Roadmap)
- Separate databases: AuthDB, FinanceDB, BillingDB
- Multi-user support with tenant isolation
- Import pipelines (CSV/OFX) with validation and audit logs
- Observability: logs, metrics, alerts