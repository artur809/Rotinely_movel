//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';
import 'package:rotinely/visao/telas/Principal.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/visao/util/CustomIcons.dart';

import 'package:rotinely/visao/telas/Splash1.dart';
import 'package:rotinely/visao/util/SocialIcons.dart';

//import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:rotinely/main.dart';
import 'package:rotinely/visao/util/WidgetsUteis.dart';

import 'Login.dart';

//classe inicial da tela
class Splash2 extends StatefulWidget {
  @override
  _Splash2State createState() => _Splash2State();
}
//classe altualizavel da tela
class _Splash2State extends State<Splash2> {

  //método de inicialização da tela
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Principal()),
      );
    });
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
