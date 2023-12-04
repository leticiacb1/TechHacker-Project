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

variable "aval_zone" {
  description = "Avaliable Zone, VPC"
  default     = "us-east-2a"
}