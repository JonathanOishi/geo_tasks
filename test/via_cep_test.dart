import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/models/via_cep.dart';

void main() {
  group('ViaCep', () {
    final map = {
      'cep': '01001-000',
      'bairro': 'Sé',
      'localidade': 'São Paulo',
    };

    test('fromMap cria objeto corretamente', () {
      final viaCep = ViaCep.fromMap(map);
      expect(viaCep.cep, '01001-000');
      expect(viaCep.bairro, 'Sé');
      expect(viaCep.localidade, 'São Paulo');
    });

    test('toMap retorna todos os campos', () {
      final viaCep = ViaCep(
        cep: '01001-000',
        bairro: 'Sé',
        localidade: 'São Paulo',
      );
      final result = viaCep.toMap();
      expect(result['cep'], '01001-000');
      expect(result['bairro'], 'Sé');
      expect(result['localidade'], 'São Paulo');
    });

    test('fromMap e toMap são simétricos', () {
      final viaCep = ViaCep.fromMap(map);
      expect(viaCep.toMap(), map);
    });

    test('fromMap com campos ausentes usa string vazia', () {
      final viaCep = ViaCep.fromMap({});
      expect(viaCep.cep, '');
      expect(viaCep.bairro, '');
      expect(viaCep.localidade, '');
    });

    test('fromMap com campos nulos usa string vazia', () {
      final viaCep = ViaCep.fromMap({
        'cep': null,
        'bairro': null,
        'localidade': null,
      });
      expect(viaCep.cep, '');
      expect(viaCep.bairro, '');
      expect(viaCep.localidade, '');
    });
  });
}
