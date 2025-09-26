const express = require('express');

const router = express.Router();

const { userRegister, userLogin, usersList } = require('../controllers/userController');

router.post('/registrarUsuario', userRegister);
router.post('/login', userLogin);
router.get('/users', usersList)

module.exports = router;