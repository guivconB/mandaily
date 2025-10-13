import cadastroController from '../Controllers/cadastroController.js';
import express from 'express';

const router = express.Router();

router.post("/cadastro", cadastroController.novoCadastro);

export default router;

////teste
