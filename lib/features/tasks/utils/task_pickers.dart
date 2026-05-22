import 'package:flutter/material.dart';

Future<DateTime?> pickTaskDate({
  required BuildContext context,
  required DateTime? selectedDate,
}) async {
  final now = DateTime.now();

  return showDatePicker(
    context: context,
    initialDate: selectedDate ?? now,
    firstDate: DateTime(now.year - 1),
    lastDate: DateTime(now.year + 5),
    helpText: 'Selecione a data',
    cancelText: 'Cancelar',
    confirmText: 'OK',
  );
}

Future<TimeOfDay?> pickTaskTime({
  required BuildContext context,
  required TimeOfDay? selectedTime,
}) async {
  return showTimePicker(
    context: context,
    initialTime: selectedTime ?? TimeOfDay.now(),
    helpText: 'Selecione o horario',
    cancelText: 'Cancelar',
    confirmText: 'OK',
  );
}
