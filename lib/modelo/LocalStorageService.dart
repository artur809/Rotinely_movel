import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rotinely/modelo/objects/Autorizacao.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';

class LocalStorageService {
  //Constantes que indicam a chave shared em que o dado será persistido
  static const String AUTORIZACAO = 'autorizacao';
  static const String LISTA_TAREFAS = 'lista_tarefas';

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
}