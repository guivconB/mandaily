import Medicamento from '../models/medicationModel.js';
import { agendarNotificacaoDiaria } from '../services/notificationService.js';

export const criarMedicamento = async (dados) => {// ✨ CORREÇÃO AQUI: Mudamos 'userId' para 'user' para corresponder ao que o front-end envia.
    const { user, nome, tipo, dose, horarioInicio, dataInicio, notificacaoDiaria, dias, frequencia, numeroDias } = dados;

    const novoMedicamento = new Medicamento({
        user, // Agora a referência ao usuário será salva corretamente.
        nome,
        tipo,
        dose,
        horarioInicio,
        dataInicio,
        notificacaoDiaria,
        dias,
        frequencia,
        numeroDias
    });

    if (notificacaoDiaria) {
        agendarNotificacaoDiaria(novoMedicamento);
    }

    await novoMedicamento.save();
    return novoMedicamento;
};

// Listar todos medicamentos
export const listarMedicamentos = async () => {
    const medicamentos = await Medicamento.find();
    return medicamentos;
};

// Buscar medicamento por ID
export const listarMedicamentoPorId = async (id) => {
    const medicamento = await Medicamento.findById(id);
    if (!medicamento) {
        throw new Error('Medicamento não encontrado');
    }
    return medicamento;
};

// Atualizar medicamento
export const atualizarMedicamento = async (id, dados) => {
    const medicamento = await Medicamento.findByIdAndUpdate(id, dados, { new: true });
    if (!medicamento) {
        throw new Error('Medicamento não encontrado');
    }
    return medicamento;
};

// Deletar medicamento
export const deletarMedicamento = async (id) => {
    const medicamento = await Medicamento.findByIdAndDelete(id);
    if (!medicamento) {
        throw new Error('Medicamento não encontrado');
    }
    return medicamento;
};