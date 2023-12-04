#!/bin/bash
sudo apt -y remove needrestart

# Aceitar automaticamente a atualização do kernel
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq -y -o Dpkg::Options::="--force-confdef" -o Dpkg::options::="--force-confold" dist-upgrade

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Adicionar repositório do Remmina
echo | sudo add-apt-repository ppa:remmina-ppa-team/remmina-next
sudo apt-get update
sudo apt-get install -y freerdp2-dev freerdp2-x11

# Baixar e executar script de instalação do Guacamole
wget -O guac-install.sh https://git.io/fxZq5
chmod +x guac-install.sh
sudo ./guac-install.sh --mysqlpwd ${guacamole_password} --guacpwd ${guacamole_password} --nomfa --installmysql

echo "Guacamole Installation Completed !"

# Baixar e instalar o plugin Guacamole Auth TOTP
wget https://downloads.apache.org/guacamole/1.5.3/binary/guacamole-auth-totp-1.5.3.tar.gz
tar -xzvf guacamole-auth-totp-1.5.3.tar.gz
cd guacamole-auth-totp-1.5.3/
sudo cp guacamole-auth-totp-1.5.3.jar /etc/guacamole/extensions

echo "Auth TOTP Installation Completed !"

# Reiniciar o serviço Tomcat9 
sudo systemctl restart tomcat9
echo " Tomcat restarted successfully !"

# Para acessar Dashboard: http://<ip-publico>:8080/guacamole
#
# Usuário : guacadmin
# Senha   : guacadmin