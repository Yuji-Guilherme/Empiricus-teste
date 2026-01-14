# 📱 App de Assinaturas Empiricus (Desafio Técnico)

Este projeto é uma aplicação Flutter desenvolvida como resposta ao desafio técnico. A aplicação tem como funcionalidade principal listar assinaturas e exibir os seus detalhes, implementando **Arquitetura limpa**, **Gestão de estado reativa** e **Qualidade de Código** através de uma suite de testes abrangente.

## 🎯 Visão Geral e Requisitos Atingidos

O projeto cumpre **100% dos requisitos obrigatórios** e todos os requisitos **bônus** propostos, focando na performance, tratamento de erros e experiência do usuário (UX).

<img src="https://github.com/user-attachments/assets/43c93c94-c683-44b1-9fcb-a67fb54ca875" width="300">

### ✅ Funcionalidades Principais

- **Listagem de Assinaturas:** Consumo de dados em tempo real, exibindo imagem, título e descrição.

- **Detalhes da Assinatura:** Exibição com imagem grande, autores, features e descrição completa.

- **Deep Linking:** Suporte a navegação direta para detalhes (ex: `/slug-do-artigo`), com suporte a redirecionamento pós-login preservando a intenção original do usuário.

- **Pull-to-Refresh:** Atualização da lista com estratégia **não-destrutiva** (mantém os dados antigos visíveis e em caso de erro notifica o usuário com snackbar).

### ⭐️ Funcionalidades Bônus Implementadas

- **Splash Screen:** Tela de abertura com a logo + ícone do aplicativo.

<img src="https://github.com/user-attachments/assets/56e9925a-5303-4384-b4f7-d12306fa83cb" width="300">

- **Autenticação (Login):** Validação de credenciais hardcoded com feedback visual e redirecionamento inteligente.

<img src="https://github.com/user-attachments/assets/d9b72a58-ce72-49ad-a555-837673c1039e" width="300">

- **Tratamento de Erros (UX):** Feedback visual via `SnackBars` e `ErrorViews` dedicadas permitindo "Retry".

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/bc7a11b4-dd7c-4598-8c70-3c49c1970bd9" width="300"></td>
    <td><img src="https://github.com/user-attachments/assets/ad7afdd7-82fa-44f5-83b8-b0c9755f57ab" width="300"></td>
  </tr>
</table>

- **suite de Testes:** Cobertura de cenários críticos com Testes Unitários, de Widget e de Integração.

---

## 🏗 Arquitetura e Decisões Técnicas

O projeto segue os princípios da **Clean Architecture**, dividindo a responsabilidade em camadas para garantir desacoplamento e testabilidade.

### 1. Camadas (Layers)

- **Domain:** Contém Entidades, Casos de Uso e Contratos (Interfaces).
- **Data:** Implementação dos repositórios e Models.
- **Presentation:** A camada visual e interativa. Contém `Pages`, `Widgets` e Gerenciadores de Estado (`BLoC`/`Cubit`).

### 2. Gerenciamento de Estado (BLoC)

O projeto utiliza o **BloC** para garantir a reatividade e a separação clara entre as regras de negócio e a UI, com estratégias avançadas para cada contexto:

- `ArticleBloc`**(Listagem):** Gerencia o ciclo de vida da lista. Implementa lógica de persistência visual durante erros de refresh, se a atualização falhar, os dados antigos são mantidos e o erro é exibido por uma snackbar.
- `ArticleDetailBloc`**(Detalhe):** Implementa estratégia de **Zero-Fetch Navigation**. Se o usuário vem da listagem, os dados já carregados são exibidos instantaneamente (cache efêmero). Se o acesso é via **Deep Link**, o BLoC realiza o *fetch* automaticamente. Além disso, faz o mapeamento específico para erros **404 (Not Found)**.
- `LoginCubit`**(Auth):** Controla o fluxo de autenticação, orquestrando o `LoginUseCase`e convertendo falhas técnicas em mensagens amigáveis via `FailureExtension`.

### 3. Navegação e Deep Links (GoRouter)
A navegação é gerida pelo `go_router`, permitindo suporte a Deep Links.

- **Guard de Autenticação Reativo:** Observa o `AuthService` e redirecionam usuários não autenticados.
- **Deep Links com Contexto:** Se um usuário tenta acessar a um artigo específico sem login, o router guarda a query (`?from=...`) e redireciona-o para o conteúdo desejado após o login.
- **Implementação de Zero-Fetch**: O router utiliza o campo `extra` para passar o artigo (`ArticleEntity`) entre a listagem e os detalhes. Isso permite que a página de detalhes exiba o conteúdo instantaneamente.

