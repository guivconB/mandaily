import { criarAgendamento, listarAgendamentos, buscarAgendamentoPorId, atualizarAgendamento, deletarAgendamento } from "../services/scheduleService.js";

// Criar um novo agendamento
export const criarAgendamentoController = async (req, res) => {
  try {
    const novoAgendamento = await criarAgendamento(req.body);
    return res.status(201).json({ message: "Agendamento criado com sucesso!", agendamento: novoAgendamento });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

// Listar todos os agendamentos
export const listarAgendamentosController = async (req, res) => {
  try {
    const agendamentos = await listarAgendamentos();
    return res.status(200).json(agendamentos);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Buscar agendamento por ID
export const buscarAgendamentoPorIdController = async (req, res) => {
  try {
    const agendamento = await buscarAgendamentoPorId(req.params.id);
    return res.status(200).json(agendamento);
  } catch (error) {
    return res.status(404).json({ error: error.message });
  }
};

// Atualizar agendamento
export const atualizarAgendamentoController = async (req, res) => {
  try {
    const agendamento = await atualizarAgendamento(req.params.id, req.body);
    return res.status(200).json({ message: "Agendamento atualizado com sucesso!", agendamento });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

// Deletar agendamento
export const deletarAgendamentoController = async (req, res) => {
  try {
    await deletarAgendamento(req.params.id);
    return res.status(200).json({ message: "Agendamento deletado com sucesso." });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};
