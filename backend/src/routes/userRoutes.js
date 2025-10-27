import express from 'express';
import { novoCadastro, listarCadastros, buscarCadastroPorEmail, buscarCadastroPorId, atualizarCadastro, deletarCadastro } from '../Controllers/userController.js';

const router = express.Router();

//listar todos os cadastros
router.get('/users', listarCadastros);
//buscar cadastro por email
router.get('user/:email', buscarCadastroPorEmail);
// buscar cadastro por ID
router.get('/user/:id', buscarCadastroPorId);
//criar novo cadastro
router.post('/user', novoCadastro);
//atualizar cadastro por ID
router.put('/user/:id', atualizarCadastro);
//deletar cadastro por ID
router.delete('/user/:id', deletarCadastro);
//login



export default router;

