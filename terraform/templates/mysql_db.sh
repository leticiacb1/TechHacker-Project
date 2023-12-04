#!/bin/bash
# Utilizando uma iam criada com MYSQL e Zabbix Agent no Dashboard AWS

# Remover o pacote needrestart
sudo apt -y remove needrestart

sudo chmod 755 /home/ubuntu

# Set ROOT password
# Execute comandos seguros para configurar o MySQL (definir senha root, remover usuários anônimos, desativar login root remoto, remover banco de dados de teste)
sudo mysql_secure_installation <<EOF

y
${root_password}
${root_password}
y
n
y
y
EOF

# Create a new MySQL database and user
sudo mysql -u root -p${root_password} -e "CREATE DATABASE ${db_name};"
sudo mysql -u root -p${root_password} -e "CREATE USER '${db_user}'@'localhost' IDENTIFIED BY '${db_pass}';"
sudo mysql -u root -p${root_password} -e "ALTER USER '${db_user}'@'localhost' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
sudo mysql -u root -p${root_password} -e "SET PASSWORD FOR '${db_user}'@'localhost' = PASSWORD('${db_pass}');"
sudo mysql -u root -p${root_password} -e "GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost';"
sudo mysql -u root -p${root_password} -e "FLUSH PRIVILEGES;"

# Enable remote connections (optional, for development purposes)
# Replace 0.0.0.0/0 with your specific IP range for security
echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart MySQL for changes to take effect
sudo systemctl restart mysql

echo "MySQL setup completed."

# ---------- Install Guacamole client ----------
echo "Installing Guacamole client..."

echo "PubkeyAcceptedKeyTypes +ssh-rsa" | sudo tee -a /etc/ssh/sshd_config
echo "KexAlgorithms +diffie-hellman-group14-sha1" | sudo tee -a /etc/ssh/sshd_config
echo "HostKeyAlgorithms +ssh-rsa" | sudo tee -a /etc/ssh/sshd_config

sudo systemctl restart ssh

# ---------- Install Zabbix Agent ----------

sudo sed -i "s/Server=127.0.0.1/Server=${zabbix_ip}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=${zabbix_ip}/" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/Hostname=Zabbix server/Hostname=${name}/" /etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent
