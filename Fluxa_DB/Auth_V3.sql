-- =========================================
-- 1. CRIAÇÃO DA ESTRUTURA LÓGICA
-- =========================================
-- Cria a "gaveta" exclusiva para autenticação
CREATE SCHEMA IF NOT EXISTS auth;

-- Garante que as extensões de segurança existam (no schema public)
CREATE EXTENSION IF NOT EXISTS "pgcrypto" SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "citext" SCHEMA public;

-- =========================================
-- 2. TABELA DE USUÁRIOS (Versão Profissional)
-- =========================================
CREATE TABLE IF NOT EXISTS auth.users (
    -- ID Seguro (UUID)
    user_id UUID PRIMARY KEY DEFAULT public.gen_random_uuid(),

    -- Dados Cadastrais
    display_name VARCHAR(100) NOT NULL,
    email public.citext NOT NULL,
    password_hash TEXT NOT NULL,

    -- Controle de Acesso (Admin ou Cliente)
    role VARCHAR(20) NOT NULL DEFAULT 'cliente',

    -- Preparação para o futuro "Esqueci a Senha"
    reset_token VARCHAR(255) NULL,
    reset_token_expires TIMESTAMPTZ NULL,

    -- Status e Auditoria
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ NULL
);

-- =========================================
-- 3. ÍNDICES (O "Sumário" para busca rápida)
-- =========================================
-- Garante e-mail único para contas não deletadas
CREATE UNIQUE INDEX IF NOT EXISTS uq_users_email_active 
ON auth.users (email) 
WHERE deleted_at IS NULL;

-- Acelera a filtragem de usuários ativos
CREATE INDEX IF NOT EXISTS idx_users_is_active ON auth.users (is_active);

-- Acelera a busca por data de criação (Ordenação)
CREATE INDEX IF NOT EXISTS idx_users_created_at ON auth.users (created_at DESC);