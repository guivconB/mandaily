import Agendamento from "../models/scheduleModel.js";
import User from "../models/userModel.js";
import Medicamento from "../models/medicationModel.js";
import Consulta from "../models/consultaModel.js";

/**
 * Criar um novo agendamento
 */
export const criarAgendamento = async (req, res) => {
  try {
    const { userID, nome, tipoAgendamento, referenceId, dataAgendamento, horarioAgendamento, notificacao, notificacaoDiaria } = req.body;

    // Validações básicas
    if (!userID || !nome || !tipoAgendamento || !referenceId || !dataAgendamento) {
      return res.status(400).json({ message: "Campos obrigatórios não preenchidos." });
    }

    // Verifica se o usuário existe
    const usuario = await User.findById(userID);
    if (!usuario) {
      return res.status(404).json({ message: "Usuário não encontrado." });
    }

    // Verifica se o item de referência existe (dependendo do tipoAgendamento)
    if (tipoAgendamento === "medicamento") {
      const medicamento = await Medicamento.findById(referenceId);
      if (!medicamento) return res.status(404).json({ message: "Medicamento não encontrado." });
    } else if (tipoAgendamento === "consulta") {
      const consulta = await Consulta.findById(referenceId);
      if (!consulta) return res.status(404).json({ message: "Consulta não encontrada." });
    } else {
      return res.status(400).json({ message: "Tipo de agendamento inválido." });
    }

    // Criação do agendamento
    const novoAgendamento = new Agendamento({
      userID,
      nome,
      tipoAgendamento,
      referenceId,
      dataAgendamento,
      horarioAgendamento,
      notificacao,
      notificacaoDiaria
    });

    await novoAgendamento.save();

    res.status(201).json({
      message: "Agendamento criado com sucesso!",
      agendamento: novoAgendamento
    });

  } catch (error) {
    console.error("Erro ao criar agendamento:", error);
    res.status(500).json({ message: "Erro ao criar agendamento." });
  }
};


/**
 * Listar todos os agendamentos
 */
export const listarAgendamentos = async (req, res) => {
  try {
    const agendamentos = await Agendamento.find()
      .populate("userID", "nome email") // mostra o nome e email do usuário
      .populate("referenceId"); // traz os dados da consulta ou medicamento relacionados

    res.status(200).json(agendamentos);
  } catch (error) {
    console.error("Erro ao listar agendamentos:", error);
    res.status(500).json({ message: "Erro ao listar agendamentos." });
  }
};


/**
 * Buscar agendamento por ID
 */
export const buscarAgendamentoPorId = async (req, res) => {
  try {
    const { id } = req.params;
    const agendamento = await Agendamento.findById(id)
      .populate("userID", "nome email")
      .populate("referenceId");

    if (!agendamento) {
      return res.status(404).json({ message: "Agendamento não encontrado." });
    }

    res.status(200).json(agendamento);
  } catch (error) {
    console.error("Erro ao buscar agendamento:", error);
    res.status(500).json({ message: "Erro ao buscar agendamento." });
  }
};


/**
 * Deletar agendamento
 */
export const deletarAgendamento = async (req, res) => {
  try {
    const { id } = req.params;
    const agendamento = await Agendamento.findByIdAndDelete(id);

    if (!agendamento) {
      return res.status(404).json({ message: "Agendamento não encontrado." });
    }

    res.status(200).json({ message: "Agendamento deletado com sucesso." });
  } catch (error) {
    console.error("Erro ao deletar agendamento:", error);
    res.status(500).json({ message: "Erro ao deletar agendamento." });
  }
};
