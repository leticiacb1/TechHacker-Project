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
    guacamole_password = var.GUACAMOLE_PASSWORD
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




# ------------- Web Server (WordPress) --------------------



# ------------- Database (Maria DB) --------------------



