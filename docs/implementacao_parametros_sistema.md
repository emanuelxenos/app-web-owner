# Guia Técnico: Implementação de Parâmetros do Sistema e Regras de Negócio

Este documento detalha a arquitetura e os passos necessários para implementar a tela de **Parâmetros do Sistema** no UnifyTech Xenos ERP, permitindo a configuração dinâmica de comissões, metas e regras operacionais.

---

## 1. Camada de Dados (Banco de Dados)

### SQL de Migração
Para evitar que o sistema quebre, os novos campos devem ser adicionados à tabela `empresa` com valores padrão.

```sql
ALTER TABLE empresa 
ADD COLUMN comissao_padrao DECIMAL(5,2) DEFAULT 0.00,
ADD COLUMN ticket_medio_alvo DECIMAL(12,2) DEFAULT 0.00;

-- Opcional: Atualizar registros existentes para 1% (padrão atual do mercado)
UPDATE empresa SET comissao_padrao = 1.00 WHERE comissao_padrao = 0;
```

---

## 2. Camada de Backend (Go)

### Estruturas (Models/DTOs)
Em `internal/domain/models/empresa.go` (ou arquivo de relatórios), adicionar a estrutura:
```go
type EmpresaConfig struct {
    ComissaoPadrao  float64 `json:"comissao_padrao"`
    TicketMedioAlvo float64 `json:"ticket_medio_alvo"`
}
```

### Endpoints (Handlers)
Criar rotas autenticadas (protegidas por EmpresaID):
1. `GET /api/empresa/config`: Retorna os valores atuais das colunas.
2. `PUT /api/empresa/config`: Atualiza os valores.

### Refatoração Crítica: RelatorioService
Onde houver cálculos de comissão, o código deve ser alterado de:
```go
// ANTIGO (LEGADO)
c.Comissao = c.ValorTotal * 0.01 
```
Para:
```go
// NOVO (ESCALÁVEL)
// 1. Buscar config da empresa
var config EmpresaConfig
err := s.db.Pool.QueryRow(ctx, "SELECT comissao_padrao FROM empresa WHERE id_empresa = $1", empresaID).Scan(&config.ComissaoPadrao)
// 2. Aplicar cálculo
c.Comissao = c.ValorTotal * (config.ComissaoPadrao / 100)
```

---

## 3. Camada de Frontend (Flutter)

### Localização dos Arquivos
- **Tela:** `lib/presentation/views/settings/system_parameters_screen.dart`
- **Provider:** `lib/presentation/providers/system_parameters_provider.dart`

### Menu Lateral (Sidebar)
Em `app_shell.dart`, inserir antes do item "Configurações":
```dart
_NavItem(
  icon: Icons.tune_rounded,
  label: 'Parâmetros',
  isActive: currentPath.startsWith('/parametros'),
  isExpanded: _isExpanded,
  onTap: () => context.go('/parametros'),
),
```

### Estrutura da Interface (UI)
A tela deve utilizar um `DefaultTabController` com as seguintes abas iniciais:
1. **Aba "Vendas & Metas":**
    - Cards com campos de input para `% Comissão` e `R$ Ticket Médio`.
    - Botão de "Salvar Alterações" flutuante ou no AppBar.
2. **Abas futuras (Placeholders):** Estoque, Financeiro, Fiscal.

---

## 4. Ordem Segura de Execução
1. **Executar SQL:** Garante que o backend não falhe ao tentar ler colunas inexistentes.
2. **Atualizar Backend:** Criar endpoints e testar via Postman/Curl.
3. **Refatorar Relatórios:** Garantir que o BI já use os novos valores do banco.
4. **Implementar Frontend:** Criar a tela e o provider para que o usuário final possa gerenciar.

---
**Documento gerado para fins de escalabilidade do projeto UnifyTech Xenos.**
