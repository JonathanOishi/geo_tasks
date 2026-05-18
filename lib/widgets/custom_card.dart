import 'package:flutter/material.dart';
import 'package:geo_tasks/core/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comprar Suplementos',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.edit),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.calendar_month_outlined),
                Text("17:00"),
                Icon(
                  Icons.delete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Farmacia 24h'),
                SizedBox(width: 40),
                Text('Pendente'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
