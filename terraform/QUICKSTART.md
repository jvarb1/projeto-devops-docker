# Guia Rápido - Terraform

## 🚀 Início Rápido (5 minutos)

### 1. Configurar Variáveis

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seu token da DigitalOcean
```

### 2. Configurar Backend (Escolha uma opção)

#### Opção A: Terraform Cloud (Mais Fácil)

1. Crie conta em https://app.terraform.io
2. Crie organização e workspace
3. Copie `backend.tf.example` para `backend.tf`:
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
4. Adicione `TF_API_TOKEN` como secret no GitHub

#### Opção B: Backend Local (Apenas para testes)

Não crie `backend.tf` - o Terraform usará backend local.

⚠️ **Atenção**: Backend local não funciona no GitHub Actions!

### 3. Testar Localmente

```bash
terraform init
terraform plan
terraform apply
```

### 4. Configurar Secrets no GitHub

Adicione os seguintes secrets no GitHub:

- `DO_TOKEN` - Token da DigitalOcean
- `TF_API_TOKEN` - Token do Terraform Cloud (se usar Terraform Cloud)
- `SSH_USER` - Usuário SSH (geralmente `root` para DigitalOcean)
- `SSH_KEY` - Chave privada SSH (deve corresponder à chave pública no Terraform)

### 5. Pronto!

Faça push para `main` e o pipeline irá:
1. Executar testes
2. Build da imagem Docker
3. **Criar/atualizar servidor automaticamente**
4. Deploy da aplicação

## 📝 Checklist

- [ ] Terraform instalado localmente
- [ ] `terraform.tfvars` configurado (não commitado!)
- [ ] Backend remoto configurado (para CI/CD)
- [ ] Secrets configurados no GitHub
- [ ] Chave SSH configurada no Terraform
- [ ] Teste local bem-sucedido (`terraform apply`)

## ❓ Problemas Comuns

**"Provider not found"**
```bash
terraform init -upgrade
```

**"Invalid token"**
- Verifique se o token da DigitalOcean está correto
- Gere novo token: https://cloud.digitalocean.com/account/api/tokens

**"Backend configuration changed"**
```bash
terraform init -migrate-state
```

