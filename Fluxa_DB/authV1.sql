-- =========================================
-- FLUXA DB - AUTH MODULE (V1)
-- Database: fluxa_db
-- Schema: auth
-- =========================================

-- =========================================
-- 1) EXTENSIONS (public)
-- =========================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "citext";

-- =========================================
-- 2) SCHEMA
-- =========================================
CREATE SCHEMA IF NOT EXISTS auth;

-- =========================================
-- 3) TABLE: auth.users
--    Short ID strategy: 12 chars from UUID
-- =========================================
CREATE TABLE IF NOT EXISTS auth.users (
    user_id VARCHAR(15) PRIMARY KEY DEFAULT SUBSTRING(public.gen_random_uuid()::text, 1, 12),

    display_name VARCHAR(100) NOT NULL,
    email public.citext NOT NULL,
    password_hash TEXT NOT NULL,

    role VARCHAR(20) NOT NULL DEFAULT 'cliente',

    reset_token VARCHAR(255) NULL,
    reset_token_expires TIMESTAMPTZ NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ NULL
);

-- =========================================
-- 4) INDEXES
-- =========================================
-- Unique email for non-deleted accounts
CREATE UNIQUE INDEX IF NOT EXISTS uq_users_email_active
ON auth.users (email)
WHERE deleted_at IS NULL;

CREATE INDEX IF NOT EXISTS idx_users_is_active
ON auth.users (is_active);

CREATE INDEX IF NOT EXISTS idx_users_created_at
ON auth.users (created_at DESC);

-- =========================================
-- 5) SEED: Admin user
-- NOTE:
-- This uses PostgreSQL crypt() for hashing at seed time.
-- In production, passwords should be hashed by the backend.
-- =========================================
INSERT INTO auth.users (email, password_hash, display_name, role)
VALUES (
    'finmanagement.fluxa@gmail.com',
    crypt('fluxa123', gen_salt('bf')),
    'Admin Fluxa',
    'admin'
)
ON CONFLICT DO NOTHING;