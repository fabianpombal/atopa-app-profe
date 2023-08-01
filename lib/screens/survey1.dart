import 'dart:io';

import 'dart:convert';

import 'package:atopa_app_flutter/api/encuestaAPI.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';



List <String> respuestas = List.filled(48, "");


class Survey1 extends StatefulWidget {
  const Survey1({
    Key ? key,
  }): super(key: key);

  @override
  State<Survey1> createState() => _Survey1State();
}

class _Survey1State extends State<Survey1> {
  EncuestaAPI _encuestaAPI = EncuestaAPI();
  int? rol;
  int? evaluacion;
  TextStyle preg= estilo(18, true, false);
  BoxDecoration borde= new BoxDecoration(border: Border.all(color: Colors.blue, width: 3));
  List<String> opc1=["Totalmente en desacuerdo",
                              "En desacuerdo",
                              "Ni en desacuerdo ni en acuerdo",
                              "En acuerdo",
                              "Totalmente de acuerdo",
                              "NS/NC"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      setState(() {});
    });

  }
  
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      
        appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
        body: SingleChildScrollView(
          child: 
          Center(
          child: Column(children: [
            SizedBox(height: 10, ),
            Row(children: [BreadCrumbNavigator()],
              mainAxisAlignment: MainAxisAlignment.start, ),
            SizedBox(height: 10, ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Center(
              child: Column(
                children: [
                  Text("Evaluación de la Aplicación Atopa\n", style: estilo(25, false, false),),
                  
                  Text( "El objetivo de esta encuesta es llevar a cabo una evaluación de su percepción sobre la eficacia de la aplicación Atopa, con el fin de mejorarla.\n\n"
                        "Para llevar a cabo esta evaluación, pedimos su colaboración respondiendo al siguiente cuestionario. Su cumplimentación no le llevará más de 10 minutos.\n\n"
                        "Este cuestionario es anónimo, sus respuestas serán tratadas de forma confidencial, y en ningún caso individualizadas.\n\n"
                        "Al responder está aceptando que los resultados sean utilizados con fines académicos y, eventualmente, publicados siempre sin identificar a los participantes. La finalidad de la publicación será dar a conocer el proyecto Atopa y sus herramientas. El proyecto atopa es un proyecto cuyo objetivo es fomentar el uso de instrumentos sociométricos en los centros educativos, para evaluar y mejorar el clima de aula (https://www.atopa.es/).\n\n"
                        "Muchas gracias por su participación.\n", textAlign: TextAlign.center, style: estilo(15, false, false),),

                  Text("Equipo del proyecto Atopa\n", textAlign: TextAlign.center, style: estilo(15, false, true),),

                  Text("Contacto: participa@atopa.es\n", textAlign: TextAlign.center, style: estilo(15, true, false),),

                  Text("Información del perfil", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  
                  
                  multiChoice1("Por favor, indique a qué grupo pertenece",
                            ["Orientador/a","Profesor/a","Psicologo/a"],
                             0),
                  multiChoice1("Por favor, indique su rango de edad",
                            ["<30","30-45","46-60",">60","Prefiero no contestar"],
                             1),


                  multiChoice1("Por favor, indique su sexo",
                            ["Mujer","Hombre","Prefiero no contestar"],
                             2),

                  Text("Información sobre la instalación", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  multiChoice1("Por favor, indique el Sistema Operativo en el que se ejecuta la aplicación",
                            ["Windows","Linux","Mac OS"],
                             3),
                  multiChoice1("Por favor, indique el tipo de instalación que ha escogido",
                            ["Han instalado la aplicación ATOPA y el servidor ATOPA en el mismo ordenador en su centro",
                            "Han instalado la aplicación ATOPA y el servidor ATOPA en  distintos ordenadores, los dos en su centro",
                            "Han instalado la aplicación ATOPA en un equipo de su centro, y acceden al servidor ATOPA en la nube",
                            "Ha instalado la aplicación ATOPA y el servidor ATOPA en su portatil",
                            "Ha instalado la aplicación ATOPA en su portatil y accede al servidor ATOPA en la nube"],
                             4),

                  Text("Aplicación Atopa", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  multiChoice1("¿Cómo conoció la aplicación Atopa?",
                            ["A través de la asociación Teavi",
                            "A través de la asociación TADEGA",
                            "A través de la web de Atopa",
                            "A través de los medios de comunicación",
                            "Buscando por Internet herramientas para la evaluación de la convivencia en el aula"],
                             5),

                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child:Column(
                      children: [
                        Text("Está de acuerdo o en desacuerdo con las siguientes afirmaciones sobre la aplicación Atopa:", textAlign: TextAlign.center, style: estilo(17, true, false),),

                        multiChoice1("Es entendible",opc1,6),
                        
                        multiChoice1("Es fácil de usar",opc1,7),
                        multiChoice1("Es aburrida",opc1,8),
                        multiChoice1("Es lenta",opc1,9),
                        multiChoice1("Es segura",opc1,10),
                        multiChoice1("Cubre mis expectativas",opc1,11),
                        multiChoice1("Es novedosa",opc1,12),
                      ],
                    )
                  ),

                  Text("Comentarios para la mejora", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  texto("¿Qué característica de la aplicación Atopa es más importante para usted?", 13),
                  texto("¿Qué característica de la aplicación Atopa es menos importante para usted?", 14),
                  texto("¿Cuál es la característica más importante que cree que deberíamos de añadir?", 15),
                  texto("¿Qué es lo que más le gusta de la aplicación Atopa?", 16),
                  texto("¿Qué es lo que menos le gusta de la aplicación Atopa?", 17),

                  Text("Evaluación global", textAlign: TextAlign.center, style: estilo(20, true, false),),
                  multiChoice2("Si puntuase la aplicación Atopa en una escala del 1 al 10, ¿qué puntuación nos daría?", 
                    ["1","2","3","4","5","6","7","8","9","10"],
                    18),
                  texto("En pocas palabras, describa lo que motivó su nota", 19),
                  multiChoice2("¿Qué probabilidad hay de que pueda recomendar la aplicación Atopa a sus colegas?", 
                    ["0","1","2","3","4","5","6","7","8","9","10"],
                    20),

                  Text("Evaluación específica", textAlign: TextAlign.center, style: estilo(20, true, false),),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text('Sobre la "Creación de clases" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es fácil de usar",opc1,21),
                        multiChoice1("Es atractivo",opc1,22),
                        multiChoice1("Hace lo esperado",opc1,23),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text('Sobre la "Creación de cuestionarios" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es fácil de usar",opc1,24),
                        multiChoice1("Es atractivo",opc1,25),
                        multiChoice1("Hace lo esperado",opc1,26),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text('Sobre el "proceso de inicio de sesión a la hora de subir, descargar o borrar cuestionarios al servidor ATOPA" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es fácil de usar",opc1,27),
                        multiChoice1("Es engorroso",opc1,28),
                        multiChoice1("Aporta seguridad",opc1,29),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text('Sobre los "informes individuales" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es útil",opc1,30),
                        multiChoice1("Es fácil de entender",opc1,31),
                        multiChoice1("Es atractivo",opc1,32),
                        multiChoice1("Los resultados son correctos",opc1,33),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text('Sobre los "informes de grupo" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es útil",opc1,34),
                        multiChoice1("Es fácil de entender",opc1,35),
                        multiChoice1("Es atractivo",opc1,36),
                        multiChoice1("Los resultados son correctos",opc1,37),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      
                      children: [
                        Text('Sobre las "propuestas de intervención" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es útil",opc1,38),
                        multiChoice1("Es fácil de usar",opc1,39),
                        multiChoice1("Es fácil de entender",opc1,40),
                        multiChoice1("Los resultados son correctos",opc1,41),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text('Sobre el "proceso de instalación" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es sencillo",opc1,42),
                        multiChoice1("Da algunos errores",opc1,43),
                        multiChoice1("Da problemas",opc1,44),
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Text('Sobre el "proceso de ejecución" indique si está de acuerdo o en desacuerdo con las siguientes afirmaciones:', textAlign: TextAlign.center, style: estilo(17, true, false),),
                        multiChoice1("Es sencillo",opc1,45),
                        multiChoice1("Da algunos errores",opc1,46),
                        multiChoice1("Da problemas",opc1,47),
                      ],
                    ),
                  ),

                  





                  Padding(
                  padding: EdgeInsets.all(10),
                  child:ElevatedButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Enviar respuestas.'),
                        content: const Text('Ya no se podrán cambiar'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              print(jsonEncode(Res(respuestas)));
                              Map < String, dynamic > body = {'respuesta': jsonEncode(Res(respuestas))};
                              Response value = await _encuestaAPI.newEncuesta(body);
                              Navigator.pop(context);
                                if (value.statusCode == 200) {
                                  Navigator.pop(context);
                                } else if (value.statusCode == 400) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(t!.error),
                                        content: Text(json.decode(value.body)['message']),
                                        actions: < Widget > [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                                child: Text(t.ok),
                                            ),
                                          ),
                                        ],
                                    ),
                                  );
                                }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),



                    
                    child: Text(t!.save),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 15.0,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                textStyle:
                                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ), ),
                ),
                ],
              ),
            ),
          ),
        ]))),
        persistentFooterButtons: const [
        CustomFooterBar()
      ],
    );
  }
  Row radios(String valor, int index) {
    return Row(
      children: [
        Radio(
          value: "$valor", 
          groupValue: respuestas[index], 
          onChanged: (value){
            setState(() {
              respuestas[index]="$value";
            },);
          }
        ),
        Text("$valor",),
      ],
    );
  }

  Container multiChoice1(String pregunta, List <String> res, int index){
    return Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("$pregunta", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for(int i=0; i<res.length; i++)...[
                              radios("${res[i]}", index)
                            ],
                          ],
                        )
                      ],
                    ),
                  );
  }

   Column radiosC(String valor, int index) {
    return Column(
      children: [
        Text("$valor",),
        Radio(
          value: "$valor", 
          groupValue: respuestas[index], 
          onChanged: (value){
            setState(() {
              respuestas[index]="$value";
            },);
          }
        ),
        
      ],
    );
  }

  Container multiChoice2(String pregunta, List<String> res, int index){
     return Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(

                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,20),
                          child: Text("$pregunta", style: preg,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for(int i=0; i<res.length; i++)...[
                              radiosC("${res[i]}", index)
                            ],
                          ],
                        )
                      ],
                    ),
                  );
  }

  Container texto(String pregunta, int index){
    return Container(
      decoration: borde,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Column(

        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,20),
            child: Text("$pregunta", style: preg,),
          ),
          TextField(
            textAlign: TextAlign.center,
            onChanged: (text){
              respuestas[index]=text;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 2)),
              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            ),
          ),
        ],
      ),
    );
  }

}

class Res {
  List resultados=[];

  Res(this.resultados);

  Map<String, dynamic> toJson(){
    
    Map<String, dynamic> a={};

    for(int i=0; i<respuestas.length; i++){
      a["$i"]=respuestas[i];
    }

    return a;
    
  }
}

TextStyle estilo (double tam, bool bold, bool italics){

  return new TextStyle(fontSize: tam, fontWeight: bold?FontWeight.bold:FontWeight.normal, fontStyle: italics? FontStyle.italic: FontStyle.normal);

}


