# Use a imagem base do Node.js
FROM node:14

# Defina o diretório de trabalho dentro do container
WORKDIR /usr/src/app

# Copie o package.json e o package-lock.json para o diretório de trabalho
COPY package*.json ./

# Instale as dependências do projeto
RUN npm install

# Copie o restante do código da aplicação
COPY . .

# Exponha a porta que o IPFS vai usar e a porta do servidor Express
EXPOSE 4002
EXPOSE 4000

# Crie um volume compartilhado para o diretório "uploads"
VOLUME /uploads

# Comando para rodar a aplicação
CMD [ "node", "index.js" ]




