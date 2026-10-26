class ApiConfig {
  static const String baseUrl = 'https://rotinely.sao.dom.my.id/api';

  static const String referer = 'https://rotinely.sao.dom.my.id/';

  static Map<String, String> cabecalhos({String? token}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Referer': referer,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}