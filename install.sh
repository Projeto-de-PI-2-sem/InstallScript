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
if [ "$get" = "s" ]; then # então
    # Verificando se o maquinário possui JRE Java
    java -version
    if [ $? = 0 ]; then
        echo "Maquinário já possui JRE Java"
    else
        sudo apt update
        sudo apt install openjdk-17-jre -y
    fi

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

    # Verificando se o maquinário possui Git
    git --version
    if [ $? = 0 ]; then
        echo "Maquinário já possui Git"
    else
        sudo apt-get install git-all -y
    fi
    
    mkdir assets
    cd assets

    # Clonar os repositórios Git
    git clone https://github.com/Projeto-de-PI-2-sem/Banco-De-Dados.git
    git clone https://github.com/Projeto-de-PI-2-sem/Notelog-Application.git

    cd Banco-De-Dados
    find . -type f ! -name 'BD-Notelog.sql' -exec rm -f {} +
    cd ..

    echo "FROM mysql:latest
    ENV MYSQL_DATABASE=notelog
    ENV MYSQL_USER=notelogUser
    ENV MYSQL_PASSWORD=notelikeag0d*
    ENV MYSQL_ROOT_PASSWORD=notelikeag0d*
    COPY ./Banco-De-Dados /docker-entrypoint-initdb.d/
    EXPOSE 3306" > Dockerfile
    

    cd Notelog-Application/target
    mv app-note-log-1.0-SNAPSHOT-jar-with-dependencies.jar ../..
    

    cd ../..
    sudo rm -rf Notelog-Application

    # Construir e rodar a imagem Docker   
    echo "Construindo a imagem Docker..."
    sudo docker build -t notelogbd .
    if [ $? -ne 0 ]; then
        echo "Erro ao construir a imagem Docker."
        exit 1
    fi

    # Parar e remover o contêiner antigo se existir
    if sudo docker ps -a | grep -q "notelog-container"; then
        echo "Parando e removendo o contêiner antigo..."
        sudo docker stop notelog-container
        sudo docker rm notelog-container
    fi

    # Executar um novo contêiner
    echo "Executando o contêiner Docker..."
    sudo docker run -d --name notelog-container -p 3306:3306 notelogbd
    if [ $? -ne 0 ]; then
        echo "Erro ao executar o contêiner Docker."
        exit 1
    fi
    cd ..

    # Criar o novo script e escrever o conteúdo nele
    echo "#!/bin/bash
    clear
    cd assets
    sudo java -jar app-note-log-1.0-SNAPSHOT-jar-with-dependencies.jar" > Notelog.sh

    # Tornar o novo script executável
    chmod 777 Notelog.sh

    echo "======================================================"
    echo "                 Instalação Finalizada                "
    echo "======================================================"
    cd assets
    find . -type f ! -name 'app-note-log-1.0-SNAPSHOT-jar-with-dependencies.jar' -exec rm -f {} +
    sudo rm -rf Banco-De-Dados
else
    echo "======================================================"
    echo "                 Instalação cancelada                 "
    echo "======================================================"
fi