import express from 'express';
import { criarAgendamentoController, listarAgendamentosController, buscarAgendamentoPorIdController, 
    atualizarAgendamentoController, deletarAgendamentoController } from "../controllers/scheduleController.js";

const router = express.Router();

router.post('/agendamento', criarAgendamentoController);
router.get('/agendamento', listarAgendamentosController);
router.get('/agendamento', buscarAgendamentoPorIdController);
router.put('/agendamento', atualizarAgendamentoController)
router.delete('/agendamento', deletarAgendamentoController);

export default router;