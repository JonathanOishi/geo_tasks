import 'package:flutter/material.dart';
import 'package:geo_tasks/core/utils/task_formatters.dart';
import 'package:geo_tasks/core/utils/task_pickers.dart';
import 'package:geo_tasks/core/utils/task_validators.dart';
import 'package:geo_tasks/core/models/tasks.dart';

class TaskFormController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
  }

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
  }

  Future<void> pickDate(BuildContext context) async {
    final result = await pickTaskDate(
      context: context,
      selectedDate: _selectedDate,
    );
    if (result == null) return;

    _selectedDate = result;
    dateController.text = formatTaskDate(result);
  }

  Future<void> pickTime(BuildContext context) async {
    final result = await pickTaskTime(
      context: context,
      selectedTime: _selectedTime,
    );
    if (result == null) return;

    _selectedTime = result;
    timeController.text = formatTaskTime(result);
  }

  String? validate() {
    final error = validateTaskForm(
      title: titleController.text,
      date: _selectedDate,
      time: _selectedTime,
    );

    if (error != null) return error;
    return null;
  }

  void dispose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    notesController.dispose();
  }

  Task buildTask({Task? existingTask}) {
    return Task(
      uid: existingTask?.uid ?? UniqueKey().toString(),
      title: titleController.text,
      date: _selectedDate!,
      time: _selectedTime!,
      location: notesController.text.isNotEmpty ? notesController.text : null,
      isCompleted: existingTask?.isCompleted ?? false,
    );
  }
}
