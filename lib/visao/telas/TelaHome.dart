import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/modelo/ItemListView.dart';
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
  void _salvar() {}

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
          )

        ),
        body:Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme
                        .of(context)
                        .highlightColor,
                    Theme
                        .of(context)
                        .primaryColorLight
                  ])),
          child:
          SingleChildScrollView(
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
                        value: 'Todas',
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
                        onChanged: (valor) {},
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 550,
                      width: double.maxFinite,
                      child: WidgetsUteis().listaTarefas(context, tarefas),
                    )
                  ],
                ),
              ),
            ),
          ),

        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvar,
        child: const Icon(Icons.save),
      ),
    );
  }
  List<ItemListView> tarefas = [
    ItemListView(tituloT: 'Fazer compras', descricao: 'Ir ao mercado', prioridade: 'alta', categoria: 'Compras', concluido: false),
    ItemListView(tituloT: 'Estudar Flutter', descricao: 'Revisar widgets', prioridade: 'alta', categoria: 'Estudos', concluido: false),
    ItemListView(tituloT: 'Jogar futebol', descricao: 'Segunda as 18h', prioridade: 'média', categoria: 'Pessoal & Lazer', concluido: false),
    ItemListView(tituloT: 'Reunião', descricao: 'Reunião às 14h', prioridade: 'alta', categoria: 'Trabalho', concluido: true),
    ItemListView(tituloT: 'Caminhar', descricao: '', prioridade: 'baixa', categoria: 'Saúde', concluido: true),
    ItemListView(tituloT: 'viagem', descricao: 'Viagem marcada pro dia 25 de abril', prioridade: 'alta', categoria: 'Pessoal & Lazer', concluido: true),
    ItemListView(tituloT: 'entrega de trabalho', descricao: 'Entregar todas as migrations do trabalho ate dia 22', prioridade: 'alta', categoria: 'Estudos', concluido: false),
  ];
}

class Internacionalizacao {
  static String titulo = "Minhas tarefas";
}