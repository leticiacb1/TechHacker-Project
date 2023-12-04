# ------------- Jump Server (Guacamole) --------------------

resource "aws_security_group" "guacamole" {
  vpc_id = aws_vpc.main-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Guacamole-Security-Group"
  }
}

# ------------- Web Server (WordPress) --------------------

resource "aws_security_group" "wordpress" {
  vpc_id = aws_vpc.main-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all communication within the local network
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main-vpc.cidr_block]
  }

  # Allow http and https traffic from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WordPress-Security-Group"
  }

}

# ------------- Intern Communication --------------------
resource "aws_security_group" "intern_security_group" {
  vpc_id = aws_vpc.main-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main-vpc.cidr_block]
  }

  tags = {
    Name = "Intern-Communication-Security-Group"
  }
}