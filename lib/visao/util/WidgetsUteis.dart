import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rotinely/modelo/objects/Tarefa.dart';
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

  ListView listaTarefas(context, List<Tarefa> lista, {Function(Tarefa item)? aoTocarConcluido}){
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 4),
      itemCount: lista.length,
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final tarefa = lista[index];
        return Container(
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: Icon(
                    Icons.task_alt_outlined,
                    color: Theme.of(context).primaryColorDark,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tarefa.categoria.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        tarefa.tituloT,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tarefa.concluido ? Colors.black38 : Colors.black87,
                        ),
                      ),
                      if (tarefa.descricao.isNotEmpty) ...[
                        SizedBox(height: 2),
                        Text(
                          tarefa.descricao,
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _corPrioridade(tarefa.prioridade).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tarefa.prioridade,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _corPrioridade(tarefa.prioridade),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: tarefa.concluido,
                  activeColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  onChanged: (value) {
                    if (aoTocarConcluido != null) aoTocarConcluido(tarefa);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _corPrioridade(String prioridade) {
    switch (prioridade.toLowerCase()) {
      case 'alta': return Color(0xFFDC2626);
      case 'média':
      case 'media': return Color(0xFFD97706);
      case 'baixa': return Color(0xFF16A34A);
      default: return Colors.grey;
    }
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