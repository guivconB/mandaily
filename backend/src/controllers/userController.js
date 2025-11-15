
import { novoCadastro, listarCadastros, buscarCadastroPorEmail, buscarCadastroPorId, atualizarCadastro, deletarCadastro, login } from '../services/userService.js';


 export const novoCadastroController = async (req, res) => {
  try {
    const Usuario = await novoCadastro(req.body);
    res.status(201).json({ message: `Usuário cadastrado com sucesso! ${Usuario}`});
  } catch (error) {
    res.status(400).json({ message: error.messsage });
  }
 };

 export const listarCadastrosController = async (req, res) => {
  try {
    const Usuarios = await listarCadastros();
    res.status(201).json({ message: `Lista Completa de Usuários: ${Usuarios}` })
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
 };

 export const buscarCadastroPorEmailController = async (req, res) => {
   try {
     // Corrija req.params.id para req.params.email para coincidir com a rota
     const Usuario = await buscarCadastroPorEmail(req.params.email);
     res.status(201).json(Usuario);
   } catch (error) {
     res.status(400).json({ message: error.message })
   }
 };

export const buscarCadastroPorIdController = async (req, res) => {
  try {
    const Usuario = await buscarCadastroPorId(req.params.id);
    res.status(201).json(Usuario)
  } catch (error) {
    res.status(400).json({ message: error.message })
  }
};

export const atualizarCadastroController = async (req, res) => {
  try {
    const Usuario = await atualizarCadastro(req.body);
    res.status(201).json({ message: `Cadastro atualizado com sucesso! ${Usuario}`})
  } catch (error) {
    res.status(400).json({ message: error.message })
  }
};

export const deletarCadastroController = async (req, res) => {
  try {
    await deletarCadastro(req.params.id);
    res.status(200).json({ message: "Cadastro deletado com sucesso!" });
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const loginController = async (req, res) => {
  try {
    const { email, senha } = req.body;
    const Usuario = await login(email, senha);
    res.status(200).json({ message: "Login realizado com sucesso!", Usuario });
  } catch (error) {
    res.status(401).json({ message: error.message });
  }
};