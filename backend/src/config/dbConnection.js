import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config();

async function conectaNaDatabase() {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log("✅ Conectado ao MongoDB Atlas com sucesso!");
  } catch (error) {
    console.error("❌ Erro ao conectar ao banco:", error.message);
    process.exit(1);
  }
}

export default conectaNaDatabase;
