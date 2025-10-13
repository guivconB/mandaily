import userModel from '../models/userModel.js';
import bcrypt from 'bcrypt';

class cadastroController {
  // Criar um novo cadastro
  static async novoCadastro(req, res) {
    try {
      const { email, senha, confirmarSenha, nome, telefone, dataNascimento } = req.body;

      if (!email || !senha || !nome || !telefone || !dataNascimento) {
        return res.status(400).json({ message: "Preencha todos os campos obrigatórios." });
      }

      if (senha !== confirmarSenha) {
        return res.status(400).json({ message: "As senhas não coincidem." });
      }

      const cadastroExistente = await userModel.findOne({ email });
      if (cadastroExistente) {
        return res.status(400).json({ message: "E-mail já registrado." });
      }

      const senhaHash = await bcrypt.hash(senha, 10);

      const novoUsuario = new userModel({
        email,
        nome,
        telefone,
        dataNascimento,
        senha: senhaHash,
      });

      await novoUsuario.save();
      res.status(201).json({ message: "Usuário cadastrado com sucesso!" });
    } catch (error) {
      res.status(500).json({ message: "Erro ao cadastrar usuário.", error: error.message });
    }
  }

  // Listar todos os cadastros
  static async listarCadastros(req, res) {
    try {
      const cadastros = await userModel.find().select("-senha");
      res.status(200).json(cadastros);
    } catch (error) {
      res.status(500).json({ message: "Erro ao listar cadastros.", error: error.message });
    }
  }

  // Buscar um cadastro por ID
  static async buscarCadastroPorId(req, res) {
    try {
      const cadastro = await userModel.findById(req.params.id).select("-senha");
      if (!cadastro) {
        return res.status(404).json({ message: "Cadastro não encontrado." });
      }
      res.status(200).json(cadastro);
    } catch (error) {
      res.status(500).json({ message: "Erro ao buscar cadastro.", error: error.message });
    }
  }

  // Buscar um cadastro por e-mail
  static async buscarCadastroPorEmail(req, res) {
    try {
      const cadastro = await userModel.findOne({ email: req.params.email }).select("-senha");
      if (!cadastro) {
        return res.status(404).json({ message: "Cadastro não encontrado." });
      }
      res.status(200).json(cadastro);
    } catch (error) {
      res.status(500).json({ message: "Erro ao buscar cadastro.", error: error.message });
    }
  }

  // Atualizar um cadastro por ID
  static async atualizarCadastro(req, res) {
    try {
      if (req.body.senha) {
        req.body.senha = await bcrypt.hash(req.body.senha, 10);
      }

      const cadastroAtualizado = await userModel
        .findByIdAndUpdate(req.params.id, req.body, { new: true })
        .select("-senha");

      if (!cadastroAtualizado) {
        return res.status(404).json({ message: "Cadastro não encontrado." });
      }

      res.status(200).json(cadastroAtualizado);
    } catch (error) {
      res.status(500).json({ message: "Erro ao atualizar cadastro.", error: error.message });
    }
  }

  // Deletar um cadastro por ID
  static async deletarCadastro(req, res) {
    try {
      const cadastroDeletado = await userModel.findByIdAndDelete(req.params.id);
      if (!cadastroDeletado) {
        return res.status(404).json({ message: "Cadastro não encontrado." });
      }
      res.status(200).json({ message: "Cadastro deletado com sucesso!" });
    } catch (error) {
      res.status(500).json({ message: "Erro ao deletar cadastro.", error: error.message });
    }
  }

  // Login de usuário
  static async login(req, res) {
    try {
      const { email, senha } = req.body;

      const usuario = await userModel.findOne({ email });
      if (!usuario) {
        return res.status(401).json({ message: "E-mail ou senha incorretos." });
      }

      const senhaValida = await bcrypt.compare(senha, usuario.senha);
      if (!senhaValida) {
        return res.status(401).json({ message: "E-mail ou senha incorretos." });
      }

      res.status(200).json({ message: "Login realizado com sucesso!" });
    } catch (error) {
      res.status(500).json({ message: "Erro ao realizar login.", error: error.message });
    }
  }
}

export default cadastroController;
