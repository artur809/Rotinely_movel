import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rotinely/visao/telas/TelaPerfil.dart';
import 'package:rotinely/visao/telas/TelaHome.dart';
import 'package:rotinely/visao/util/WidgetsUteis.dart';
import 'package:rotinely/visao/estilos/Tema.dart';
import 'package:rotinely/controle/AutorizacaoController.dart';
import 'package:rotinely/visao/telas/Login.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}
class _PrincipalState extends State<Principal> {

  //construção da estrutura
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body:  _screens[_currentIndex],
        bottomNavigationBar: _bottomNavigationBar()
    );
  }

  /////////////////////////
  //variáveis
  int _currentIndex = 0;

  List<Widget> _screens = [
    new TelaUm(title: 'Primeira tela'),
    new TelaDois(title: 'Segunda tela'),
  ];


  @override
  void initState() {
    _currentIndex = 0;
  }
  //////////////////////////
  //widgets
  //barra de títulos
  AppBar _appBar(){
    return AppBar(
      title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Internacionalizacao.titulo,
                style: GoogleFonts.cormorantGaramond(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              Icon(
                  Icons.task_alt,
                  color: Colors.white,
                  size: 30,
                ),
            ],
          ),
      backgroundColor: Theme.of(context).primaryColorDark,
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await AutorizacaoController.logout();
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login(title: 'Aplicativo')),
                  (route) => false,
            );
          },
        ),
      ],
    );
  }
  //barra de menu
  BottomNavigationBar _bottomNavigationBar(){
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColorLight,
      currentIndex: _currentIndex!,
      onTap: (index) {
        setState(() {
          _currentIndex = index; // Atualiza o índice
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: Internacionalizacao.opt1,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: Internacionalizacao.opt2,
        ),
      ],
    );
  }

}
class Internacionalizacao {
  static String opt1 = "Tarefas";
  static String opt2 = "Perfil";
  static String titulo = "ROTINELY";

}

