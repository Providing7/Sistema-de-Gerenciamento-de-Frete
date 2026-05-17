<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Redefinir senha &mdash; FretesTMS</title>
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
      Defina sua<br>nova <span>senha</span>
    </h1>
    <p class="login-hero-sub">
      Escolha uma senha segura com no m&iacute;nimo 6 caracteres.
    </p>
    <ul class="login-features">
      <li><i class="bi bi-check-circle-fill"></i> M&iacute;nimo 6 caracteres</li>
      <li><i class="bi bi-check-circle-fill"></i> Armazenada com criptografia</li>
      <li><i class="bi bi-check-circle-fill"></i> Token de uso &uacute;nico</li>
    </ul>
  </div>

  <div class="login-panel-right">
    <div class="login-form-wrapper">

      <div class="login-brand">
        <div class="login-brand-icon"><i class="bi bi-truck-front-fill"></i></div>
        <span class="login-brand-name">FretesTMS</span>
      </div>

      <% if (Boolean.TRUE.equals(request.getAttribute("tokenInvalido"))) { %>

        <div class="login-form-header">
          <h2>Link inválido ou expirado</h2>
          <p>Este link de redefinição não é mais válido.</p>
        </div>
        <div class="alert alert-error" style="margin-bottom:20px;">
          <i class="bi bi-exclamation-circle-fill"></i>
          O link pode ter expirado (validade de 1 hora) ou já foi utilizado.
        </div>
        <a href="${pageContext.request.contextPath}/esqueceu-senha"
           class="login-submit" style="display:block;text-align:center;text-decoration:none;margin-bottom:16px;">
          <i class="bi bi-arrow-repeat"></i> Solicitar novo link
        </a>

      <% } else { %>

        <div class="login-form-header">
          <h2>Redefinir senha</h2>
          <p>Informe e confirme sua nova senha.</p>
        </div>

        <% if (request.getAttribute("erro") != null) { %>
          <div class="alert alert-error" style="margin-bottom:20px;">
            <i class="bi bi-exclamation-circle-fill"></i> ${erro}
          </div>
        <% } %>

        <form class="login-form" method="post" action="${pageContext.request.contextPath}/redefinir-senha">
          <input type="hidden" name="token" value="${token}" />

          <div class="login-field">
            <label for="novaSenha">Nova senha</label>
            <input type="password" id="novaSenha" name="novaSenha"
                   placeholder="Mínimo 6 caracteres" required minlength="6" autofocus />
          </div>
          <div class="login-field">
            <label for="confirmacao">Confirmar nova senha</label>
            <input type="password" id="confirmacao" name="confirmacao"
                   placeholder="Repita a nova senha" required minlength="6" />
          </div>
          <button class="login-submit" type="submit">
            <i class="bi bi-shield-lock-fill"></i> Salvar nova senha
          </button>
        </form>

      <% } %>

      <div class="login-footer">
        <a href="${pageContext.request.contextPath}/login">
          <i class="bi bi-arrow-left"></i> Voltar ao login
        </a>
      </div>

    </div>
  </div>

</div>
</body>
</html>
