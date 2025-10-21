import express from 'express';
import { createMedication, getAllMedications, getMedicationById, updateMedication, deleteMedication } from '../Controllers/medicationController.js';

const router = express.Router();

router.post('/novoMedicamento', createMedication);
router.get('/medicament', getAllMedications);
router.get('/medicamento/:id', getMedicationById);
router.put('/medicamento/:id', updateMedication);
router.delete('/medicamento/:id', deleteMedication);

export default router;