-- =========================================
-- Fluxa - Seed de Usuários (Auth DB)
-- =========================================
-- Dados APENAS para desenvolvimento/testes

INSERT INTO users (
    display_name,
    email,
    password_hash,
    is_active
) VALUES
(
    'Felipe Teste',
    'felipe@fluxa.dev',
    '$2b$10$HASH_DE_TESTE_1',
    TRUE
),
(
    'Admin Fluxa',
    'admin@fluxa.dev',
    '$2b$10$HASH_DE_TESTE_2',
    TRUE
),
(
    'Usuario Inativo',
    'inativo@fluxa.dev',
    '$2b$10$HASH_DE_TESTE_3',
    FALSE
);
