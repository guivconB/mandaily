import express from 'express';
import { criarConsultaController, listarConsultasController, buscarConsultaPorIdController, 
    atualizarConsultaController, deletarConsultaController } from '../controllers/appointmentController.js'

const router = express.Router();

router.post('/consulta', criarConsultaController);
router.get('/consulta', listarConsultasController);
router.get('/consulta/:id', buscarConsultaPorIdController);
router.put('/consulta/:id', atualizarConsultaController);
router.delete('/consulta/:id', deletarConsultaController);

export default router;
