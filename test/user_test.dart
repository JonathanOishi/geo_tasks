import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/models/user.dart';

void main() {
  group('User.fromAuth', () {
    test('usa nome quando fornecido', () {
      final user = User.fromAuth(
        id: '1',
        name: 'Jonathan',
        email: 'jon@test.com',
      );
      expect(user.name, 'Jonathan');
      expect(user.email, 'jon@test.com');
    });

    test('usa parte do email quando nome está vazio', () {
      final user = User.fromAuth(id: '1', name: '', email: 'jonathan@test.com');
      expect(user.name, 'jonathan');
    });

    test('usa parte do email quando nome é null', () {
      final user = User.fromAuth(
        id: '1',
        name: null,
        email: 'jonathan@test.com',
      );
      expect(user.name, 'jonathan');
    });

    test('usa "Usuario" quando nome e email estão vazios', () {
      final user = User.fromAuth(id: '1', name: null, email: null);
      expect(user.name, 'Usuario');
    });

    test('usa "Usuario" quando email não tem @', () {
      final user = User.fromAuth(id: '1', name: '', email: 'semArroba');
      expect(user.name, 'Usuario');
    });

    test('armazena avatarBase64 quando fornecido', () {
      final user = User.fromAuth(
        id: '1',
        name: 'Jon',
        email: 'j@t.com',
        avatarBase64: 'abc123',
      );
      expect(user.avatarBase64, 'abc123');
    });

    test('avatarBase64 é null por padrão', () {
      final user = User.fromAuth(id: '1', name: 'Jon', email: 'j@t.com');
      expect(user.avatarBase64, null);
    });
  });

  group('User.fromFirestore', () {
    test('usa dados do Firestore quando presentes', () {
      final user = User.fromFirestore(
        id: '1',
        data: {'name': 'Maria', 'email': 'maria@test.com'},
      );
      expect(user.name, 'Maria');
      expect(user.email, 'maria@test.com');
    });

    test('usa fallback quando dados são null', () {
      final user = User.fromFirestore(
        id: '1',
        data: null,
        fallbackName: 'Fallback',
        fallbackEmail: 'fallback@test.com',
      );
      expect(user.name, 'Fallback');
      expect(user.email, 'fallback@test.com');
    });

    test('usa fallback quando campos do Firestore são null', () {
      final user = User.fromFirestore(
        id: '1',
        data: {'name': null, 'email': null},
        fallbackName: 'Fallback',
        fallbackEmail: 'fallback@test.com',
      );
      expect(user.name, 'Fallback');
    });

    test('lê avatarBase64 do Firestore', () {
      final user = User.fromFirestore(
        id: '1',
        data: {'name': 'Jon', 'email': 'j@t.com', 'avatarBase64': 'base64data'},
      );
      expect(user.avatarBase64, 'base64data');
    });
  });

  group('User.copyWith', () {
    final user = User(id: '1', name: 'Jon', email: 'j@t.com');

    test('copia com novo nome', () {
      final copy = user.copyWith(name: 'Maria');
      expect(copy.name, 'Maria');
      expect(copy.id, '1');
    });

    test('copia com novo avatarBase64', () {
      final copy = user.copyWith(avatarBase64: 'novaFoto');
      expect(copy.avatarBase64, 'novaFoto');
    });

    test('mantém campos não alterados', () {
      final copy = user.copyWith(email: 'novo@test.com');
      expect(copy.id, user.id);
      expect(copy.name, user.name);
    });
  });
}
