# ------------- AWS Credentials --------------------

variable "AWS_REGION" {
  description = "Região utilizada pela AWS"
  type        = string

  default = "us-east-2"             # Ohio
}

variable "AWS_ACCESS_KEY_ID" {
  description = "Acess Key ID - Obtida via Dashboard"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Acess Secret Key - Obtida via Dashboard"
  type        = string
  sensitive   = true
}

variable "key_pair_path" {
  description = "Path to your public key for ssh connections"
  default     = "/home/leticiacb/Documents/TechHacker/ProjetoTechHacker/project_key.pub"
}

# ------------- Subnet --------------------

variable "aval_zone" {
  description = "Avaliable Zone, VPC"
  default     = "us-east-2a"
}

# ------------- Database (Mysql) --------------------

variable "DB_ROOT_PASS" {
  type        = string
  description = "Root database password"
}

variable "DB_NAME" {
  type        = string
  description = "Database name"
}

variable "DB_USER" {
  type        = string
  description = "Database user"
}

variable "DB_PASS" {
  type        = string
  description = "Database password"
}

variable name_keypair_db {
    default = "key-pair-db"
}


# ------------- Jump Server --------------------

variable "GUACAMOLE_PASSWORD" {
  type        = string
  description = "Guacamole password"
}

variable name_keypair_js {
    default = "key-pair-js"
}

# ------------- Zabbix --------------------

variable "ZABBIX_PASS" {
  type        = string
  description = "Zabbix password"
}
