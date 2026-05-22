# Geo Tasks

Aplicativo Flutter para gerenciamento de tarefas com suporte a geolocalizacao.

<p align="center">
  <img src="https://kommodo.ai/i/K7wcnr3ejhZwYw2NViNQ" 
       alt="Geo Tasks"
       width="60%"/>
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

1. Instale as dependencias:

```bash
flutter pub get
```

2. Rode o projeto:

```bash
flutter run
```

## Observacao

Atualmente os dados das tarefas ficam em memoria (sem persistencia local). Ao fechar o app, a lista e reiniciada.
