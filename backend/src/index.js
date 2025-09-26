require('dotenv').config();
const express = require('express');
const app = express();
const port = process.env.PORT || 3000; /// isso é variável de ambiente / usar port por convenção

app.use(express.json());

///Importação das rotas de usuário
const userRoutes = require('./routes/userRoutes');
app.use('/api', userRoutes); /// Todas as rotas terão prefixo API

app.get('/', (req, res) => {
    res.status(200).json({ msg:"Bem-vindo" });
});

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});


