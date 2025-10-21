import express from 'express';
import scheduleController, { listarAgendamentos, listarAgendamentosConsulta, listarAgendamentosMedicacao, novoAgendamento } from '../Controllers/scheduleController'

const router = express.Router();

router.post('/novoAgendamento', scheduleController.novoAgendamento);
router.get('/agendamentos', scheduleController.listarAgendamentos);
router.get('/consultas', listarAgendamentosConsulta );
router.get('/medicacao', listarAgendamentosMedicacao );
router.put('/', );
router.delete('/', );

///// Por ID
router.get('/', );

export default router;