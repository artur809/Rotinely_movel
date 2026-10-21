import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rotinely/modelo/objects/Autorizacao.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';

class LocalStorageService {
  //Constantes que indicam a chave shared em que o dado será persistido
  static const String AUTORIZACAO = 'autorizacao';
  static const String LISTA_TAREFAS = 'lista_tarefas';
  static const String PENDENCIAS = 'pendencias_status';

  //Login

  static Future<void> salvarAutorizacao(Autorizacao auth) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(auth.toMap());
    await prefs.setString(AUTORIZACAO, encodedData);
  }

  static Future<void> desgravarAutorizacao() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AUTORIZACAO);
  }

  static Future<Autorizacao?> carregarAutorizacao() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authJson = prefs.getString(AUTORIZACAO);
    if (authJson == null) return null;
    return Autorizacao.fromMap(json.decode(authJson));
  }

  //Tarefas
  // Salvar a lista inteira de tarefas
  static Future<void> salvarTarefas(List<Tarefa> lista) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = Tarefa.encode(lista);
    await prefs.setString(LISTA_TAREFAS, encodedData);
  }

  // Recuperar a lista inteira de tarefas
  static Future<List<Tarefa>> carregarTarefas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? tarefasJson = prefs.getString(LISTA_TAREFAS);
    if (tarefasJson == null) return [];
    return Tarefa.decode(tarefasJson);
  }

  // Apaga as tarefas e as pendências (usado no logout)
  static Future<void> limparTarefas() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(LISTA_TAREFAS);
    await prefs.remove(PENDENCIAS);
  }

  //Pendências: mudanças de "concluída" feitas sem internet, esperando para serem enviadas
  //guarda um mapa: id da tarefa -> estado desejado (true = concluída)
  static Future<Map<String, bool>> carregarPendencias() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? dados = prefs.getString(PENDENCIAS);
    if (dados == null) return {};
    final Map<String, dynamic> mapa = json.decode(dados);
    return mapa.map((id, valor) => MapEntry(id, valor as bool));
  }

  static Future<void> _salvarPendencias(Map<String, bool> pendencias) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PENDENCIAS, json.encode(pendencias));
  }

  static Future<void> registrarPendencia(String id, bool concluido) async {
    final pendencias = await carregarPendencias();
    pendencias[id] = concluido;
    await _salvarPendencias(pendencias);
  }

  //só remove se o valor ainda for o que foi enviado
  //(se o usuário mudou de novo nesse meio tempo, a mudança nova continua pendente)
  static Future<void> removerPendencia(String id, bool concluidoEnviado) async {
    final pendencias = await carregarPendencias();
    if (pendencias[id] == concluidoEnviado) {
      pendencias.remove(id);
      await _salvarPendencias(pendencias);
    }
  }
}