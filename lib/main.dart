//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/visao/estilos/Tema.dart';
import 'package:rotinely/visao/telas/Splash1.dart';


//método que chama a classe inicial da aplicação
void main() async{
  //habilitando o pacote screen_util
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());
}

//classe inicial da aplicação
class MyApp extends StatelessWidget {


  //construtor padrão da aplicação
  const MyApp({super.key});

  //método responsável por construir uma interface não alterável, neste caso a moldura em branco do app
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: temaEscuro(),//tema criado em estilos
      home: Splash1(), //chamando a tela de splash
    );
  }
}
