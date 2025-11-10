// src/services/notificationService.js
import cron from "node-cron";

/**
 * Agenda uma notificação diária com base no horário do medicamento.
 * @param {Object} medicamento - Objeto do medicamento salvo no banco.
 */
export const agendarNotificacaoDiaria = (medicamento) => {
  if (!medicamento.horarioInicio) return;

  const [hora, minuto] = medicamento.horarioInicio.split(":").map(Number);

  // Agendamento no formato cron: minuto hora * * *
  cron.schedule(`${minuto} ${hora} * * *`, () => {
    console.log(`Lembrete: Tomar ${medicamento.nome} (${medicamento.dose})`);
  });

  console.log(
    `Notificação diária agendada para ${medicamento.nome} às ${medicamento.horarioInicio}`
  );
};
