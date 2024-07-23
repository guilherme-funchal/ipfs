# Instalação dos IPFS Client e Server

## Crie um Banco de dados Postgres e importe as tabelas do diretório BD
Pode ser usado o comando pg_restore em banco de dados existente conforme abaixo : 

```
pg_restore -U postgres -d srv -v backup.dump
```
## Ajustes nos arquivos de configuração 

### IPFS Client

Ajustar o .env no diretório ipfs-client conforme abaixo :

```
DB_USER=Usuário do Postgres
DB_HOST=Endereço do banco
DB_DATABASE=Nome do banco de dados
DB_PASSWORD=Senha
DB_PORT=Porta
```

### IPFS Server

1)Ajustar o .env no diretório ipfs-server conforme abaixo :

```
IPFS_DATA_PATH=./ipfs_data
IPFS_STAGING_PATH=./ipfs_staging
SWARM_KEY_PATH=./swarm.key
```
2)Ajustar quais os endereços que o Servidor vai aceitar conexões
No arquivo Dockerfile do diretório ipfs-server  ajustar o endereço abaixo:

```
# Configure o IPFS para escutar no endereço 127.0.0.1 na porta 5001
RUN ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
```

Onde "0.0.0.0" é aceitar em qualquer endereço

## Gerar todos os conteiners
Executar o comando abaixo : 

```
docker-compose up --build
```

## Testar as chamadas de API

1)Importar no Insomnia o arquivo da pasta insomnia
2)Na autenticação é necessário passar como Token Bearer os endereço de wallet contidos na tabela "tokens"
