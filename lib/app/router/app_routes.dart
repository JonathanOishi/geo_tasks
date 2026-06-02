import 'package:flutter/material.dart';
import 'package:geo_tasks/features/tasks/views/add_edit_task_page.dart';
import 'package:geo_tasks/features/tasks/views/dashboard_page.dart';
import 'package:geo_tasks/features/tasks/views/login_page.dart';
import 'package:geo_tasks/features/tasks/views/profile_page.dart';
import 'package:geo_tasks/features/tasks/views/register_page.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_nav_bar.dart';

class AppRoutes {
  static const String addEditTask = '/add-edit-task';
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      addEditTask: (context) => const AddEditTaskPage(),
      login: (context) => const LoginPage(),
      home: (context) => const CustomNavBar(),
      register: (context) => const RegisterPage(),
      profile: (context) => const ProfilePage(),
      dashboard: (context) => const DashboardPage(),
    };
  }
}
