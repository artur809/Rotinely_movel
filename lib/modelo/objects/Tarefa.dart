import 'dart:convert';

//classe modelo de objeto
class Tarefa {
  final String id;
  final String tituloT;
  final String descricao;
  final String prioridade;
  final String categoria; //nomes das categorias juntos (para mostrar na tela)
  final List<String> categorias; //cada categoria separada (para o filtro)
  final bool concluido;

  Tarefa({
    required this.id,
    required this.tituloT,
    required this.descricao,
    required this.prioridade,
    required this.concluido,
    required this.categoria,
    this.categorias = const [],
  });

  //devolve uma cópia da tarefa só com o campo concluido trocado
  Tarefa copiarComConcluido(bool novoValor) {
    return Tarefa(
      id: id,
      tituloT: tituloT,
      descricao: descricao,
      prioridade: prioridade,
      categoria: categoria,
      categorias: categorias,
      concluido: novoValor,
    );
  }

  // Converte o objeto para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': tituloT,
      'descricao': descricao,
      'prioridade': prioridade,
      'categoria': categoria,
      'categorias': categorias,
      'concluido': concluido,
    };
  }

  // Cria um objeto a partir de um Map (dados salvos no celular)
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    final String categoria = map['categoria'] ?? '';
    final List<String> categorias = map['categorias'] != null
        ? List<String>.from(map['categorias'])
        : (categoria.isEmpty ? <String>[] : <String>[categoria]);

    return Tarefa(
      id: map['id'].toString(),
      tituloT: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      prioridade: map['prioridade'] ?? '',
      categoria: categoria,
      categorias: categorias,
      concluido: map['concluido'] ?? false,
    );
  }

  // Cria um objeto a partir do JSON que vem da API do web
  factory Tarefa.fromApi(Map<String, dynamic> map) {
    final List<String> nomes = (map['categorias'] as List<dynamic>? ?? [])
        .map((c) => (c as Map<String, dynamic>)['nome'].toString())
        .toList();
    final String prioridade = (map['prioridade'] ?? '').toString();

    return Tarefa(
      id: map['id'].toString(),
      tituloT: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '', //o web pode mandar null
      //o web manda "media" (sem acento); o app usa "média"
      prioridade: prioridade == 'media' ? 'média' : prioridade,
      categoria: nomes.join(', '),
      categorias: nomes,
      concluido: map['status'] == 'concluida',
    );
  }

  // Converte de uma lista de objetos para uma String JSON
  static String encode(List<Tarefa> tarefas) => json.encode(
    tarefas.map<Map<String, dynamic>>((t) => t.toMap()).toList(),
  );

  // Converte de uma String JSON para uma lista de objetos
  static List<Tarefa> decode(String tarefasJson) =>
      (json.decode(tarefasJson) as List<dynamic>)
          .map<Tarefa>((item) => Tarefa.fromMap(item))
          .toList();
}