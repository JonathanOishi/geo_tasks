import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';
import 'package:geo_tasks/features/tasks/viewmodels/autentication._view_model.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:geo_tasks/features/tasks/widgets/profile_app_bar_avatar.dart';
import 'package:geo_tasks/features/tasks/widgets/dashboard_widgets.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _confirmAndClearHistory(
    BuildContext context,
    TasksViewModel tasksViewModel,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir todo o historico?'),
          content: const Text(
            'Essa acao remove todas as tarefas concluidas e nao pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Excluir',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await tasksViewModel.clearCompletedTasksHistory();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Historico de concluidas excluido com sucesso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksViewModel = context.watch<TasksViewModel>();
    final authVm = context.watch<AuthenticationViewModel>();
    final user = authVm.currentUserData;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarBackground,
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
                color: AppColors.appBarTitle,
                height: 1.1,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProfileAppBarAvatar(imageBase64: user?.avatarBase64),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.appBarDivider,
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
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Historico de concluidas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                if (tasksViewModel.completedTasks.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _confirmAndClearHistory(
                      context,
                      tasksViewModel,
                    ),
                    icon: const Icon(
                      Icons.delete_sweep_outlined,
                      color: AppColors.error,
                    ),
                    label: const Text(
                      'Excluir historico',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
              ],
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
