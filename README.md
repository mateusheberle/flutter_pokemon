# 📱 Flutter Pokédex App

Aplicativo Flutter desenvolvido como **teste técnico**, consumindo a **PokéAPI**, com foco em **Clean Architecture**, boas práticas de Flutter/Dart, consumo de API REST e organização de código.

---

## 🎯 Objetivo

Desenvolver um aplicativo Flutter que consuma dados da **PokéAPI**, aplicando os princípios de **Clean Architecture**, com separação clara de responsabilidades entre as camadas **Domain**, **Data** e **Presentation**.

---

## 🌐 API Utilizada

**PokéAPI**
API pública que fornece dados completos sobre Pokémon.

* Endpoint principal:

```http
GET https://pokeapi.co/api/v2/pokemon?limit=20&offset=0
```

* Documentação oficial:
  [https://pokeapi.co/](https://pokeapi.co/)

---

## ✨ Funcionalidades

### 📋 Listagem de Pokémon

* Listagem paginada utilizando `limit` e `offset`
* Scroll infinito
* Exibição do nome e imagem do Pokémon
* Estados de loading, erro e sucesso

### 📄 Detalhes do Pokémon

* Nome
* Imagem (sprite)
* Tipos
* Altura
* Peso
* Tela dedicada com carregamento individual

### 🔀 Navegação

* Navegação entre listagem e detalhes
* Passagem de parâmetros entre telas

---

## 🧱 Arquitetura

O projeto segue os princípios de **Clean Architecture**, com separação clara entre responsabilidades.

### 📂 Camadas

#### **Domain**

* **Entities**: regras de negócio puras
* **Repositories**: contratos (interfaces)
* **UseCases**: casos de uso da aplicação

> Não dependem de Flutter nem de bibliotecas externas

#### **Data**

* **Models**: mapeamento de dados da API
* **DataSources**: comunicação com a API REST
* **Repositories (implementações)**: implementação dos contratos do domínio

#### **Presentation**

* **Pages**: telas da aplicação
* **Widgets**: componentes reutilizáveis
* **State**: gerenciamento de estado com `ChangeNotifier`

---

## 🗂️ Estrutura de Pastas

```text
lib/
 ├── core/
 │   ├── di/
 │   ├── error/
 │   ├── network/
 │   └── usecase/
 │
 ├── features/
 │   └── pokemon/
 │       ├── domain/
 │       │   ├── entities/
 │       │   ├── repositories/
 │       │   └── usecases/
 │       ├── data/
 │       │   ├── datasources/
 │       │   ├── models/
 │       │   └── repositories/
 │       └── presentation/
 │           ├── pages/
 │           ├── widgets/
 │           └── state/
 │
 └── main.dart
```

---

## 🛠️ Tecnologias e Ferramentas

* **Flutter**
* **Dart**
* **Dio** (consumo de API REST)
* **Provider / ChangeNotifier** (gerenciamento de estado)
* **get_it** (injeção de dependência)
* **Clean Architecture**

---

## ▶️ Como Rodar o Projeto

### Pré-requisitos

* Flutter instalado
* Android Studio ou VS Code
* Emulador Android ou dispositivo físico

### Passos

```bash
git clone https://github.com/mateusheberle/flutter_pokemon.git
cd flutter_pokemon
flutter pub get
flutter run
```

---

## 🚀 Possíveis Melhorias

* Implementação de cache em memória
* Adição de testes unitários
* Tratamento offline
* Animações e melhorias visuais
* Internacionalização (i18n)

---

## 👨‍💻 Autor

**Mateus Auler Heberle**
Flutter Developer

---

## 📄 Licença

Este projeto foi desenvolvido exclusivamente para fins de **avaliação técnica**.