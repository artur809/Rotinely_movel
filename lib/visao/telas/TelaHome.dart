import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/controle/TarefaController.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';
import 'package:rotinely/visao/util/WidgetsUteis.dart';

class TelaUm extends StatefulWidget {
  const TelaUm({super.key, required this.title});
  final String title;

  @protected
  @override
  State<TelaUm> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaUm> {

  //lista de tarefas carregada do armazenamento local
  List<Tarefa> _tarefas = [];

  //categoria selecionada no filtro (dropdown)
  String _categoriaSelecionada = 'Todas';

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  //busca as tarefas persistidas e atualiza a tela
  Future<void> _carregarTarefas() async {
    final dados = await TarefaController.listarTarefas();
    setState(() => _tarefas = dados);
  }

  //chamado quando o usuário toca no checkbox de uma tarefa
  Future<void> _tocarConcluido(Tarefa item) async {
    await TarefaController.alternarConcluido(item);
    await _carregarTarefas();
  }

  //retorna só as tarefas da categoria escolhida no filtro
  List<Tarefa> get _tarefasFiltradas {
    if (_categoriaSelecionada == 'Todas') return _tarefas;
    return _tarefas.where((t) => t.categoria == _categoriaSelecionada).toList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1304));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).highlightColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetsUteis().espacoHorizontal5,
            WidgetsUteis().espacoHorizontal5,
            Text(
              Internacionalizacao.titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).highlightColor,
                  Theme.of(context).primaryColorLight
                ])),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton<String>(
                      value: _categoriaSelecionada,
                      dropdownColor: Theme.of(context).primaryColorLight,
                      style: TextStyle(color: Colors.black),
                      items: [
                        DropdownMenuItem(value: 'Todas', child: Text('Todas')),
                        DropdownMenuItem(value: 'Trabalho', child: Text('Trabalho')),
                        DropdownMenuItem(value: 'Estudos', child: Text('Estudos')),
                        DropdownMenuItem(value: 'Pessoal & Lazer', child: Text('Pessoal & Lazer')),
                        DropdownMenuItem(value: 'Saúde', child: Text('Saúde')),
                        DropdownMenuItem(value: 'Finanças', child: Text('Finanças')),
                        DropdownMenuItem(value: 'Casa', child: Text('Casa')),
                        DropdownMenuItem(value: 'Compras', child: Text('Compras')),
                        DropdownMenuItem(value: 'Família', child: Text('Família')),
                      ],
                      onChanged: (valor) {
                        if (valor == null) return;
                        setState(() => _categoriaSelecionada = valor);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 550,
                    width: double.maxFinite,
                    child: WidgetsUteis().listaTarefas(
                      context,
                      _tarefasFiltradas,
                      aoTocarConcluido: _tocarConcluido,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Internacionalizacao {
  static String titulo = "Minhas tarefas";
}