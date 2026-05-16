import 'package:flutter/material.dart';
import 'package:geo_tasks/core/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: AppColors.primary,
          shadowColor: Colors.red,
          surfaceTintColor: Colors.white,

          child: Text('Teste'),
        ),
      ),
    );
  }
}
