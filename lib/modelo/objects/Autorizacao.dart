//simulando um login autenticado usando API
class Autorizacao {
  final String usuario;
  final String dataHoraLogin;
  final String tokenAutenticacao;

  Autorizacao({
    required this.usuario,
    required this.dataHoraLogin,
    required this.tokenAutenticacao,
  });

  //converte o objeto para um Map (usado para persistir em JSON)
  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'dataHoraLogin': dataHoraLogin,
      'tokenAutenticacao': tokenAutenticacao,
    };
  }

  //cria um objeto a partir de um Map (usado ao recuperar do SharedPreferences)
  factory Autorizacao.fromMap(Map<String, dynamic> map) {
    return Autorizacao(
      usuario: map['usuario'] ?? '',
      dataHoraLogin: map['dataHoraLogin'] ?? '',
      tokenAutenticacao: map['tokenAutenticacao'] ?? '',
    );
  }
}