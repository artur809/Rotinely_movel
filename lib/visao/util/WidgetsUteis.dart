import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/modelo/ItemListView.dart';
import 'package:rotinely/visao/estilos/EstilosTexto.dart';
import 'package:rotinely/visao/util/CustomIcons.dart';
import 'package:rotinely/visao/telas/Splash1.dart';
import 'package:rotinely/visao/util/SocialIcons.dart';

class WidgetsUteis{
  //organizadores
  SizedBox espacoHorizontal15 = SizedBox(
    height: ScreenUtil().setHeight(15),
  );
  SizedBox espacoHorizontal5 = SizedBox(
    height: ScreenUtil().setHeight(5),
  );
  Widget horizontalLine() =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          //width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.white.withOpacity(0.6),
        ),
      );

  //botões
  botaoAzulBorda({
    required context,
    required String texto,
    required Function executa,
  }){
    return  Container(
      padding: EdgeInsets.all(8.0), // Padding geral no Container
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3C5A99), // Define a cor de fundo
          padding: EdgeInsets.symmetric(vertical: 12.0), // Padding interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
            side: BorderSide(color: Colors.white, width: 2.0), // Borda opcional
          ),
          elevation: 4.0, // Sombra para destaque
          overlayColor: Colors.blueAccent.withOpacity(0.2), // Cor ao pressionar o botão
        ),
        onPressed: () {
          executa(context);
        }, // Ação do botão
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ajusta o tamanho ao conteúdo
          children: <Widget>[
            //IconeSocial(CustomIcons.email), // Ícone
            SizedBox(width: 8.0), // Espaço entre o ícone e o texto
            Text(
              texto, // Texto
              style: EstilosTextosCustomizado.button(context), // Estilo
            ),
          ],
        ),
      ),
    );
  }
  botaoAzulBordaIcone({
    required context,
    required String texto,
    required Icon icone,
    required Function executa,
  }){
    return  Container(
      padding: EdgeInsets.all(8.0), // Padding geral no Container
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3C5A99), // Define a cor de fundo
          padding: EdgeInsets.symmetric(vertical: 12.0), // Padding interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
            side: BorderSide(color: Colors.white, width: 2.0), // Borda opcional
          ),
          elevation: 4.0, // Sombra para destaque
          overlayColor: Colors.blueAccent.withOpacity(0.2), // Cor ao pressionar o botão
        ),
        onPressed: () {
          executa(context);
        }, // Ação do botão
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ajusta o tamanho ao conteúdo
          children: <Widget>[
            //IconeSocial(CustomIcons.email), // Ícone
            icone,
            SizedBox(width: 8.0), // Espaço entre o ícone e o texto
            Text(
              texto, // Texto
              style: EstilosTextosCustomizado.button(context), // Estilo
            ),
          ],
        ),
      ),
    );
  }

  botaoSemBorda({
    required context,
    required String texto,
    required Function executa,
  }){
    return ElevatedButton(
      style: TextButton.styleFrom(
          padding: EdgeInsets.all(12),
          elevation: 2,
          shadowColor: Color.fromRGBO(11, 94, 215, 1.0),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromRGBO(85, 63, 48, 1.0),
                width: 1,
                //strokeAlign: StrokeAlign.outside
              ),
              borderRadius: BorderRadius.circular(12)
          ),
          backgroundColor: Color.fromRGBO(11, 94, 215, 1.0),
      ),
      onPressed: () {
        executa(context);
      }, // Ação do botão,//=> CLogin Model.tryToLogInUserViaEmail(context, _emailController, _passwordController),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ajusta o tamanho do botão ao conteúdo
        children: <Widget>[
          Expanded(
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: EstilosTextosCustomizado.button(context),
            ),
          ),
        ],
      ),
    );
  }
  ListView listaTarefas(context, List<ItemListView> lista){
    // return lista.map((item) {
    //   return ListTile(
    //     titleTextStyle: EstilosTextosCustomizado.subTitle(context),
    //     subtitleTextStyle: EstilosTextosCustomizado.formField(context),
    //     leading: CircleAvatar(
    //       backgroundColor: Colors.white70,
    //       child: Icon(Icons.monetization_on, color: Colors.blueGrey),
    //     ),
    //     title: Text(item.title),
    //     subtitle: Text(item.subtitle),
    //   );
    // }).toList();
    return ListView.builder(
      itemCount: lista.length, // Número de itens na lista
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          titleTextStyle: EstilosTextosCustomizado.subTitle(context),
          subtitleTextStyle: EstilosTextosCustomizado.formField2(context),
          leading: CircleAvatar(
            backgroundColor: Colors.white70,
            child: Icon(Icons.task, color: Colors.blueGrey),
          ),
          title: Text(lista[index].categoria, style: EstilosTextosCustomizado.formField2(context)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lista[index].tituloT),
              Text(lista[index].descricao, style: EstilosTextosCustomizado.formField2(context)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // importante pra não ocupar toda a largura
            children: [
              Text(
                lista[index].prioridade,
                style: EstilosTextosCustomizado.formField2(context),
              ),
              Checkbox(
                value: lista[index].concluido,
                onChanged: (value) {},
              ),
            ],
          ),
        );
      },
    );

  }

  Widget barraCircularProgresso() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            height: 150,
            width: 150,
            child: CircularProgressIndicator(
              strokeWidth: 8.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
        ),
      ],
    );
  }
}