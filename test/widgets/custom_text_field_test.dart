import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_text_field.dart';
import 'package:geo_tasks/features/tasks/widgets/profile_app_bar_avatar.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('CustomTextField', () {
    testWidgets('exibe label quando fornecido', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextField(label: 'E-mail', hintText: 'Digite seu e-mail'),
        ),
      );
      expect(find.text('E-mail'), findsOneWidget);
    });

    testWidgets('não exibe label quando não fornecido', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextField(hintText: 'Digite algo'),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('exibe hintText', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextField(hintText: 'example@example.com'),
        ),
      );
      expect(find.text('example@example.com'), findsOneWidget);
    });

    testWidgets('exibe prefixIcon quando fornecido', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextField(hintText: 'Email', prefixIcon: Icons.email),
        ),
      );
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('não exibe prefixIcon quando não fornecido', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextField(hintText: 'Email'),
        ),
      );
      expect(find.byIcon(Icons.email), findsNothing);
    });

    testWidgets('exibe suffixIconWidget quando fornecido', (tester) async {
      await tester.pumpWidget(
        wrap(
          CustomTextField(
            hintText: 'Senha',
            suffixIconWidget: const Icon(Icons.visibility),
          ),
        ),
      );
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('campo é readOnly quando readOnly=true', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(
          CustomTextField(
            hintText: 'Data',
            controller: controller,
            readOnly: true,
          ),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, true);
    });

    testWidgets('campo não é readOnly por padrão', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextField(hintText: 'Nome'),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, false);
    });

    testWidgets('oscurece texto quando obscureText=true', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CustomTextField(hintText: 'Senha', obscureText: true),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('chama onTap quando campo é tocado e readOnly=true', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrap(
          CustomTextField(
            hintText: 'Data',
            readOnly: true,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(tapped, true);
    });

    testWidgets('controller recebe o texto digitado', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        wrap(
          CustomTextField(hintText: 'Nome', controller: controller),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Jonathan');
      expect(controller.text, 'Jonathan');
    });
  });

  group('ProfileAppBarAvatar', () {
    testWidgets('exibe ícone de pessoa quando imageBase64 é null', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const ProfileAppBarAvatar(imageBase64: null),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('exibe ícone de pessoa quando imageBase64 está vazio', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const ProfileAppBarAvatar(imageBase64: ''),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renderiza CircleAvatar', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ProfileAppBarAvatar(imageBase64: null),
        ),
      );
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('tamanho padrão é 56', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ProfileAppBarAvatar(imageBase64: null),
        ),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, 56);
    });

    testWidgets('tamanho customizável via parâmetro size', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ProfileAppBarAvatar(imageBase64: null, size: 80),
        ),
      );
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, 80);
    });
  });
}
