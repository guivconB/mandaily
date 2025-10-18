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

const router = express.Router();

router.post('/dados', novoCadastro);

export default router;

// File: `backend/src/app.js`
import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import conectaNaDatabase from './config/dbConnection.js';
import userRoutes from './routes/userRoutes.js';

const app = express();
app.use(cors());
app.use(express.json());

conectaNaDatabase();

app.use('/', userRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server rodando na porta ${PORT}`));
