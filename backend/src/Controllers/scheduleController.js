import Agendamento from '../models/scheduleModel.js';

export const criarAgendamento = async (req, res) => {
    try {
        const {nome, tipoAgendamento, dataAgendamento, horarioAgendamento, notificacao, notificacaoDiaria} = req.body;

        if (!nome || nome.trim() === "") {
            return res.status(400).json({message: "Nome do Agendamento obrigatório" });
        };

        if (!dataAgendamento) {
            return res.status(400).json({ message: "Data Obrigatória!" });
        };

        const novoAgendamento = new Agendamento ({
            nome,
            tipoAgendamento,
            dataAgendamento,
            horarioAgendamento,
            notificacao: notificacao ?? false,
            notificacaoDiaria: notificacaoDiaria ?? false,
        });
        
        await novoAgendamento.save();
        res.status(200).json({message: "Agendamento criado com sucesso"});
    


    } catch(error) {
        res.status(500).json({message: "Erro ao criar agendamento"});
    }
}