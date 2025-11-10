import express from 'express';
import { novoMedicamentoController, listarMedicamentosController, listarMedicamentoPorIdController,
     atualizarMedicamentoController, deletarMedicamentoController } from '../controllers/medicationController.js';

const router = express.Router();

router.post('/medicamento', novoMedicamentoController);
router.get('/medicamentos', listarMedicamentosController);
router.get('/medicamento/:id', listarMedicamentoPorIdController);
router.put('/medicamento/:id', atualizarMedicamentoController);
router.delete('/medicamento/:id', deletarMedicamentoController);

export default router;