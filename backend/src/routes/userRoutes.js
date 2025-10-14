import express from 'express';
import cadastroController from '../Controllers/cadastroController.js';

const router = express.Router();

//listar todos os cadastros
router.get('/dados', cadastroController.listarCadastros);
//buscar cadastro por email
router.get('/dados/email/:email', cadastroController.buscarCadastroPorEmail);
// buscar cadastro por ID
router.get('/dados/:id', cadastroController.buscarCadastroPorId);
//criar novo cadastro
router.post('/dados', cadastroController.novoCadastro);
//atualizar cadastro por ID
router.put('/dados/:id', cadastroController.atualizarCadastro);
//deletar cadastro por ID
router.delete('/dados/:id', cadastroController.deletarCadastro);
//login
router.post('/login', cadastroController.login);

export default router;

