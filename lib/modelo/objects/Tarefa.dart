import 'dart:convert';

//classe modelo de objeto
class Tarefa {
  final String id;
  final String tituloT;
  final String descricao;
  final String prioridade;
  final String categoria;
  final bool concluido;

  Tarefa({
    required this.id,
    required this.tituloT,
    required this.descricao,
    required this.prioridade,
    required this.concluido,
    required this.categoria,
  });

  // Converte o objeto para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': tituloT,
      'descricao': descricao,
      'prioridade': prioridade,
      'categoria': categoria,
      'concluido': concluido,
    };
  }

  // Cria um objeto a partir de um Map
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'].toString(),
      tituloT: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      prioridade: map['prioridade'] ?? '',
      categoria: map['categoria'] ?? '',
      concluido: map['concluido'] ?? false,
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