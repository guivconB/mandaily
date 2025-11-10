import User from "../models/userModel.js";
import bcrypt from "bcrypt";

// Criar um novo cadastro
export const novoCadastro = async (dados) => {
  const { email, senha, nome, dataNascimento } = dados;

  if (!email || !senha || !nome || !dataNascimento) {
    throw new Error("Preencha todos os campos obrigatórios.");
  }

  const cadastroExistente = await User.findOne({ email });
  if (cadastroExistente) {
    throw new Error("E-mail já registrado.");
  }

  const senhaHash = await bcrypt.hash(senha, 10);

  const novoUsuario = new User({
    email,
    nome,
    dataNascimento,
    senha: senhaHash,
  });

  await novoUsuario.save();
  return novoUsuario;
};

// Listar todos os cadastros
export const listarCadastros = async () => {
  const cadastros = await User.find().select("-senha");
  return cadastros;
};

// Buscar cadastro por ID
export const buscarCadastroPorId = async (id) => {
  const cadastro = await User.findById(id).select("-senha");
  if (!cadastro) {
    throw new Error("Cadastro não encontrado.");
  }
  return cadastro;
};

// Buscar cadastro por e-mail
export const buscarCadastroPorEmail = async (email) => {
  const cadastro = await User.findOne({ email }).select("-senha");
  if (!cadastro) {
    throw new Error("Cadastro não encontrado.");
  }
  return cadastro;
};

// Atualizar cadastro
export const atualizarCadastro = async (id, dados) => {
  if (dados.senha) {
    dados.senha = await bcrypt.hash(dados.senha, 10);
  }

  const cadastroAtualizado = await User.findByIdAndUpdate(id, dados, { new: true }).select("-senha");
  if (!cadastroAtualizado) {
    throw new Error("Cadastro não encontrado.");
  }

  return cadastroAtualizado;
};

// Deletar cadastro
export const deletarCadastro = async (id) => {
  const cadastroDeletado = await User.findByIdAndDelete(id);
  if (!cadastroDeletado) {
    throw new Error("Cadastro não encontrado.");
  }

  return cadastroDeletado;
};

// Login de usuário
export const login = async (email, senha) => {
  const usuario = await User.findOne({ email });
  if (!usuario) {
    throw new Error("E-mail ou senha incorretos.");
  }

  const senhaValida = await bcrypt.compare(senha, usuario.senha);
  if (!senhaValida) {
    throw new Error("E-mail ou senha incorretos.");
  }

  return usuario;
};
