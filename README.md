# ERP UnifyTech Xenos - Painel Web (Owner/Admin)

Aplicativo frontend construído para ser o **Centro de Comando** tanto dos Donos de Lojas (Clientes) quanto dos SuperAdministradores (Equipe UnifyTech). 

## 📱 Principais Funcionalidades

- **Painel do Dono (Owner Dashboard):** Interface rica e focada em BI (Business Intelligence) onde os proprietários visualizam o faturamento, vendas diárias e resumo financeiro de suas lojas em tempo real, consultando diretamente o banco local da loja através do Túnel WebSocket.
- **Painel do Administrador (SuperAdmin):** Ambiente restrito para a gestão de licenças, cadastro de clientes (donos), registro de lojas físicas pelo CNPJ e vinculação de lojas aos donos. 
- **Experiência Visual Moderna:** Sistema de abas, pesquisas em tempo real (com `debounce`), paginação nativa e uso de componentes responsivos baseados no Material Design.
- **Navegação Segura:** Rotas protegidas (GoRouter) e controle de estado reativo utilizando Riverpod.

## 🛠 Tecnologias Utilizadas
- **Framework:** Flutter (Web)
- **Linguagem:** Dart
- **Gerência de Estado:** Riverpod
- **Roteamento:** GoRouter
- **Estilização:** Tema Customizado (Cores Escuras, Componentes Vidro/Translúcidos, Micro-animações)

## 📦 Como Rodar Localmente

1. Certifique-se de ter o [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
2. Clone o repositório.
3. Baixe as dependências do projeto:
   ```bash
   flutter pub get
   ```
4. Rode a aplicação em um navegador web (ex: Chrome):
   ```bash
   flutter run -d chrome
   ```

## 🏗 Arquitetura Frontend
O app é desenhado com uma estrutura baseada em Features (Apresentação, Serviços, Core). Toda a comunicação HTTP passa por um `ApiService` (utilizando o pacote `dio`) que embute os tokens JWT nas requisições, abstraindo a complexidade de rotas paginadas e a proteção de rotas restritas.
