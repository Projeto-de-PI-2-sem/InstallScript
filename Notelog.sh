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
echo “Bem vindo ao instalador NoteLog”
echo “Gostaria de prosseguir para instalação de todas as dependencias de nossos serviços? [s/n]”
echo "======================================================"

read get
if [ \“$get\” == \“s\” ]; then #entao
    #Verificando se maquinário possui JRE Java
    java -version
    if [ $? = 0 ]; then
        echo “Maquinario já possui JRE Java”
    else
        sudo apt install openjdk-17-jre -y
    fi

    #Verificando se maquinário possui MySQL
    mysql --version
    if [ $? = 0 ]; then
        echo “Maquinario já possui MySQL”
    else
        sudo apt-get install mysql-server -y
    fi

    #Verificando se maquinário possui Git
    git --version
    if [ $? = 0 ]; then
        echo “Maquinario já possui Git”
    else
        sudo apt-get install git-all -y
    fi

    # Clone do repositórios Git
    git clone https://github.com/Projeto-de-PI-2-sem/Banco-De-Dados.git
    git clone https://github.com/Projeto-de-PI-2-sem/Notelog-Application.git
	
	# Setando banco local
	cd Banco-De-Dados
	echo "Insira sua senha de Usuário abaixo para prosseguir:"
	sudo mysql -u root -p "" < BD-Notelog.sql
	
	# Setando jar
	cd ..
	cd Notelog-Application/app-note-log/target
	clear
	java -jar app-note-log-1.0-SNAPSHOT-jar-with-dependencies.jar
	

else
echo "======================================================"
echo "                 Instalação cancelada                 "
echo "======================================================"    
fi
