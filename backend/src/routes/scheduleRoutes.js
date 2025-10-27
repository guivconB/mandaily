import express from 'express';
import { criarAgendamento } from '../Controllers/scheduleController.js';

const router = express.Router();

router.post('/agendamento', criarAgendamento);


export default router;