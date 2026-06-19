import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';

void main() {
  group('Task', () {
    final task = Task(
      uid: 'uid-1',
      title: 'Buscar encomenda',
      date: DateTime(2025, 6, 15),
      time: const TimeOfDay(hour: 14, minute: 30),
      location: 'Correios',
      latitude: -23.5505,
      longitude: -46.6333,
      isCompleted: false,
    );

    // --- dateLabel ---
    test('dateLabel formata dia e mês com zero à esquerda', () {
      expect(task.dateLabel, '15/06');
    });

    test('dateLabel para dia e mês com dois dígitos', () {
      final t = task.copyWith(date: DateTime(2025, 12, 25));
      expect(t.dateLabel, '25/12');
    });

    test('dateLabel para dia com um dígito', () {
      final t = task.copyWith(date: DateTime(2025, 1, 5));
      expect(t.dateLabel, '05/01');
    });

    // --- timeLabel ---
    test('timeLabel formata hora e minuto com zero à esquerda', () {
      expect(task.timeLabel, '14:30');
    });

    test('timeLabel para hora e minuto de um dígito', () {
      final t = task.copyWith(time: const TimeOfDay(hour: 9, minute: 5));
      expect(t.timeLabel, '09:05');
    });

    test('timeLabel para meia-noite', () {
      final t = task.copyWith(time: const TimeOfDay(hour: 0, minute: 0));
      expect(t.timeLabel, '00:00');
    });

    // --- statusLabel ---
    test('statusLabel retorna Pendente quando não concluída', () {
      expect(task.statusLabel, 'Pendente');
    });

    test('statusLabel retorna Concluida quando concluída', () {
      final t = task.copyWith(isCompleted: true);
      expect(t.statusLabel, 'Concluida');
    });

    // --- copyWith ---
    test('copyWith mantém campos não alterados', () {
      final copy = task.copyWith(title: 'Novo titulo');
      expect(copy.uid, task.uid);
      expect(copy.title, 'Novo titulo');
      expect(copy.date, task.date);
      expect(copy.time, task.time);
      expect(copy.location, task.location);
      expect(copy.latitude, task.latitude);
      expect(copy.longitude, task.longitude);
      expect(copy.isCompleted, task.isCompleted);
    });

    test('copyWith pode alterar isCompleted', () {
      final copy = task.copyWith(isCompleted: true);
      expect(copy.isCompleted, true);
    });

    // --- toJson / fromJson ---
    test('toJson contém todos os campos', () {
      final json = task.toJson();
      expect(json['uid'], 'uid-1');
      expect(json['title'], 'Buscar encomenda');
      expect(json['isCompleted'], false);
      expect(json['location'], 'Correios');
      expect(json['latitude'], -23.5505);
      expect(json['longitude'], -46.6333);
      expect(json['timeHour'], 14);
      expect(json['timeMinute'], 30);
    });

    test('fromJson reconstrói o objeto corretamente', () {
      final json = task.toJson();
      final restored = Task.fromJson(json);
      expect(restored.uid, task.uid);
      expect(restored.title, task.title);
      expect(restored.date, task.date);
      expect(restored.time.hour, task.time.hour);
      expect(restored.time.minute, task.time.minute);
      expect(restored.location, task.location);
      expect(restored.latitude, task.latitude);
      expect(restored.longitude, task.longitude);
      expect(restored.isCompleted, task.isCompleted);
    });

    test('fromJson com isCompleted ausente usa false como padrão', () {
      final json = task.toJson()..remove('isCompleted');
      final restored = Task.fromJson(json);
      expect(restored.isCompleted, false);
    });

    test('fromJson com latitude e longitude nulos', () {
      final json = task.toJson();
      json['latitude'] = null;
      json['longitude'] = null;
      final restored = Task.fromJson(json);
      expect(restored.latitude, null);
      expect(restored.longitude, null);
    });

    test('toJson e fromJson são simétricos para tarefa concluída', () {
      final completed = task.copyWith(isCompleted: true);
      final restored = Task.fromJson(completed.toJson());
      expect(restored.isCompleted, true);
    });
  });
}
