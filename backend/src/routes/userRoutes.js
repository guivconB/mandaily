import express from 'express';
import userController from '../Controllers/userController.js';
import { novoCadastro } from '../controllers/userController.js';

const router = express.Router();

//listar todos os cadastros
router.get('/dados', userController.listarCadastros);
//buscar cadastro por email
router.get('/dados/email/:email', userController.buscarCadastroPorEmail);
// buscar cadastro por ID
router.get('/dados/:id', userController.buscarCadastroPorId);
//criar novo cadastro
router.post('/dados', userController.novoCadastro);
//atualizar cadastro por ID
router.put('/dados/:id', userController.atualizarCadastro);
//deletar cadastro por ID
router.delete('/dados/:id', userController.deletarCadastro);
//login
router.post('/login', userController.login);



export default router;

