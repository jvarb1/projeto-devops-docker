variable "tenancy_ocid" {
  description = "OCID do tenancy da Oracle Cloud"
  type        = string
  sensitive   = true
}

variable "user_ocid" {
  description = "OCID do usuário"
  type        = string
  sensitive   = true
}

variable "fingerprint" {
  description = "Fingerprint da chave API"
  type        = string
  sensitive   = true
}

variable "private_key" {
  description = "Conteúdo da chave privada da API (obrigatório para Terraform Cloud)"
  type        = string
  sensitive   = true
}

variable "compartment_ocid" {
  description = "OCID do compartment"
  type        = string
}

variable "region" {
  description = "Região da Oracle Cloud"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "availability_domain" {
  description = "Availability Domain (ex: AD-1). Deixe vazio para usar a primeira disponível"
  type        = string
  default     = ""
}

variable "vcn_id" {
  description = "OCID da VCN"
  type        = string
}

variable "subnet_id" {
  description = "OCID da Subnet pública"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "projeto-devops"
}

variable "ssh_public_key_path" {
  description = "Caminho para a chave pública SSH"
  type        = string
  default     = "C:/Users/contr/.ssh/id_ed25519_terraform.pub"
}
