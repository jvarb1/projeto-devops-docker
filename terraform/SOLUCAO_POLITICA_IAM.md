# Solução para Política IAM - Limite de Statements Excedido

## ⚠️ Problema

O Oracle Cloud Free Tier tem um limite de statements por compartment chain. Não é possível criar novas políticas via Terraform quando esse limite é atingido.

## ✅ Solução: Verificar e Adicionar Usuário ao Grupo Administrators

O grupo **Administrators** no Oracle Cloud geralmente já tem permissões para criar instâncias. Você só precisa garantir que seu usuário está nesse grupo.

### Passo 1: Verificar se você está no grupo Administrators

1. Acesse: https://cloud.oracle.com/
2. Menu → **Identity & Security** → **Groups**
3. Clique no grupo **Administrators**
4. Na aba **"Members"**, verifique se seu usuário `jvarb1@aluno.ifal.edu.br` está listado

### Passo 2: Se NÃO estiver no grupo, adicionar

1. Na página do grupo **Administrators**, clique em **"Add User to Group"**
2. Selecione seu usuário: `jvarb1@aluno.ifal.edu.br`
3. Clique em **"Add"**

### Passo 3: Verificar Políticas Existentes

1. Menu → **Identity & Security** → **Policies**
2. Verifique se já existe uma política no tenancy que permita:
   - `manage instance-family`
   - `use volume-family`
   - `use virtual-network-family`

3. Se existir uma política, você pode **editar** ela e adicionar as permissões necessárias (em vez de criar uma nova)

### Passo 4: Alternativa - Editar Política Existente

Se já existe uma política no tenancy:

1. Clique na política existente
2. Clique em **"Edit Policy Statements"**
3. Adicione estas statements (se não existirem):
   ```
   Allow group Administrators to manage instance-family in tenancy
   Allow group Administrators to read app-catalog-listing in tenancy
   Allow group Administrators to use volume-family in tenancy
   Allow group Administrators to use virtual-network-family in tenancy
   ```
4. Salve as alterações

## 🎯 Após Configurar

Depois de adicionar seu usuário ao grupo Administrators (ou editar uma política existente), execute o Terraform novamente:

```bash
terraform apply
```

Ou aguarde o pipeline do GitHub Actions executar automaticamente.

