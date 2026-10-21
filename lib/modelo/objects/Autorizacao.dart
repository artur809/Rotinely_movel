//guarda o login e os dados do perfil do usuário logado
class Autorizacao {
  final String usuario;
  final String dataHoraLogin;
  final String tokenAutenticacao;
  final String email;
  final String dataCadastro;

  Autorizacao({
    required this.usuario,
    required this.dataHoraLogin,
    required this.tokenAutenticacao,
    this.email = '',
    this.dataCadastro = '',
  });

  //converte o objeto para um Map (usado para persistir em JSON)
  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'dataHoraLogin': dataHoraLogin,
      'tokenAutenticacao': tokenAutenticacao,
      'email': email,
      'dataCadastro': dataCadastro,
    };
  }

  //cria um objeto a partir de um Map (usado ao recuperar do SharedPreferences)
  factory Autorizacao.fromMap(Map<String, dynamic> map) {
    return Autorizacao(
      usuario: map['usuario'] ?? '',
      dataHoraLogin: map['dataHoraLogin'] ?? '',
      tokenAutenticacao: map['tokenAutenticacao'] ?? '',
      email: map['email'] ?? '',
      dataCadastro: map['dataCadastro'] ?? '',
    );
  }
}