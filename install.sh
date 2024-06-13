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
    # Verificando se o maquinário possui Docker
    docker -v
    if [ $? = 0 ]; then
        echo "Maquinário já possui DockerEngine"
    else
       # Add Docker's official GPG key:
        sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update

        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
        echo "Para aplicar as permissões do Docker, é necessário fazer logout e login novamente."
        exit 1
    fi

    # Construir e rodar a imagem Docker   
    echo "Instalando container Jar..."
    sudo docker pull zeeeu/mysql-notelog:5.7
    if [ $? -ne 0 ]; then
        echo "Erro ao instalar imagem Docker."
        exit 1
    fi 

    # Parar e remover o contêiner antigo se existir
    if sudo docker ps -a | grep -q "mysql-notelog"; then
        echo "Parando e removendo o contêiner antigo..."
        sudo docker stop mysql-notelog
        sudo docker rm mysql-notelog
    fi

    # Executar um novo contêiner
    echo "Executando o contêiner Docker..."
    sudo docker run -d --name mysql-notelog -p 3306:3306 zeeeu/mysql-notelog:5.7 
    if [ $? -ne 0 ]; then
        echo "Erro ao executar o contêiner Docker."
        exit 1
    fi

    # Criar o novo script e escrever o conteúdo nele
    echo "#!/bin/bash
    clear
    docker run -it --name notelog-start --net host zeeeu/notelog-jar:17" > Notelog.sh

    # Tornar o novo script executável
    chmod 777 Notelog.sh

    echo "======================================================"
    echo "                 Instalação Finalizada                "
    echo "======================================================"
else
    echo "======================================================"
    echo "                 Instalação cancelada                 "
    echo "======================================================"
fi