import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:geo_tasks/features/tasks/widgets/dashboard_widgets.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksViewModel = context.watch<TasksViewModel>();

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
              'Geo Tasks',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B7267),
                height: 1.1,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historico de Tarefas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DashboardStatCard(
                    title: 'Total',
                    value: tasksViewModel.totalTasksCount.toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardStatCard(
                    title: 'Pendentes',
                    value: tasksViewModel.pendingTasksCount.toString(),
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardStatCard(
                    title: 'Concluidas',
                    value: tasksViewModel.completedTasksCount.toString(),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Historico de concluidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (tasksViewModel.completedTasks.isEmpty)
              const DashboardEmptyHistory()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasksViewModel.completedTasks.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = tasksViewModel.completedTasks[index];

                  return DashboardHistoryTaskCard(
                    title: task.title,
                    subtitle: tasksViewModel.historySubtitleFor(task),
                    location: task.location,
                    completedLabel: task.statusLabel,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
