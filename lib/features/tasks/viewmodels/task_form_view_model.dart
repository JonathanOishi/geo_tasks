import 'package:flutter/material.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/utils/task_formatters.dart';
import 'package:geo_tasks/features/tasks/utils/task_pickers.dart';
import 'package:geo_tasks/features/tasks/utils/task_validators.dart';
import 'package:geo_tasks/features/tasks/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class TaskFormViewModel extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isInitialized = false;
  Position? currentPosition;
  double? _latitude;
  double? _longitude;

  void initialize(Task? task) {
    if (_isInitialized) return;

    if (task != null) {
      titleController.text = task.title;
      dateController.text = formatTaskDate(task.date);
      timeController.text = formatTaskTime(task.time);
      locationController.text = task.location ?? '';
      _latitude = task.latitude;
      _longitude = task.longitude;
      _selectedDate = task.date;
      _selectedTime = task.time;
    }

    _isInitialized = true;
  }

  Future<void> pickDate(BuildContext context) async {
    final result = await pickTaskDate(
      context: context,
      selectedDate: _selectedDate,
    );
    if (result == null) return;

    _selectedDate = result;
    dateController.text = formatTaskDate(result);
    notifyListeners();
  }

  Future<void> pickTime(BuildContext context) async {
    final result = await pickTaskTime(
      context: context,
      selectedTime: _selectedTime,
    );
    if (result == null) return;

    _selectedTime = result;
    timeController.text = formatTaskTime(result);
    notifyListeners();
  }

  String? validate() {
    return validateTaskForm(
      title: titleController.text,
      date: _selectedDate,
      time: _selectedTime,
    );
  }

  Task buildTask({Task? existingTask}) {
    return Task(
      uid: existingTask?.uid ?? UniqueKey().toString(),
      title: titleController.text.trim(),
      date: _selectedDate!,
      time: _selectedTime!,
      location: locationController.text.trim().isNotEmpty
          ? locationController.text.trim()
          : null,
      latitude: _latitude ?? existingTask?.latitude,
      longitude: _longitude ?? existingTask?.longitude,
      isCompleted: existingTask?.isCompleted ?? false,
    );
  }

  final LocationService _locationService = LocationService();

  Future<String?> searchLocation() async {
    try {
      currentPosition = await _locationService.determinePosition();
      _latitude = currentPosition!.latitude;
      _longitude = currentPosition!.longitude;
      if (locationController.text.trim().isEmpty) {
        locationController.text = 'Meu local';
      }
      notifyListeners();
      return null;
    } catch (e) {
      return 'Erro ao obter localização: $e';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
