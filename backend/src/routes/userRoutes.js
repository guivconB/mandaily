import express from 'express';
import { novoCadastroController, listarCadastrosController, buscarCadastroPorEmailController,
    buscarCadastroPorIdController, atualizarCadastroController, deletarCadastroController, loginController } from '../controllers/userController.js';

const router = express.Router();

//listar todos os cadastros
router.get('/users', listarCadastrosController);
//buscar cadastro por email
router.get('/user/email/:email', buscarCadastroPorEmailController);
// buscar cadastro por ID
router.get('/user/:id', buscarCadastroPorIdController);
//criar novo cadastro
router.post('/user', novoCadastroController);
//atualizar cadastro por ID
router.put('/user/:id', atualizarCadastroController);
//deletar cadastro por ID
router.delete('/user/:id', deletarCadastroController);
//login
router.post('/login', loginController);


export default router;

