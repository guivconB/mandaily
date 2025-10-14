import express from 'express';
import MedicationController from '../Controllers/medicationController.js';

const router = express.Router();

router.get('/listarMedicamentos', MedicationController.listarMedicamentos);
router.post('/adicionarMedicamento', MedicationController.adicionarMedicamento);
router.put();
router.delete();

export default router;