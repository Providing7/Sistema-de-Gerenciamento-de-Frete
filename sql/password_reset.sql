-- Tabela para tokens de redefinição de senha
-- Execute este script no banco para habilitar o "Esqueceu a senha?"

CREATE TABLE IF NOT EXISTS password_reset_token (
    id          SERIAL PRIMARY KEY,
    email       VARCHAR(100) NOT NULL,
    token       VARCHAR(64)  NOT NULL UNIQUE,
    expira_em   TIMESTAMP    NOT NULL,
    usado       BOOLEAN      NOT NULL DEFAULT FALSE,
    criado_em   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_prt_token ON password_reset_token(token);
CREATE INDEX IF NOT EXISTS idx_prt_email ON password_reset_token(email);
