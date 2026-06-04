// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/services/location_service.dart';
import 'package:geo_tasks/features/tasks/viewmodels/add_edit_task_args.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:provider/provider.dart';

class CrudViewModel {
  final LocationService _locationService = LocationService();

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> setCurrentLocationForTask(
    BuildContext context,
    Task task,
  ) async {
    try {
      final position = await _locationService.determinePosition();
      if (!context.mounted) return;

      final tasksViewModel = Provider.of<TasksViewModel>(
        context,
        listen: false,
      );

      final locationName =
          (task.location != null && task.location!.trim().isNotEmpty)
          ? task.location!
          : 'Meu local';

      await tasksViewModel.updateTask(
        task.copyWith(
          location: locationName,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      _showMessage(context, 'Localizacao atual vinculada a tarefa.');
    } catch (e) {
      if (!context.mounted) return;
      _showMessage(context, 'Erro ao capturar localizacao: $e');
    }
  }

  Future<void> openAddTask(BuildContext context) async {
    final tasksViewModel = Provider.of<TasksViewModel>(context, listen: false);
    await Navigator.of(context).pushNamed(
      AppRoutes.addEditTask,
      arguments: AddEditTaskArgs(tasksViewModel: tasksViewModel),
    );
  }

  Future<void> editTask(BuildContext context, Task task) async {
    final tasksViewModel = Provider.of<TasksViewModel>(context, listen: false);
    await Navigator.of(context).pushNamed(
      AppRoutes.addEditTask,
      arguments: AddEditTaskArgs(
        tasksViewModel: tasksViewModel,
        task: task,
      ),
    );
  }
}
