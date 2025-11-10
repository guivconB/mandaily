import Agendamento from "../models/scheduleModel.js";
import User from "../models/userModel.js";
import Medicamento from "../models/medicationModel.js";
import Consulta from "../models/appointmentModel.js";

//// Novo Agendamento
export const criarAgendamento = async (dados) => {
  const { userId, nome, tipoAgendamento, referenceId, dataAgendamento, horarioAgendamento, notificacao, notificacaoDiaria } = dados;

  // Validações básicas
  if (!userId || !nome || !tipoAgendamento || !referenceId || !dataAgendamento) {
    throw new Error("Campos obrigatórios não preenchidos.");
  }

  // Verifica se o usuário existe
  const usuario = await User.findById(userID);
  if (!usuario) {
    throw new Error("Usuário não encontrado.");
  }

  // Verificando se o item de referência existe
  if (tipoAgendamento === "medicamento") {
    const medicamento = await Medicamento.findById(referenceId);
    if (!medicamento) throw new Error("Medicamento não encontrado.");
  } else if (tipoAgendamento === "consulta") {
    const consulta = await Consulta.findById(referenceId);
    if (!consulta) throw new Error("Consulta não encontrada.");
  } else {
    throw new Error("Tipo de agendamento inválido.");
  }

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

  return novoAgendamento;
};

// Listar todos os agendamentos
export const listarAgendamentos = async () => {
  const agendamentos = await Agendamento.find()
    .populate("userID", "nome email")
    .populate("referenceId");

  return agendamentos;
};

//Buscar agendamento por ID
export const buscarAgendamentoPorId = async (id) => {
  const agendamento = await Agendamento.findById(id)
    .populate("userID", "nome email")
    .populate("referenceId");

  if (!agendamento) {
    throw new Error("Agendamento não encontrado.");
  }

  return agendamento;
};


export const atualizarAgendamento = async (id, dadosAtualizados) => {
  try {
    const agendamentoAtualizado = await Agendamento.findByIdAndUpdate(
      id,
      dadosAtualizados,
      { new: true, runValidators: true }
    );

    if (!agendamentoAtualizado) {
      throw new Error("Agendamento não encontrado");
    }

    return agendamentoAtualizado;
  } catch (error) {
    throw new Error(error.message);
  }
};

// Deletar agendamento
export const deletarAgendamento = async (id) => {
  const agendamento = await Agendamento.findByIdAndDelete(id);

  if (!agendamento) {
    throw new Error("Agendamento não encontrado.");
  }

  return agendamento;
};