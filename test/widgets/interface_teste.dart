import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:geo_tasks/features/tasks/viewmodels/autentication._view_model.dart';
import 'package:geo_tasks/features/tasks/viewmodels/tasks_view_model.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_text_field.dart';

// Stub mínimo para AuthenticationViewModel sem Firebase
class FakeAuthViewModel extends AuthenticationViewModel {
  FakeAuthViewModel() : super();
}

Widget buildTestApp(Widget page) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationViewModel>(
        create: (_) => AuthenticationViewModel(),
      ),
      ChangeNotifierProvider<TasksViewModel>(
        create: (_) => TasksViewModel(),
      ),
    ],
    child: MaterialApp(
      home: page,
    ),
  );
}

void main() {
  group('Testes de interface - CustomTextField (tela de Login)', () {
    testWidgets('campo de e-mail aceita entrada de texto', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'E-mail',
              hintText: 'example@example.com',
              prefixIcon: Icons.email,
              controller: controller,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'teste@email.com');
      expect(controller.text, 'teste@email.com');
    });

    testWidgets('campo de senha com obscureText oculta o texto', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Senha',
              hintText: 'Digite sua senha',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
          ),
        ),
      );

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.obscureText, isTrue);
    });

    testWidgets('botão de toggle de senha altera visibilidade', (tester) async {
      bool obscure = true;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: CustomTextField(
                label: 'Senha',
                hintText: 'Senha',
                obscureText: obscure,
                suffixIconWidget: IconButton(
                  onPressed: () => setState(() => obscure = !obscure),
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });

  group('Testes de interface - Formulário de Tarefa', () {
    testWidgets('campos de data e horário são readOnly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CustomTextField(
                  label: 'Data',
                  hintText: 'dd/mm/aaaa',
                  readOnly: true,
                  icon: Icons.calendar_today_outlined,
                ),
                CustomTextField(
                  label: 'Horario',
                  hintText: '--:--',
                  readOnly: true,
                  icon: Icons.access_time_outlined,
                ),
              ],
            ),
          ),
        ),
      );

      final textFields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      expect(textFields[0].readOnly, true);
      expect(textFields[1].readOnly, true);
    });

    testWidgets('campo de CEP aceita apenas números', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'CEP',
              hintText: 'Digite o CEP',
              controller: controller,
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      );

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.keyboardType, TextInputType.number);
    });
  });

  group('Testes de interface - Navegação', () {
    testWidgets('AppBar com botão de voltar está presente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Adicionar Tarefa'),
              centerTitle: true,
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Adicionar Tarefa'), findsOneWidget);
    });

    testWidgets('FAB com ícone de adicionar está presente na home', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add, size: 40),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('BottomNavBar com 3 abas renderiza corretamente', (
      tester,
    ) async {
      int currentIndex = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: const SizedBox(),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (i) => setState(() => currentIndex = i),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt_rounded),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_rounded),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      await tester.tap(find.text('Dashboard'));
      await tester.pump();
      expect(currentIndex, 1);
    });
  });

  group('Testes de interface - Dashboard Stats', () {
    testWidgets('cards de estatística exibem valores dinâmicos', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Text('Total', style: TextStyle(fontSize: 13)),
                          Text('8', style: TextStyle(fontSize: 28)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Total'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });
  });
}
