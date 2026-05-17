<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Esqueceu a senha &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="login-page">

  <div class="login-panel-left">
    <div class="login-hero-badge">
      <i class="bi bi-truck-front-fill"></i> FretesTMS
    </div>
    <h1 class="login-hero-title">
      Recupere o seu<br><span>acesso</span>
    </h1>
    <p class="login-hero-sub">
      Informe o e-mail cadastrado e um link de redefini&ccedil;&atilde;o ser&aacute; gerado para voc&ecirc;.
    </p>
    <ul class="login-features">
      <li><i class="bi bi-check-circle-fill"></i> Token com validade de 1 hora</li>
      <li><i class="bi bi-check-circle-fill"></i> Link de uso &uacute;nico</li>
      <li><i class="bi bi-check-circle-fill"></i> Senha criptografada no banco</li>
    </ul>
  </div>

  <div class="login-panel-right">
    <div class="login-form-wrapper">

      <div class="login-brand">
        <div class="login-brand-icon"><i class="bi bi-truck-front-fill"></i></div>
        <span class="login-brand-name">FretesTMS</span>
      </div>

      <div class="login-form-header">
        <h2>Esqueceu a senha?</h2>
        <p>Digite seu e-mail para recuperar o acesso.</p>
      </div>

      <%-- Exibe erro --%>
      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">
          <i class="bi bi-exclamation-circle-fill"></i> ${erro}
        </div>
      <% } %>

      <%-- Após o POST: exibe o link gerado --%>
      <% if (request.getAttribute("emailEnviado") != null) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          <i class="bi bi-check-circle-fill"></i>
          Solicitação recebida para <strong>${emailEnviado}</strong>.
        </div>

        <% if (request.getAttribute("linkRedefinicao") != null) { %>
          <div style="background:var(--surface-2);border:1px solid var(--border);
                      border-radius:var(--radius-md);padding:16px;margin-bottom:20px;">
            <p style="font-size:13px;color:var(--text-muted);margin-bottom:8px;">
              <i class="bi bi-link-45deg"></i>
              <strong style="color:var(--text);">Link de redefinição</strong> (válido por 1 hora):
            </p>
            <a href="${linkRedefinicao}" style="word-break:break-all;color:var(--primary);font-size:13px;">
              ${linkRedefinicao}
            </a>
          </div>
          <a href="${linkRedefinicao}" class="login-submit" style="display:block;text-align:center;text-decoration:none;margin-bottom:16px;">
            <i class="bi bi-key-fill"></i> Redefinir minha senha agora
          </a>
        <% } %>

        <div class="login-footer">
          <a href="${pageContext.request.contextPath}/login">
            <i class="bi bi-arrow-left"></i> Voltar ao login
          </a>
        </div>

      <% } else { %>
        <%-- Formulário de solicitação --%>
        <form class="login-form" method="post" action="${pageContext.request.contextPath}/esqueceu-senha">
          <div class="login-field">
            <label for="email">E-mail cadastrado</label>
            <input type="email" id="email" name="email" placeholder="seu@email.com" required autofocus />
          </div>
          <button class="login-submit" type="submit">
            <i class="bi bi-send-fill"></i> Gerar link de redefinição
          </button>
        </form>

        <div class="login-footer">
          Lembrou a senha?
          <a href="${pageContext.request.contextPath}/login">Fazer login</a>
        </div>
      <% } %>

    </div>
  </div>

</div>
</body>
</html>
