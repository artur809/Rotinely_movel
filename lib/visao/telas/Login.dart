import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/controle/AutorizacaoController.dart';
import 'package:rotinely/visao/telas/Splash2.dart';
import 'package:rotinely/visao/util/CustomIcons.dart';
import 'package:rotinely/visao/estilos/EstilosBotoes.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';
import 'package:rotinely/visao/telas/Principal.dart';
import 'package:rotinely/visao/util/SocialIcons.dart';
import 'package:rotinely/visao/util/WidgetsUteis.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key, required this.title});
  final String title;
  @protected
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Future<void> _realizarLogin(context) async {
    final usuario = _emailController.text;
    final senha = _passwordController.text;

    //não deixa logar com campos vazios
    if (usuario.trim().isEmpty || senha.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informe usuário e senha para continuar.')),
      );
      return;
    }

    //senha precisa ter pelo menos 6 caracteres
    if (senha.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A senha deve ter pelo menos 6 caracteres.')),
      );
      return;
    }

    if (await AutorizacaoController.verificaAutorizacaoOnline(usuario, senha)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário autenticado: $usuario')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Splash2()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado!')),
      );
    }
  }

  Widget _showEntrar(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: ScreenUtil().setHeight(30)),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              style: TextStyle(color: Theme.of(context).highlightColor),
              controller: _emailController,
              decoration: InputDecoration(
                hintText: Internacionalizacao.hintTextUser,
                hintStyle: EstilosTextosCustomizado.formField(context),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).highlightColor, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).highlightColor, width: 1.0)),
                prefixIcon: const Icon(Icons.person, color: Colors.white),
              ),
              obscureText: false,
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(50)),
        Container(
          child: Padding(
            padding: EdgeInsets.only(),
            child: TextField(
              obscureText: true,
              style: TextStyle(color: Theme.of(context).highlightColor),
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: Internacionalizacao.hintTextPassword,
                hintStyle: EstilosTextosCustomizado.formField(context),
                enabledBorder: UnderlineInputBorder(borderSide: EstilosBotoes().borderSideFino(context)),
                focusedBorder: UnderlineInputBorder(borderSide: EstilosBotoes().borderSideFino(context)),
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(80)),
        Container(
          padding: EdgeInsets.only(),
          child: WidgetsUteis().botaoSemBorda(
              context: context,
              texto: 'Logar',
              executa: _realizarLogin
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(15)),
        WidgetsUteis().espacoHorizontal15,
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
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorLight
                  ])),
          child: Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(Internacionalizacao.logoTitle, style: EstilosTextosCustomizado.title(context)),
                          Icon(Icons.task_alt, color: Colors.white, size: 48),
                        ],
                      )),
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(190),
                ),
                SizedBox(height: ScreenUtil().setHeight(60)),
                SizedBox(height: ScreenUtil().setHeight(5)),
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: _showEntrar(context)),
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(778),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class Internacionalizacao {
  static String logoTitle = "ROTINELY";
  static String hintTextUser = "Nome de usuário";
  static String hintTextPassword = "Senha";
}