import 'dart:collection';

import 'package:geo_tasks/features/tasks/models/task.dart';

class TaskRepository {
  final List<Task> _tasks = <Task>[];

  UnmodifiableListView<Task> getTasks() => UnmodifiableListView<Task>(_tasks);

  Task getTaskAt(int index) => _tasks[index];

  void addTask(Task task) {
    _tasks.add(task);
  }

  void updateTask(int index, Task task) {
    _tasks[index] = task;
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
  }

  void toggleTaskCompletion(int index) {
    final current = _tasks[index];
    _tasks[index] = current.copyWith(isCompleted: !current.isCompleted);
  }
}
