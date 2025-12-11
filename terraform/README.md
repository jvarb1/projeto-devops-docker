# Infraestrutura como Código (IaC) com Terraform

Este diretório contém a configuração do Terraform para provisionar automaticamente a infraestrutura do projeto na DigitalOcean.

## 📋 Estrutura de Arquivos

- `main.tf` - Configuração principal do provider e recursos
- `variables.tf` - Definição de variáveis
- `outputs.tf` - Outputs do Terraform (IP do servidor, etc.)
- `terraform.tfvars.example` - Exemplo de variáveis (copie para `terraform.tfvars`)
- `backend.tf.example` - Exemplo de configuração de backend remoto

## 🚀 Configuração Inicial

### 1. Instalar Terraform

**Windows:**
```powershell
# Via Chocolatey
choco install terraform

# Ou baixe de: https://www.terraform.io/downloads
```

**Linux/macOS:**
```bash
# Via Homebrew (macOS)
brew install terraform

# Ou baixe de: https://www.terraform.io/downloads
```

### 2. Configurar Variáveis

1. Copie o arquivo de exemplo:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edite `terraform.tfvars` com suas credenciais:
```hcl
do_token = "seu-token-da-digitalocean"
project_name = "projeto-devops"
droplet_region = "nyc1"
droplet_size = "s-1vcpu-1gb"
```

**⚠️ IMPORTANTE:** Nunca faça commit do arquivo `terraform.tfvars`!

### 3. Configurar Backend Remoto (Opcional)

Para desenvolvimento local, você pode pular esta etapa. Para produção/CI/CD, configure um backend remoto:

**Opção 1: Terraform Cloud (Recomendado)**
1. Crie uma conta em https://app.terraform.io
2. Crie uma organização
3. Crie um workspace
4. Copie `backend.tf.example` para `backend.tf` e configure:

```hcl
terraform {
  cloud {
    organization = "sua-organizacao"
    workspaces {
      name = "projeto-devops"
    }
  }
}
```

**Opção 2: AWS S3**
```hcl
terraform {
  backend "s3" {
    bucket         = "seu-bucket-terraform-state"
    key            = "projeto-devops/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

**Opção 3: DigitalOcean Spaces**
```hcl
terraform {
  backend "s3" {
    endpoint   = "https://nyc3.digitaloceanspaces.com"
    bucket     = "seu-bucket-terraform-state"
    key        = "projeto-devops/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
  }
}
```

## 🔧 Uso Local

### Inicializar Terraform

```bash
cd terraform
terraform init
```

### Verificar Plano de Execução

```bash
terraform plan
```

### Aplicar Configuração

```bash
terraform apply
```

Confirme digitando `yes` quando solicitado.

### Obter Outputs

```bash
# Ver todos os outputs
terraform output

# Ver apenas o IP
terraform output droplet_ip
```

### Destruir Infraestrutura

```bash
terraform destroy
```

## 📝 Recursos Criados

O Terraform cria automaticamente:

1. **Droplet (Servidor)**
   - Sistema operacional: Ubuntu 22.04
   - Docker e Docker Compose instalados via Cloud-Init
   - Chave SSH configurada para acesso
   - IP público disponível via output

2. **Chave SSH** (se não especificar uma existente)
   - Criada automaticamente na DigitalOcean

## 🔐 Segurança

- ✅ Arquivos sensíveis (`.tfvars`, `.tfstate`) estão no `.gitignore`
- ✅ Variáveis sensíveis marcadas como `sensitive = true`
- ✅ Chave SSH injetada automaticamente no servidor
- ✅ Estado do Terraform pode ser armazenado remotamente e criptografado

## 🐛 Troubleshooting

### Erro: "Provider not found"
```bash
terraform init -upgrade
```

### Erro: "Invalid token"
Verifique se o token da DigitalOcean está correto em `terraform.tfvars`.

### Erro: "SSH key not found"
Certifique-se de que o caminho da chave pública está correto ou forneça o ID de uma chave existente.

### Servidor não inicia Docker
O Cloud-Init pode levar alguns minutos. Verifique os logs:
```bash
# Via DigitalOcean Dashboard ou SSH
journalctl -u cloud-init
```

## 📚 Referências

- [Documentação do Terraform](https://www.terraform.io/docs)
- [Provider DigitalOcean](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
- [Terraform Cloud](https://www.terraform.io/cloud)