<table>
  <thead>
    <tr>
      <th align="left">Usuário Logado (Acesso Direto)</th>
      <th align="left">Usuário Deslogado (Redirecionamento)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Acessa diretamente o detalhe</td>
      <td>Login -> Redireciona para o detalhe original</td>
    </tr>
    <tr>
      <td>
        <img src="https://github.com/user-attachments/assets/fe50924b-f95a-4e90-b8b4-591cc12ae863" width="300" alt="Fluxo Logado">
      </td>
      <td>
        <img src="https://github.com/user-attachments/assets/12777165-bc61-467a-9a22-4004d6cd684e" width="300" alt="Fluxo Deslogado">
      </td>
    </tr>
  </tbody>
</table>

### 4. Injeção de Dependências (GetIt) 
O projeto utiliza o `GetIt` como *Service Locator* centralizado para promover o desacoplamento entre camadas.

- **Singletons** (`registerLazySingleton`)**:** Para infraestrutura (`HttpAdapter`), serviços (`AuthService`) e repositórios, garantindo instância única.

- **Factories** (`registerFactory`)**:** Para BLoCs e Cubits, garantindo que cada tela receba uma instância limpa de estado, prevenindo efeitos colaterais entre navegações.

### 📂 Estrutura de Pastas
A estrutura do projeto reflete a separação de responsabilidades proposta pela arquitetura limpa, modularizada por *features*:

```bash
lib/
├── core/                        # Camada transversal (compartilhada por todo o app)
│   ├── components/              # Widgets reutilizáveis (Alertas, Botões)
│   ├── constants/               # Constantes estáticas (Base URL, Credenciais)
│   ├── di/                      # Injeção de Dependências (Service Locator)
│   ├── errors/                  # Definição de Failures customizadas
│   ├── network/                 # Implementação do HttpAdapter e NetworkInfo
│   ├── routes/                  # Configuração do GoRouter
│   ├── services/                # Serviço reativo (AuthService)
│   ├── theme/                   # Estilização global e cores
│   └── utils/                   # Extensões, Validadores e Observers
│
├── features/                    # Módulos da aplicação
│   ├── articles/
│   │   ├── data/                # Repositórios (Impl) e Models (API)
│   │   ├── domain/              # Entidades, Contratos (Interfaces) e UseCases
│   │   └── presentation/        # BLoCs, Pages e Widgets específicos da tela
│   │
│   └── auth/
│       ├── data/
│       ├── domain/              # Inclui LoginUseCase
│       └── presentation/        # Inclui LoginCubit
│
└── main.dart
```
---

## 🧩 Soluções de Engenharia e Core

Além das funcionalidades visíveis, o projeto conta com uma camada `Core` robusta que sustenta a aplicação através de *Design Patterns* e boas práticas.

### 🔌 Network Adapter (Adapter Pattern)

Implementação do padrão **Adapter** para a camada HTTP (`HttpAdapter`). 

- **Objetivo**: Promover o desacoplamento entre a lógica de negócio e as dependências de terceiros (como o `package:http`), garantindo que mudanças em bibliotecas externas não gerem impactos em cascata no sistema.

- **Benefício:** Permite a troca fácil do client HTTP no futuro e intercepta exceções de baixo nível (como `SocketException`), convertendo-as em Exceções de Domínio (`NetworkFailure`) antes que cheguem aos Repositórios.

### 🛡️ Tratamento Centralizado de Erros (Failure Extension)

Uso de **Dart 3 Pattern Matching** para converter erros técnicos em feedback de UI.

- A `FailureExtension` atua como um tradutor, convertendo erros de domínio (`ServerFailure`, `NetworkFailure`) em mensagens de UI amigáveis e ícones específicos. retirando essa responsabilidade da View.

### 🔐 Autenticação Reativa

O `AuthService` atua como a "Fonte da Verdade" para o estado de autenticação.

- Integrado ao `refreshListenable` do Router, ele garante que qualquer mudança no estado de login dispare automaticamente o redirecionamento de rotas, sem necessidade de *listeners* espalhados pelas telas.

### 🧹 Polimento de UX (Snackbar Observer)

Implementação de um `NavigatorObserver` personalizado (`SnackbarCleanerObserver`). 

- Responsável por limpar `SnackBars` ao navegar entre rotas. Isso evita que mensagens de erro de uma tela anterior "vazem" visualmente para a nova tela, garantindo uma interface sempre limpa.

---

## 🧪 Estratégia de Testes 
A suite de testes foca nos riscos críticos da aplicação: 

1. **Unitários:** Validam a lógica pura nos BLoCs e o tratamento de dados nos Repositórios.
2. **Widget (Integração de UI):** Validação de feedback visual (Loading, Error View, SnackBars) na `LoginPage`, `HomePage` e `DetailsPage`. 
3. **Integração (Flow):** Simulam a jornada do usuário, cobrindo os fluxos de: *Login -> Home* & *Home -> Detalhes*.

---

<h2 id="access">🔑 Credenciais de Acesso </h2>

> **E-mail:** `empiricusteste@email.com` 
> **Senha:** `123456`
