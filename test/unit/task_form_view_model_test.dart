import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/viewmodels/task_form_view_model.dart';

void main() {
  group('TaskFormViewModel', () {
    late TaskFormViewModel vm;

    setUp(() {
      vm = TaskFormViewModel();
    });

    tearDown(() {
      vm.dispose();
    });

    group('initialize', () {
      test('não preenche campos quando task é null', () {
        vm.initialize(null);
        expect(vm.titleController.text, '');
        expect(vm.dateController.text, '');
        expect(vm.timeController.text, '');
        expect(vm.locationController.text, '');
      });

      test('preenche campos com dados da task existente', () {
        final task = Task(
          uid: 'uid-1',
          title: 'Buscar encomenda',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 14, minute: 30),
          location: 'Correios',
          latitude: -23.5,
          longitude: -46.6,
        );

        vm.initialize(task);

        expect(vm.titleController.text, 'Buscar encomenda');
        expect(vm.dateController.text, '15/06/2025');
        expect(vm.timeController.text, '14:30');
        expect(vm.locationController.text, 'Correios');
      });

      test('inicializa apenas uma vez (segunda chamada ignorada)', () {
        final task = Task(
          uid: 'uid-1',
          title: 'Original',
          date: DateTime(2025, 1, 1),
          time: const TimeOfDay(hour: 8, minute: 0),
        );

        vm.initialize(task);
        vm.titleController.text = 'Modificado';

        // Chamar de novo não deve sobrescrever
        vm.initialize(task);
        expect(vm.titleController.text, 'Modificado');
      });

      test('preenche location como vazio quando task.location é null', () {
        final task = Task(
          uid: 'uid-1',
          title: 'Tarefa',
          date: DateTime(2025, 1, 1),
          time: const TimeOfDay(hour: 8, minute: 0),
          location: null,
        );
        vm.initialize(task);
        expect(vm.locationController.text, '');
      });
    });

    group('validate', () {
      test('retorna erro quando título vazio e sem data/hora', () {
        vm.initialize(null);
        final error = vm.validate();
        expect(error, isNotNull);
        expect(error, contains('nome da tarefa'));
      });

      test('retorna null quando formulário está completo', () {
        final task = Task(
          uid: 'uid-1',
          title: 'Tarefa',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 10, minute: 0),
        );
        vm.initialize(task);
        expect(vm.validate(), null);
      });

      test(
        'retorna erro de data quando título preenchido mas data ausente',
        () {
          vm.initialize(null);
          vm.titleController.text = 'Tarefa';
          final error = vm.validate();
          expect(error, contains('data'));
        },
      );
    });

    group('buildTask', () {
      test('cria nova task com uid único quando sem existingTask', () {
        final task = Task(
          uid: 'uid-1',
          title: 'Original',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 10, minute: 0),
        );
        vm.initialize(task);
        vm.titleController.text = 'Nova Tarefa';

        final built = vm.buildTask();
        expect(built.title, 'Nova Tarefa');
        expect(built.isCompleted, false);
      });

      test('mantém uid da existingTask ao editar', () {
        final existing = Task(
          uid: 'uid-existente',
          title: 'Original',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 10, minute: 0),
        );
        vm.initialize(existing);

        final built = vm.buildTask(existingTask: existing);
        expect(built.uid, 'uid-existente');
      });

      test('mantém isCompleted da existingTask', () {
        final existing = Task(
          uid: 'uid-1',
          title: 'Tarefa',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 10, minute: 0),
          isCompleted: true,
        );
        vm.initialize(existing);

        final built = vm.buildTask(existingTask: existing);
        expect(built.isCompleted, true);
      });

      test('location fica null quando campo de localização está vazio', () {
        final task = Task(
          uid: 'uid-1',
          title: 'Tarefa',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 10, minute: 0),
          location: null,
        );
        vm.initialize(task);

        final built = vm.buildTask(existingTask: task);
        expect(built.location, null);
      });

      test('location é preenchida quando locationController tem texto', () {
        final task = Task(
          uid: 'uid-1',
          title: 'Tarefa',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 10, minute: 0),
        );
        vm.initialize(task);
        vm.locationController.text = 'Meu local';

        final built = vm.buildTask(existingTask: task);
        expect(built.location, 'Meu local');
      });

      test('título é trimado antes de criar a task', () {
        final task = Task(
          uid: 'uid-1',
          title: '  Tarefa com espaços  ',
          date: DateTime(2025, 6, 15),
          time: const TimeOfDay(hour: 10, minute: 0),
        );
        vm.initialize(task);

        final built = vm.buildTask(existingTask: task);
        expect(built.title, 'Tarefa com espaços');
      });
    });

    test('dispose não lança exceção', () {
      final localVm = TaskFormViewModel();
      expect(() => localVm.dispose(), returnsNormally);
    });
  });
}
