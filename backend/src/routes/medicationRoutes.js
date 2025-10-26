import express from 'express';
import { novoMedicamento, listarMedicamentos, listarMedicamentosPorId, atualizarMedicamento, deletarMedicamento } from '../Controllers/medicationController.js';

const router = express.Router();

router.post('/medicamento', novoMedicamento);
router.get('/medicamentos', listarMedicamentos);
router.get('/medicamento/:id', listarMedicamentosPorId);
router.put('/medicamento/:id', atualizarMedicamento);
router.delete('/medicamento/:id', deletarMedicamento);

export default router;