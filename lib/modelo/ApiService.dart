import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rotinely/modelo/ApiConfig.dart';
import 'package:rotinely/modelo/objects/Autorizacao.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';

//tipos de problema que podem acontecer na conversa com a API
enum ApiErro { semConexao, sessaoExpirada, credenciaisInvalidas, naoEncontrado, servidor }

//erro com um tipo (para o app decidir o que fazer) e uma mensagem (para mostrar ao usuário)
class ApiException implements Exception {
  final ApiErro tipo;
  final String mensagem;

  ApiException(this.tipo, this.mensagem);

  @override
  String toString() => mensagem;
}

//toda a comunicação com a API do web fica aqui
class ApiService {
  //se o servidor não responder em 15 segundos, considera que está sem conexão
  static const Duration _tempoLimite = Duration(seconds: 15);

  //faz a chamada e transforma qualquer falha de rede em ApiException
  static Future<http.Response> _enviar(Future<http.Response> Function() chamada) async {
    try {
      return await chamada().timeout(_tempoLimite);
    } catch (_) {
      throw ApiException(ApiErro.semConexao, 'Sem conexão com o servidor.');
    }
  }

  //se o servidor recusou o token, a sessão acabou
  static void _verificarSessao(http.Response resposta) {
    if (resposta.statusCode == 401) {
      throw ApiException(ApiErro.sessaoExpirada, 'Sessão expirada. Entre novamente.');
    }
  }

  //POST /api/login: devolve a Autorizacao com nome, data/hora e token
  static Future<Autorizacao> login(String email, String senha) async {
    final resposta = await _enviar(() => http.post(
      Uri.parse('${ApiConfig.baseUrl}/login'),
      headers: ApiConfig.cabecalhos(),
      body: jsonEncode({'email': email, 'password': senha}),
    ));

    if (resposta.statusCode == 200) {
      try {
        final dados = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
        return Autorizacao(
          usuario: dados['usuario']['nome'] ?? '',
          dataHoraLogin: dados['data_hora'] ?? '',
          tokenAutenticacao: dados['token'] ?? '',
        );
      } catch (_) {
        throw ApiException(ApiErro.servidor, 'Resposta inesperada do servidor.');
      }
    }
    if (resposta.statusCode == 401) {
      throw ApiException(ApiErro.credenciaisInvalidas, 'E-mail ou senha inválidos.');
    }
    if (resposta.statusCode == 422) {
      throw ApiException(ApiErro.credenciaisInvalidas, 'Informe um e-mail válido.');
    }
    if (resposta.statusCode == 429) {
      throw ApiException(ApiErro.servidor, 'Muitas tentativas. Aguarde um minuto.');
    }
    throw ApiException(ApiErro.servidor, 'Erro no servidor (${resposta.statusCode}).');
  }

  //GET /api/tarefas: todas as tarefas do usuário dono do token
  static Future<List<Tarefa>> buscarTarefas(String token) async {
    final resposta = await _enviar(() => http.get(
      Uri.parse('${ApiConfig.baseUrl}/tarefas'),
      headers: ApiConfig.cabecalhos(token: token),
    ));

    _verificarSessao(resposta);
    if (resposta.statusCode != 200) {
      throw ApiException(ApiErro.servidor, 'Erro no servidor (${resposta.statusCode}).');
    }

    try {
      final lista = jsonDecode(utf8.decode(resposta.bodyBytes)) as List<dynamic>;
      return lista.map((item) => Tarefa.fromApi(item as Map<String, dynamic>)).toList();
    } catch (_) {
      throw ApiException(ApiErro.servidor, 'Resposta inesperada do servidor.');
    }
  }

  //PATCH /api/tarefas/{id}/status: manda o estado desejado (concluída ou pendente)
  static Future<void> atualizarStatus(String token, String id, bool concluido) async {
    final resposta = await _enviar(() => http.patch(
      Uri.parse('${ApiConfig.baseUrl}/tarefas/$id/status'),
      headers: ApiConfig.cabecalhos(token: token),
      body: jsonEncode({'status': concluido ? 'concluida' : 'pendente'}),
    ));

    _verificarSessao(resposta);
    if (resposta.statusCode == 404) {
      throw ApiException(ApiErro.naoEncontrado, 'A tarefa não existe mais no servidor.');
    }
    if (resposta.statusCode != 200) {
      throw ApiException(ApiErro.servidor, 'Erro no servidor (${resposta.statusCode}).');
    }
  }

  //POST /api/logout: apaga o token no servidor (se não conseguir, não faz mal)
  static Future<void> logout(String token) async {
    try {
      await http
          .post(
        Uri.parse('${ApiConfig.baseUrl}/logout'),
        headers: ApiConfig.cabecalhos(token: token),
      )
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      //sem internet: o logout local acontece do mesmo jeito
    }
  }
}