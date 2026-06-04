import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String? location;
  final bool isCompleted;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onSetCurrentLocation;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.location,
    required this.isCompleted,
    required this.onDelete,
    required this.onComplete,
    required this.onEdit,
    required this.onSetCurrentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: const BoxDecoration(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Usar localizacao atual',
                        onPressed: onSetCurrentLocation,
                        constraints: const BoxConstraints.tightFor(
                          width: 34,
                          height: 34,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.my_location_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (location != null && location!.trim().isNotEmpty)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                          ),
                          label: Text(location!),
                        ),
                      Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: isCompleted
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.warning.withValues(alpha: 0.15),
                        label: Text(
                          isCompleted ? 'Concluida' : 'Pendente',
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
