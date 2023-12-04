# ------------- Jump Server (Guacamole) --------------------

# ----- SSH key pair -----
# Create a key pair with SSH acess to the instance

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair_js" {
  key_name   = var.name_keypair_js
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key_js" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.name_keypair_js
}

# ----- Script to run when instance launch -----
data "template_file" "guacamole_config" {
  template = file("templates/guacamole_server.sh")

  vars = {
    # Guacamole 
    guacamole_password = var.GUACAMOLE_PASSWORD

    # Database server IP and private key
    db_ip          = aws_instance.db_server.private_ip
    db_private_key = local_file.db_server_key.content

    # Zabbix server IP and private key
    zabbix_ip          = aws_instance.zabbix_server.private_ip
    zabbix_private_key = local_file.zabbix_server_key.content
  }
}

# ----- AWS instance -----
resource "aws_instance" "js_guacamole" {
  ami                    = "ami-0e83be366243f524a"   # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-09-19           
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.subnet-public-1.id
  key_name               = aws_key_pair.key_pair_js.key_name
  vpc_security_group_ids = [aws_security_group.guacamole.id]

  associate_public_ip_address = true

  user_data = data.template_file.guacamole_config.rendered

  tags = {
    Name = "Guacamole - Jump Server"
  }
}

# ------------- Monitoring (Zabbix) --------------------

resource "aws_key_pair" "zabbix_key_pair" {
  key_name   = "zabbix_server_key_pair"
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "zabbix_server_key" {
  content  = data.template_file.zabbix_server.rendered
  filename = "zabbix_server_setup.sh"
}

data "template_file" "zabbix_server" {
  template = file("templates/zabbix.sh")
  vars = {
    zabbix_pass = var.ZABBIX_PASS
  }
}

resource "aws_instance" "zabbix_server" {
  ami                    = "ami-0e83be366243f524a"   # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-09-19
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.subnet-public-1.id
  key_name               = aws_key_pair.zabbix_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]

  # Allocate and associate an Elastic IP
  associate_public_ip_address = true

  tags = {
    Name = "Zabbix Server"
  }

  user_data = data.template_file.zabbix_server.rendered
}

# ------------- Database (MySQL) --------------------

resource "aws_key_pair" "key_pair_db" {
  key_name   = var.name_keypair_db
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "db_server_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.name_keypair_db
}

data "template_file" "db_server" {
  template = file("templates/mysql_db.sh")
  vars = {
    root_password = var.DB_ROOT_PASS
    db_name   = var.DB_NAME
    db_user   = var.DB_USER
    db_pass   = var.DB_PASS
    zabbix_ip = aws_instance.zabbix_server.private_ip
    name = "Database"
  }
}

resource "aws_instance" "db_server" {
  ami                    = "ami-009e390692db8124c"         # AMI com MySQL e Zabbix Agent instalada (template-mysql)
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.subnet-public-1.id
  key_name               = aws_key_pair.key_pair_db.key_name
  vpc_security_group_ids = [aws_security_group.intern_security_group.id]

  user_data = data.template_file.db_server.rendered

  tags = {
    Name = "Database Server"
  }
}
