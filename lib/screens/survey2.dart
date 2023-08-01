import 'dart:io';

import 'dart:convert';

import 'package:atopa_app_flutter/api/encuestaAPI.dart';
import 'package:atopa_app_flutter/api/models/test.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class Survey2 extends StatefulWidget {

  const Survey2({
    Key ? key,
  }): super(key: key);

  @override
  State<Survey2> createState() => _Survey2State();
}

class _Survey2State extends State<Survey2> {
  EncuestaAPI _encuestaAPI = EncuestaAPI();
  int? rol;
  int? evaluacion;
  TextStyle preg= estilo(18, true, false);
  BoxDecoration borde= new BoxDecoration(border: Border.all(color: Colors.blue, width: 3));

  var respuestas = ["","","","","","","","","","","","","","",""];

  Test? test;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map < String, dynamic > ? args = ModalRoute.of(context) !.settings.arguments as Map < String, dynamic > ? ;
        if (args != null) {
          if (args.containsKey('test')) {
            this.test = args['test'];
          }
        }
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
                  
                  Text( "El objetivo de esta encuesta es llevar a cabo una evaluación de su percepción sobre la eficacia de la aplicación Atopa.\n\n"
                        "Para llevar a cabo esta evaluación, pedimos su colaboración respondiendo al siguiente cuestionario. Su cumplimentación no le llevará más de 20 minutos.\n\n"
                        "Este cuestionario es anónimo, sus respuestas serán tratadas de forma confidencial, y en ningún caso individualizadas.\n\n"
                        "Al responder está aceptando que los resultados sean utilizados con fines académicos y, eventualmente, publicados siempre sin identificar a los participantes. La finalidad de la publicación será dar a conocer el proyecto Atopa y sus herramientas. El proyecto atopa es un proyecto cuyo objetivo es fomentar el uso de instrumentos sociométricos en los centros educativos, para evaluar y mejorar el clima de aula (https://www.atopa.es/).\n\n"
                        "Muchas gracias por su participación.\n", textAlign: TextAlign.center, style: estilo(15, false, false),),

                  Text("Equipo del proyecto Atopa\n", textAlign: TextAlign.center, style: estilo(15, false, true),),

                  Text("Contacto: participa@atopa.es\n", textAlign: TextAlign.center, style: estilo(15, true, false),),

                  Text("INFORMACIÓN PERSONAL", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  Container(
                    decoration: borde,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("Por favor, indique a qué grupo pertenece:", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Orientador/a", 0),
                            radios("Profesor/a", 0),
                            radios("Psicólogo/a", 0),
                            
                          ],
                        )
                      ],
                    ),
                  ),

                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("Por favor, indique su rango de edad:", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("<30", 1),
                            radios("30-45", 1),
                            radios("46-60", 1),
                            radios(">60", 1),
                            radios("Prefiero no contestar", 1),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("Por favor, indique su sexo:", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Mujer", 2),
                            radios("Hombre", 2),
                            radios("Prefiero no contestar", 2),
                            
                          ],
                        )
                      ],
                    ),
                  ),    
                  Text("RESULTADOS", textAlign: TextAlign.center, style: estilo(20, true, false),),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("¿El alumno o alumna líder positivo del grupo que usted esperaba coincide con el resultado del informe?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 3),
                            radios("No", 3),
                            radios("NS/NC", 3),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("¿El alumno o alumna líder negativo del grupo que usted esperaba coincide con el resultado del informe?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 4),
                            radios("No", 4),
                            radios("NS/NC", 4),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("¿Los alumnos o alumnas rechazados por sus compañeros que usted esperaba coinciden con el resultado del informe?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 5),
                            radios("No", 5),
                            radios("NS/NC", 5),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("¿Los alumnos o alumnas aislados que usted esperaba coinciden con el resultado del informe?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 6),
                            radios("No", 6),
                            radios("NS/NC", 6),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("¿Los alumnos o alumnas que comparten una relación de amistad/enemistad mutua que usted esperaba coinciden con el resultado del informe?", style: preg,)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              radios("Sí", 7),
                              radios("No", 7),
                              radios("NS/NC", 7),
                              
                            ],
                          )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex:1,
                          child: Text("¿Los alumnos o alumnas con los que sus compañeros no quieren trabajar en grupo que usted esperaba coinciden con el resultado del informe?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 8),
                            radios("No", 8),
                            radios("NS/NC", 8),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex:1,
                          child: Text("Las situaciones sociales en este grupo que considera que convendría mejorar coinciden con la propuesta de intervención del informe:", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 9),
                            radios("No", 9),
                            radios("NS/NC", 9),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("Antes de realizar el cuestionario ¿pensaba que el grupo estaba cohesionado?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 10),
                            radios("No", 10),
                            radios("NS/NC", 10),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("¿Ha cambiado su opinión después de hacer el cuestionario?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 11),
                            radios("No", 11),
                            radios("NS/NC", 11),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("Antes de realizar el cuestionario ¿pensaba que había subgrupos en el aula?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 12),
                            radios("No", 12),
                            radios("NS/NC", 12),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("¿Ha cambiado su opinión después de hacer el cuestionario?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 13),
                            radios("No", 13),
                            radios("NS/NC", 13),
                            
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: borde,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex:1,child: Text("¿Los subgrupos que usted esperaba que hubiese en el aula, coinciden con los identificados en el informe?", style: preg,)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            radios("Sí", 14),
                            radios("No", 14),
                            radios("NS/NC", 14),
                            
                          ],
                        )
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
                              Map < String, dynamic > body = {'respuesta': jsonEncode(Res(respuestas)), 'test': this.test!.id};
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
                              // final Directory dir= await getApplicationDocumentsDirectory();
                              // final File file= File("${dir.path}/encuesta.json");
                              // await file .writeAsString(jsonEncode(Res(respuestas)));
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
}

class Res {
  List resultados=[];

  Res(this.resultados);

  Map<String, dynamic> toJson() => 
  {
    
    "test":"encuesta1",
    "1":resultados[0],
    "2":resultados[1],
    "3":resultados[2],
    "4":resultados[3],
    "5":resultados[4],
    "6":resultados[5],
    "7":resultados[6],
    "8":resultados[7],
    "9":resultados[8],
    "10":resultados[9],
    "11":resultados[10],
    "12":resultados[11],
    "13":resultados[12],
    "14":resultados[13],
    "15":resultados[14],
    
  };
}

TextStyle estilo (double tam, bool bold, bool italics){

  return new TextStyle(fontSize: tam, fontWeight: bold?FontWeight.bold:FontWeight.normal, fontStyle: italics? FontStyle.italic: FontStyle.normal);

}


