import Consulta from "../models/appointmentModel.js";

// Criar nova consulta
export const criarConsulta = async (dados) => {
  const { userId, nomeConsulta, nomeProfissional, endereco, horario, data } = dados;

  if (!userId || !data) {
    throw new Error("Campos obrigatórios não preenchidos.");
  }

  const novaConsulta = new Consulta({
    userId,
    nomeConsulta,
    nomeProfissional,
    endereco,
    horario,
    data,
  });

  await novaConsulta.save();
  return novaConsulta;
};

// Listar todas as consultas
export const listarConsultas = async () => {
  const consultas = await Consulta.find();
  return consultas;
};

// Buscar consulta por ID
export const buscarConsultaPorId = async (id) => {
  const consulta = await Consulta.findById(id);
  if (!consulta) {
    throw new Error("Consulta não encontrada.");
  }
  return consulta;
};

// Atualizar consulta
export const atualizarConsulta = async (id, dados) => {
  const consulta = await Consulta.findByIdAndUpdate(id, dados, { new: true });
  if (!consulta) {
    throw new Error("Consulta não encontrada.");
  }
  return consulta;
};

// Deletar consulta
export const deletarConsulta = async (id) => {
  const consulta = await Consulta.findByIdAndDelete(id);
  if (!consulta) {
    throw new Error("Consulta não encontrada.");
  }
  return consulta;
};
