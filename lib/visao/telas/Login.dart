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

  //true enquanto espera a resposta do servidor
  bool _entrando = false;

  Future<void> _realizarLogin(context) async {
    final usuario = _emailController.text.trim();
    final senha = _passwordController.text;

    //não deixa logar com campos vazios
    if (usuario.isEmpty || senha.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informe e-mail e senha para continuar.')),
      );
      return;
    }

    //senha precisa ter pelo menos 8 caracteres
    if (senha.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('A senha deve ter pelo menos 8 caracteres.')),
      );
      return;
    }

    setState(() => _entrando = true);
    //devolve null se deu certo, ou a mensagem de erro
    final erro = await AutorizacaoController.verificaAutorizacaoOnline(usuario, senha);
    if (!mounted) return;
    setState(() => _entrando = false);

    if (erro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário autenticado: $usuario')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Splash2()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
    }
  }

  //card branco com ícone + campo de texto
  Widget _campoTexto({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icone,
    bool senha = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: senha,
        style: TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black38),
          prefixIcon: Icon(icone, color: Theme.of(context).primaryColorDark),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  //widget painel entrar
  Widget _showEntrar(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: ScreenUtil().setHeight(30)),
        _campoTexto(
          context: context,
          controller: _emailController,
          hint: Internacionalizacao.hintTextUser,
          icone: Icons.person_outline,
        ),
        SizedBox(height: ScreenUtil().setHeight(30)),
        _campoTexto(
          context: context,
          controller: _passwordController,
          hint: Internacionalizacao.hintTextPassword,
          icone: Icons.lock_outline,
          senha: true,
        ),
        SizedBox(height: ScreenUtil().setHeight(80)),
        Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            //desativa o botão enquanto espera o servidor
            onPressed: _entrando ? null : () => _realizarLogin(context),
            child: _entrando
                ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : Text(
              'Logar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
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
  static String hintTextUser = "E-mail";
  static String hintTextPassword = "Senha";
}