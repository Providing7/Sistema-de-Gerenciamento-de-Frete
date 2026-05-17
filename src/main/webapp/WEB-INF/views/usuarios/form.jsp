<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Criar Conta &mdash; Gestão de Fretes</title>
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
      Crie sua<br><span>conta agora</span>
    </h1>
    <p class="login-hero-sub">
      Comece a gerenciar seus fretes em poucos segundos.
    </p>
    <ul class="login-features">
      <li><i class="bi bi-check-circle-fill"></i> Cadastro r&aacute;pido e gratuito</li>
      <li><i class="bi bi-check-circle-fill"></i> Acesso completo ao sistema</li>
      <li><i class="bi bi-check-circle-fill"></i> Dados seguros e criptografados</li>
      <li><i class="bi bi-check-circle-fill"></i> Suporte a m&uacute;ltiplos usu&aacute;rios</li>
    </ul>
  </div>

  <div class="login-panel-right">
    <div class="login-form-wrapper">

      <div class="login-brand">
        <div class="login-brand-icon"><i class="bi bi-person-plus-fill"></i></div>
        <span class="login-brand-name">Nova Conta</span>
      </div>

      <div class="login-form-header">
        <h2>Criar nova conta</h2>
        <p>Preencha os campos abaixo para come&ccedil;ar.</p>
      </div>

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">
          <i class="bi bi-exclamation-circle-fill"></i> ${erro}
        </div>
      <% } %>

      <form class="login-form" method="post"
            action="${pageContext.request.contextPath}/usuarios?acao=cadastrar">

        <div class="login-field">
          <label for="nomeCompleto">Nome Completo</label>
          <input type="text" id="nomeCompleto" name="nomeCompleto"
                 value="${nomeCompleto}"
                 placeholder="Seu nome completo" required autofocus />
        </div>

        <div class="login-field">
          <label for="email">E-mail</label>
          <input type="email" id="email" name="email"
                 value="${email}"
                 placeholder="seu@email.com" required />
        </div>

        <div class="login-field">
          <label for="senha">Senha <span style="font-weight:400;color:var(--text-muted);">(m&iacute;nimo 6 caracteres)</span></label>
          <input type="password" id="senha" name="senha"
                 placeholder="Crie uma senha segura" required minlength="6" />
        </div>

        <button class="login-submit" type="submit">
          <i class="bi bi-person-check-fill"></i> Criar minha conta &rarr;
        </button>
      </form>

      <div class="login-footer">
        J&aacute; tem uma conta?
        <a href="${pageContext.request.contextPath}/login">Fazer login</a>
      </div>

    </div>
  </div>

</div>
</body>
</html>