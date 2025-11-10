import mongoose from 'mongoose';

const agendamentoSchema = new mongoose.Schema({

    userId: { type: mongoose.Schema.Types.ObjectId, ref:"User", required: true },
    nome: { type: String, required: true },
    tipoAgendamento: { type: String, enum: ["medicamento","consulta"], required: true },
    dataAgendamento: { type: Date, required: true },
    horarioAgendamento: { type: Date },
    referenceId: { type: mongoose.Schema.Types.ObjectId, refPath: "tipoAgendamento", required: true },
    notificacao: { type: Boolean, default: false },
    notificacaoDiaria: { type: Boolean, default: false }

}, { timestamps: true });

const Agendamento = mongoose.model('Agendamento', agendamentoSchema);
export default Agendamento;