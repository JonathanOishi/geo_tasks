import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';

class AddEditTaskArgs {
  const AddEditTaskArgs({
    required this.tasksViewModel,
    this.task,
  });

  final TasksViewModel tasksViewModel;
  final Task? task;

  bool get isEditing => task != null;
}
