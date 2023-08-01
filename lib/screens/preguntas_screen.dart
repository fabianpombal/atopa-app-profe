import 'dart:convert';
import 'dart:typed_data';
import 'package:atopa_app_flutter/api/preguntaAPI.dart';
import 'package:atopa_app_flutter/api/models/pregunta.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:html'
as html;
import 'package:http/http.dart'
as http;
import 'dart:js'
as js;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PreguntasScreen extends StatefulWidget {
  const PreguntasScreen({
    Key ? key
  }): super(key: key);

  @override
  State < PreguntasScreen > createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State < PreguntasScreen > {
  Future < List < Pregunta >> ? preguntas;
  // late List<Pregunta> preguntasObj;
  PreguntaAPI _preguntaAPI = PreguntaAPI();

  int? rol;
  int? evaluacion;

  int ? lang;
  LanguageProvider? provLang;
  var f;

  @override
  void initState() {
    super.initState();
    this.provLang = Provider.of < LanguageProvider > (context, listen: false);
    this.lang = this.provLang!.currentIndex;
    this.f = () { 
      this.lang = this.provLang!.currentIndex;
      this.preguntas = _preguntaAPI.getPreguntasSearch({
          'idioma': this.lang
        });
      if (mounted)
      setState(() {
    });};
    this.provLang!.addListener(this.f);
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      setState(() {
        // Map < String, dynamic > ? args = ModalRoute.of(context) !.settings.arguments as Map < String, dynamic > ? ;
        // if (args != null) {
        //   if (args.containsKey('year')) {
        //     this.year = args['year'];
        //   }
        // }
        this.preguntas = _preguntaAPI.getPreguntasSearch({
          'idioma': this.lang
        });
      });
      // refreshPreguntas();
    });

  }

  @override
  void dispose() {
    this.provLang!.removeListener(this.f);
    super.dispose();
  }

  // void _delete(BuildContext context, Pregunta pregunta) {
  //   var t = AppLocalizations.of(context);
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext ctx) {
  //       return AlertDialog(
  //         title: Text(t!.confirm),
  //           content: Text(t.confirm_pregunta + pregunta.pregunta + " " + t.confirm_pregunta2),
  //           actions: [
  //             // The "Yes" button
  //             TextButton(
  //               onPressed: () async {
  //                 // Remove the box
  //                 Response value = await _preguntaAPI.deletePregunta(pregunta.id!);

  //                 if (value.statusCode == 200) {
  //                   Navigator.of(context).pop();
  //                   this.f();
  //                 }
  //                 // Close the dialog
  //               },
  //               child: Text(t.yes)),
  //             TextButton(
  //               onPressed: () {
  //                 // Close the dialog
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(t.no))
  //           ],
  //       );
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
      body:
      FutureBuilder < List < Pregunta >> (future: preguntas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            
            if (snapshot.hasData) {
              List < Pregunta > data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10, ),
                    Row(children: [BreadCrumbNavigator()],
                      mainAxisAlignment: MainAxisAlignment.start, ),
                    SizedBox(height: 10, ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const _CustomIconButton(
                        //   icono: Icons.remove_red_eye_rounded,
                        // ),
                        
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Tooltip(
                            message: '',
                            textStyle: TextStyle(fontSize: 12, color: Colors.white), 
                            child:ElevatedButton.icon(
                            onPressed: () {
                              this.provLang!.removeListener(this.f);
                              Navigator.pushNamed(context, 'new-pregunta',
                                arguments: {
                                  'menu': t!.new_question
                                }).then((value) {
                                this.provLang!.addListener(this.f);
                                this.f();
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                            label: Text(
                              t!.new_question,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: CustomTheme.atopaBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 15.0,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            ),
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 10, ),
                    data.isEmpty ?
                    Center(child: Column(children: [
                      SizedBox(height: 25, ),
                      Container(
                        width: 2 * MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: CustomTheme.atopaGrey,
                          border: Border.all(color: CustomTheme.atopaGreyDark, width: 2),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(t.no_questions, style: TextStyle(fontSize: 20))]), ),
                    ], )) :
                    ExpansionPanelList(
                      elevation: 3,
                      // Controlling the expansion behavior
                      expansionCallback: (index, isExpanded) {
                        setState(() {
                          data[index].isExpanded = !isExpanded;
                        });
                      },
                      animationDuration: Duration(milliseconds: 600),
                      children: data
                      .map(
                        (item) => ExpansionPanel(
                          canTapOnHeader: true,
                          backgroundColor:
                          item.isExpanded == true ? CustomTheme.atopaBlueLight : Colors.white,
                          headerBuilder: (context, isExpanded) {
                            return Container(
                              padding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                              child: Column(children: [Center(child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, //Center Row contents horizontally,
                                crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                children: [
                                  Text(
                                    item.pregunta,
                                    style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  Row(children: [
                                    Tooltip(
                                      message: t.edit_question,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child: ElevatedButton(
                                        child: Row(children: [Icon(Icons.edit, size: 25, )]),
                                        onPressed: () {
                                          this.provLang!.removeListener(this.f);
                                            Navigator.pushNamed(context, 'new-pregunta',
                                              arguments: {
                                                'pregunta': item,
                                                'menu': t.edit_question
                                              }).then((value) {
                                              this.provLang!.addListener(this.f);
                                              this.f();
                                            });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 15.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      ),
                                    ),
                                    // SizedBox(width: 10, ),
                                    // Tooltip(
                                    //   message: t.delete_question,
                                    //   textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                    //   child:
                                    //   ElevatedButton(
                                    //     child: Row(children: [Icon(Icons.delete, size: 25, )]),
                                    //     onPressed: this.year!.current == 0 ? null : () => _delete(context, item),
                                    //     style: ElevatedButton.styleFrom(
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(5),
                                    //       ),
                                    //       elevation: 15.0,
                                    //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                    //         primary: Colors.red
                                    //       // textStyle:
                                    //       //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                    //     ),
                                    //   )),
                                  ], )
                                ]
                              ))])
                            );
                          },
                          body: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: CustomTheme.atopaGreyDark, width: 2),
                                bottom: BorderSide(color: CustomTheme.atopaGreyDark, width: 1))
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: Column(children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: CustomTheme.atopaGrey, width: 1),
                                ),
                                width: (2 * MediaQuery.of(context).size.width) / 3,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
                                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                  children: [
                                    Column(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              children: < TextSpan > [
                                                TextSpan(text: t.age_group + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: item.grupo_edad_nombre),
                                              ],
                                          )),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start, ),
                                    Column(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              children: < TextSpan > [
                                                TextSpan(text: t.typeStructure + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: item.tipo_estructura_nombre),
                                              ],
                                          )),
                                        
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start, ),
                                    Column(children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                            children: < TextSpan > [
                                              TextSpan(text: t.type_question + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: item.tipo_pregunta_nombre),
                                            ],
                                        )),
                                    ], crossAxisAlignment: CrossAxisAlignment.start, ),
                                  ]),
                              )
                            ])
                          ),
                          isExpanded: item.isExpanded!, ), )
                      .toList(),
                    ),
                    const SizedBox(height: 40, ),
                  ], )
              );

            }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(
              child: CircularProgressIndicator(),
            )],
          );
        },
      ),
      persistentFooterButtons: const [
        CustomFooterBar()
      ],
    );
  }
}