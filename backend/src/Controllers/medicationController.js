
import Medicamento from '../models/medicationModel.js';

// Criar medicamento
export const novoMedicamento = async (req, res) => {
	try {
		const { nome, tipo, dose, horarioInicio, dataInicio, dias, frequencia, numeroDias} = (req.body);
		const novoMedicamento = new Medicamento ({
			nome,
			tipo,
			dose,
			horarioInicio,
			dataInicio,
			dias,
			frequencia,
			numeroDias
		});

		await novoMedicamento.save();
		res.status(201).json(novoMedicamento);

		} catch (error) {
		res.status(400).json({ error: error.message });
	}
}


// Listar todos medicamentos
export const listarMedicamentos = async (req, res) => {
	try {
		const Medicamentos = await Medicamento.find();
		res.json(Medicamentos);
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};

// Buscar medicamento por ID
export const listarMedicamentosPorId = async (req, res) => {
	try {
		const Medicamento = await Medicamento.findById(req.params.id);
		if (!Medicamento) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json(Medicamento);
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};

// Atualizar medicamento
export const atualizarMedicamento = async (req, res) => {
	try {
		const Medicamento = await Medicamento.findByIdAndUpdate(req.params.id, req.body, { new: true });
		if (!Medicamento) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json(Medicamento);
	} catch (error) {
		res.status(400).json({ error: error.message });
	}
};

// Deletar medicamento
export const deletarMedicamento = async (req, res) => {
	try {
		const Medicamento = await Medicamento.findByIdAndDelete(req.params.id);
		if (!Medicamento) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json({ message: 'Medicamento deletado com sucesso' });
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};
