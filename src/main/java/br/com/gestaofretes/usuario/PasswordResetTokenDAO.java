package br.com.gestaofretes.usuario;

import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Gerencia tokens de redefinição de senha na tabela password_reset_token.
 */
public class PasswordResetTokenDAO {

    /** Validade do token: 1 hora */
    private static final int VALIDADE_HORAS = 1;

    /**
     * Gera e persiste um token para o e-mail informado.
     * Invalida tokens anteriores do mesmo e-mail antes de criar o novo.
     * @return o token gerado (UUID sem hífens, 32 chars)
     */
    public String criarToken(String email) throws SQLException {
        // Invalida tokens anteriores
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE password_reset_token SET usado = TRUE WHERE email = ? AND usado = FALSE")) {
            ps.setString(1, email);
            ps.executeUpdate();
        }

        String token = UUID.randomUUID().toString().replace("-", "")
                     + UUID.randomUUID().toString().replace("-", ""); // 64 chars
        LocalDateTime expira = LocalDateTime.now().plusHours(VALIDADE_HORAS);

        String sql = "INSERT INTO password_reset_token (email, token, expira_em) VALUES (?, ?, ?)";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString   (1, email);
            ps.setString   (2, token);
            ps.setTimestamp(3, Timestamp.valueOf(expira));
            ps.executeUpdate();
        }
        return token;
    }

    /**
     * Busca e valida o token. Retorna o e-mail associado se o token for
     * válido (não usado e não expirado), ou null caso contrário.
     */
    public String validarToken(String token) throws SQLException {
        String sql =
            "SELECT email FROM password_reset_token " +
            "WHERE token = ? AND usado = FALSE AND expira_em > NOW()";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("email");
            }
        }
        return null;
    }

    /**
     * Marca o token como usado após redefinição bem-sucedida.
     */
    public void marcarUsado(String token) throws SQLException {
        String sql = "UPDATE password_reset_token SET usado = TRUE WHERE token = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        }
    }
}
