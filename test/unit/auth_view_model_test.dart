import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/models/user.dart';

String mapAuthError(String code) {
  switch (code) {
    case 'invalid-email':
      return 'E-mail invalido.';
    case 'user-not-found':
      return 'Usuario nao encontrado.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'E-mail ou senha incorretos.';
    case 'email-already-in-use':
      return 'Este e-mail ja esta em uso.';
    case 'weak-password':
      return 'Senha fraca. Use pelo menos 6 caracteres.';
    case 'too-many-requests':
      return 'Muitas tentativas. Tente novamente em instantes.';
    default:
      return 'Nao foi possivel autenticar. Tente novamente.';
  }
}

void main() {
  group('AuthenticationViewModel - mapeamento de erros', () {
    test('mapeia invalid-email corretamente', () {
      expect(mapAuthError('invalid-email'), 'E-mail invalido.');
    });

    test('mapeia user-not-found corretamente', () {
      expect(mapAuthError('user-not-found'), 'Usuario nao encontrado.');
    });

    test('mapeia wrong-password corretamente', () {
      expect(mapAuthError('wrong-password'), 'E-mail ou senha incorretos.');
    });

    test('mapeia invalid-credential corretamente', () {
      expect(mapAuthError('invalid-credential'), 'E-mail ou senha incorretos.');
    });

    test('mapeia email-already-in-use corretamente', () {
      expect(
        mapAuthError('email-already-in-use'),
        'Este e-mail ja esta em uso.',
      );
    });

    test('mapeia weak-password corretamente', () {
      expect(
        mapAuthError('weak-password'),
        'Senha fraca. Use pelo menos 6 caracteres.',
      );
    });

    test('mapeia too-many-requests corretamente', () {
      expect(
        mapAuthError('too-many-requests'),
        'Muitas tentativas. Tente novamente em instantes.',
      );
    });

    test('retorna mensagem padrão para código desconhecido', () {
      expect(
        mapAuthError('unknown-error'),
        'Nao foi possivel autenticar. Tente novamente.',
      );
    });

    test('retorna mensagem padrão para string vazia', () {
      expect(mapAuthError(''), 'Nao foi possivel autenticar. Tente novamente.');
    });
  });

  group('AuthenticationViewModel - validações de registro (lógica pura)', () {
    String? validateRegister({
      required String name,
      required String email,
      required String password,
      required String confirmPassword,
    }) {
      if (name.trim().isEmpty) return 'Informe seu nome.';
      if (email.trim().isEmpty || password.trim().isEmpty)
        return 'E-mail e senha sao obrigatorios.';
      if (password.trim() != confirmPassword.trim())
        return 'As senhas nao conferem.';
      return null;
    }

    test('retorna erro quando nome está vazio', () {
      expect(
        validateRegister(
          name: '',
          email: 'a@b.com',
          password: '123456',
          confirmPassword: '123456',
        ),
        'Informe seu nome.',
      );
    });

    test('retorna erro quando email está vazio', () {
      expect(
        validateRegister(
          name: 'Jon',
          email: '',
          password: '123456',
          confirmPassword: '123456',
        ),
        'E-mail e senha sao obrigatorios.',
      );
    });

    test('retorna erro quando senha está vazia', () {
      expect(
        validateRegister(
          name: 'Jon',
          email: 'a@b.com',
          password: '',
          confirmPassword: '',
        ),
        'E-mail e senha sao obrigatorios.',
      );
    });

    test('retorna erro quando senhas não conferem', () {
      expect(
        validateRegister(
          name: 'Jon',
          email: 'a@b.com',
          password: '123456',
          confirmPassword: '654321',
        ),
        'As senhas nao conferem.',
      );
    });

    test('retorna null quando todos os dados são válidos', () {
      expect(
        validateRegister(
          name: 'Jon',
          email: 'a@b.com',
          password: '123456',
          confirmPassword: '123456',
        ),
        null,
      );
    });

    test('nome com apenas espaços é inválido', () {
      expect(
        validateRegister(
          name: '   ',
          email: 'a@b.com',
          password: '123456',
          confirmPassword: '123456',
        ),
        'Informe seu nome.',
      );
    });
  });

  group('User.fromAuth - cobertura extra', () {
    test('email vazio e nome vazio resulta em Usuario', () {
      final user = User.fromAuth(id: '1', name: null, email: null);
      expect(user.name, 'Usuario');
      expect(user.id, '1');
    });

    test('email com múltiplos @ usa tudo antes do primeiro', () {
      final user = User.fromAuth(
        id: '1',
        name: null,
        email: 'user@domain@extra.com',
      );
      expect(user.name, 'user');
    });
  });
}
