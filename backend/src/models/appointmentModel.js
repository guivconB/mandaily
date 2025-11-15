import mongoose from 'mongoose';

const ConsultaSchema = new mongoose.Schema({
	userId: { type: mongoose.Schema.Types.ObjectId, refPath: "User", required: true },
	nomeConsulta: { type: String, required: true },
	nomeProfissional: { type: String },
	endereco: { type: String },
	horario: { type: String },
	data: { type: Date, required: true }
});

const Consulta = mongoose.model('Consulta', ConsultaSchema);
export default Consulta;
