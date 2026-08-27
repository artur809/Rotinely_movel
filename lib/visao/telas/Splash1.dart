//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/visao/util/CustomIcons.dart';

import 'package:rotinely/visao/telas/Splash1.dart';
import 'package:rotinely/visao/telas/Splash2.dart';
import 'package:rotinely/visao/util/SocialIcons.dart';

//import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:rotinely/main.dart';
import 'package:rotinely/visao/util/WidgetsUteis.dart';

import 'Login.dart';
import 'package:rotinely/controle/AutorizacaoController.dart';

//classe inicial da tela
class Splash1 extends StatefulWidget {
  @override
  _Splash1State createState() => _Splash1State();
}
//classe altualizavel da tela
class _Splash1State extends State<Splash1> {

  //método de inicialização da tela
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      await verificaLogin();
    });
  }

  Future<void> verificaLogin() async {
    bool jaLogado = await AutorizacaoController.verificaAutorizacaoOffline();
    if (!mounted) return; // evita erro se a tela já foi fechada nesse meio tempo

    if (jaLogado) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Splash2()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(title: 'Aplicativo')));
    }
  }
//método de construção da interface da tela
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ROTINELY',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.task_alt,
                  color: Colors.white,
                  size: 70,
                ),
              ],
            ),
            WidgetsUteis().espacoHorizontal15,
            WidgetsUteis().barraCircularProgresso(),
          ],
        ),
      ),
    );
  }
}
