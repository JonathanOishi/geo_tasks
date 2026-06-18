import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:geo_tasks/features/tasks/models/via_cep.dart';

class ViaCepApiTestable {
  ViaCepApiTestable({required this.client});
  final http.Client client;

  Future<ViaCep> getAddressFromCep(String cep) async {
    final sanitizedCep = cep.replaceAll(RegExp(r'\D'), '');

    if (sanitizedCep.length != 8) {
      throw Exception('Informe um CEP com 8 digitos.');
    }

    final uri = Uri.parse('https://viacep.com.br/ws/$sanitizedCep/json/');

    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(
          jsonDecode(response.body) as Map,
        );
        if (data['erro'] == true) {
          throw Exception('CEP não encontrado.');
        }
        return ViaCep.fromMap(data);
      } else {
        throw Exception(
          'Erro ao buscar endereço. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao buscar endereço: $e');
    }
  }
}

void main() {
  group('ViaCepApi', () {
    test('retorna ViaCep para CEP válido', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'cep': '01001-000',
            'bairro': 'Sé',
            'localidade': 'São Paulo',
          }),
          200,
        );
      });

      final api = ViaCepApiTestable(client: mockClient);
      final result = await api.getAddressFromCep('01001000');

      expect(result.cep, '01001-000');
      expect(result.bairro, 'Sé');
      expect(result.localidade, 'São Paulo');
    });

    test('aceita CEP com hífen e o sanitiza', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('01001000'));
        return http.Response(
          jsonEncode({
            'cep': '01001-000',
            'bairro': 'Sé',
            'localidade': 'São Paulo',
          }),
          200,
        );
      });

      final api = ViaCepApiTestable(client: mockClient);
      await api.getAddressFromCep('01001-000');
    });

    test('lança exceção para CEP com menos de 8 dígitos', () async {
      final api = ViaCepApiTestable(
        client: MockClient((_) async => http.Response('', 200)),
      );
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
      final api = ViaCepApiTestable(
        client: MockClient((_) async => http.Response('', 200)),
      );
      expect(
        () => api.getAddressFromCep('123456789'),
        throwsA(isA<Exception>()),
      );
    });

    test('lança exceção quando CEP não encontrado (erro: true)', () async {
      final mockClient = MockClient(
        (_) async => http.Response(jsonEncode({'erro': true}), 200),
      );

      final api = ViaCepApiTestable(client: mockClient);
      expect(
        () => api.getAddressFromCep('99999999'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('não encontrado'),
          ),
        ),
      );
    });

    test('lança exceção quando servidor retorna status 500', () async {
      final mockClient = MockClient(
        (_) async => http.Response('Server Error', 500),
      );

      final api = ViaCepApiTestable(client: mockClient);
      expect(
        () => api.getAddressFromCep('01001000'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('500'),
          ),
        ),
      );
    });

    test('lança exceção quando servidor retorna status 404', () async {
      final mockClient = MockClient(
        (_) async => http.Response('Not Found', 404),
      );

      final api = ViaCepApiTestable(client: mockClient);
      expect(
        () => api.getAddressFromCep('01001000'),
        throwsA(isA<Exception>()),
      );
    });

    test('CEP com letras é sanitizado e validado pelo tamanho', () async {
      final api = ViaCepApiTestable(
        client: MockClient((_) async => http.Response('', 200)),
      );
      expect(
        () => api.getAddressFromCep('ABC'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
