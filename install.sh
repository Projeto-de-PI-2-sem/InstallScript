#!/bin/bash
echo " __    _  _______  _______  _______  ___      _______  _______ "
echo "|  |  | ||       ||       ||       ||   |    |       ||       |"
echo "|   |_| ||   _   ||_     _||    ___||   |    |   _   ||    ___|"
echo "|       ||  | |  |  |   |  |   |___ |   |    |  | |  ||   | __ "
echo "|  _    ||  |_|  |  |   |  |    ___||   |___ |  |_|  ||   ||  |"
echo "| | |   ||       |  |   |  |   |___ |       ||       ||   |_| |"
echo "|_|  |__||_______|  |___|  |_______||_______||_______||_______|"
echo ""

echo "======================================================"
echo "Bem vindo ao instalador NoteLog"
echo "Gostaria de prosseguir para instalação de todas as dependências de nossos serviços? [s/n]"
echo "======================================================"

read get
if [ "$get" = "s" ]; then
    # Verificando se o Docker está instalado
    docker -v
    if [ $? -eq 0 ]; then
        echo "Maquinário já possui DockerEngine"
    else
        # Adicionando o repositório Docker
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
        echo "Para aplicar as permissões do Docker, é necessário fazer logout e login novamente."
        exit 1
    fi

    # Parar e remover o contêiner MySQL antigo se existir
    if sudo docker ps -a | grep -q "mysql-notelog"; then
        echo "Parando e removendo o contêiner MySQL antigo..."
        sudo docker stop mysql-notelog
        sudo docker rm mysql-notelog
    fi

    # Executar um novo contêiner MySQL
    echo "Executando o contêiner MySQL..."
    sudo docker run -d --name mysql-notelog -p 3306:3306 zeeeu/mysql-notelog:latest
    if [ $? -ne 0 ]; then
        echo "Erro ao executar o contêiner MySQL."
        exit 1
    fi

    # Criar o script para iniciar o contêiner do aplicativo
    cat << 'EOF' > Notelog.sh
#!/bin/bash
clear
docker run -it --rm --name notelog-start --network host zeeeu/notelog-jar:17
EOF

    # Tornar o novo script executável
    chmod +x Notelog.sh

    echo "======================================================"
    echo "                 Instalação Finalizada                "
    echo "======================================================"
else
    echo "======================================================"
    echo "                 Instalação cancelada                 "
    echo "======================================================"
fi