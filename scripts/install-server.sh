#!/bin/bash

set -e

echo "=========================================="
echo "Script de Instalacao - Oracle Cloud Server"
echo "Git, Docker e Docker Compose"
echo "=========================================="
echo ""

if [ "$EUID" -eq 0 ]; then
   echo "ERRO: Nao execute este script como root/sudo"
   echo "Execute como usuario normal (o script pedira sudo quando necessario)"
   exit 1
fi

echo "[1/5] Verificando sistema operacional..."
if [ -f /etc/oracle-release ]; then
    OS="oracle"
    echo "   Sistema detectado: Oracle Linux"
elif [ -f /etc/redhat-release ]; then
    OS="rhel"
    echo "   Sistema detectado: Red Hat / CentOS"
elif [ -f /etc/debian_version ]; then
    OS="debian"
    echo "   Sistema detectado: Debian / Ubuntu"
else
    OS="unknown"
    echo "   AVISO: Sistema nao reconhecido, tentando Oracle Linux"
fi

echo ""
echo "[2/5] Instalando Git..."
if command -v git &> /dev/null; then
    echo "   Git ja esta instalado: $(git --version)"
else
    echo "   Instalando Git..."
    if [ "$OS" = "oracle" ] || [ "$OS" = "rhel" ]; then
        sudo yum update -y
        sudo yum install -y git
    elif [ "$OS" = "debian" ]; then
        sudo apt-get update
        sudo apt-get install -y git
    else
        echo "   ERRO: Nao foi possivel determinar o gerenciador de pacotes"
        exit 1
    fi
    echo "   Git instalado: $(git --version)"
fi

echo ""
echo "[3/5] Instalando Docker..."
if command -v docker &> /dev/null; then
    echo "   Docker ja esta instalado: $(docker --version)"
else
    echo "   Instalando Docker..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    sudo usermod -aG docker "$USER"
    rm -f /tmp/get-docker.sh
    echo "   Docker instalado: $(docker --version)"
    echo "   IMPORTANTE: Voce precisa fazer logout e login novamente"
    echo "   ou executar: newgrp docker"
fi

echo ""
echo "[4/5] Instalando Docker Compose..."
if command -v docker compose &> /dev/null || command -v docker-compose &> /dev/null; then
    if command -v docker compose &> /dev/null; then
        echo "   Docker Compose ja esta instalado: $(docker compose version)"
    else
        echo "   Docker Compose ja esta instalado: $(docker-compose --version)"
    fi
else
    echo "   Instalando Docker Compose..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "   Docker Compose instalado"
fi

echo ""
echo "[5/5] Verificando instalacoes..."
echo "   Git: $(git --version)"
echo "   Docker: $(docker --version)"
if command -v docker compose &> /dev/null; then
    echo "   Docker Compose: $(docker compose version)"
else
    echo "   Docker Compose: $(docker-compose --version)"
fi

echo ""
echo "=========================================="
echo "Instalacao concluida!"
echo "=========================================="
echo ""
echo "IMPORTANTE: Se o Docker foi instalado agora, execute:"
echo "  newgrp docker"
echo ""
echo "Ou faca logout e login novamente para que as"
echo "permissoes do grupo docker sejam aplicadas."
echo ""
echo "Depois, teste com:"
echo "  docker ps"
echo "  docker compose version"
echo ""

