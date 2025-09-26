require('dotenv').config();
const express = require('express');
const port = process.env.PORT || 3000; /// isso é variável de ambiente / usar port por convenção
const bcrypt = require('bcrypt');


const users = require('../db.js');


const userRegister = async (req, res) => {
    const {nome, email, senha} = req.body;
    if ( !nome || !email || !senha ) {
        return res.status(400).json({ error: 'Todos os campos são obrigatórios'});
    } try {
        const saltRounds = 10; /// criptografia
        const senhaCriptografada = await bcrypt.hash(senha, saltRounds);

        users.push({ nome, email, senha: senhaCriptografada });

        res.status(200).send(`Usuário ${nome} criado no e-mail ${email}`);
    } catch (error) {
        console.error('Erro interno', error);
        res.status(401).json ({ error:'Erro durante a criação de conta.' });
    }
};

const userLogin = async (req,res) => {
    const { email, senha } = req.body;

    const usuario = users.find(u => u.email === email); //// Percorra o array users e para cada item
    if (!usuario) {                                  ////// que estou chamando de "u" verifique se o email é igual ao que eu recebi
        return res.status(404).send({ error: 'usuario não encontrado' });
    }

    const senhaCorreta = await bcrypt.compare(senha, usuario.senha);
    if (!senhaCorreta) {
        return res.status(401).json({ error: 'Senha incorreta' });
    }

    res.json({ message: `Login bem-sucedido. Bem vindo(a), ${usuario.nome}`});
}; 


const usersList = async (req, res) => {
    res.json(users);
};

module.exports = {
    userRegister,
    userLogin,
    usersList
};