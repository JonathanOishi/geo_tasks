import 'package:flutter/material.dart';

String? validateTaskForm({
  required String title,
  required DateTime? date,
  required TimeOfDay? time,
}) {
  if (title.trim().isEmpty) {
    return 'Informe o nome da tarefa.';
  }
  if (date == null) {
    return 'Selecione uma data.';
  }
  if (time == null) {
    return 'Selecione um horario.';
  }
  return null;
}
