import dotenv from 'dotenv';
dotenv.config();

import express from 'express';



import userRoutes from './routes/userRoutes.js';
import medicationRoutes from './routes/medicationRoutes.js';
import consultaRoutes from './routes/appointmentRoutes.js';
import scheduleRoutes from './routes/scheduleRoutes.js';

import conectaNaDatabase from './config/dbConnection.js';
await conectaNaDatabase();


const app = express();
const port = process.env.PORT || 3000;



app.use(express.json());
app.use(userRoutes);
app.use(scheduleRoutes);
app.use(medicationRoutes);
app.use(consultaRoutes);

app.get('/', (req, res) => {
    res.status(200).json({ msg: "Bem-vindo" });
});

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}.`)
});