import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/repositories/task_repository.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel({TaskRepository? repository})
    : _repository = repository ?? TaskRepository();

  final TaskRepository _repository;

  UnmodifiableListView<Task> get tasks => _repository.getTasks();

  Task taskAt(int index) => _repository.getTaskAt(index);

  void addTask(Task task) {
    _repository.addTask(task);
    notifyListeners();
  }

  void updateTask(int index, Task task) {
    _repository.updateTask(index, task);
    notifyListeners();
  }

  void deleteTask(int index) {
    _repository.deleteTask(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    _repository.toggleTaskCompletion(index);
    notifyListeners();
  }
}
