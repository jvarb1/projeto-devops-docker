# Validação e Correção do Provider OCI

## 🔍 Análise do Problema

### Erro Identificado
```
Error: can not create client, bad configuration: did not find a proper configuration for private key
```

### Causa Raiz

**O Terraform Cloud executa remotamente** e não tem acesso ao sistema de arquivos do runner do GitHub Actions. Quando usamos `private_key_path`, o Terraform Cloud tenta acessar esse caminho no servidor remoto do Terraform Cloud, que não existe.

## ✅ Solução Correta

### 1. Usar `private_key` (conteúdo) em vez de `private_key_path` (caminho)

**Para Terraform Cloud (execução remota):**
- ✅ Use `private_key` com o **conteúdo completo** da chave privada
- ❌ NÃO use `private_key_path` (caminho de arquivo)

**Para execução local:**
- ✅ Use `private_key_path` com o caminho do arquivo
- ✅ Ou use `private_key` com o conteúdo

### 2. Formato Correto da Chave Privada

A chave privada deve ter o formato completo:

```
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDPFBYfbHwrG7C3
[... conteúdo completo ...]
OVcUS9pcJbdQxlk/MazaujbqGw==
-----END PRIVATE KEY-----
```

**Importante:**
- ✅ Deve incluir `-----BEGIN PRIVATE KEY-----` no início
- ✅ Deve incluir `-----END PRIVATE KEY-----` no final
- ✅ Deve manter todas as quebras de linha
- ✅ Não deve ter espaços extras ou caracteres inválidos

### 3. Verificação do Fingerprint

O fingerprint deve corresponder à chave pública registrada na Oracle Cloud:

```
43:af:9c:ed:6c:65:2d:e9:10:65:63:fc:96:25:9d:96
```

**Como verificar:**
1. No console da Oracle Cloud: User Settings → API Keys
2. O fingerprint deve corresponder exatamente ao configurado

## 📝 Configuração Corrigida

### Provider OCI (main.tf)

```hcl
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key  # ✅ Conteúdo da chave (não caminho)
  region       = var.region
}
```

### Variável (variables.tf)

```hcl
variable "private_key" {
  description = "Conteúdo da chave privada da API (obrigatório para Terraform Cloud)"
  type        = string
  sensitive   = true
}
```

### Workflow GitHub Actions

```yaml
env:
  TF_VAR_private_key: ${{ secrets.OCI_PRIVATE_KEY }}  # ✅ Conteúdo completo da chave
```

## 🔧 Ajustes no Terraform Cloud

### 1. Variáveis de Ambiente no Workspace

No Terraform Cloud, você pode configurar variáveis de duas formas:

**Opção A: Via GitHub Actions (Recomendado)**
- As variáveis são passadas via `TF_VAR_*` no workflow
- Não precisa configurar no Terraform Cloud
- ✅ Funciona automaticamente

**Opção B: Via Terraform Cloud UI**
1. Acesse: https://app.terraform.io/app/jvarb1/workspaces/projeto-devops/variables
2. Adicione variáveis sensíveis:
   - `private_key` (Terraform Variable, Sensitive)
   - `tenancy_ocid` (Terraform Variable, Sensitive)
   - `user_ocid` (Terraform Variable, Sensitive)
   - `fingerprint` (Terraform Variable, Sensitive)
   - etc.

### 2. Verificar Workspace

Certifique-se de que:
- ✅ Workspace `projeto-devops` existe na organização `jvarb1`
- ✅ Execution Mode está como "Remote" (não "Local")
- ✅ VCS Connection está configurada (se aplicável)

## ✅ Checklist de Validação

- [ ] Provider usa `private_key` (não `private_key_path`)
- [ ] Variável `private_key` está definida como `sensitive = true`
- [ ] Secret `OCI_PRIVATE_KEY` contém a chave completa (BEGIN/END incluídos)
- [ ] Fingerprint corresponde à chave pública na Oracle Cloud
- [ ] Todas as variáveis OCI estão sendo passadas via `TF_VAR_*` no workflow
- [ ] Workspace no Terraform Cloud está configurado corretamente

## 🚨 Problemas Comuns

### Problema 1: Chave privada sem BEGIN/END
**Sintoma:** Erro de formato
**Solução:** Certifique-se de que o secret `OCI_PRIVATE_KEY` inclui as linhas `-----BEGIN PRIVATE KEY-----` e `-----END PRIVATE KEY-----`

### Problema 2: Fingerprint incorreto
**Sintoma:** Erro de autenticação
**Solução:** Verifique o fingerprint no console da Oracle Cloud e compare com o secret `OCI_FINGERPRINT`

### Problema 3: Chave privada com quebras de linha incorretas
**Sintoma:** Erro de parsing
**Solução:** Ao copiar a chave para o secret, mantenha todas as quebras de linha originais

## 📋 Exemplo de Secret Correto

O secret `OCI_PRIVATE_KEY` deve conter exatamente:

```
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDPFBYfbHwrG7C3
E0CMmky+fvFI4TBSrcU1yWutRiZKhcasSasTlIx3znIyMDH9uJEufudHFJThPrxP
[... todas as linhas ...]
OVcUS9pcJbdQxlk/MazaujbqGw==
-----END PRIVATE KEY-----
```

**Sem espaços extras, sem caracteres inválidos, com todas as quebras de linha.**

