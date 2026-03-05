# Fluxa — Architecture

## Goal
Fluxa is a personal and family financial management system focused on:
- Income and expense tracking
- CSV and OFX imports
- Data security
- Scalable architecture for a future SaaS and mobile app

## Repository Structure (Monorepo)
This repository uses a lightweight monorepo layout:

- `apps/web` → Frontend (currently the login page)
- `apps/api` → Backend API (authentication and business rules)
- `docs` → Project documentation
- `fluxa_db` → SQL scripts and database assets

## High-level Components

### Web (apps/web)
Responsibilities:
- UI screens (login now; dashboard later)
- Calls the API endpoints via HTTP (fetch)
- Displays validation and error messages

Current app:
- `apps/web/login`
  - `index.html`
  - `css/style.css`
  - `js/script.js`
  - `assets/logo/*` (icons, favicons, svg)

### API (apps/api)
Responsibilities:
- Authentication endpoints (login now; register and others later)
- Input validation and normalization (e.g., lowercasing email)
- Password verification using bcrypt
- Communicates with PostgreSQL through Prisma

Current endpoint:
- `POST /login`

Current stack:
- Node.js + Express
- Prisma ORM + PostgreSQL
- bcrypt
- CORS enabled for local development

### Database (PostgreSQL)
Single database:
- `fluxa_db`

Logical separation using schemas (gavetas):
- `auth` → authentication and users (implemented)
- `finance` → accounts/transactions/categories (planned)
- `billing` → subscriptions/payments (planned)

## Current MVP Flow (Login)
1. User opens `apps/web/login/index.html`
2. User submits email + password
3. Frontend calls `POST http://localhost:3000/login`
4. API normalizes email and checks user status
5. API validates password with bcrypt vs `password_hash`
6. API returns:
   - `200` with user data when OK
   - `401/403` when invalid credentials or inactive user
7. Frontend shows success message and stores user info in `localStorage`

## Security Notes (Current)
- Passwords are stored hashed (`password_hash`)
- API uses bcrypt to compare password hashes
- `.env` must never be committed
- CORS is enabled (development)

## Next Steps (Planned)
- Add `auth/register` endpoint
- Add sessions / tokens (JWT or secure cookie)
- Add schema `finance` and its tables
- Add CSV/OFX import pipeline
- Add authorization rules based on `role`