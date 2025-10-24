import mongoose from 'mongoose';

const ConsultaSchema = new mongoose.Schema({
	userId: {type: mongoose.Schema.Types.ObjectId, refPath: "User"},
	nomeConsulta: { type: String, required: true },
	nomeProfissional: { type: String, required: true },
	endereco: { type: String, required: true },
	horario: { type: String, required: true },
	data: { type: Date, required: true }
});

const Consulta = mongoose.model('Consulta', ConsultaSchema);
export default Consulta;
