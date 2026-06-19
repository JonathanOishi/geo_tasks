import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/widgets/task_card.dart';
import 'package:geo_tasks/features/tasks/widgets/dashboard_widgets.dart';

Widget wrapWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  group('TaskCard', () {
    Widget buildCard({
      String title = 'Buscar encomenda',
      String time = '15/06 14:30',
      String? location,
      bool isCompleted = false,
      VoidCallback? onDelete,
      VoidCallback? onComplete,
      VoidCallback? onEdit,
      VoidCallback? onSetCurrentLocation,
    }) {
      return wrapWidget(
        TaskCard(
          title: title,
          time: time,
          location: location,
          isCompleted: isCompleted,
          onDelete: onDelete ?? () {},
          onComplete: onComplete ?? () {},
          onEdit: onEdit ?? () {},
          onSetCurrentLocation: onSetCurrentLocation ?? () {},
        ),
      );
    }

    testWidgets('exibe título da tarefa', (tester) async {
      await tester.pumpWidget(buildCard(title: 'Buscar encomenda'));
      expect(find.text('Buscar encomenda'), findsOneWidget);
    });

    testWidgets('exibe horário da tarefa', (tester) async {
      await tester.pumpWidget(buildCard(time: '15/06 14:30'));
      expect(find.text('15/06 14:30'), findsOneWidget);
    });

    testWidgets('exibe chip de localização quando location não é null', (
      tester,
    ) async {
      await tester.pumpWidget(buildCard(location: 'Correios'));
      expect(find.text('Correios'), findsOneWidget);
    });

    testWidgets('não exibe chip de localização quando location é null', (
      tester,
    ) async {
      await tester.pumpWidget(buildCard(location: null));
      expect(find.text('Correios'), findsNothing);
    });

    testWidgets('exibe chip Pendente quando não concluída', (tester) async {
      await tester.pumpWidget(buildCard(isCompleted: false));
      expect(find.text('Pendente'), findsOneWidget);
    });

    testWidgets('exibe chip Concluida quando concluída', (tester) async {
      await tester.pumpWidget(buildCard(isCompleted: true));
      expect(find.text('Concluida'), findsOneWidget);
    });

    testWidgets('exibe ícone de localização GPS', (tester) async {
      await tester.pumpWidget(buildCard());
      expect(find.byIcon(Icons.my_location_outlined), findsOneWidget);
    });

    testWidgets('chama onSetCurrentLocation ao tocar no ícone GPS', (
      tester,
    ) async {
      bool called = false;
      await tester.pumpWidget(
        buildCard(onSetCurrentLocation: () => called = true),
      );
      await tester.tap(find.byIcon(Icons.my_location_outlined));
      await tester.pump();
      expect(called, true);
    });

    testWidgets('não exibe localização vazia como chip', (tester) async {
      await tester.pumpWidget(buildCard(location: '   '));
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);
    });
  });

  group('DashboardStatCard', () {
    testWidgets('exibe título e valor', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const DashboardStatCard(
            title: 'Total',
            value: '5',
            color: Colors.blue,
          ),
        ),
      );
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('exibe três cards de estatística lado a lado', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const Row(
            children: [
              Expanded(
                child: DashboardStatCard(
                  title: 'Total',
                  value: '10',
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: DashboardStatCard(
                  title: 'Pendentes',
                  value: '6',
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: DashboardStatCard(
                  title: 'Concluidas',
                  value: '4',
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Pendentes'), findsOneWidget);
      expect(find.text('Concluidas'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });
  });

  group('DashboardHistoryTaskCard', () {
    testWidgets('exibe título, subtítulo e status', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const DashboardHistoryTaskCard(
            title: 'Tarefa concluída',
            subtitle: 'Hoje, 14:30',
            location: 'Correios',
            completedLabel: 'Concluida',
          ),
        ),
      );
      expect(find.text('Tarefa concluída'), findsOneWidget);
      expect(find.text('Hoje, 14:30'), findsOneWidget);
      expect(find.text('Correios'), findsOneWidget);
      expect(find.text('Concluida'), findsOneWidget);
    });

    testWidgets('não exibe chip de localização quando location é null', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWidget(
          const DashboardHistoryTaskCard(
            title: 'Tarefa',
            subtitle: 'Hoje, 10:00',
            location: null,
            completedLabel: 'Concluida',
          ),
        ),
      );
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);
    });

    testWidgets('exibe ícone de calendário', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const DashboardHistoryTaskCard(
            title: 'Tarefa',
            subtitle: 'Hoje, 10:00',
            location: null,
            completedLabel: 'Concluida',
          ),
        ),
      );
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });
  });

  group('DashboardEmptyHistory', () {
    testWidgets('exibe mensagem de histórico vazio', (tester) async {
      await tester.pumpWidget(wrapWidget(const DashboardEmptyHistory()));
      expect(find.text('Nenhuma tarefa concluida ainda.'), findsOneWidget);
    });
  });
}
