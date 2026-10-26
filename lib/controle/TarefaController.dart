import 'package:rotinely/modelo/ApiService.dart';
import 'package:rotinely/modelo/LocalStorageService.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';

class ResultadoTarefas {
  final List<Tarefa> tarefas;
  final bool offline;
  final bool sessaoExpirada;

  ResultadoTarefas(this.tarefas, {this.offline = false, this.sessaoExpirada = false});
}

class TarefaController {
  static Future<List<Tarefa>> listarTarefas() async {
    return await LocalStorageService.carregarTarefas();
  }

  static Future<ResultadoTarefas> sincronizar() async {
    final auth = await LocalStorageService.carregarAutorizacao();
    if (auth == null) {
      return ResultadoTarefas(await listarTarefas(), sessaoExpirada: true);
    }

    try {
      await _enviarPendencias(auth.tokenAutenticacao);
      final doServidor = await ApiService.buscarTarefas(auth.tokenAutenticacao);
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

  static Future<bool> alternarConcluido(Tarefa tarefa) async {
    final novoValor = !tarefa.concluido;

    await atualizarTarefa(tarefa.copiarComConcluido(novoValor));

    await LocalStorageService.registrarPendencia(tarefa.id, novoValor);

    final auth = await LocalStorageService.carregarAutorizacao();
    if (auth == null) return false;
    try {
      await _enviarPendencias(auth.tokenAutenticacao);
      return true;
    } on ApiException {
      return false;
    }
  }

  static Future<void> _enviarPendencias(String token) async {
    final pendentes = await LocalStorageService.carregarPendencias();
    for (final entrada in pendentes.entries) {
      try {
        await ApiService.atualizarStatus(token, entrada.key, entrada.value);
      } on ApiException catch (e) {

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