const express = require('express');
const sql = require('mssql');
const bodyParser = require('body-parser');
const cors = require('cors');
const nodemailer = require('nodemailer');
const path = require('path')
const fs = require('fs');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());
app.use(cors());

const dbConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: true,
    trustServerCertificate: true
  }
};

const connectDB = async () => {
  try {
    await sql.connect(dbConfig);
    console.log('Conexão com o SQL Server estabelecida.');
  } catch (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
  }
};

const transporter = nodemailer.createTransport({
  service: process.env.MAIL_SERVICE,
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_PASSWORD
  }
});

const emailTemplatePath = path.join(__dirname, 'recovery_email.html');

function getRecoveryEmail(username, resetCode) {
  let template = fs.readFileSync(emailTemplatePath, 'utf8'); // Lê o arquivo como string
  template = template.replace('{{username}}', username);    // Substitui {{username}}
  template = template.replace('{{resetCode}}', resetCode);  // Substitui {{resetCode}}
  return template;
}

app.post('/users/add', async (req, res) => {
    const { nome, sobrenome, email, data_nascimento, senha } = req.body;
  
    try {
      await sql.query`
        INSERT INTO usuarios (nome, sobrenome, email, data_nascimento, senha)
        VALUES (${nome}, ${sobrenome}, ${email}, ${data_nascimento}, ${senha})`;
  
      res.status(201).json({ message: 'Usuário cadastrado com sucesso!' });
    } catch (err) {
      console.error(err);
      if (err.originalError && err.originalError.info && err.originalError.info.number === 2627) {
        res.status(409).json({ error: 'Email já cadastrado.' });
      } else {
        res.status(500).json({ error: 'Erro ao cadastrar usuário.' });
      }
    }
  });

app.post('/login', async (req, res) => {
  const { email, senha } = req.body;

  try {
    const result = await sql.query`
      SELECT id, nome, sobrenome, email, data_nascimento 
      FROM usuarios 
      WHERE email = ${email} AND senha = ${senha}`;

    if (result.recordset.length > 0) {
      const user = result.recordset[0];
      res.json({
        id: user.id,
        nome: user.nome,
        sobrenome: user.sobrenome,
        email: user.email,
        data_nascimento: user.data_nascimento
      });
    } else {
      res.status(401).json({ message: 'Email ou senha inválidos' });
    }
  } catch (err) {
    res.status(500).json({ error: 'Erro ao realizar o login' });
  }
});

app.post('/password-recovery', async (req, res) => {
  const { email } = req.body;

  try {
    const result = await sql.query`
      EXEC GenerateResetCode @Email = ${email}`;

    if (result.recordset.length === 0) {
      return res.status(404).json({ error: 'Email não encontrado' });
    }
    const resetCode = result.recordset[0].ResetCode;
    const nome = result.recordset[0].Nome;

    const emailHtml = getRecoveryEmail(nome, resetCode);

    const mailOptions = {
      from: process.env.MAIL_USER,
      to: email,                           
      subject: 'Código de Recuperação de Senha', 
      html: emailHtml
    };

    await transporter.sendMail(mailOptions);

    res.status(200).json({ message: 'Código de recuperação enviado para o email.' });
  } catch (err) {
    console.error('Erro ao gerar código de recuperação ou enviar email:', err);
    res.status(500).json({ error: 'Erro ao processar a recuperação de senha' });
  }
});

app.post('/validate-code', async (req, res) => {
  const { email, resetCode } = req.body;

  try {
    const result = await sql.query`
      SELECT * FROM PasswordReset 
      WHERE UserEmail = ${email} AND ResetCode = ${resetCode} AND ExpiryTime > GETDATE()`;

    if (result.recordset.length === 0) {
      return res.status(400).json({ error: 'Código de recuperação inválido ou expirado' });
    }

    await sql.query`
      DELETE FROM PasswordReset
      WHERE UserEmail = ${email} AND ResetCode = ${resetCode}`;

    res.status(200).json({ message: 'Código de validação verificado com sucesso' });
  } catch (err) {
    console.error('Erro ao validar código:', err);
    res.status(500).json({ error: 'Erro ao validar código' });
  }
});

