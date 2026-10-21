//configurações da API (endereço e cabeçalhos padrão)
class ApiConfig {
  static const String baseUrl = 'https://rotinely.sao.dom.my.id/api';

  //o servidor gratuito do DomCloud bloqueia chamadas sem esse cabeçalho
  static const String referer = 'https://rotinely.sao.dom.my.id/';

  //monta os cabeçalhos de toda chamada; o token só vai depois do login
  static Map<String, String> cabecalhos({String? token}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Referer': referer,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}