import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/tasks/services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        initialRoute: AppRoutes.login,
        theme: AppTheme.light,
        routes: AppRoutes.routes,
      ),
    );
  }
}
