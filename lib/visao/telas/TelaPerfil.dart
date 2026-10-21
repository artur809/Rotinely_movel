import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';

class TelaDois extends StatefulWidget {
  const TelaDois({super.key, required this.title});
  final String title;

  @protected
  @override
  State<TelaDois> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaDois> {

  //linha de dado pessoal: rótulo pequeno em cima, valor em baixo
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
                        'A',
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
                      _linhaDado(context, Internacionalizacao.labelNome, 'Artur Ribeiro', Icons.person_outline),
                      SizedBox(height: 18),
                      _linhaDado(context, Internacionalizacao.labelEmail, 'arturribeiroalmeida2009@gmail.com', Icons.email_outlined),
                      SizedBox(height: 18),
                      _linhaDado(context, Internacionalizacao.labelMembro, '04/10/2026', Icons.calendar_today_outlined),
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