app.post('/reset-password', async (req, res) => {
  const { email, newPassword } = req.body;

  try {
    await sql.query`
      UPDATE usuarios
      SET senha = ${newPassword}
      WHERE email = ${email}`;

    res.status(200).json({ message: 'Senha redefinida com sucesso' });
  } catch (err) {
    console.error('Erro ao redefinir a senha:', err);
    res.status(500).json({ error: 'Erro ao redefinir a senha' });
  }
});

app.post('/favorites/add', async (req, res) => {
  const { idUsuario, idFilme } = req.body;

  if (!idUsuario || !idFilme) {
    return res.status(400).json({ error: 'ID do usuário e ID do filme são obrigatórios.' });
  }

  try {
    await sql.query`
      INSERT INTO FilmesFavoritos (IdUser, IdFilme)
      VALUES (${idUsuario}, ${idFilme})`;

    res.status(201).json({ message: 'Filme adicionado aos favoritos com sucesso!' });
  } catch (err) {
    console.error('Erro ao adicionar filme aos favoritos:', err);

    if (err.originalError && err.originalError.info && err.originalError.info.number === 2627) {
      res.status(409).json({ error: 'O filme já está nos favoritos do usuário.' });
    } else {
      res.status(500).json({ error: 'Erro ao adicionar filme aos favoritos.' });
    }
  }
});

app.get('/favorites/load/:idUsuario', async (req, res) => {
  const { idUsuario } = req.params;

  try {
    const result = await sql.query`
      SELECT IdFilme
      FROM FilmesFavoritos
      WHERE IdUser = ${idUsuario}`;
    res.status(200).json(result.recordset);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Erro ao listar filmes favoritos' });
  }
});

app.delete('/favorites/remove', async (req, res) => {
  const { idUsuario, idFilme } = req.body;

  if (!idUsuario || !idFilme) {
    return res.status(400).json({ error: 'ID do usuário e ID do filme são obrigatórios.' });
  }

  try {
    const result = await sql.query`
      DELETE FROM FilmesFavoritos 
      WHERE IdUser = ${idUsuario} AND IdFilme = ${idFilme}`;

    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: 'Filme não encontrado nos favoritos do usuário.' });
    }

    res.status(200).json({ message: 'Filme removido dos favoritos com sucesso!' });
  } catch (err) {
    console.error('Erro ao remover filme dos favoritos:', err);

    res.status(500).json({ error: 'Erro ao remover filme dos favoritos.' });
  }
});


app.get('/favorites/check', async (req, res) => {
  const userId = parseInt(req.query.userId);
  const movieId = parseInt(req.query.movieId);

  if (isNaN(userId) || isNaN(movieId)) {
    return res.status(400).json({ error: 'Os parâmetros userId e movieId devem ser números válidos.' });
  }

  try {
    const isFavorite = await checkIfMovieIsFavorite(userId, movieId);

    if (isFavorite) {
      res.status(200).json({ isFavorite: true });
    } else {
      res.status(200).json({ isFavorite: false });
    }
  } catch (error) {
    res.status(500).json({ message: 'Erro ao verificar favoritos.', error: error.message });
  }
});



async function checkIfMovieIsFavorite(userId, movieId) {
  try {
    const result = await sql.query`
      SELECT COUNT(*) AS isFavorite 
      FROM FilmesFavoritos 
      WHERE IdUser = ${userId} AND IdFilme = ${movieId}`;
    
    return result.recordset[0].isFavorite > 0;
  } catch (error) {
    throw new Error('Erro ao consultar banco de dados: ' + error.message);
  }
}

connectDB();

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});