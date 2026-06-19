import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geo_tasks/features/tasks/models/via_cep.dart';

class ViaCepApi {
  ViaCepApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ViaCep> getAddressFromCep(String cep) async {
    final sanitizedCep = cep.replaceAll(RegExp(r'\D'), '');

    if (sanitizedCep.length != 8) {
      throw Exception('Informe um CEP com 8 digitos.');
    }

    final viaCepUrl = 'https://viacep.com.br/ws/$sanitizedCep/json/';

    try {
      final response = await _client.get(Uri.parse(viaCepUrl));

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
