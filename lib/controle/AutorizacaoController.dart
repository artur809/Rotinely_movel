import 'package:rotinely/modelo/LocalStorageService.dart';
import 'package:rotinely/modelo/objects/Autorizacao.dart';

class AutorizacaoController {

  //Simula a chamada a uma API de login e devolve um objeto com usuário, dataHora e token
  static Future<bool> verificaAutorizacaoOnline(String usuario, String senha) async {
    await Future.delayed(Duration(milliseconds: 600)); //simula um delay de rede

    if (usuario.trim().isNotEmpty && senha.trim().isNotEmpty) {
      Autorizacao authRetornoApi = Autorizacao(
        usuario: usuario,
        dataHoraLogin: DateTime.now().toIso8601String(),
        tokenAutenticacao: 'TOKEN-${DateTime.now().millisecondsSinceEpoch}',
      );
      await LocalStorageService.salvarAutorizacao(authRetornoApi);
      return true;
    }
    return false;
  }

  //verifica se já existe login salvo no dispositivo (uso offline)
  static Future<bool> verificaAutorizacaoOffline() async {
    Autorizacao? auth = await LocalStorageService.carregarAutorizacao();
    return auth != null;
  }

  static Future<Autorizacao?> usuarioLogado() async {
    return await LocalStorageService.carregarAutorizacao();
  }

  static Future<void> logout() async {
    await LocalStorageService.desgravarAutorizacao();
  }
}