import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geo_tasks/core/theme/app_colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final bool isCompleted;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.location,
    required this.isCompleted,
    required this.onDelete,
    required this.onComplete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.75,
              children: [
                SlidableAction(
                  onPressed: (_) => onComplete(),
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.onPrimary,
                  icon: Icons.check_circle,
                  label: 'Concluir',
                ),
                SlidableAction(
                  onPressed: (_) => onEdit(),
                  backgroundColor: AppColors.warning,
                  foregroundColor: AppColors.onPrimary,
                  icon: Icons.edit,
                  label: 'Editar',
                ),
                SlidableAction(
                  onPressed: (_) => onDelete(),
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.onPrimary,
                  icon: Icons.delete,
                  label: 'Excluir',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLowest,
                border: Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 8,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // DATA / HORA
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // CHIPS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                        ),
                        label: Text(location),
                      ),

                      Chip(
                        backgroundColor: isCompleted
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.warning.withValues(alpha: 0.15),
                        label: Text(
                          isCompleted ? 'Concluída' : 'Pendente',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
