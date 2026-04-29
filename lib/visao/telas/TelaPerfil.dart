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
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Text(
                      'A',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(Internacionalizacao.dadosPessoais, style: EstilosTextosCustomizado.subTitle(context)),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Internacionalizacao.labelNome, style: EstilosTextosCustomizado.formField2(context)),
                      SizedBox(height: 4),
                      Text('Artur Ribeiro', style: EstilosTextosCustomizado.subTitle(context)),
                      SizedBox(height: 16),
                      Text(Internacionalizacao.labelEmail, style: EstilosTextosCustomizado.formField2(context)),
                      SizedBox(height: 4),
                      Text('arturribeiroalmeida2009@gmail.com', style: EstilosTextosCustomizado.subTitle(context)),
                      SizedBox(height: 16),
                      Text(Internacionalizacao.labelMembro, style: EstilosTextosCustomizado.formField2(context)),
                      SizedBox(height: 4),
                      Text('24/04/2026', style: EstilosTextosCustomizado.subTitle(context)),
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