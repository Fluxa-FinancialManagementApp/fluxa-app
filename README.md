# Fluxa -- Financial Management App

Fluxa is a modern personal and financial management system designed to
help users organize, track, and control their finances in a simple and
secure way.

This project is being built with a modular architecture, separating
authentication, financial data, and billing systems into independent
components to ensure scalability and maintainability.

------------------------------------------------------------------------

# Project Status

🚧 In Development

Current focus: - Authentication system - Backend API foundation -
Database architecture - Frontend login interface

------------------------------------------------------------------------

# Repository Structure

    fluxa-app/
    │
    ├── apps
    │   ├── api
    │   │   ├── prisma
    │   │   ├── server.js
    │   │   ├── package.json
    │   │   └── tsconfig.json
    │   │
    │   └── web
    │       └── login
    │           ├── index.html
    │           ├── css
    │           ├── js
    │           └── assets
    │
    ├── docs
    │   ├── api.md
    │   ├── architecture.md
    │   └── database.md
    │
    ├── Fluxa_DB
    │   └── SQL scripts and database structure
    │
    └── README.md

------------------------------------------------------------------------

# Architecture

Fluxa follows a modular architecture designed to separate concerns
between layers of the system.

Main components:

Frontend - HTML - CSS - JavaScript

Backend - Node.js - Express

Database - PostgreSQL

Documentation - Markdown documentation located in `/docs`

The goal is to evolve the project into a scalable SaaS platform.

More details are available in:

docs/architecture.md

------------------------------------------------------------------------

# Database Design

Fluxa uses a single PostgreSQL database:

    fluxa_db

Inside this database, schemas are used to separate system modules.

Example:

    fluxa_db
    │
    ├── auth
    │   └── users
    │
    ├── finance (planned)
    │
    └── billing (planned)

Auth Schema Responsible for authentication and user management.

Features: - User registration - Login - Password hashing - Account
status control - Role management (admin / client)

Future modules:

Finance - Transactions - Categories - Accounts - Reports

Billing - Subscription plans - Payment management - Account status based
on subscription

Full database details are documented in:

docs/database.md

------------------------------------------------------------------------

# API

The backend API handles communication between the frontend and the
database.

Initial endpoints include:

Authentication - Login - User validation

Future endpoints will include:

Finance - Transaction management - Financial summaries

Billing - Subscription management

Full API documentation:

docs/api.md

------------------------------------------------------------------------

# Technologies

Backend - Node.js - Express

Frontend - HTML - CSS - JavaScript

Database - PostgreSQL - pgcrypto extension - citext extension

Tools - Git - GitHub - VS Code

------------------------------------------------------------------------

# Author

Felipe Camacho

------------------------------------------------------------------------

# Vision

Fluxa aims to become a complete financial management SaaS platform that
combines:

-   Simplicity
-   Automation
-   Security
-   Scalability

The long-term goal is to support web and mobile platforms with advanced
financial insights and automation tools.
