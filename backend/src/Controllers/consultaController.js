import Consulta from '../models/consultaModel.js';

// Criar nova consulta
export const criarConsulta = async (req, res) => {
	try {
		const { userId, nomeConsulta, nomeProfissional, endereco, horario, data } = req.body;
		
		if(!userId || !data) {
			return res.status(400).json({ error: "Campos Obrigatórios" });
		}

		const novaConsulta = new Consulta({
			userId,
			nomeConsulta,
			nomeProfissional,
			endereco,
			horario,
			data
		});

		await novaConsulta.save();
		res.status({ message: "Consulta criada com sucesso" });

	} catch (error) {
		res.status(400).json({ error: "Erro ao criar Consulta" });
	}
};

// Listar todas as consultas
export const listarConsultas = async (req, res) => {
	try {
		const consultas = await Consulta.find();
		res.json(consultas);
	} catch (error) {
		res.status(500).json({ error: "Erro ao listar consultas" });
	}
};

// Buscar consulta por ID
export const buscarConsultaPorId = async (req, res) => {
	try {
		const consulta = await Consulta.findById(req.params.id);
		if (!consulta) return res.status(404).json({ error: 'Consulta não encontrada' });
		res.json(consulta);
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};

// Atualizar consulta
export const atualizarConsulta = async (req, res) => {
	try {
		const consulta = await Consulta.findByIdAndUpdate(req.params.id, req.body, { new: true });
		if (!consulta) return res.status(404).json({ error: 'Consulta não encontrada' });
		res.json(consulta);
	} catch (error) {
		res.status(400).json({ error: error.message });
	}
};

// Deletar consulta
export const deletarConsulta = async (req, res) => {
	try {
		const consulta = await Consulta.findByIdAndDelete(req.params.id);
		if (!consulta) return res.status(404).json({ error: 'Consulta não encontrada' });
		res.status(200).json({ message: 'Consulta deletada com sucesso' });
	} catch (error) {
		res.status(400).json({ error: "Falha ao deletar Consulta" });
	}
};
