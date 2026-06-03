import 'package:flutter/material.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/viewmodels/autentication._view_model.dart';
import 'package:geo_tasks/features/tasks/viewmodels/crud_view_model.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:provider/provider.dart';
import 'package:geo_tasks/features/tasks/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CrudViewModel _crudViewModel = CrudViewModel();

  @override
  Widget build(BuildContext context) {
    final tasksViewModel = Provider.of<TasksViewModel>(context);
    final authVm = context.watch<AuthenticationViewModel>();
    final userName = authVm.currentUserData?.name ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
        titleSpacing: 20,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ola, $userName',
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: FloatingActionButton(
          onPressed: () => _crudViewModel.openAddTask(context),
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Builder(
        builder: (context) {
          if (tasksViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (tasksViewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  tasksViewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final tasks = tasksViewModel.activeTasks;

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma tarefa pendente.',
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
                onDelete: () async {
                  await tasksViewModel.deleteTask(index);
                },
                onComplete: () async {
                  await tasksViewModel.toggleTaskCompletion(index);
                },
                onEdit: () => _crudViewModel.editTask(context, index),
                onSetCurrentLocation: () =>
                    _crudViewModel.setCurrentLocationForTask(
                      context,
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
