import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/services/location_service.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:provider/provider.dart';
import 'package:geo_tasks/features/tasks/viewmodels/add_edit_task_args.dart';
import 'package:geo_tasks/features/tasks/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _setCurrentLocationForTask(int index, Task task) async {
    try {
      final position = await _locationService.determinePosition();
      if (!mounted) return;

      final tasksViewModel = Provider.of<TasksViewModel>(
        context,
        listen: false,
      );

      final locationName =
          (task.location != null && task.location!.trim().isNotEmpty)
          ? task.location!
          : 'Meu local';

      tasksViewModel.updateTask(
        index,
        task.copyWith(
          location: locationName,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      _showMessage('Localizacao atual vinculada a tarefa.');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Erro ao capturar localizacao: $e');
    }
  }

  Future<void> _openAddTask() async {
    final tasksViewModel = Provider.of<TasksViewModel>(context, listen: false);
    await Navigator.of(context).pushNamed(
      AppRoutes.addEditTask,
      arguments: AddEditTaskArgs(tasksViewModel: tasksViewModel),
    );
  }

  Future<void> _editTask(int index) async {
    final tasksViewModel = Provider.of<TasksViewModel>(context, listen: false);
    await Navigator.of(context).pushNamed(
      AppRoutes.addEditTask,
      arguments: AddEditTaskArgs(
        tasksViewModel: tasksViewModel,
        taskIndex: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksViewModel = Provider.of<TasksViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 110,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
        titleSpacing: 20,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Ola, usuario',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B7267),
                height: 1.1,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Vamos organizar seu dia?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF58615F),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF17A89B),
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFDAF5F1),
                child: Icon(
                  Icons.person,
                  color: Color(0xFF0B7267),
                  size: 32,
                ),
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E8E7),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: Builder(
        builder: (context) {
          final tasks = tasksViewModel.tasks;

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma tarefa cadastrada ainda.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final Task task = tasks[index];
              final dateStr =
                  '${task.date.day.toString().padLeft(2, '0')}/${task.date.month.toString().padLeft(2, '0')}';
              final timeStr = task.time.format(context);
              final timeLabel = '$dateStr $timeStr';

              return TaskCard(
                title: task.title,
                time: timeLabel,
                location: task.location,
                isCompleted: task.isCompleted,
                onDelete: () => tasksViewModel.deleteTask(index),
                onComplete: () => tasksViewModel.toggleTaskCompletion(index),
                onEdit: () => _editTask(index),
                onSetCurrentLocation: () => _setCurrentLocationForTask(
                  index,
                  task,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
