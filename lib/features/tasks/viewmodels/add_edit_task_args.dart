import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';

class AddEditTaskArgs {
  const AddEditTaskArgs({
    required this.tasksViewModel,
    this.taskIndex,
  });

  final TasksViewModel tasksViewModel;
  final int? taskIndex;

  bool get isEditing => taskIndex != null;

  Task? get task {
    if (taskIndex == null) return null;
    return tasksViewModel.taskAt(taskIndex!);
  }
}
