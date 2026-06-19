import 'package:flutter_test/flutter_test.dart';
import 'package:geo_tasks/features/tasks/services/via_cep_api.dart';

void main() {
  group('ViaCepApi', () {
    test('lança exceção para CEP com menos de 8 dígitos', () async {
      final api = ViaCepApi();
      expect(
        () => api.getAddressFromCep('1234'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('8 digitos'),
          ),
        ),
      );
    });

    test('lança exceção para CEP com mais de 8 dígitos', () async {
      final api = ViaCepApi();
      expect(
        () => api.getAddressFromCep('123456789'),
        throwsA(isA<Exception>()),
      );
    });

    test('lança exceção para CEP vazio', () async {
      final api = ViaCepApi();
      expect(
        () => api.getAddressFromCep(''),
        throwsA(isA<Exception>()),
      );
    });

    test('lança exceção para CEP com apenas letras', () async {
      final api = ViaCepApi();
      expect(
        () => api.getAddressFromCep('ABCDEFGH'),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'CEP com hífen e exatamente 8 dígitos numéricos não lança erro de tamanho',
      () async {
        final api = ViaCepApi();
        try {
          await api.getAddressFromCep('01001-000');
        } catch (e) {
          expect(e.toString(), isNot(contains('8 digitos')));
        }
      },
    );

    test('instancia ViaCepApi sem erros', () {
      expect(() => ViaCepApi(), returnsNormally);
    });
  });
}
