import mongoose from "mongoose";

async function conectaNaDatabase() {
  try {
    // Conecta usando a variável de ambiente MONGODB_URI (ainda precisa colocar no arquivo .env na raiz do projeto)
    await mongoose.connect(process.env.MONGODB_URI,//colocar a string de conexão do MongoDB aqui
      {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log("Conexão com o banco de dados realizada com sucesso!");
  } catch (error) {
    console.error("Erro ao conectar ao banco de dados:", error);
    process.exit(1); // Encerra a aplicação em caso de falha
  }

  return mongoose.connection;
}

export default conectaNaDatabase;
