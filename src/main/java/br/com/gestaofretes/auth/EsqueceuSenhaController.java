package br.com.gestaofretes.auth;

import br.com.gestaofretes.usuario.PasswordResetTokenDAO;
import br.com.gestaofretes.usuario.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * GET  /esqueceu-senha  → exibe formulário de solicitação
 * POST /esqueceu-senha  → gera token e exibe link de redefinição
 */
@WebServlet("/esqueceu-senha")
public class EsqueceuSenhaController extends HttpServlet {

    private final UsuarioDAO            usuarioDAO = new UsuarioDAO();
    private final PasswordResetTokenDAO tokenDAO   = new PasswordResetTokenDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/esqueceuSenha.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");

        try {
            String senhaHash = usuarioDAO.buscarSenhaHash(email);

            if (senhaHash != null) {
                // Usuário existe e está ativo — gera token
                String token = tokenDAO.criarToken(email);
                String baseUrl = req.getScheme() + "://" + req.getServerName()
                               + ":" + req.getServerPort()
                               + req.getContextPath();
                String link = baseUrl + "/redefinir-senha?token=" + token;
                req.setAttribute("linkRedefinicao", link);
            }

            // Mesmo se o e-mail não existir, mostramos a mesma mensagem
            // (evita enumeração de usuários)
            req.setAttribute("emailEnviado", email);
            req.getRequestDispatcher("/WEB-INF/views/esqueceuSenha.jsp").forward(req, resp);

        } catch (Exception e) {
            System.err.println("[EsqueceuSenhaController] Erro: " + e.getMessage());
            req.setAttribute("erro", "Erro interno. Tente novamente.");
            req.getRequestDispatcher("/WEB-INF/views/esqueceuSenha.jsp").forward(req, resp);
        }
    }
}
