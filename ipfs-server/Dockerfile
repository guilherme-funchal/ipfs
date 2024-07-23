# Use uma imagem base do Ubuntu
FROM ubuntu:20.04

# Instale dependências e o IPFS (Kubo)
RUN apt-get update && \
    apt-get install -y wget tar && \
    wget https://dist.ipfs.tech/kubo/v0.18.1/kubo_v0.18.1_linux-amd64.tar.gz && \
    tar -xvzf kubo_v0.18.1_linux-amd64.tar.gz && \
    cd kubo && \
    ./install.sh

# Crie diretório para o IPFS e adicione a chave swarm
RUN mkdir -p /data/ipfs
COPY swarm.key /data/ipfs/swarm.key

# Defina o diretório de trabalho e inicialize o IPFS
WORKDIR /data/ipfs
RUN ipfs init

# Configure o IPFS para escutar no endereço 127.0.0.1 na porta 5001
RUN ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
RUN ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

# Exponha as portas padrão
EXPOSE 4001 5001 8080

# Defina o comando para iniciar o IPFS
CMD ["ipfs", "daemon", "--enable-pubsub-experiment"]

