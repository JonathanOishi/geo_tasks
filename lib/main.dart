import 'package:flutter/material.dart';
import 'package:geo_tasks/app/router/app_routes.dart';
import 'package:geo_tasks/app/theme/app_theme.dart';
import 'package:geo_tasks/features/tasks/viewmodels/autentication._view_model.dart';
import 'package:provider/provider.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/tasks/services/firebase_options.dart';
import 'package:geo_tasks/features/tasks/views/login_page.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GeoTasksApp());
}

class GeoTasksApp extends StatelessWidget {
  const GeoTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TasksViewModel()),
        ChangeNotifierProvider(create: (_) => AuthenticationViewModel()),
      ],
      child: MaterialApp(
        home: Consumer<AuthenticationViewModel>(
          builder: (context, authVm, _) {
            if (authVm.isLoggedIn) {
              return const CustomNavBar();
            }
            return const LoginPage();
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routes: AppRoutes.routes,
      ),
    );
  }
}
