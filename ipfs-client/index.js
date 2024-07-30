import express from 'express';
import { create } from 'ipfs-http-client';
import multer from 'multer';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import pg from 'pg';
import bodyParser from 'body-parser';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const port = 6000; // Porta do seu servidor Express

// Configuração do multer para upload de arquivos
const upload = multer({ dest: 'uploads/' });

// Configuração do PostgreSQL
const { Pool } = pg;
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

// Conectar ao IPFS existente
const ipfs = create({ url: process.env.IPFS_API_URL || 'http://localhost:5001' });

//const ipfs = create({ url: 'http://127.0.0.1:5001' });

// Configurar body-parser
app.use(bodyParser.json());

// Função para verificar se o arquivo está pinado
const checkFilePinned = async (hash) => {
    try {
        // Obter a lista de arquivos pinados
        const pinnedFiles = [];
        for await (const file of ipfs.pin.ls()) {
            pinnedFiles.push(file.cid.toString());
        }

        // Verificar se o hash está na lista de arquivos pinados
        return pinnedFiles.includes(hash);
    } catch (error) {
        throw new Error(`Erro ao verificar se o arquivo está pinado: ${error.message}`);
    }
};

// Função para listar todos os arquivos pinados no IPFS
const listPinnedFiles = async () => {
    try {
        const pinnedFiles = [];
        for await (const file of ipfs.pin.ls()) {
            pinnedFiles.push(file.cid.toString());
        }
        return pinnedFiles;
    } catch (error) {
        throw new Error(`Erro ao listar arquivos pinados: ${error.message}`);
    }
};

// Função para buscar metadados do banco de dados
const getMetadata = async (hash) => {
    try {
        const result = await pool.query('SELECT metadata FROM file_metadata WHERE hash = $1', [hash]);
        return result.rows[0]?.metadata || null;
    } catch (error) {
        throw new Error(`Erro ao buscar metadados: ${error.message}`);
    }
};


// Função para adicionar metadados ao banco de dados
const addMetadata = async (hash, metadata) => {
    try {
        const filecid  = await ipfs.add(JSON.stringify(metadata));
        await pool.query(
            'INSERT INTO file_metadata (hash, metadata, filecid) VALUES ($1, $2, $3) ON CONFLICT (hash) DO UPDATE SET metadata = $2',
            [hash, metadata, filecid.path]
        );
        return `ipfs://${filecid.path.toString()}`;
    } catch (error) {
        throw new Error(`Erro ao adicionar metadados: ${error.message}`);
    }
};

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

// Endpoint para listar todos os arquivos pinados
app.get('/files', async (req, res) => {
    try {
        const pinnedFiles = await listPinnedFiles();

        if (pinnedFiles.length === 0) {
            // Retornar resposta vazia se nenhum arquivo estiver pinado
            return res.status(204).send();
        }

        res.json(pinnedFiles);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para fazer upload de arquivos
app.post('/upload', authenticateToken, upload.single('file'), async (req, res) => {
    try {
        const file = req.file;
        const filePath = path.join(__dirname, file.path);
        const fileBuffer = fs.readFileSync(filePath);

        const result = await ipfs.add(fileBuffer);

        // Deletar o arquivo local depois do upload para IPFS
        fs.unlinkSync(filePath);

        // Calcular o tamanho do arquivo em kilobytes
        const sizeInKilobytes = (result.size / 1024).toFixed(2);

        // Retornar o CID do arquivo no IPFS
        res.json({
            cid: `ipfs://${result.path}`, // CID do arquivo no IPFS
            size: sizeInKilobytes, // Tamanho do arquivo em kilobytes
            success: true
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para buscar arquivos no IPFS
app.get('/fetch/:hash', authenticateToken, async (req, res) => {
    try {
        const hash = req.params.hash;

        // Verificar se o arquivo está pinado
        const isPinned = await checkFilePinned(hash);

        if (!isPinned) {
            return res.status(404).json({ message: `Arquivo com hash ${hash} não está mais pinado e não está disponível no IPFS.` });
        }

        // Se o arquivo está pinado, buscar o conteúdo
        const stream = ipfs.cat(hash);
        let data = [];

        for await (const chunk of stream) {
            data.push(chunk);
        }

        res.send(Buffer.concat(data).toString());
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para excluir arquivos do IPFS e remover metadados
app.delete('/delete/:hash', authenticateToken, async (req, res) => {
    try {
        const hash = req.params.hash;
        const result = await pool.query('SELECT hash, filecid FROM file_metadata WHERE hash = $1', [hash]);
        const filecid = result.rows[0]?.filecid;

        await ipfs.pin.rm(hash);
        
        // Remover metadados associados ao arquivo
        await ipfs.pin.rm(filecid);
        await pool.query('DELETE FROM file_metadata WHERE filecid = $1', [filecid]);

        res.status(200).json({ message: `Arquivo com hash excluído do IPFS e metadados removidos.` });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para excluir arquivos do IPFS e remover metadados pelo metadado
app.delete('/metadata/:filecid', authenticateToken, async (req, res) => {
    try {
        const filecid = req.params.filecid;
        const result = await pool.query('SELECT hash,filecid FROM file_metadata WHERE filecid = $1', [filecid]);
        const hash = result.rows[0]?.hash;

        await ipfs.pin.rm(filecid);
        await ipfs.pin.rm(hash);

        await pool.query('DELETE FROM file_metadata WHERE filecid = $1', [filecid]);

        res.status(200).json({ message: `Arquivo com filecid excluído do IPFS.` });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para incluir metadados
app.post('/upload-metadata', authenticateToken, async (req, res) => {
    try {
        const metadata = req.body;

        if (!metadata) {
            return res.status(400).json({ message: 'URL do IPFS e metadados são necessários.' });
        }

        // Extrair o hash da URL do IPFS
        const hashMatch = metadata.image.match(/^ipfs:\/\/(.+)$/);

        if (!hashMatch) {
            return res.status(400).json({ message: 'URL do IPFS inválida. Deve estar no formato ipfs://hash.' });
        }

        const hash = hashMatch[1];

        // Adicionar metadados ao banco de dados
        const tokenURI = await addMetadata(hash, metadata);

        res.status(200).json({tokenURI});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Endpoint para buscar metadados
app.get('/metadata/:hash', authenticateToken, async (req, res) => {
    try {
        const hash = req.params.hash;

        // Buscar metadados do banco de dados
        const metadata = await getMetadata(hash);

        if (!metadata) {
            return res.status(404).json({ message: `Metadados para o hash ${hash} não encontrados.` });
        }

        res.json(metadata);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Iniciar o servidor
app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});
