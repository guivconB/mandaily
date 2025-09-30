// models/informacoes.js
import mongoose from "mongoose";

const informacoesSchema = new mongoose.Schema(
  {
    email: { type: String, required: true, unique: true },
    nome: { type: String, required: true },
    senha: { type: String, required: true },
    dataNascimento: { type: Date, required: true },
  },
  { versionKey: false } // remove o __v do documento
);

const informacoes = mongoose.model("informacoes", informacoesSchema);

export default informacoes;
