# Use a imagem base do Node.js
FROM node:18

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o package.json e o package-lock.json para o diretório de trabalho
COPY package*.json ./

# Instale as dependências do projeto
RUN npm install

# Copie o restante do código da aplicação
COPY . .

# Exponha a porta que o IPFS vai usar e a porta do servidor Express
EXPOSE 6000

# Crie um volume compartilhado para o diretório "uploads"
VOLUME /uploads

# Comando para rodar a aplicação
CMD [ "node", "index.js" ]