#!/bin/bash
echo"           _____                   _______               _____                    _____                    _____           _______                   _____          "
echo"          /\    \                 /::\    \             /\    \                  /\    \                  /\    \         /::\    \                 /\    \         "
echo"         /::\____\               /::::\    \           /::\    \                /::\    \                /::\____\       /::::\    \               /::\    \        "
echo"        /::::|   |              /::::::\    \          \:::\    \              /::::\    \              /:::/    /      /::::::\    \             /::::\    \       "
echo"       /:::::|   |             /::::::::\    \          \:::\    \            /::::::\    \            /:::/    /      /::::::::\    \           /::::::\    \      "
echo"      /::::::|   |            /:::/~~\:::\    \          \:::\    \          /:::/\:::\    \          /:::/    /      /:::/~~\:::\    \         /:::/\:::\    \     "
echo"     /:::/|::|   |           /:::/    \:::\    \          \:::\    \        /:::/__\:::\    \        /:::/    /      /:::/    \:::\    \       /:::/  \:::\    \    "
echo"    /:::/ |::|   |          /:::/    / \:::\    \         /::::\    \      /::::\   \:::\    \      /:::/    /      /:::/    / \:::\    \     /:::/    \:::\    \   "
echo"   /:::/  |::|   | _____   /:::/____/   \:::\____\       /::::::\    \    /::::::\   \:::\    \    /:::/    /      /:::/____/   \:::\____\   /:::/    / \:::\    \  "
echo"  /:::/   |::|   |/\    \ |:::|    |     |:::|    |     /:::/\:::\    \  /:::/\:::\   \:::\    \  /:::/    /      |:::|    |     |:::|    | /:::/    /   \:::\ ___\ "
echo" /:: /    |::|   /::\____\|:::|____|     |:::|    |    /:::/  \:::\____\/:::/__\:::\   \:::\____\/:::/____/       |:::|____|     |:::|    |/:::/____/  ___\:::|    |"
echo" \::/    /|::|  /:::/    / \:::\    \   /:::/    /    /:::/    \::/    /\:::\   \:::\   \::/    /\:::\    \        \:::\    \   /:::/    / \:::\    \ /\  /:::|____|"
echo"  \/____/ |::| /:::/    /   \:::\    \ /:::/    /    /:::/    / \/____/  \:::\   \:::\   \/____/  \:::\    \        \:::\    \ /:::/    /   \:::\    /::\ \::/    / "
echo"          |::|/:::/    /     \:::\    /:::/    /    /:::/    /            \:::\   \:::\    \       \:::\    \        \:::\    /:::/    /     \:::\   \:::\ \/____/  "
echo"          |::::::/    /       \:::\__/:::/    /    /:::/    /              \:::\   \:::\____\       \:::\    \        \:::\__/:::/    /       \:::\   \:::\____\    "
echo"          |:::::/    /         \::::::::/    /     \::/    /                \:::\   \::/    /        \:::\    \        \::::::::/    /         \:::\  /:::/    /    "
echo"          |::::/    /           \::::::/    /       \/____/                  \:::\   \/____/          \:::\    \        \::::::/    /           \:::\/:::/    /     "
echo"          /:::/    /             \::::/    /                                  \:::\    \               \:::\    \        \::::/    /             \::::::/    /      "
echo"         /:::/    /               \::/____/                                    \:::\____\               \:::\____\        \::/____/               \::::/    /       "
echo"         \::/    /                 ~~                                           \::/    /                \::/    /         ~~                      \::/____/        "
echo"          \/____/                                                                \/____/                  \/____/                                                   "
echo""

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
        echo “sudo apt install openjdk-17-jre -y”
    fi

    #Verificando se maquinário possui MySQL
    mysql --version
    if [ $? = 0 ]; then
        echo “Maquinario já possui MySQL”
    else
        echo “sudo apt-get install mysql-server -y”
    fi

    #Verificando se maquinário possui Git
    git --version
    if [ $? = 0 ]; then
        echo “Maquinario já possui Git”
    else
        echo “sudo apt-get install git-all -y”
    fi

    # Clone do repositórios Git
    git clone https://github.com/Projeto-de-PI-2-sem/Banco-De-Dados.git
    git clone https://github.com/Projeto-de-PI-2-sem/Notelog-Application.git

    cd Notelog-Application/out/artifacts/Notelog_Application_jar
    chmod 777
    java -jar Notelog-Application.jar 
    clear
    echo "Instalação concluida"



else
echo "======================================================"
echo "                 Instalação cancelada                 "
echo "======================================================"    
fi

