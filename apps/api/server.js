const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { PrismaPg } = require('@prisma/adapter-pg');
const { Pool } = require('pg');
const cors = require('cors');
const bcrypt = require('bcrypt');

const app = express();

const connectionString = "postgresql://postgres:billy@localhost:5432/fluxa_db?schema=public";
const pool = new Pool({ connectionString });
const adapter = new PrismaPg(pool);

const prisma = new PrismaClient({ 
  adapter,
  log: ['query', 'info', 'warn', 'error'] 
});

app.use(cors()); 
app.use(express.json());

// ROTA DE LOGIN SEGURA E REFINADA
app.post('/login', async (req, res) => {
  // Normalização: e-mail sempre minúsculo e sem espaços nas pontas
  const email = req.body.email ? req.body.email.toLowerCase().trim() : null;
  const { password } = req.body;
  
  console.log(`\n--- Tentativa de Login: ${new Date().toLocaleString()} ---`);
  console.log(`📧 E-mail: ${email}`);

  if (!email || !password) {
    return res.status(400).json({ message: 'E-mail e senha são obrigatórios.' });
  }

  try {
    const user = await prisma.user.findUnique({ where: { email: email } });

    if (!user) {
      console.log("❌ Resultado: E-mail não encontrado no banco.");
      return res.status(401).json({ message: 'E-mail não cadastrado.' });
    }

    if (!user.is_active) {
      console.log("⚠️ Resultado: Tentativa em conta desativada.");
      return res.status(403).json({ message: 'Esta conta está desativada.' });
    }

    // Compara a senha digitada com o Hash do banco
    const senhaValida = await bcrypt.compare(password, user.password_hash);

    if (senhaValida) {
      console.log(`✅ Sucesso! Usuário: ${user.display_name} | ID: ${user.user_id}`);
      return res.status(200).json({
        message: 'Login realizado com sucesso!',
        user: { 
          id: user.user_id,
          nome: user.display_name, 
          cargo: user.role 
        }
      });
    } else {
      console.log("❌ Resultado: Senha incorreta.");
      return res.status(401).json({ message: 'Senha incorreta.' });
    }

  } catch (error) {
    console.error('🚨 Erro interno no servidor:', error);
    res.status(500).json({ message: 'Erro ao conectar com o banco de dados.' });
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`\n🚀 SERVIDOR FLUXA REFINADO: http://localhost:${PORT}`);
  console.log(`🔒 Segurança: Bcrypt + Normalização de E-mail ativada.`);
  console.log(`⏳ Aguardando interações...`);
});