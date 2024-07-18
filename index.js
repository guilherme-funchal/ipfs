const IPFS = require('ipfs-core');
const express = require('express');
const multer = require('multer');
const bodyParser = require('body-parser');
const fs = require('fs');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');
require("dotenv").config();
const app = express();
const upload = multer({ dest: 'uploads/' });
const os = require('os');
const path = require('path');
app.use(bodyParser.json());

// Configuração da conexão com o banco de dados PostgreSQL
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

// Função para ler a chave secreta do arquivo
function getSecretKey() {
  return fs.readFileSync('secretKey.txt', 'utf8').trim();
}

// Inicialização do Cliente IPFS
let ipfsClient;
async function initIPFSClient() {
  if (!ipfsClient) {
    const repoPath = path.join(os.tmpdir(), `ipfs-repo-${Math.random()}`);
    ipfsClient = await IPFS.create({
      repo: repoPath,
      config: {
        Addresses: {
          Swarm: [
            '/ip4/0.0.0.0/tcp/0',
            '/ip4/127.0.0.1/tcp/0/ws'
          ],
          API: '/ip4/127.0.0.1/tcp/0',
          Gateway: '/ip4/127.0.0.1/tcp/0'
        }
      }
    });
  }
}

// Função para obter metadados do IPFS
async function getMetadata(cid) {
  await initIPFSClient();
  const stream = ipfsClient.cat(cid);
  let data = '';
  for await (const chunk of stream) {
    data += chunk.toString();
  }
  return JSON.parse(data);
}

// Função para fazer upload de metadados para o IPFS
async function uploadMetadata(metadata) {
  await initIPFSClient();
  const { cid } = await ipfsClient.add(JSON.stringify(metadata));
  return `ipfs://${cid.toString()}`;
}

// Função para carregar tokens autorizados do banco de dados
async function loadAuthorizedTokens() {
  const res = await pool.query('SELECT token FROM tokens');
  return res.rows.map(row => row.token);
}

// Middleware para verificar o token em todas as rotas
async function authenticateToken(req, res, next) {
  const token = req.headers['authorization']?.split(' ')[1];
  const authorizedTokens = await loadAuthorizedTokens();

  if (!token || !authorizedTokens.includes(token)) {
    return res.sendStatus(401); // Unauthorized
  }
  next();
}

async function startIpfs() {
  const ipfs = await IPFS.create();
  console.log('IPFS node is ready');
  const { id } = await ipfs.id();
  console.log('Node ID:', id);

  // Rota protegida para adicionar arquivo ao IPFS
  app.post('/upload-metadata', authenticateToken, async (req, res) => {
    const metadata = req.body;
    try {
      const tokenURI = await uploadMetadata(metadata);
      res.status(200).json({ message: 'Metadados carregados com sucesso!', tokenURI });
    } catch (error) {
      console.error('Erro ao carregar metadados para o IPFS:', error);
      res.status(500).json({ error: 'Erro ao carregar metadados para o IPFS' });
    }

  });

  app.get('/metadata/:cid', async (req, res) => {
    const { cid } = req.params;

    try {
      const metadata = await getMetadata(cid);
      res.status(200).json(metadata);
    } catch (error) {
      console.error('Erro ao obter metadados do IPFS:', error);
      res.status(500).json({ error: 'Erro ao obter metadados do IPFS' });
    }
  });

  app.post('/upload', authenticateToken, upload.single('file'), async (req, res) => {
    const filePath = req.file.path;
    const file = await fs.promises.readFile(filePath);
    const result = await ipfs.add(file);

    res.send({ cid: result.path });
  });

  // Rota protegida para recuperar arquivo do IPFS
  app.get('/file/:cid', authenticateToken, async (req, res) => {
    const { cid } = req.params;
    const stream = ipfs.cat(cid);

    let data = '';
    for await (const chunk of stream) {
      data += chunk.toString();
    }

    res.send(data);
  });

  // Rota protegida para remover arquivo do IPFS
  app.post('/delete', async (req, res) => {
    try {
      const { cid } = req.body;
      let fileExists = false;

      // Verifica se o arquivo existe no IPFS
      for await (const file of ipfs.pin.ls()) {
        if (file.cid.toString() === cid) {
          fileExists = true;
          break;
        }
      }

      if (!fileExists) {
        return res.status(404).send({ message: 'Arquivo não encontrado' });
      }

      // Remove o arquivo do IPFS
      await ipfs.pin.rm(cid);
      await ipfs.repo.gc();
      res.send({ message: 'Arquivo e metadado excluido com sucesso' });
    } catch (err) {
      res.status(500).send(err.toString());
    }
  });
  // Rota protegida para listar todos os arquivos no IPFS
  app.get('/files', authenticateToken, async (req, res) => {
    const pins = await ipfs.pin.ls();
    const files = [];
    for await (const { cid, type } of pins) {
      if (type === 'recursive') {
        files.push(cid.toString());
      }
    }
    res.send({ files });
  });

  app.listen(4000, () => {
    console.log('Servidor rodando na porta 4000');
  });
}

startIpfs().catch(err => {
  console.error('Erro de inicio no IPFS:', err);
});


