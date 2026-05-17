<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- REDESIGN: Dark Glassmorphic / Bento Grid — FretesTMS --%>
<%@ page import="br.com.gestaofretes.motorista.Motorista, br.com.gestaofretes.mensageria.NotificacaoMotorista, java.util.List, java.time.LocalDate, java.time.temporal.ChronoUnit, java.time.format.DateTimeFormatter" %>
<%
    List<Motorista> alertas = (List<Motorista>) request.getAttribute("motoristasAlerta");
    LocalDate hoje = LocalDate.now();
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    int qtdVencidas = 0, qtd30 = 0, qtd60 = 0, qtd90 = 0;
    if (alertas != null) {
        for (Motorista m : alertas) {
            if (m.getCnhValidade() == null) continue;
            long dias = ChronoUnit.DAYS.between(hoje, m.getCnhValidade());
            if      (dias < 0)   qtdVencidas++;
            else if (dias <= 30) qtd30++;
            else if (dias <= 60) qtd60++;
            else                 qtd90++;
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Alertas de CNH &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">

    <!-- ── Topbar dark ── -->
    <header class="cnh-topbar">
      <div class="cnh-topbar-left">
        <div class="cnh-topbar-icon"><i class="bi bi-shield-exclamation"></i></div>
        <div>
          <div class="cnh-topbar-title">Alertas de CNH</div>
          <div class="cnh-topbar-sub">Valida&ccedil;&otilde;es cr&iacute;ticas de motoristas &mdash; pr&oacute;ximos 90 dias</div>
        </div>
      </div>
      <div class="cnh-topbar-right">
        <a href="${pageContext.request.contextPath}/dashboard" class="cnh-btn-back">
          <i class="bi bi-arrow-left"></i> Dashboard
        </a>
      </div>
    </header>

    <main class="cnh-page-body">

      <!-- ═══ BENTO GRID — Cards de resumo ═══ -->
      <div class="cnh-bento">

        <div class="cnh-card cnh-card--vencida">
          <div class="cnh-card-glow cnh-glow--vencida"></div>
          <div class="cnh-card-inner">
            <div class="cnh-card-icon"><i class="bi bi-x-octagon-fill"></i></div>
            <div class="cnh-card-num"><%= qtdVencidas %></div>
            <div class="cnh-card-label">CNH Vencida</div>
            <div class="cnh-card-desc">Motoristas bloqueados para opera&ccedil;&atilde;o</div>
          </div>
          <div class="cnh-card-accent cnh-accent--vencida"></div>
        </div>

        <div class="cnh-card cnh-card--critico">
          <div class="cnh-card-glow cnh-glow--critico"></div>
          <div class="cnh-card-inner">
            <div class="cnh-card-icon"><i class="bi bi-exclamation-triangle-fill"></i></div>
            <div class="cnh-card-num"><%= qtd30 %></div>
            <div class="cnh-card-label">Cr&iacute;tico</div>
            <div class="cnh-card-desc">Vence em at&eacute; 30 dias</div>
          </div>
          <div class="cnh-card-accent cnh-accent--critico"></div>
        </div>

        <div class="cnh-card cnh-card--atencao">
          <div class="cnh-card-glow cnh-glow--atencao"></div>
          <div class="cnh-card-inner">
            <div class="cnh-card-icon"><i class="bi bi-clock-fill"></i></div>
            <div class="cnh-card-num"><%= qtd60 %></div>
            <div class="cnh-card-label">Aten&ccedil;&atilde;o</div>
            <div class="cnh-card-desc">Vence entre 31 e 60 dias</div>
          </div>
          <div class="cnh-card-accent cnh-accent--atencao"></div>
        </div>

        <div class="cnh-card cnh-card--aviso">
          <div class="cnh-card-glow cnh-glow--aviso"></div>
          <div class="cnh-card-inner">
            <div class="cnh-card-icon"><i class="bi bi-info-circle-fill"></i></div>
            <div class="cnh-card-num"><%= qtd90 %></div>
            <div class="cnh-card-label">Aviso</div>
            <div class="cnh-card-desc">Vence entre 61 e 90 dias</div>
          </div>
          <div class="cnh-card-accent cnh-accent--aviso"></div>
        </div>

      </div>

      <!-- ═══ Filtros rápidos ═══ -->
      <div class="cnh-filtros">
        <button class="cnh-filtro-btn ativo" onclick="filtrar('todos', this)">
          <span class="cnh-filtro-dot cnh-dot--todos"></span>
          Todos <span class="cnh-filtro-count"><%= alertas != null ? alertas.size() : 0 %></span>
        </button>
        <button class="cnh-filtro-btn" onclick="filtrar('vencida', this)">
          <span class="cnh-filtro-dot cnh-dot--vencida"></span>
          Vencidas <span class="cnh-filtro-count"><%= qtdVencidas %></span>
        </button>
        <button class="cnh-filtro-btn" onclick="filtrar('critico', this)">
          <span class="cnh-filtro-dot cnh-dot--critico"></span>
          Cr&iacute;tico <span class="cnh-filtro-count"><%= qtd30 %></span>
        </button>
        <button class="cnh-filtro-btn" onclick="filtrar('atencao', this)">
          <span class="cnh-filtro-dot cnh-dot--atencao"></span>
          Aten&ccedil;&atilde;o <span class="cnh-filtro-count"><%= qtd60 %></span>
        </button>
        <button class="cnh-filtro-btn" onclick="filtrar('aviso', this)">
          <span class="cnh-filtro-dot cnh-dot--aviso"></span>
          Aviso <span class="cnh-filtro-count"><%= qtd90 %></span>
        </button>
      </div>

      <!-- ═══ Tabela principal ═══ -->
      <div class="cnh-glass-panel">
        <div class="cnh-panel-header">
          <span class="cnh-panel-title"><i class="bi bi-table"></i> Motoristas em Alerta</span>
          <span class="cnh-panel-meta">Total: <%= alertas != null ? alertas.size() : 0 %> registros</span>
        </div>

        <% if (alertas == null || alertas.isEmpty()) { %>
          <div class="cnh-empty">
            <i class="bi bi-check2-circle"></i>
            <p>Nenhum motorista com CNH vencida ou a vencer nos pr&oacute;ximos 90 dias.</p>
          </div>
        <% } else { %>
        <div class="cnh-table-wrap">
          <table class="cnh-table">
            <thead>
              <tr>
                <th>Motorista</th>
                <th>CNH N&ordm;</th>
                <th>Categoria</th>
                <th>Validade</th>
                <th>Situa&ccedil;&atilde;o</th>
                <th class="td-center">Dias</th>
                <th class="td-center">A&ccedil;&atilde;o</th>
              </tr>
            </thead>
            <tbody>
              <% for (Motorista m : alertas) {
                   if (m.getCnhValidade() == null) continue;
                   long dias    = ChronoUnit.DAYS.between(hoje, m.getCnhValidade());
                   boolean venc = dias < 0;
                   String grupo   = venc ? "vencida" : dias <= 30 ? "critico" : dias <= 60 ? "atencao" : "aviso";
                   String badgeC  = venc ? "cnh-badge--vencida" : dias <= 30 ? "cnh-badge--critico" : dias <= 60 ? "cnh-badge--atencao" : "cnh-badge--aviso";
                   String sitLbl  = venc ? "VENCIDA" : dias <= 30 ? "CR\u00CDTICO" : dias <= 60 ? "ATEN\u00C7\u00C3O" : "AVISO";
                   String diasCls = venc ? "cnh-dias--vencido" : dias <= 30 ? "cnh-dias--critico" : dias <= 60 ? "cnh-dias--atencao" : "cnh-dias--aviso";
              %>
              <tr data-grupo="<%= grupo %>">
                <td>
                  <div class="cnh-motorista-cell">
                    <div class="cnh-avatar cnh-avatar--<%= grupo %>"><%= m.getNome().charAt(0) %></div>
                    <strong><%= m.getNome() %></strong>
                  </div>
                </td>
                <td class="cnh-mono"><%= m.getCnhNumero() != null ? m.getCnhNumero() : "&mdash;" %></td>
                <td>
                  <% if (m.getCnhCategoria() != null) { %>
                    <span class="cnh-categoria-pill"><%= m.getCnhCategoria().name() %></span>
                  <% } else { %>&mdash;<% } %>
                </td>
                <td class="cnh-mono"><%= m.getCnhValidade().format(fmt) %></td>
                <td><span class="cnh-badge <%= badgeC %>"><%= sitLbl %></span></td>
                <td class="td-center">
                  <span class="<%= diasCls %>">
                    <% if (venc) { %>&minus;<%= Math.abs(dias) %>d
                    <% } else { %>+<%= dias %>d<% } %>
                  </span>
                </td>
                <td class="td-center">
                  <a href="${pageContext.request.contextPath}/motoristas?acao=editar&id=<%= m.getId() %>"
                     class="cnh-btn-atualizar">
                    <i class="bi bi-pencil-square"></i> Atualizar CNH
                  </a>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
        <% } %>
      </div>

      <!-- ═══ HISTÓRICO DE NOTIFICAÇÕES ═══ -->
      <%
        List<NotificacaoMotorista> historico =
            (List<NotificacaoMotorista>) request.getAttribute("historicoNotificacoes");
        DateTimeFormatter fmtDH = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
      %>
      <div class="cnh-glass-panel" style="margin-top:24px;">
        <div class="cnh-panel-header">
          <span class="cnh-panel-title"><i class="bi bi-clock-history"></i> Hist&oacute;rico de Notifica&ccedil;&otilde;es do Sistema</span>
          <span class="cnh-panel-meta cnh-scheduler-badge"><i class="bi bi-cpu"></i> Verificado ao iniciar + a cada 24h</span>
        </div>

        <% if (historico == null || historico.isEmpty()) { %>
          <div class="cnh-empty">
            <i class="bi bi-bell-slash"></i>
            <p>Nenhuma notifica&ccedil;&atilde;o registrada ainda.</p>
          </div>
        <% } else { %>
        <div class="cnh-table-wrap">
          <table class="cnh-table">
            <thead>
              <tr>
                <th>Data / Hora</th>
                <th>Motorista</th>
                <th>CNH N&ordm;</th>
                <th>Validade CNH</th>
                <th class="td-center">Dias (na &eacute;poca)</th>
                <th>N&iacute;vel</th>
              </tr>
            </thead>
            <tbody>
              <% for (NotificacaoMotorista n : historico) {
                   String badgeN = "VENCIDA".equals(n.getNivel())  ? "cnh-badge--vencida"  :
                                   "CRITICO".equals(n.getNivel())  ? "cnh-badge--critico"  :
                                   "ATENCAO".equals(n.getNivel())  ? "cnh-badge--atencao"  : "cnh-badge--aviso";
                   String labelN = "VENCIDA".equals(n.getNivel())  ? "VENCIDA"             :
                                   "CRITICO".equals(n.getNivel())  ? "CR\u00CDTICO"        :
                                   "ATENCAO".equals(n.getNivel())  ? "ATEN\u00C7\u00C3O"   : "AVISO";
              %>
              <tr>
                <td class="cnh-mono cnh-ts"><%= n.getProcessadoEm().format(fmtDH) %></td>
                <td><strong><%= n.getMotoristaNome() %></strong></td>
                <td class="cnh-mono"><%= n.getCnhNumero() != null ? n.getCnhNumero() : "&mdash;" %></td>
                <td class="cnh-mono"><%= n.getCnhValidade().format(fmt) %></td>
                <td class="td-center">
                  <% if (n.getDiasRestantes() < 0) { %>
                    <span class="cnh-dias--vencido">&minus;<%= Math.abs(n.getDiasRestantes()) %>d</span>
                  <% } else if (n.getDiasRestantes() <= 15) { %>
                    <span class="cnh-dias--critico">+<%= n.getDiasRestantes() %>d</span>
                  <% } else if (n.getDiasRestantes() <= 30) { %>
                    <span class="cnh-dias--atencao">+<%= n.getDiasRestantes() %>d</span>
                  <% } else { %>
                    <span class="cnh-dias--aviso">+<%= n.getDiasRestantes() %>d</span>
                  <% } %>
                </td>
                <td><span class="cnh-badge <%= badgeN %>"><%= labelN %></span></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
        <% } %>
      </div>

    </main>
  </div>
</div>

<script>
  function filtrar(grupo, btn) {
    document.querySelectorAll('.cnh-filtro-btn').forEach(b => b.classList.remove('ativo'));
    btn.classList.add('ativo');
    const firstTbody = document.querySelector('.cnh-table tbody');
    if (!firstTbody) return;
    firstTbody.querySelectorAll('tr').forEach(tr => {
      tr.classList.toggle('hide', grupo !== 'todos' && tr.dataset.grupo !== grupo);
    });
  }
</script>
</body>
</html>
