// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geo_tasks/pages/add_edit_task_page.dart';

class AppRoutes {
  static const String ADDEDITTASK = "/AddEditTasks";

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      ADDEDITTASK: (context) => AddEditTaskPage(),
    };
  }
}
