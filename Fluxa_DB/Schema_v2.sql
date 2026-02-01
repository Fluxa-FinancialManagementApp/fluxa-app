-- =========================================
-- Fluxa - Banco de Autenticação (Auth DB)
-- =========================================
-- Observações:
-- - Utiliza UUID como chave primária (pgcrypto)
-- - Email tratado como case-insensitive (citext)
-- - Datas com timezone (TIMESTAMPTZ) para evitar problemas de fuso horário
-- - Soft delete implementado via deleted_at (registro não é apagado fisicamente)
-- - updated_at preparado para controle de alterações (backend ou trigger futuramente)

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "citext";

-- Tabela principal de usuários
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Nome exibido do usuário no sistema
    display_name VARCHAR(100) NOT NULL,

    -- Email do usuário (não diferencia maiúsculas/minúsculas)
    email CITEXT NOT NULL,

    -- Hash da senha (nunca armazenar senha em texto puro)
    password_hash TEXT NOT NULL,

    -- Indica se o usuário está ativo ou bloqueado no sistema
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Data e hora de criação do registro
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Data e hora da última atualização do registro
    -- Será atualizado pelo backend ou por trigger no futuro
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Soft delete:
    -- NULL = usuário ativo
    -- Preenchido = usuário removido logicamente
    deleted_at TIMESTAMPTZ NULL
);

-- Garante unicidade de email apenas para usuários não removidos
-- Permite recriar conta com o mesmo email após soft delete
CREATE UNIQUE INDEX uq_users_email_active
    ON users (email)
    WHERE deleted_at IS NULL;

-- Índice para filtros por status de conta
CREATE INDEX idx_users_is_active
    ON users (is_active);

-- Índice para consultas envolvendo usuários removidos
CREATE INDEX idx_users_deleted_at
    ON users (deleted_at);

-- Índice auxiliar para ordenação por data de criação
CREATE INDEX idx_users_created_at
    ON users (created_at DESC);

-- Observação futura:
-- Pode ser criado um trigger para atualizar automaticamente o campo updated_at
-- quando um registro for alterado (UPDATE).
