import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/controle/AutorizacaoController.dart';
import 'package:rotinely/controle/TarefaController.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';
import 'package:rotinely/visao/telas/Login.dart' show Login;
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

  //busca as novidades do web de tempos em tempos
  Timer? _temporizador;

  //evita duas sincronizações ao mesmo tempo
  bool _sincronizando = false;

  @override
  void initState() {
    super.initState();
    _mostrarTarefasSalvas();
    _sincronizar();
    //enquanto a tela estiver aberta, busca as novidades do web a cada 30 segundos
    _temporizador = Timer.periodic(
      const Duration(seconds: 30),
          (_) => _sincronizar(silencioso: true),
    );
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  //mostra na hora o que está salvo no celular
  Future<void> _mostrarTarefasSalvas() async {
    final dados = await TarefaController.listarTarefas();
    if (!mounted) return;
    setState(() => _tarefas = dados);
  }

  //envia o que está pendente, busca as tarefas do servidor e atualiza a tela
  //silencioso = true não mostra aviso de "sem conexão" (usado na busca automática)
  Future<void> _sincronizar({bool silencioso = false}) async {
    if (_sincronizando) return;
    _sincronizando = true;

    late final ResultadoTarefas resultado;
    try {
      resultado = await TarefaController.sincronizar();
    } finally {
      _sincronizando = false;
    }
    if (!mounted) return;

    //token recusado: limpa tudo e volta para o login
    if (resultado.sessaoExpirada) {
      await AutorizacaoController.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login(title: 'Rotinely')),
            (rota) => false,
      );
      return;
    }

    setState(() => _tarefas = resultado.tarefas);

    if (resultado.offline && !silencioso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sem conexão. Mostrando as tarefas salvas no celular.')),
      );
    }
  }

  //chamado quando o usuário toca no checkbox de uma tarefa
  Future<void> _tocarConcluido(Tarefa item) async {
    final enviado = await TarefaController.alternarConcluido(item);
    await _mostrarTarefasSalvas();
    if (!enviado && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sem conexão. A mudança será enviada assim que possível.')),
      );
    }
  }

  //retorna só as tarefas da categoria escolhida no filtro
  List<Tarefa> get _tarefasFiltradas {
    if (_categoriaSelecionada == 'Todas') return _tarefas;
    return _tarefas.where((t) => t.categorias.contains(_categoriaSelecionada)).toList();
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).primaryColorDark),
            tooltip: 'Atualizar',
            onPressed: () => _sincronizar(),
          ),
        ],
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
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _categoriaSelecionada,
                          icon: Icon(Icons.filter_list, color: Theme.of(context).primaryColorDark),
                          dropdownColor: Colors.white,
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                          items: [
                            DropdownMenuItem(value: 'Todas', child: Text('Todas')),
                            DropdownMenuItem(value: 'Trabalho', child: Text('Trabalho')),
                            DropdownMenuItem(value: 'Estudos', child: Text('Estudos')),
                            DropdownMenuItem(value: 'Pessoal e Lazer', child: Text('Pessoal e Lazer')),
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