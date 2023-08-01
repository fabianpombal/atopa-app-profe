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

List <String> respuestas = List.filled(19, "");

class Survey3 extends StatefulWidget {
  const Survey3({
    Key ? key,
  }): super(key: key);

  @override
  State<Survey3> createState() => _Survey3State();
}

class _Survey3State extends State<Survey3> {
  EncuestaAPI _encuestaAPI = EncuestaAPI();
  int? rol;
  int? evaluacion;
  TextStyle preg= estilo(18, true, false);
  BoxDecoration borde= new BoxDecoration(border: Border.all(color: Colors.blue, width: 3));

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

                  Text("Información del perfil", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  
                  
                  multiChoice1("Por favor, indique a qué grupo pertenece",
                            ["Orientador/a","Profesor/a","Psicologo/a"],
                             0),
                  multiChoice1("Por favor, indique su rango de edad",
                            ["<30","30-45","46-60",">60","Prefiero no contestar"],
                             1),


                  multiChoice1("Por favor, indique su sexo",
                            ["Mujer","Hombre"],
                             2),

                  Text("Primer Cuestionario", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  multiChoice1("¿Cree que los resultados de los informes individuales del primer cuestionario son acertados?",
                            ["Si","No","NS/NC"],
                             3),
                  multiChoice1("¿Cree que los resultados de los informes de grupo del primer cuestionario son acertados?",
                            ["Si","No","NS/NC"],
                             4),
                  multiChoice1("¿Cree que las propuestas de intervención del primer cuestionario son acertadas?",
                            ["Si","No","NS/NC"],
                             5),

                  Text("Intervención", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  multiChoice1("¿Ha tenido en cuenta los resultados de los informes generados por la aplicación ATOPA para realizar actividades de intervención en el aula?",
                            ["Si","No","NS/NC"],
                             6),

                  multiChoice1("¿Ha utilizado alguna de las actividades propuestas en la Web Atopa?",
                            ["Si","No","NS/NC"],
                             7),

                  texto("En caso de haber utilizado alguna de las actividades propuestas ¿podría decirnos cuáles?", 8),

                  texto("Describa brevemente su experiencia (indique las principales áreas en las que trabajar con el grupo, las actividades llevadas a cabo, la duración del proceso, ...)", 9),

                  Text("Segundo Cuestionario", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  multiChoice1("¿Ha realizado un segundo cuestionario?",
                            ["Si","No"],
                             10),

                  multiChoice1("¿Cree que los resultados de los informes individuales del segundo cuestionario son acertados?",
                            ["Si","No","NS/NC"],
                             11),

                  multiChoice1("¿Cree que los resultados de los informes de grupo del segundo cuestionario son acertados?",
                            ["Si","No","NS/NC"],
                             12),

                  multiChoice1("¿Cree que las propuestas de intervención del segundo cuestionario son acertadas?",
                            ["Si","No","NS/NC"],
                             13),

                  Text("Evaluación Global", textAlign: TextAlign.center, style: estilo(20, true, false),),

                  multiChoice1("¿Se ha reducido el número de alumnos que sufre rechazo?",
                            ["Si","No","NS/NC"],
                             14),

                  multiChoice1("¿Cuál es su percepción sobre la evolución de la convivencia en el aula, desde que se realizó el primer cuestionario, hasta que se realizó el segundo?",
                            ["empeoró alarmantemente","empeoró ligeramente","se mantuvo","mejoró ligeramente","mejoró sustancialmente","NS/NC"],
                             15),

                  multiChoice2("Si puntuase la aplicación Atopa en una escala del 1 al 10, ¿qué puntuación nos daría?",
                            ["1","2","3","4","5","6","7","8","9","10"],
                             16),

                  texto("En pocas palabras, describa lo que motivó su nota", 17),

                  multiChoice2("¿Qué probabilidad hay de que pueda recomendar la aplicación Atopa a sus colegas?",
                            ["0","1","2","3","4","5","6","7","8","9","10"],
                             18),


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


