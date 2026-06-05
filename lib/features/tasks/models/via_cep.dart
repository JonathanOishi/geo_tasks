class ViaCep {
  final String cep;
  final String bairro;
  final String localidade;

  ViaCep({
    required this.cep,
    required this.bairro,
    required this.localidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'bairro': bairro,
      'localidade': localidade,
    };
  }

  factory ViaCep.fromMap(Map<String, dynamic> map) {
    return ViaCep(
      cep: map['cep'] ?? '',
      bairro: map['bairro'] ?? '',
      localidade: map['localidade'] ?? '',
    );
  }

  //   {
  //   "cep": "01001-000",
  //   "logradouro": "Praça da Sé",
  //   "complemento": "lado ímpar",
  //   "bairro": "Sé",
  //   "localidade": "São Paulo",
  //   "uf": "SP",
  //   "unidade": "",
  //   "ibge": "3550308",
  //   "gia": "1004"
  // }
}
