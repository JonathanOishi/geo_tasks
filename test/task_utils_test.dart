import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/utils/task_validators.dart';
import 'package:geo_tasks/features/tasks/utils/task_formatters.dart';

void main() {
  group('validateTaskForm', () {
    final date = DateTime(2025, 6, 15);
    const time = TimeOfDay(hour: 10, minute: 0);

    test('retorna null quando todos os campos são válidos', () {
      expect(
        validateTaskForm(title: 'Tarefa', date: date, time: time),
        null,
      );
    });

    test('retorna erro quando título está vazio', () {
      expect(
        validateTaskForm(title: '', date: date, time: time),
        'Informe o nome da tarefa.',
      );
    });

    test('retorna erro quando título é só espaços', () {
      expect(
        validateTaskForm(title: '   ', date: date, time: time),
        'Informe o nome da tarefa.',
      );
    });

    test('retorna erro quando data é null', () {
      expect(
        validateTaskForm(title: 'Tarefa', date: null, time: time),
        'Selecione uma data.',
      );
    });

    test('retorna erro quando hora é null', () {
      expect(
        validateTaskForm(title: 'Tarefa', date: date, time: null),
        'Selecione um horario.',
      );
    });

    test('valida título com apenas um caractere', () {
      expect(
        validateTaskForm(title: 'A', date: date, time: time),
        null,
      );
    });

    test('título com espaços em volta é válido', () {
      expect(
        validateTaskForm(title: '  Tarefa  ', date: date, time: time),
        null,
      );
    });

    test('prioriza erro de título antes de data', () {
      expect(
        validateTaskForm(title: '', date: null, time: null),
        'Informe o nome da tarefa.',
      );
    });

    test('prioriza erro de data antes de hora', () {
      expect(
        validateTaskForm(title: 'Tarefa', date: null, time: null),
        'Selecione uma data.',
      );
    });
  });

  group('formatTaskDate', () {
    test('formata data com dia e mês de dois dígitos', () {
      expect(formatTaskDate(DateTime(2025, 12, 25)), '25/12/2025');
    });

    test('formata data com zero à esquerda para dia', () {
      expect(formatTaskDate(DateTime(2025, 1, 5)), '05/01/2025');
    });

    test('formata data com zero à esquerda para mês', () {
      expect(formatTaskDate(DateTime(2025, 3, 20)), '20/03/2025');
    });

    test('formata data do começo do ano', () {
      expect(formatTaskDate(DateTime(2024, 1, 1)), '01/01/2024');
    });

    test('formata data do fim do ano', () {
      expect(formatTaskDate(DateTime(2024, 12, 31)), '31/12/2024');
    });
  });

  group('formatTaskTime', () {
    test('formata hora e minuto com dois dígitos', () {
      expect(formatTaskTime(const TimeOfDay(hour: 14, minute: 30)), '14:30');
    });

    test('formata hora e minuto com zero à esquerda', () {
      expect(formatTaskTime(const TimeOfDay(hour: 9, minute: 5)), '09:05');
    });

    test('formata meia-noite', () {
      expect(formatTaskTime(const TimeOfDay(hour: 0, minute: 0)), '00:00');
    });

    test('formata horário de pico (23:59)', () {
      expect(formatTaskTime(const TimeOfDay(hour: 23, minute: 59)), '23:59');
    });
  });
}
