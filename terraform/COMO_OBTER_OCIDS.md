# Como Obter OCIDs da Oracle Cloud

## 📋 OCIDs Necessários

Para configurar o Terraform, você precisa dos seguintes OCIDs:

1. **Tenancy OCID**
2. **User OCID**
3. **Compartment OCID**
4. **VCN OCID** ✅ (você já tem a VCN `vcn-dev-ops`)
5. **Subnet OCID** (precisa verificar se existe)

## 🔍 Como Obter Cada OCID

### 1. Tenancy OCID
1. No console, clique no menu do usuário (canto superior direito)
2. Clique em **"Tenancy: [nome]"**
3. O OCID aparece na página (começa com `ocid1.tenancy.oc1..`)

### 2. User OCID
1. Menu do usuário → **"User Settings"**
2. O OCID aparece no topo da página (começa com `ocid1.user.oc1..`)

### 3. Compartment OCID
1. Menu → **"Identity & Security"** → **"Compartments"**
2. Clique no compartment que você quer usar (geralmente o root ou um criado por você)
3. O OCID aparece na página de detalhes (começa com `ocid1.compartment.oc1..`)

### 4. VCN OCID ✅
1. Menu → **"Networking"** → **"Virtual Cloud Networks"**
2. Clique na VCN `vcn-dev-ops`
3. Na página de detalhes, copie o **OCID** (começa com `ocid1.vcn.oc1..`)

### 5. Subnet OCID
1. Na página da VCN `vcn-dev-ops`, vá na aba **"Subnets"**
2. Se já existir uma subnet pública:
   - Clique nela
   - Copie o **OCID** (começa com `ocid1.subnet.oc1..`)
3. Se não existir:
   - Podemos criar via Terraform automaticamente
   - Ou você cria manualmente no console

### 6. Availability Domain
1. Menu → **"Compute"** → **"Instances"**
2. Ao criar uma instância, você verá os Availability Domains disponíveis
3. Geralmente são: `AD-1`, `AD-2`, `AD-3`
4. Ou deixe vazio no Terraform que ele usa o primeiro disponível

## 🔑 Credenciais da API

Você também precisa criar uma chave API:

1. Menu do usuário → **"User Settings"**
2. Aba **"API Keys"**
3. Clique em **"Add API Key"**
4. Escolha **"Paste Public Key"** ou **"Generate Key Pair"**
5. Se gerar:
   - Baixe a chave privada (`.pem`)
   - Copie o **Fingerprint**
6. Salve a chave privada em: `~/.oci/api_key.pem` (ou outro local seguro)

## 📝 Checklist

- [ ] Tenancy OCID
- [ ] User OCID
- [ ] Compartment OCID
- [ ] VCN OCID (você já tem a VCN)
- [ ] Subnet OCID (verificar se existe)
- [ ] Availability Domain (ou deixar vazio)
- [ ] Chave API criada
- [ ] Fingerprint da chave API
- [ ] Chave privada salva

