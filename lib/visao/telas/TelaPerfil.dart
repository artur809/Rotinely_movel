import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rotinely/controle/AutorizacaoController.dart';
import 'package:rotinely/modelo/objects/Autorizacao.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';
import 'package:rotinely/visao/telas/Login.dart' show Login;

class TelaDois extends StatefulWidget {
  const TelaDois({super.key, required this.title});
  final String title;

  @protected
  @override
  State<TelaDois> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaDois> {

  //dados do usuário logado (vêm do celular e são atualizados pelo servidor)
  Autorizacao? _auth;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    //mostra na hora o que está salvo no celular
    final salvo = await AutorizacaoController.usuarioLogado();
    if (!mounted) return;
    setState(() => _auth = salvo);

    //pede ao servidor os dados atuais (o nome ou e-mail pode ter mudado no web)
    final sessaoValida = await AutorizacaoController.atualizarPerfil();
    if (!mounted) return;

    //token recusado: limpa tudo e volta para o login
    if (!sessaoValida) {
      await AutorizacaoController.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login(title: 'Rotinely')),
            (rota) => false,
      );
      return;
    }

    //mostra os dados atualizados
    final atualizado = await AutorizacaoController.usuarioLogado();
    if (!mounted) return;
    setState(() => _auth = atualizado);
  }

  //transforma a data do servidor (2026-10-04T...) em 04/10/2026
  String _formatarData(String iso) {
    if (iso.isEmpty) return '-';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return '-';
    }
  }

  Widget _linhaDado(BuildContext context, String rotulo, String valor, IconData icone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Icon(icone, size: 16, color: Theme.of(context).primaryColorDark),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                valor,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.init(context, designSize: const Size(750, 1304));

    //dados que aparecem na tela (se ainda não tem, mostra "-")
    final String nome = _auth?.usuario ?? '';
    final String email = _auth?.email ?? '';
    final String inicial = nome.isEmpty ? '?' : nome[0].toUpperCase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          Internacionalizacao.titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).primaryColorDark),
            tooltip: 'Atualizar',
            onPressed: _carregarPerfil,
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
              Theme.of(context).primaryColorLight,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        inicial,
                        style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  Internacionalizacao.dadosPessoais.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _linhaDado(context, Internacionalizacao.labelNome, nome.isEmpty ? '-' : nome, Icons.person_outline),
                      SizedBox(height: 18),
                      _linhaDado(context, Internacionalizacao.labelEmail, email.isEmpty ? '-' : email, Icons.email_outlined),
                      SizedBox(height: 18),
                      _linhaDado(context, Internacionalizacao.labelMembro, _formatarData(_auth?.dataCadastro ?? ''), Icons.calendar_today_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Internacionalizacao {
  static String titulo = "Meu Perfil";
  static String dadosPessoais = "Dados Pessoais";
  static String labelNome = "Nome de usuário";
  static String labelEmail = "Email";
  static String labelMembro = "Data de cadastro";
}