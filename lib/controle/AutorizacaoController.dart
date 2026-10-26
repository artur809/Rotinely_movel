import 'package:rotinely/modelo/ApiService.dart';
import 'package:rotinely/modelo/LocalStorageService.dart';
import 'package:rotinely/modelo/objects/Autorizacao.dart';

class AutorizacaoController {
  static Future<String?> verificaAutorizacaoOnline(String email, String senha) async {
    try {
      Autorizacao authRetornoApi = await ApiService.login(email.trim(), senha);
      await LocalStorageService.limparTarefas();
      await LocalStorageService.salvarAutorizacao(authRetornoApi);
      return null;
    } on ApiException catch (e) {
      return e.mensagem;
    }
  }

  static Future<bool> verificaAutorizacaoOffline() async {
    Autorizacao? auth = await LocalStorageService.carregarAutorizacao();
    return auth != null;
  }

  static Future<Autorizacao?> usuarioLogado() async {
    return await LocalStorageService.carregarAutorizacao();
  }

  static Future<bool> atualizarPerfil() async {
    final auth = await LocalStorageService.carregarAutorizacao();
    if (auth == null) return false;

    try {
      final atualizada = await ApiService.perfil(auth);
      await LocalStorageService.salvarAutorizacao(atualizada);
      return true;
    } on ApiException catch (e) {
      return e.tipo != ApiErro.sessaoExpirada;
    }
  }

  static Future<void> logout() async {
    Autorizacao? auth = await LocalStorageService.carregarAutorizacao();
    if (auth != null) {
      await ApiService.logout(auth.tokenAutenticacao);
    }
    await LocalStorageService.desgravarAutorizacao();
    await LocalStorageService.limparTarefas();
  }
}