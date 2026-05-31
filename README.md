# Geo Tasks

Aplicativo Flutter para gerenciamento de tarefas com suporte a geolocalizacao.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Provider](https://img.shields.io/badge/State%20Management-Provider-green)
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

## Tecnologias

- Flutter
- Provider + ChangeNotifier
- Geolocator

## Arquitetura

O projeto segue separacao por feature com MVVM:

- models: entidades do dominio
- repositories: acesso e manipulacao de dados em memoria
- viewmodels: estado e regras de negocio com ChangeNotifier
- views/widgets: interface e componentes visuais

## Funcionalidades

- Criar tarefa
- Editar tarefa
- Excluir tarefa
- Listar tarefas
- Marcar tarefa como concluida
- Capturar GPS na tela de criacao/edicao
- Inserir geolocalizacao tambem pela tela de listagem (botao no card)
- Exibir nome da localizacao no card quando informado

## Gerenciamento de Estado

O app usa Provider + ChangeNotifier + notifyListeners().

- O `TasksViewModel` concentra estado da lista de tarefas.
- A UI observa mudancas via Provider e atualiza automaticamente.

## Como executar

Clone o repositório:

```bash
git clone https://github.com/JonathanOishi/geo_tasks.git
```

Instale as dependências:

```bash
flutter pub get
```

Execute o projeto:

```bash
flutter run
```

Se precisar inicializar o Firebase, passe as chaves no build em vez de mantê-las no repositório:

```bash
flutter run \
  --dart-define=FIREBASE_API_KEY_ANDROID=... \
  --dart-define=FIREBASE_API_KEY_IOS=... \
  --dart-define=FIREBASE_API_KEY_WEB=...
```

## Observacao

Atualmente os dados das tarefas ficam em memoria (sem persistencia local). Ao fechar o app, a lista e reiniciada.
