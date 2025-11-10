import { criarMedicamento, listarMedicamentos , listarMedicamentoPorId, atualizarMedicamento, deletarMedicamento } from '../services/medicationService.js'; 

// Criar medicamento
export const novoMedicamentoController = async (req, res) => {
  try {
    const novoMedicamento = await criarMedicamento(req.body);

    res.status(201).json({ message: "Medicamento criado com sucesso!", medicamento: novoMedicamento });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};


// Listar todos medicamentos
export const listarMedicamentosController = async (req, res) => {
	try {
		const Medicamentos = await listarMedicamentos();
		res.json(Medicamentos);
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};

// Buscar medicamento por ID
export const listarMedicamentoPorIdController = async (req, res) => {
	try {
		const Medicamento = await listarMedicamentoPorId(req.params.id);
		if (!Medicamento) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json(Medicamento);
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};

// Atualizar medicamento
export const atualizarMedicamentoController = async (req, res) => {
	try {
		const Medicamento = await atualizarMedicamento(req.params.id, req.body, { new: true });
		if (!Medicamento) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json(Medicamento);
	} catch (error) {
		res.status(400).json({ error: error.message });
	}
};

// Deletar medicamento
export const deletarMedicamentoController = async (req, res) => {
	try {
		const Medicamento = await deletarMedicamento(req.params.id);
		if (!Medicamento) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json({ message: 'Medicamento deletado com sucesso' });
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};
