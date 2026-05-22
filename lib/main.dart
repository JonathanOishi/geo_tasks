import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/app/theme/app_theme.dart';
import 'package:geo_tasks/features/tasks/views/home_page.dart';
import 'package:provider/provider.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';

void main() {
  runApp(const GeoTasksApp());
}

class GeoTasksApp extends StatelessWidget {
  const GeoTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TasksViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: AppTheme.light,
        routes: AppRoutes.routes,
      ),
    );
  }
}
