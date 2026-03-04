-- 1. Ativa a extensão de criptografia (caso não esteja)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 2. Esvazia a gaveta primeiro para evitar conflitos de tamanho
DELETE FROM auth.users;

-- 3. Remove a regra antiga temporariamente
ALTER TABLE auth.users ALTER COLUMN user_id DROP DEFAULT;

-- 4. Mantém a "gaveta" com limite de 15 espaços (para ter uma folga de segurança)
ALTER TABLE auth.users ALTER COLUMN user_id TYPE VARCHAR(15);

-- 5. A NOVA REGRA: Agora ele pega exatamente os primeiros 12 caracteres!
ALTER TABLE auth.users ALTER COLUMN user_id SET DEFAULT SUBSTRING(gen_random_uuid()::text, 1, 12);

-- 6. Insere o seu usuário com a senha já criptografada pelo banco
INSERT INTO auth.users (email, password_hash, display_name, role) 
VALUES (
    'finmanagement.fluxa@gmail.com', 
    crypt('fluxa123', gen_salt('bf')), 
    'Admin Fluxa', 
    'admin'
);