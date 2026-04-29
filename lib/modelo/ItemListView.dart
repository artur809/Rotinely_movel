//classe modelo de objeto
class ItemListView {
  final String tituloT;
  final String descricao;
  final String prioridade;
  final String categoria;
  final bool concluido;



  ItemListView({required this.tituloT, required this.descricao, required this.prioridade, required this.concluido, required this.categoria});

  factory ItemListView.fromJson(Map<String, dynamic> json) {
    return ItemListView(
      tituloT: json['titulo'],
      descricao: json['descricao'],
      prioridade: json['prioridade'],
      categoria: json['categoria'],
      concluido: json['concluido'],
    );
  }
}