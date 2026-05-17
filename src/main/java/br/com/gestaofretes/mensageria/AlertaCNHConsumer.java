package br.com.gestaofretes.mensageria;

import java.util.logging.Level;
import java.util.logging.Logger;

public class AlertaCNHConsumer implements Runnable {

    private static final Logger log = Logger.getLogger(AlertaCNHConsumer.class.getName());

    private final NotificacaoMotoristaDAO notificacaoDAO = new NotificacaoMotoristaDAO();

    private volatile boolean rodando = true;

    @Override
    public void run() {
        log.info("[CONSUMER] Iniciado — aguardando alertas de CNH na fila...");

        while (rodando) {
            try {
                AlertaCNHMessage msg = AlertaCNHQueue.getInstance().consumir();
                processarAlerta(msg);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.info("[CONSUMER] Interrompido — encerrando.");
                break;
            } catch (Exception e) {
                log.log(Level.SEVERE, "[CONSUMER] Erro ao processar mensagem", e);
            }
        }
    }

    private void processarAlerta(AlertaCNHMessage msg) {
        /*
         * Classificação de nível — alinhada com a tela de Alertas de CNH:
         *   VENCIDA  → dias < 0  (já expirou)
         *   CRITICO  → 0 a 30 dias
         *   ATENCAO  → 31 a 60 dias
         *   AVISO    → 61 a 90 dias
         */
        int dias = msg.getDiasRestantes();

        String nivel = dias < 0  ? "VENCIDA" :
                       dias <= 30 ? "CRITICO" :
                       dias <= 60 ? "ATENCAO" : "AVISO";

        String icone = "VENCIDA".equals(nivel)  ? "🔴 VENCIDA" :
                       "CRITICO".equals(nivel)  ? "🟠 CRÍTICO" :
                       "ATENCAO".equals(nivel)  ? "🟡 ATENÇÃO" : "🟢 AVISO";

        log.warning(String.format(
            "[CONSUMER] %s | Motorista: %-30s | CNH: %-15s | Vence: %s | Dias: %d",
            icone,
            msg.getMotoristaNome(),
            msg.getCnhNumero(),
            msg.getCnhValidade(),
            dias
        ));

        try {
            notificacaoDAO.salvar(msg, nivel);
            log.info("[CONSUMER] Notificação persistida para motorista: " + msg.getMotoristaNome());
        } catch (Exception e) {
            log.log(Level.SEVERE, "[CONSUMER] Falha ao persistir notificação para "
                    + msg.getMotoristaNome(), e);
        }
    }

    public void parar() {
        rodando = false;
    }
}

