import 'package:rotinely/modelo/ApiService.dart';
import 'package:rotinely/modelo/LocalStorageService.dart';
import 'package:rotinely/modelo/objects/Autorizacao.dart';

class AutorizacaoController {

  //faz o login na API do web
  //devolve null se deu certo, ou a mensagem de erro para mostrar na tela
  static Future<String?> verificaAutorizacaoOnline(String email, String senha) async {
    try {
      Autorizacao authRetornoApi = await ApiService.login(email.trim(), senha);
      //limpa o que ficou salvo de antes (tarefas de outro usuário, dados de teste)
      await LocalStorageService.limparTarefas();
      await LocalStorageService.salvarAutorizacao(authRetornoApi);
      return null;
    } on ApiException catch (e) {
      return e.mensagem;
    }
  }

  //verifica se já existe login salvo no dispositivo (uso offline)
  static Future<bool> verificaAutorizacaoOffline() async {
    Autorizacao? auth = await LocalStorageService.carregarAutorizacao();
    return auth != null;
  }

  static Future<Autorizacao?> usuarioLogado() async {
    return await LocalStorageService.carregarAutorizacao();
  }

  //busca o perfil atualizado no servidor e salva no celular
  //devolve false só se a sessão expirou (precisa fazer login de novo)
  //sem internet devolve true: o perfil continua com o que já estava salvo
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

  //avisa o servidor (apaga o token lá) e limpa tudo que está salvo no celular
  static Future<void> logout() async {
    Autorizacao? auth = await LocalStorageService.carregarAutorizacao();
    if (auth != null) {
      await ApiService.logout(auth.tokenAutenticacao);
    }
    await LocalStorageService.desgravarAutorizacao();
    await LocalStorageService.limparTarefas();
  }
}