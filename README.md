# Geo Tasks

Geo Tasks é um aplicativo Flutter para gerenciamento de tarefas com autenticação, sincronização em tempo real e suporte a geolocalização.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Provider](https://img.shields.io/badge/State%20Management-Provider-green)
![Firebase](https://img.shields.io/badge/Backend-Firebase-orange)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)

<p align="center">
  <a href="https://github.com/JonathanOishi">
    <img
      src="https://i.ibb.co/99Spk134/Gemini-Generated-Image-yrfigeyrfigeyrfi-removebg-preview.png"
      alt="Geo Tasks"
      width="60%"
    />
  </a>
</p>

## Visão Geral

O projeto está organizado por feature e usa MVVM com Provider. A aplicação abre na tela de login quando o usuário não está autenticado e, após o login, exibe uma navegação inferior com três áreas principais:

- Tasks: lista de tarefas pendentes e ações rápidas no card
- Dashboard: histórico e resumo das tarefas concluídas
- Profile: dados do usuário e gerenciamento do perfil

## O Que O App Faz Hoje

- Autenticação com Firebase Auth
- Cadastro e login de usuário com e-mail e senha
- Salvamento das tarefas no Cloud Firestore por usuário
- Escuta em tempo real das mudanças no Firestore
- Criação, edição, exclusão e conclusão de tarefas
- Captura de localização via GPS para associar a tarefa
- Edição da localização diretamente pelo card da home
- Upload/atualização de avatar do perfil
- Separação visual entre tarefas pendentes e concluídas

## Tecnologias

- Flutter
- Provider + ChangeNotifier
- Firebase Auth
- Cloud Firestore
- flutter_dotenv
- Geolocator
- flutter_slidable
- image_picker
- crystal_navigation_bar

## Arquitetura

O projeto segue separação por feature com MVVM:

- models: entidades do domínio
- repositories: acesso ao Firebase e persistência
- viewmodels: estado e regras de negócio com ChangeNotifier
- views/widgets: interface e componentes visuais

### Fluxo das tarefas

- `TasksViewModel` observa o Firebase Auth e cria um repositório por usuário logado
- `TaskRepository` escuta a coleção `users/{uid}/tasks` em tempo real
- a Home exibe apenas tarefas pendentes
- o Dashboard exibe o histórico das tarefas concluídas
- a edição agora trabalha com a task selecionada, sem depender do índice da lista filtrada

## Estrutura Principal

- `lib/main.dart`: inicialização do app, dotenv e Firebase
- `lib/app/router`: rotas da aplicação
- `lib/app/theme`: tema e cores
- `lib/features/tasks/models`: modelos de domínio
- `lib/features/tasks/repositories`: integração com Firestore
- `lib/features/tasks/viewmodels`: estado e regras de negócio
- `lib/features/tasks/views`: telas do app
- `lib/features/tasks/widgets`: componentes reutilizáveis

## Configuração Local

Antes de executar o app, crie o arquivo `.env` a partir do exemplo:

```powershell
Copy-Item .env.example .env
```

Preencha as chaves necessárias:

```env
FIREBASE_API_KEY_ANDROID=
FIREBASE_API_KEY_IOS=
```

O app carrega esse arquivo antes de inicializar o Firebase.

## Como Executar

Instale as dependências:

```bash
flutter pub get
```

Execute o projeto:

```bash
flutter run
```

Se quiser rodar em uma plataforma específica:

```bash
flutter run -d android
flutter run -d ios
```

## Observações

- As tarefas não ficam mais em memória: elas são persistidas no Firestore por usuário.
- O app depende de login para carregar a coleção correta de tarefas.
- A tela inicial mostra somente tarefas pendentes; as concluídas aparecem no Dashboard.
