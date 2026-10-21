import 'package:rotinely/modelo/ApiService.dart';
import 'package:rotinely/modelo/LocalStorageService.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';

//o que a tela recebe depois de tentar sincronizar com o servidor
class ResultadoTarefas {
  final List<Tarefa> tarefas;
  final bool offline; //true = não conseguiu falar com o servidor, mostrou a cópia do celular
  final bool sessaoExpirada; //true = precisa fazer login de novo

  ResultadoTarefas(this.tarefas, {this.offline = false, this.sessaoExpirada = false});
}

class TarefaController {

  //devolve só o que está salvo no celular (rápido, funciona sem internet)
  static Future<List<Tarefa>> listarTarefas() async {
    return await LocalStorageService.carregarTarefas();
  }

  //envia as mudanças pendentes, busca a lista nova no servidor e guarda no celular
  static Future<ResultadoTarefas> sincronizar() async {
    final auth = await LocalStorageService.carregarAutorizacao();
    if (auth == null) {
      return ResultadoTarefas(await listarTarefas(), sessaoExpirada: true);
    }

    try {
      await _enviarPendencias(auth.tokenAutenticacao);
      final doServidor = await ApiService.buscarTarefas(auth.tokenAutenticacao);

      //se sobrou alguma mudança pendente (feita enquanto sincronizava), ela vale mais que o servidor
      final pendentes = await LocalStorageService.carregarPendencias();
      final lista = doServidor
          .map((t) => pendentes.containsKey(t.id) ? t.copiarComConcluido(pendentes[t.id]!) : t)
          .toList();

      await LocalStorageService.salvarTarefas(lista);
      return ResultadoTarefas(lista);
    } on ApiException catch (e) {
      return ResultadoTarefas(
        await listarTarefas(),
        offline: e.tipo != ApiErro.sessaoExpirada,
        sessaoExpirada: e.tipo == ApiErro.sessaoExpirada,
      );
    }
  }

  //marca/desmarca como concluída
  //devolve true se o servidor já recebeu, false se ficou pendente (sem conexão)
  static Future<bool> alternarConcluido(Tarefa tarefa) async {
    final novoValor = !tarefa.concluido;

    //muda no celular na hora, a tela responde mesmo sem internet
    await atualizarTarefa(tarefa.copiarComConcluido(novoValor));

    //anota que falta avisar o servidor
    await LocalStorageService.registrarPendencia(tarefa.id, novoValor);

    //tenta avisar agora e se não der continua pendente e sai na próxima sincronização
    final auth = await LocalStorageService.carregarAutorizacao();
    if (auth == null) return false;
    try {
      await _enviarPendencias(auth.tokenAutenticacao);
      return true;
    } on ApiException {
      return false;
    }
  }

  //manda para o servidor cada mudança pendente, uma por uma
  static Future<void> _enviarPendencias(String token) async {
    final pendentes = await LocalStorageService.carregarPendencias();
    for (final entrada in pendentes.entries) {
      try {
        await ApiService.atualizarStatus(token, entrada.key, entrada.value);
      } on ApiException catch (e) {
        //404: a tarefa foi apagada no web, então a mudança não vale mais
        if (e.tipo != ApiErro.naoEncontrado) rethrow;
      }
      await LocalStorageService.removerPendencia(entrada.key, entrada.value);
    }
  }

  static Future<void> atualizarTarefa(Tarefa tarefa) async {
    List<Tarefa> lista = await LocalStorageService.carregarTarefas();

    int index = lista.indexWhere((t) => t.id == tarefa.id);
    if (index != -1) {
      lista[index] = tarefa;
    }
    await LocalStorageService.salvarTarefas(lista);
  }
}