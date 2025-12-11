terraform {
  required_version = ">= 1.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  # Usar private_key (conteúdo) se disponível, senão usar private_key_path
  private_key      = var.private_key != "" ? var.private_key : null
  private_key_path = var.private_key != "" ? null : var.private_key_path
  region           = var.region
}

# Buscar imagem Oracle Linux
data "oci_core_images" "oracle_linux" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# Buscar VCN existente
data "oci_core_vcn" "existing_vcn" {
  vcn_id = var.vcn_id
}

# Buscar Availability Domain
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Criar instância
resource "oci_core_instance" "app_server" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain != "" ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "${var.project_name}-server"
  shape               = "VM.Standard.E2.1.Micro"  # Always Free

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(<<-EOF
      #!/bin/bash
      set -e
      
      echo "=========================================="
      echo "Configurando servidor via Cloud-Init"
      echo "=========================================="
      
      # Atualizar sistema
      sudo dnf update -y
      
      # Instalar dependências básicas
      sudo dnf install -y git curl wget
      
      # Instalar Docker
      sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      
      # Adicionar usuário opc ao grupo docker
      sudo usermod -aG docker opc
      
      # Instalar Docker Compose standalone
      sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
      
      # Habilitar Docker no boot
      sudo systemctl enable docker
      sudo systemctl start docker
      
      # Verificar instalações
      docker --version || echo "Docker instalado"
      docker compose version || echo "Docker Compose instalado"
      docker-compose --version || echo "Docker Compose standalone instalado"
      
      echo "=========================================="
      echo "Configuração concluída!"
      echo "=========================================="
    EOF
    )
  }

  freeform_tags = {
    Project = var.project_name
  }
}
