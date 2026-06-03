import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHistoryTaskCard extends StatelessWidget {
  const DashboardHistoryTaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.completedLabel,
  });

  final String title;
  final String subtitle;
  final String? location;
  final String completedLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF0F6F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.lineThrough,
                      color: Color(0xFF374B49),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFB8C4C2)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Color(0xFF7E8D8B),
                ),
                const SizedBox(width: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7E8D8B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (location != null && location!.trim().isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.location_on_outlined, size: 18),
                    label: Text(location!),
                  ),
                Chip(
                  backgroundColor: AppColors.success.withValues(alpha: 0.14),
                  label: Text(completedLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardEmptyHistory extends StatelessWidget {
  const DashboardEmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          'Nenhuma tarefa concluida ainda.',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
