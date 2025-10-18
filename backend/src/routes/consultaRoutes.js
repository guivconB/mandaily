import express from 'express';
import { criarConsulta, listarConsultas, buscarConsultaPorId, atualizarConsulta, deletarConsulta } from '../Controllers/consultaController.js';

const router = express.Router();

router.post('/consulta', criarConsulta);
router.get('/consulta', listarConsultas);
router.get('/consulta/:id', buscarConsultaPorId);
router.put('/consulta/:id', atualizarConsulta);
router.delete('/consulta/:id', deletarConsulta);

export default router;
