package br.com.gestaofretes.auth;

import br.com.gestaofretes.usuario.PasswordResetTokenDAO;
import br.com.gestaofretes.usuario.UsuarioDAO;
import br.com.gestaofretes.util.BCryptUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * GET  /redefinir-senha?token=XXX  → exibe formulário de nova senha
 * POST /redefinir-senha            → valida token e persiste nova senha
 */
@WebServlet("/redefinir-senha")
public class RedefinirSenhaController extends HttpServlet {

    private final PasswordResetTokenDAO tokenDAO   = new PasswordResetTokenDAO();
    private final UsuarioDAO            usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String email = tokenDAO.validarToken(token);
            if (email == null) {
                req.setAttribute("tokenInvalido", true);
            } else {
                req.setAttribute("token", token);
            }
        } catch (Exception e) {
            req.setAttribute("tokenInvalido", true);
        }

        req.getRequestDispatcher("/WEB-INF/views/redefinirSenha.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token       = req.getParameter("token");
        String novaSenha   = req.getParameter("novaSenha");
        String confirmacao = req.getParameter("confirmacao");

        try {
            // Validações básicas
            if (novaSenha == null || novaSenha.length() < 6) {
                req.setAttribute("token", token);
                req.setAttribute("erro", "A senha deve ter no mínimo 6 caracteres.");
                req.getRequestDispatcher("/WEB-INF/views/redefinirSenha.jsp").forward(req, resp);
                return;
            }
            if (!novaSenha.equals(confirmacao)) {
                req.setAttribute("token", token);
                req.setAttribute("erro", "As senhas não coincidem.");
                req.getRequestDispatcher("/WEB-INF/views/redefinirSenha.jsp").forward(req, resp);
                return;
            }

            String email = tokenDAO.validarToken(token);
            if (email == null) {
                req.setAttribute("tokenInvalido", true);
                req.getRequestDispatcher("/WEB-INF/views/redefinirSenha.jsp").forward(req, resp);
                return;
            }

            // Gera novo hash e atualiza banco
            String novoHash = BCryptUtil.hashSenha(novaSenha);
            usuarioDAO.atualizarSenha(email, novoHash);
            tokenDAO.marcarUsado(token);

            resp.sendRedirect(req.getContextPath()
                + "/login?sucesso=Senha+redefinida+com+sucesso!+Fa%C3%A7a+login.");

        } catch (Exception e) {
            System.err.println("[RedefinirSenhaController] Erro: " + e.getMessage());
            req.setAttribute("token", token);
            req.setAttribute("erro", "Erro interno. Tente novamente.");
            req.getRequestDispatcher("/WEB-INF/views/redefinirSenha.jsp").forward(req, resp);
        }
    }
}
