# --------- ATENÇÃO ---------
# Isso é apenas uma templae exemplo de comandos que foram executados manualmente dentro da máquina

# Atualize a lista de pacotes
sudo apt update && sudo apt upgrade -y

# Instale o servidor MySQL
sudo apt install -y mysql-server

# Install Zabbix Agent
wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-2%2Bubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.2-2+ubuntu22.04_all.deb
sudo apt update
sudo apt install zabbix-agent -y