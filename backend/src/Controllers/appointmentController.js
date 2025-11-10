import { criarConsulta, listarConsultas, buscarConsultaPorId, atualizarConsulta, deletarConsulta } from "../services/appointmentService.js";

// Criar nova consulta
export const criarConsultaController = async (req, res) => {
  try {
    const novaConsulta = await criarConsulta(req.body);
    return res.status(201).json({
      message: "Consulta criada com sucesso!",
      consulta: novaConsulta,
    });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

// Listar todas as consultas
export const listarConsultasController = async (req, res) => {
  try {
    const consultas = await listarConsultas();
    return res.status(200).json(consultas);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
};

// Buscar consulta por ID
export const buscarConsultaPorIdController = async (req, res) => {
  try {
    const consulta = await buscarConsultaPorId(req.params.id);
    return res.status(200).json(consulta);
  } catch (error) {
    return res.status(404).json({ error: error.message });
  }
};

// Atualizar consulta
export const atualizarConsultaController = async (req, res) => {
  try {
    const consulta = await atualizarConsulta(req.params.id, req.body);
    return res
      .status(200)
      .json({ message: "Consulta atualizada com sucesso!", consulta });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};

// Deletar consulta
export const deletarConsultaController = async (req, res) => {
  try {
    await deletarConsulta(req.params.id);
    return res
      .status(200)
      .json({ message: "Consulta deletada com sucesso." });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
};
