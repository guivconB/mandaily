import mongoose from 'mongoose';

const MedicationSchema = new mongoose.Schema({
  nome: { type: String, required: true },
  tipo: { type: String, required: true }, // comprimido, cápsula, etc.
  dose: { type: Number, required: true },
  horarioInicio: { type: String, required: true }, // Ex: '08:00'
  dataInicio: { type: Date, required: true },
  dias: { type: String, required: true }, // diário, semanal, etc.
  frequencia: { type: String, required: true }, // Ex: '6 horas'
  numeroDias: { type: Number, required: true }
});

const Medication = mongoose.model('Medication', MedicationSchema);
export default Medication;
