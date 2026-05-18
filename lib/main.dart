import 'package:flutter/material.dart';
import 'package:geo_tasks/core/theme/app_theme.dart';

import 'package:geo_tasks/pages/home_page.dart';
import 'package:geo_tasks/routes/app_routes.dart';

void main() {
  runApp(const GeoTasks());
}

class GeoTasks extends StatelessWidget {
  const GeoTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: AppTheme.light,
      routes: AppRoutes.routes,
    );
  }
}
