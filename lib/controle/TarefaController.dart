import 'package:rotinely/modelo/objects/Tarefa.dart';
import 'package:rotinely/modelo/LocalStorageService.dart';

class TarefaController {

  //lista inicial(depois vou pegar da API do meu web)
  static final List<Tarefa> _tarefasIniciais = [
    Tarefa(id: '1', tituloT: 'Fazer compras', descricao: 'Ir ao mercado', prioridade: 'alta', categoria: 'Compras', concluido: false),
    Tarefa(id: '2', tituloT: 'Estudar Flutter', descricao: 'Revisar widgets', prioridade: 'alta', categoria: 'Estudos', concluido: false),
    Tarefa(id: '3', tituloT: 'Jogar futebol', descricao: 'Segunda as 18h', prioridade: 'média', categoria: 'Pessoal & Lazer', concluido: false),
    Tarefa(id: '4', tituloT: 'Reunião', descricao: 'Reunião às 14h', prioridade: 'alta', categoria: 'Trabalho', concluido: false),
    Tarefa(id: '5', tituloT: 'Caminhar', descricao: '', prioridade: 'baixa', categoria: 'Saúde', concluido: false),
    Tarefa(id: '6', tituloT: 'viagem', descricao: 'Viagem marcada pro dia 25 de abril', prioridade: 'alta', categoria: 'Pessoal & Lazer', concluido: false),
    Tarefa(id: '7', tituloT: 'entrega de trabalho', descricao: 'Entregar até dia 22', prioridade: 'alta', categoria: 'Estudos', concluido: false),
  ];

  static Future<List<Tarefa>> listarTarefas() async {
    List<Tarefa> lista = await LocalStorageService.carregarTarefas();
    if (lista.isEmpty) {
      await LocalStorageService.salvarTarefas(_tarefasIniciais);
      return _tarefasIniciais;
    }
    return lista;
  }

  static Future<void> alternarConcluido(Tarefa tarefa) async {
    Tarefa tarefaAtualizada;
    if (tarefa.concluido) {
      tarefaAtualizada = Tarefa(
        id: tarefa.id, tituloT: tarefa.tituloT, descricao: tarefa.descricao,
        prioridade: tarefa.prioridade, categoria: tarefa.categoria,
        concluido: false,
      );
    } else {
      tarefaAtualizada = Tarefa(
        id: tarefa.id, tituloT: tarefa.tituloT, descricao: tarefa.descricao,
        prioridade: tarefa.prioridade, categoria: tarefa.categoria,
        concluido: true,
      );
    }
    await atualizarTarefa(tarefaAtualizada);
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