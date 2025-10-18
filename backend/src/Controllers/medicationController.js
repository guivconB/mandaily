
import Medication from '../models/medicationModel.js';

// Criar medicamento
export const createMedication = async (req, res) => {
	try {
		const medication = new Medication(req.body);
		await medication.save();
		res.status(201).json(medication);
	} catch (error) {
		res.status(400).json({ error: error.message });
	}
};

// Listar todos medicamentos
export const getAllMedications = async (req, res) => {
	try {
		const medications = await Medication.find();
		res.json(medications);
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};

// Buscar medicamento por ID
export const getMedicationById = async (req, res) => {
	try {
		const medication = await Medication.findById(req.params.id);
		if (!medication) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json(medication);
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};

// Atualizar medicamento
export const updateMedication = async (req, res) => {
	try {
		const medication = await Medication.findByIdAndUpdate(req.params.id, req.body, { new: true });
		if (!medication) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json(medication);
	} catch (error) {
		res.status(400).json({ error: error.message });
	}
};

// Deletar medicamento
export const deleteMedication = async (req, res) => {
	try {
		const medication = await Medication.findByIdAndDelete(req.params.id);
		if (!medication) return res.status(404).json({ error: 'Medicamento não encontrado' });
		res.json({ message: 'Medicamento deletado com sucesso' });
	} catch (error) {
		res.status(500).json({ error: error.message });
	}
};
