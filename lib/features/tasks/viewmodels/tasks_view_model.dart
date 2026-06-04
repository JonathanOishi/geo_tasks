import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/repositories/task_repository.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel({firebase_auth.FirebaseAuth? auth})
    : _auth = auth ?? firebase_auth.FirebaseAuth.instance {
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
    _onAuthChanged(_auth.currentUser);
  }

  final firebase_auth.FirebaseAuth _auth;
  TaskRepository? _repository;
  StreamSubscription<firebase_auth.User?>? _authSubscription;
  List<Task> _tasks = <Task>[];
  bool _isLoading = true;
  String? _errorMessage;

  UnmodifiableListView<Task> get tasks => UnmodifiableListView<Task>(_tasks);
  UnmodifiableListView<Task> get activeTasks => UnmodifiableListView<Task>(
    _tasks.where((task) => !task.isCompleted).toList(growable: false),
  );
  UnmodifiableListView<Task> get completedTasks => UnmodifiableListView<Task>(
    _tasks.where((task) => task.isCompleted).toList(growable: false),
  );
  int get totalTasksCount => _tasks.length;
  int get pendingTasksCount => activeTasks.length;
  int get completedTasksCount => completedTasks.length;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Task taskAt(int index) => _tasks[index];

  String historySubtitleFor(Task task) => 'Hoje, ${task.timeLabel}';

  Future<void> addTask(Task task) async {
    if (_repository == null) return;
    await _repository!.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    if (_repository == null) return;
    await _repository!.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    if (_repository == null) return;
    await _repository!.deleteTask(task.uid);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    if (_repository == null) return;
    await _repository!.toggleTaskCompletion(task);
  }

  Future<void> _onAuthChanged(firebase_auth.User? user) async {
    _isLoading = true;
    _errorMessage = null;
    _tasks = <Task>[];
    await _repository?.dispose();
    _repository = null;
    notifyListeners();

    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _repository = TaskRepository(userId: user.uid);
    _repository!.listenToTasks(
      onTasks: (tasks) {
        _tasks = tasks;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar tarefas: $error';
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _repository?.dispose();
    super.dispose();
  }
}
