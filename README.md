# 💰 Controle de Gastos – Flutter

Aplicativo mobile **minimalista** para controle de gastos pessoais, desenvolvido em **Flutter** utilizando **arquitetura MVC** e **persistência local com SQLite**.

---

## ✨ Funcionalidades

- ➕ Adicionar entradas e saídas
- 🗑️ Remover lançamentos
- 📊 Resumo financeiro (entradas, saídas e saldo)
- 💾 Armazenamento local (SQLite)
- 📅 Seleção de data
- 🎨 Interface limpa e minimalista (Material 3)

---

## 📱 Telas

- **Home**
  - Saldo atual
  - Lista de lançamentos
- **Novo Lançamento**
  - Entrada ou saída
  - Valor, descrição e data
- **Resumo**
  - Total de entradas
  - Total de saídas
  - Saldo final

---

## 🧱 Arquitetura

O projeto utiliza **MVC (Model–View–Controller)** com separação clara de responsabilidades:

lib/
├── core/ # Tema, cores e rotas
├── models/ # Modelos de dados
├── services/ # Acesso ao banco (SQLite)
├── controllers/ # Lógica e estado
├── screens/ # Telas
├── widgets/ # Componentes reutilizáveis
└── main.dart

---

## 🛠️ Tecnologias Utilizadas

- Flutter (Material 3)
- Dart
- SQLite (sqflite)
- intl (formatação de moeda e datas)

---

## ▶️ Como executar

```bash
1. Clone o repositório
git clone https://github.com/seu-usuario/controle-gastos-flutter.git;

2. Instale as dependências
flutter pub get

3. Execute o projeto
flutter run

🚀 Próximas melhorias (roadmap)

Filtro por mês

Edição de lançamentos

Exportação de dados

Categorias (versão futura)

Dark Mode

👨‍💻 Autor

Gustavo
Desenvolvedor Flutter em evolução 🚀
Projeto criado com foco em organização, código limpo e boas práticas.

📌 Este app é um MVP funcional e faz parte de um portfólio em constante evolução.
```
