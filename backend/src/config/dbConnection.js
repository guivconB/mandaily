import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config(); // <-- Carrega as variáveis do .env

async function conectaNaDatabase() {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("Conexão com o banco de dados realizada com sucesso!");
  } catch (error) {
    console.error("Erro ao conectar ao banco de dados:", error);
    process.exit(1);
  }
  return mongoose.connection;
}

export default conectaNaDatabase;
