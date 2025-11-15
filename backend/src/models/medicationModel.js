import mongoose from 'mongoose';

const MedicationSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref:"User", required: true },
  nome: { type: String, required: true },
  tipo: { type: String, enum ["Comprimido", "Líquido", "Pomada", "Gota", "Injeção"] required: true }, // comprimido, cápsula, etc.
  dose: { type: Number},
  horarioInicio: { type: String, required: true, match: [/^\d{2}:\d{2}$/, "Formato inválido. Use HH:MM (ex: 08:00)"] },
  dataInicio: { type: Date, required: true },
  dias: { type: String, required: true }, // diário, semanal, etc.
  frequencia: { type: String, required: true }, // Ex: '6 horas'
  numeroDias: { type: Number, required: true },
  notificacaoDiaria: { type: Boolean }
});

const Medication = mongoose.model('Medication', MedicationSchema);
export default Medication;
