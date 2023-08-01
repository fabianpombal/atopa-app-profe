import 'dart:convert';
import 'dart:js'
as js;
import 'dart:html'
as html;
import 'package:atopa_app_flutter/api/authAPI.dart';
import 'package:atopa_app_flutter/api/models/alumno.dart';
import 'package:atopa_app_flutter/api/models/preferencias.dart';
import 'package:atopa_app_flutter/api/models/pregunta.dart';
import 'package:atopa_app_flutter/api/models/test.dart';
import 'package:atopa_app_flutter/api/models/user.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/api/testAPI.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/card_container.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ResultsStudentScreen extends StatefulWidget {
  const ResultsStudentScreen({
    Key ? key
  }): super(key: key);

  @override
  _ResultsStudentScreenState createState() => _ResultsStudentScreenState();
}

class _ResultsStudentScreenState extends State < ResultsStudentScreen > {
    bool _dataLoaded = false;

    Test ? test;
    Year ? year;
    Alumno ? alumno;

    int ? lang;

    TestAPI _testAPI = new TestAPI();

    Map < String,
    dynamic > ? jsonObj;

    Map < String,
    dynamic > ? respuestas;
    List < Map < String,
    dynamic >> respuestasText = [{}, {}, {}];
    Map < String,
    dynamic > ? recomendaciones;

    int ? sp;
    int ? sn;
    int ? np;
    int ? nn;
    int ? ip;
    int ? iN;
    int ? ep;
    int ? en;
    int ? pp;
    int ? pn;
    int ? pap;
    int ? pan;
    int ? imp;
    int ? imn;
    int ? ipp;
    int ? ipn;

    String ? spValue;
    String ? snValue;
    String ? epValue;
    String ? enValue;
    String ? ppValue;
    String ? pnValue;
    String ? papValue;
    String ? panValue;
    String ? ipValue;
    String ? inValue;
    String ? impValue;
    String ? imnValue;
    String ? ippValue;
    String ? ipnValue;

    Map < String,
    dynamic > ? rp;
    Map < String,
    dynamic > ? rn;
    Map < String,
    dynamic > ? os;
    Map < String,
    dynamic > ? oip;
    Map < String,
    dynamic > ? oin;

    String ? pos;

    Map < String,
    dynamic > ? alumnosNames;

    List < dynamic > ? preguntas;
    List < dynamic > ? alumnos;

    User ? teacher;
    Preferencias? preferencias;
    AuthAPI _authAPI = AuthAPI();
    int? rol;
    int? evaluacion;

    LanguageProvider? provLang;
    var f;

    @override
    void dispose() {
      this.provLang!.removeListener(this.f);
      super.dispose();
    }

    void start() async {
      this.jsonObj = await _testAPI.getResultsStudent(this.test!.id!, this.lang!, this.alumno!.code!);
        this.respuestas = jsonDecode(jsonObj ? ['respuestas']);
        this.respuestasText[0] = jsonObj ? ['respuestasText2'];
        this.respuestasText[1] = jsonObj ? ['respuestasText4'];
        this.respuestasText[2] = jsonObj ? ['respuestasText6'];
        this.teacher = new User.fromJson(jsonObj ? ['teacher']);
        this.preferencias = await this._authAPI.getPreferencias(this.teacher!.user!);
        this.ep = int.parse(jsonObj ? ['ep']);
        this.en = int.parse(jsonObj ? ['en']);
        this.sp = int.parse(jsonObj ? ['sp']);
        this.sn = int.parse(jsonObj ? ['sn']);
        this.np = int.parse(jsonObj ? ['np']);
        this.nn = int.parse(jsonObj ? ['nn']);
        this.pp = int.parse(jsonObj ? ['pp']);
        this.pn = int.parse(jsonObj ? ['pn']);
        this.pap = int.parse(jsonObj ? ['pap']);
        this.pan = int.parse(jsonObj ? ['pan']);
        this.ip = int.parse(jsonObj ? ['ip']);
        this.iN = int.parse(jsonObj ? ['in']);
        this.imp = int.parse(jsonObj ? ['imp']);
        this.imn = int.parse(jsonObj ? ['imn']);
        this.ipp = int.parse(jsonObj ? ['ipp']);
        this.ipn = int.parse(jsonObj ? ['ipn']);

        this.pos = jsonObj ? ['pos'];

        this.spValue = jsonObj ? ['spValue'];
        this.snValue = jsonObj ? ['snValue'];
        this.epValue = jsonObj ? ['epValue'];
        this.enValue = jsonObj ? ['enValue'];
        this.ppValue = jsonObj ? ['ppValue'];
        this.pnValue = jsonObj ? ['pnValue'];
        this.papValue = jsonObj ? ['papValue'];
        this.panValue = jsonObj ? ['panValue'];
        this.ipValue = jsonObj ? ['ipValue'];
        this.inValue = jsonObj ? ['inValue'];
        this.impValue = jsonObj ? ['impValue'];
        this.imnValue = jsonObj ? ['imnValue'];
        this.ippValue = jsonObj ? ['ippValue'];
        this.ipnValue = jsonObj ? ['ipnValue'];

        this.rp = jsonDecode(jsonObj ? ['rp']);
        this.rn = jsonDecode(jsonObj ? ['rn']);
        this.os = jsonDecode(jsonObj ? ['os']);
        this.oip = jsonDecode(jsonObj ? ['oip']);
        this.oin = jsonDecode(jsonObj ? ['oin']);
        this.recomendaciones = jsonObj ? ['recomendaciones'];
        this.preguntas = jsonObj ? ['preguntas'].map((data) => new Pregunta.fromJson(data)).toList();
        this.alumnos = jsonObj ? ['alumnos'].map((data) => new Alumno.fromJson(data)).toList();

        _dataLoaded = true;
        if (mounted)
        setState(() {
          
        });
    }

    @override
    void initState() {
      super.initState();
      // call remote function to return network data
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        this.rol = await prefs.getInt('rol') ?? 2;
        this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
        this.provLang = Provider.of < LanguageProvider > (context, listen: false);
        this.lang = this.provLang!.currentIndex;
        this.f = () async {
          this.lang = this.provLang!.currentIndex;
          this._dataLoaded = false;
          start();
        };
        this.provLang!.addListener(this.f);
        Map < String, dynamic > ? args = ModalRoute.of(context) !.settings.arguments as Map < String, dynamic > ? ;
        if (args != null) {
          if (args.containsKey('year')) {
            this.year = args['year'];
          }
          if (args.containsKey('test')) {
            this.test = args['test'];
          }
          if (args.containsKey('student')) {
            this.alumno = args['student'];
          }
        }
        start();
      });
    }

    @override
    Widget build(BuildContext context) {
      var t = AppLocalizations.of(context);
      return Scaffold(
          appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
          body: _dataLoaded ? SingleChildScrollView(
            child: Center(
              child: Column(children: [
                  SizedBox(height: 10, ),
                  Row(children: [BreadCrumbNavigator()],
                    mainAxisAlignment: MainAxisAlignment.start, ),
                  SizedBox(height: 10, ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // int lang = Provider.of < LanguageProvider > (context, listen: false).currentIndex;
                            showDialog(
                              context: context,
                              builder: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: CustomTheme.atopaBlue,
                                ),
                              ),
                              barrierDismissible: false);
                            Response res = await _testAPI.downloadStudentPdf(this.alumno!.code!, this.test!, this.lang!);
                            Navigator.pop(context);
                            if (res.statusCode == 200) {
                              js.context.callMethod("webSaveAs", [html.Blob([res.data]), this.test!.nombre + "-Informe_" + this.alumno!.nombre + "_" + this.alumno!.apellidos + ".pdf"]);
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(t!.errorResults),
                                    content: Text(json.decode(utf8.decode(res.data))['message']),
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
                          icon: Icon(
                            Icons.insert_drive_file,
                            color: Colors.white,
                            size: 30,
                          ),
                          label: Text(
                            t!.down_alumno,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: CustomTheme.atopaGreenLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            elevation: 15.0,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40, ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DataTable(
                        headingRowHeight: 100,
                        headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                        border: TableBorder.all(
                          width: 2.0,
                          color: CustomTheme.atopaGreyDark,
                          borderRadius: BorderRadius.circular(10)),
                        columns: [
                          DataColumn(label: Container(
                            width: 2*MediaQuery.of(context).size.width / 3,
                            child: Row(children: [Text(
                                t.report + this.alumno!.nombre + " " + this.alumno!.apellidos,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                              )],
                              mainAxisAlignment: MainAxisAlignment.center, ), )),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text: t.alias + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.alumno!.alias),
                                    ],
                                ))))
                          ]),
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text:t.dni + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.alumno!.DNI),
                                    ],
                                ))))
                          ]),
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text: t.date_birth + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.alumno!.fecha_nacimiento),
                                    ],
                                )))),
                          ]),
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text: t.sex + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.alumno!.sexo),
                                    ],
                                )))),
                          ]),
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text: t.class_name + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.test!.clase_nombre),
                                    ],
                                )))),

                          ]),
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text: t.responsible + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.teacher!.nombre + " " + this.teacher!.apellidos),
                                    ],
                                )))),

                          ]),
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text: t.name_test + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.test!.nombre),
                                    ],
                                )))),

                          ]),
                          DataRow(cells: [
                            DataCell(Container(
                              width: 2*MediaQuery.of(context).size.width / 3,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                    children: < TextSpan > [
                                      TextSpan(text: t.creation + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: this.test!.date_created),
                                    ],
                                )))),

                          ]),
                        ],
                      ),
                    ], ),

                  SizedBox(height: 40, ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [Expanded(child: Divider(
                        height: 30,
                        color: Colors.black
                      )),
                      Text(
                        t.questions,
                        style: Theme.of(context).textTheme.headline5,
                      ), Expanded(child: Divider(
                        height: 30,
                        color: Colors.black
                      )),
                    ], ),
                  SizedBox(height: 20, ),
                  for (String num in this.respuestas!.keys)
                    Column(children: [
                        Text(
                          t.question + " " + num + " (" + (num == '1' ? 'PGP' : num == '2' ? 'PGN' : num == '3' ? 'PPP' : num == '4' ? 'PPN' : num == '5' ? 'AAP' : 'AAN') + "): " + this.preguntas![int.parse(num) - 1].pregunta,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 20),
                        for (String user in this.respuestas![num].keys)
                          if (user == this.alumno!.code)
                            DataTable(
                              headingRowHeight: 100,
                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                              border: TableBorder.all(
                                width: 2.0,
                                color: CustomTheme.atopaGreyDark,
                                borderRadius: BorderRadius.circular(10)),
                              columns: [
                                DataColumn(label: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Row(children: [Text(
                                      '1º',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                    )],
                                    mainAxisAlignment: MainAxisAlignment.center, ), )),
                                DataColumn(label: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Row(children: [Text(
                                      '2º',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                    )],
                                    mainAxisAlignment: MainAxisAlignment.center, ), )),
                                DataColumn(label: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Row(children: [Text(
                                      '3º',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                    )],
                                    mainAxisAlignment: MainAxisAlignment.center, ), )),
                                DataColumn(label: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Row(children: [Text(
                                      '4º',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                    )],
                                    mainAxisAlignment: MainAxisAlignment.center, ), )),
                                DataColumn(label: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Row(children: [Text(
                                      '5º',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                                    )],
                                    mainAxisAlignment: MainAxisAlignment.center, ), )),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Row(children: [Flexible(child:RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                        children: < TextSpan > [
                                          TextSpan(text: return_value(this.respuestas![num][user], 5)),
                                        ],
                                    )))]),),
                                  DataCell(Row(children: [Flexible(child:RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                        children: < TextSpan > [
                                          TextSpan(text: return_value(this.respuestas![num][user], 4)),
                                        ],
                                    )))]),),
                                  DataCell(Row(children: [Flexible(child:RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                        children: < TextSpan > [
                                          TextSpan(text: return_value(this.respuestas![num][user], 3)),
                                        ],
                                    )))]),),
                                  DataCell(Row(children: [Flexible(child:RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                        children: < TextSpan > [
                                          TextSpan(text: return_value(this.respuestas![num][user], 2)),
                                        ],
                                    )))]),),
                                  DataCell(Row(children: [Flexible(child:RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                        ),
                                        children: < TextSpan > [
                                          TextSpan(text: return_value(this.respuestas![num][user], 1)),
                                        ],
                                    )))]),),
                                ]),
                                if (int.parse(num) % 2 == 0)
                                  DataRow(cells: [
                                    DataCell(Text(t.why, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 18), )),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                  ]),
                                  if (int.parse(num) % 2 == 0)

                                    DataRow(cells: [
                                        for (var userAns in this.respuestasText[int.parse(num) ~/2 - 1].keys)
                                              if (userAns == return_text(this.respuestas![num][user], 5))
                                                DataCell(Row(children: [Flexible(child:Text(this.respuestasText[int.parse(num) ~/2 - 1][userAns], style: TextStyle(fontSize: 18)))])),
                                                      for (var userAns in this.respuestasText[int.parse(num) ~/2 - 1].keys)
                                                            if (userAns == return_text(this.respuestas![num][user], 4))
                                                              DataCell(Row(children: [Flexible(child:Text(this.respuestasText[int.parse(num) ~/2 - 1][userAns], style: TextStyle(fontSize: 18)))])),
                                                                    for (var userAns in this.respuestasText[int.parse(num) ~/2 - 1].keys)
                                                                          if (userAns == return_text(this.respuestas![num][user], 3))
                                                                            DataCell(Row(children: [Flexible(child:Text(this.respuestasText[int.parse(num) ~/2 - 1][userAns], style: TextStyle(fontSize: 18)))])),
                                                                                  for (var userAns in this.respuestasText[int.parse(num) ~/2 - 1].keys)
                                                                                      if (userAns == return_text(this.respuestas![num][user], 2))
                                                                                        DataCell(Row(children: [Flexible(child:Text(this.respuestasText[int.parse(num) ~/2 - 1][userAns], style: TextStyle(fontSize: 18)))])),
                                                                                            for (var userAns in this.respuestasText[int.parse(num) ~/2 - 1].keys)
                                                                                                  if (userAns == return_text(this.respuestas![num][user], 1))
                                                                                                    DataCell(Row(children: [Flexible(child:Text(this.respuestasText[int.parse(num) ~/2 - 1][userAns], style: TextStyle(fontSize: 18)))])),
                                                                                                      if (return_text(this.respuestas![num][user], 5) == '')
                                                                                                        DataCell(Text('')),
                                                                                                        if (return_text(this.respuestas![num][user], 4) == '')
                                                                                                          DataCell(Text('')),
                                                                                                          if (return_text(this.respuestas![num][user], 3) == '')
                                                                                                            DataCell(Text('')),
                                                                                                            if (return_text(this.respuestas![num][user], 2) == '')
                                                                                                              DataCell(Text('')),
                                                                                                              if (return_text(this.respuestas![num][user], 1) == '')
                                                                                                                DataCell(Text('')),
                                                                                                    ]), ]),
                                                                                                SizedBox(height: 40),

                                                                                            ], ),
                                                                                          SizedBox(height: 20),
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [Expanded(child: Divider(
                                                                                                height: 30,
                                                                                                color: Colors.black
                                                                                              )),
                                                                                              Text(
                                                                                                t.analyse,
                                                                                                style: Theme.of(context).textTheme.headline5,
                                                                                              ), Expanded(child: Divider(
                                                                                                height: 30,
                                                                                                color: Colors.black
                                                                                              )),
                                                                                            ], ),

                                                                                          SizedBox(height: 30),
                                                                                          if (this.preferencias!.sp == 1 && this.preferencias!.ep == 1)
                                                                                          Text(
                                                                                            t.spTitle1,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.sp == 1 && this.preferencias!.ep == 0)
                                                                                          Text(
                                                                                            t.spTitle2,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.sp == 0 && this.preferencias!.ep == 1)
                                                                                          Text(
                                                                                            t.spTitle3,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.sp == 1 || this.preferencias!.ep == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.sp == 1 || this.preferencias!.ep == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                if (this.preferencias!.sp == 1)
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      'SP',
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                if (this.preferencias!.sp == 1)
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      'SN',
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                if (this.preferencias!.ep == 1)
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      'EP',
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                if (this.preferencias!.ep == 1)
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      'EN',
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  if (this.preferencias!.sp == 1)
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(sp.toString(), style: TextStyle(color: this.spValue == t.low ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  if (this.preferencias!.sp == 1)
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(sn.toString(), style: TextStyle(color: this.snValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  if (this.preferencias!.ep == 1)
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(ep.toString() + "%", style: TextStyle(color: this.ep! > 25 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  if (this.preferencias!.ep == 1)
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(en.toString() + "%", style: TextStyle(color: this.en! < 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                          SizedBox(height: 40, ),

                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: 4 * MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.position,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label: Text('')),
                                                                                                    DataColumn(label: Text('')),
                                                                                                    DataColumn(label: Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.pos!, style: TextStyle(fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            ), ]),
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.sp == 1)
                                                                                          Text(
                                                                                            t.spTitleStatus,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.sp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.sp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: 2 *MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: 2*MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label: Text('')),
                                                                                                    DataColumn(label: Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.spValue!, style: TextStyle(color: this.spValue == t.low ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.np.toString() + "%", style: TextStyle(color: this.np! <= 25 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Text('')),
                                                                                                  DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.sp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.sp == 1)
                                                                                          Text(
                                                                                            t.snTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.sp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.sp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label: Text('')),
                                                                                                    DataColumn(label: Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.snValue!, style: TextStyle(color: this.snValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.nn.toString() + "%", style: TextStyle(color: this.nn! >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.sp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.rp == 1)
                                                                                          Text(
                                                                                            t.friendTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.rp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.rp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6 + MediaQuery.of(context).size.width / 18,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.nameCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6 + MediaQuery.of(context).size.width / 18,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.degree,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6 + MediaQuery.of(context).size.width / 18,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      '',
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label: Text('')),
                                                                                                    
                                                                                              ],
                                                                                              rows: [
                                                                                                for (var amigo in this.rp!.keys)
                                                                                                  DataRow(cells: [
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Flexible(child:Text(getNombre(amigo), style: TextStyle(fontSize: 18), ))])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.rp![amigo][1].toString() + "-" + this.rp![amigo][2].toString(), style: TextStyle(fontSize: 18), )])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.rp![amigo][0], style: TextStyle(fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                  ]),
                                                                                                  if (this.rp!.isEmpty)
                                                                                                    DataRow(cells: [
                                                                                                      DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [Text(t.not_there, style: TextStyle(color: Colors.red, fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                    ]),
                                                                                              ],
                                                                                            ), ]),
                                                                                            if (this.preferencias!.rp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.rp == 1)
                                                                                          Text(
                                                                                            t.enemyTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.rp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.rp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6 + MediaQuery.of(context).size.width / 18,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.nameCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6 + MediaQuery.of(context).size.width / 18,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.degree,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6 + MediaQuery.of(context).size.width / 18,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      '',
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label: Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                for (var amigo in this.rn!.keys)
                                                                                                  DataRow(cells: [
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Flexible(child:Text(getNombre(amigo), style: TextStyle(fontSize: 18), ))])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.rn![amigo][1].toString() + "-" + this.rn![amigo][2].toString(), style: TextStyle(fontSize: 18), )])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.rn![amigo][0], style: TextStyle(fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                  ]),
                                                                                                  if (this.rn!.isEmpty)
                                                                                                    DataRow(cells: [
                                                                                                      DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [Text(t.not_there, style: TextStyle(color: Colors.red, fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                    ]),
                                                                                              ],
                                                                                            ), ]),
                                                                                            if (this.preferencias!.rp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.os == 1)
                                                                                          Text(
                                                                                            t.osTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.os == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.os == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.chooses,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.rejects,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.degree,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      '',
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                              ],
                                                                                              rows: [
                                                                                                for (var amigo in this.os!.keys)
                                                                                                  DataRow(cells: [
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Flexible(child:Text(getNombre(this.os![amigo][3]), style: TextStyle(fontSize: 18), ))])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Flexible(child:Text(getNombre(this.os![amigo][4]), style: TextStyle(fontSize: 18), ))])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.os![amigo][1].toString() + "-" + this.os![amigo][2].toString(), style: TextStyle(fontSize: 18), )])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.os![amigo][0], style: TextStyle(fontSize: 18), )])),
                                                                                                  ]),
                                                                                                  if (this.os!.isEmpty)
                                                                                                    DataRow(cells: [
                                                                                                      DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [Text(t.not_there, style: TextStyle(color: Colors.red, fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                    ]),
                                                                                              ],
                                                                                            ), ]),
                                                                                            if (this.preferencias!.os == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.ep == 1)
                                                                                          Text(
                                                                                            t.epTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.ep == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.ep == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ep.toString() + "%", style: TextStyle(color: this.ep! <= 25 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.epValue!, style: TextStyle(color: this.epValue == t.low ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Text('')),
                                                                                                  DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.ep == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Text(
                                                                                            t.ppTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.pp.toString() + "%", style: TextStyle(color: this.pp! <= 25 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ppValue!, style: TextStyle(color: this.ppValue == t.low ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.pp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Text(
                                                                                            t.papTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.pap.toString() + "%", style: TextStyle(fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.papValue!, style: TextStyle(fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.oip == 1)
                                                                                          Text(
                                                                                            t.oipTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.oip == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.oip == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.nameCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.degree,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                                
                                                                                              ],
                                                                                              rows: [
                                                                                                for (var amigo in this.oip!.keys)
                                                                                                  DataRow(cells: [
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Flexible(child:Text(getNombre(amigo), style: TextStyle(fontSize: 18), ))])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.oip![amigo][1].toString() + "-" + this.oip![amigo][2].toString(), style: TextStyle(fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                  ]),
                                                                                                  if (this.oip!.isEmpty)
                                                                                                    DataRow(cells: [
                                                                                                      DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [Text(t.not_there, style: TextStyle(color: Colors.red, fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                    ]),
                                                                                              ],
                                                                                            ), ]),
                                                                                            if (this.preferencias!.oip == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.ep == 1)
                                                                                          Text(
                                                                                            t.enTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.ep == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.ep == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.en.toString() + "%", style: TextStyle(color: this.en! >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.enValue!, style: TextStyle(color: this.enValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.ep == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Text(
                                                                                            t.pnTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.pn.toString() + "%", style: TextStyle(color: this.pn! >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.pnValue!, style: TextStyle(color: this.pnValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.pp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Text(
                                                                                            t.panTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.pp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.pan.toString() + "%", style: TextStyle(fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.panValue!, style: TextStyle(fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.pp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.oip == 1)
                                                                                          Text(
                                                                                            t.oinTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.oip == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.oip == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.nameCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.degree,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                                
                                                                                              ],
                                                                                              rows: [
                                                                                                for (var amigo in this.oin!.keys)
                                                                                                  DataRow(cells: [
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Flexible(child:Text(getNombre(amigo), style: TextStyle(fontSize: 18), ))])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [Text(this.oin![amigo][1].toString() + "-" + this.oin![amigo][2].toString(), style: TextStyle(fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                  ]),
                                                                                                  if (this.oin!.isEmpty)
                                                                                                    DataRow(cells: [
                                                                                                      DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [Text(t.not_there, style: TextStyle(color: Colors.red, fontSize: 18), )])),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                      DataCell(Text('')),
                                                                                                    ]),
                                                                                              ],
                                                                                            ), ]),
                                                                                            if (this.preferencias!.oip == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.ip == 1)
                                                                                          Text(
                                                                                            t.ipTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.ip == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.ip == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ip.toString(), style: TextStyle(color: this.ipValue == t.low ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ipValue!, style: TextStyle(color: this.ipValue == t.low ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.imp.toString() + "%", style: TextStyle(color: this.imp! >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.impValue!, style: TextStyle(color: this.impValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.ip == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.ip == 1)
                                                                                          Text(
                                                                                            t.inTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.ip == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.ip == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 6,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.iN.toString(), style: TextStyle(color: this.inValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.inValue!, style: TextStyle(color: this.inValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.imn.toString() + "%", style: TextStyle(color: this.imn! >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.imnValue!, style: TextStyle(color: this.imnValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.ip == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.ipp == 1)
                                                                                          Text(
                                                                                            t.ippTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.ipp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.ipp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ipp.toString() + "%", style: TextStyle(color: this.ipp! >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ippValue!, style: TextStyle(color: this.ippValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.ipp == 1)
                                                                                          SizedBox(height: 40, ),
                                                                                          if (this.preferencias!.ipp == 1)
                                                                                          Text(
                                                                                            t.ipnTitle,
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                          ),
                                                                                          if (this.preferencias!.ipp == 1)
                                                                                          SizedBox(height: 20),
                                                                                          if (this.preferencias!.ipp == 1)
                                                                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [DataTable(
                                                                                              headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                                border: Border.all(
                                                                                                  width: 2,
                                                                                                  color: CustomTheme.atopaGreyDark,
                                                                                                  style: BorderStyle.solid,
                                                                                                ),
                                                                                              ),
                                                                                              columns: [
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.valueCap,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                DataColumn(label: Container(
                                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(
                                                                                                      t.level,
                                                                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                                                                                    )]), )),
                                                                                                    DataColumn(label:Text('')),
                                                                                                    DataColumn(label:Text('')),
                                                                                              ],
                                                                                              rows: [
                                                                                                DataRow(cells: [
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ipn.toString() + "%", style: TextStyle(color: this.ipn! >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                  DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [Text(this.ipnValue!, style: TextStyle(color: this.ipnValue == t.high ? Colors.red : Colors.black, fontSize: 18), )])),
                                                                                                    DataCell(Text('')),
                                                                                                    DataCell(Text('')),
                                                                                                ]),
                                                                                              ],
                                                                                            )]),
                                                                                            if (this.preferencias!.ipp == 1)
                                                                                          SizedBox(height: 30, ),

                                                                                          SizedBox(height: 40, ),
                                                                                          const SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                            Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [Expanded(child: Divider(
                                                                                                  height: 30,
                                                                                                  color: Colors.black
                                                                                                )),
                                                                                                Text(
                                                                                                  t.proposal,
                                                                                                  style: Theme.of(context).textTheme.headline5,
                                                                                                ), Expanded(child: Divider(
                                                                                                  height: 30,
                                                                                                  color: Colors.black
                                                                                                )),
                                                                                              ], ),
                                                                                            SizedBox(height: 20, ),
                                                                                          Row(children: [Flexible(child: CardContainer(
                                                                                            color: Colors.white38,
                                                                                            width: 7 * MediaQuery.of(context).size.width / 8,
                                                                                            child: Column(
                                                                                              children: [
                                                                                                for (MapEntry vari in this.recomendaciones!.entries)
                                                                                                  
                                                                                                    if (not_empty(vari.value))
                                                                                                      Column(children: [
                                                                                                        Row(children: [
                                                                                                          SizedBox(height: 20, ),
                                                                                                          Flexible(child: Container(
                                                                                                            padding: EdgeInsets.only(left: 25),
                                                                                                            child: RichText(
                                                                                                              text: TextSpan(
                                                                                                                style: const TextStyle(
                                                                                                                    fontSize: 19.0,
                                                                                                                    color: Colors.black,
                                                                                                                  ),
                                                                                                                  children: < TextSpan > [
                                                                                                                    TextSpan(text: vari.key.toString() + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                                                                    TextSpan(text: return_des(vari.value)),
                                                                                                                  ],
                                                                                                              )))),
                                                                                                        ]),
                                                                                                        for (MapEntry variNum in vari.value.entries)
                                                                                                          for (MapEntry areaEx in variNum.value.entries)
                                                                                                            if (not_empty_ex(areaEx.value))
                                                                                                              Column(children: [
                                                                                                                SizedBox(height: 15, ),
                                                                                                                Row(children: [
                                                                                                                  Container(
                                                                                                                    padding: EdgeInsets.only(left: 30),
                                                                                                                    child: Text(areaEx.key.toString() + ":", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18), ), )
                                                                                                                ]),
                                                                                                                for (MapEntry areaInNum in areaEx.value.entries)
                                                                                                                  for (MapEntry areaIn in areaInNum.value.entries)
                                                                                                                    for (MapEntry ans in areaIn.value.entries)
                                                                                                                      Column(children: [
                                                                                                                        SizedBox(height: 5, ),
                                                                                                                        Row(children: [
                                                                                                                          Container(
                                                                                                                            padding: EdgeInsets.only(left: 45),
                                                                                                                            child: TextButton(
                                                                                                                              onPressed: () async {
                                                                                                                                if (await canLaunch(ans.value[0])) {
                                                                                                                                  await launch(ans.value[0], forceWebView: true);
                                                                                                                                }
                                                                                                                              },
                                                                                                                              child: Text(areaIn.key.toString()),
                                                                                                                              style: TextButton.styleFrom(
                                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                                                                                  textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                                                                                                              ),
                                                                                                                            )),
                                                                                                                            ], ),
                                                                                                                            Column(children: [
                                                                                                                                SizedBox(height: 5, ),
                                                                                                                                Row(children: [
                                                                                                                                  Flexible(child: Container(
                                                                                                                                    padding: EdgeInsets.only(left: 100),
                                                                                                                                    child: Row(children: [
                                                                                                                                      Text('· ' + ans.key, style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold), ),],) ),)
                                                                                                                                  
                                                                                                                                ]),]),
                                                                                                                          for (int m = 0; m < (ans.value as List).length; m++)
                                                                                                                                      if (m >= 2)
                                                                                                                                        if (ans.value[m] != '')
                                                                                                                              Column(children: [
                                                                                                                                SizedBox(height: 5, ),
                                                                                                                                Row(children: [
                                                                                                                                  Flexible(child: Container(
                                                                                                                                    padding: EdgeInsets.only(left: 150),
                                                                                                                                    child: Row(children: [
                                                                                                                                      Flexible(child:
                                                                                                                                      Text('· ' + ans.value[m], style: TextStyle(fontSize: 16), )),],) ),)
                                                                                                                                  
                                                                                                                                ]),]),
                                                                                                                          SizedBox(height: 20, ),
                                                                                                                                
                                                                                                                        

                                                                                                                      ], )

                                                                                                              ], )
                                                                                                      ], ),
                                                                                              ]),
                                                                                          ))]),

                                                                                        ])
                                                                                    )): Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      )],
                                                                                    ),
                                                                                    persistentFooterButtons: const [
                                                                                      CustomFooterBar()
                                                                                    ],
                                                                                );
                                                                              }

                                                                              String return_des(l) {
                                                                                try {
                                                                                  for (var num in l.keys) {
                                                                                    for (var ex in l[num].keys) {
                                                                                      for (var innum in l[num][ex].keys) {
                                                                                        for (var inname in l[num][ex][innum].keys) {
                                                                                          for (var ans in l[num][ex][innum][inname].keys) {
                                                                                            return l[num][ex][innum][inname][ans][1];
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  return '';
                                                                                }
                                                                                on Exception
                                                                                catch (_) {
                                                                                  return '';
                                                                                }
                                                                              }

                                                                              bool not_empty(l) {
                                                                                try {
                                                                                  for (var num in l.keys) {
                                                                                    for (var ex in l[num].keys) {
                                                                                      for (var innum in l[num][ex].keys) {
                                                                                        for (var inname in l[num][ex][innum].keys) {
                                                                                          for (var ans in l[num][ex][innum][inname].keys) {
                                                                                            return true;
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  return false;
                                                                                }
                                                                                on Exception
                                                                                catch (_) {
                                                                                  return false;
                                                                                }
                                                                              }

                                                                              bool not_empty_ex(l) {
                                                                                try {
                                                                                  for (var innum in l.keys) {
                                                                                    for (var inname in l[innum].keys) {
                                                                                      for (var ans in l[innum][inname].keys) {
                                                                                        return true;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  return false;
                                                                                }
                                                                                on Exception
                                                                                catch (_) {
                                                                                  return false;
                                                                                }
                                                                              }

                                                                              String return_value(l, value) {
                                                                                for (var al in l.keys) {
                                                                                  for (var color in l[al].keys) {
                                                                                    if (l[al][color] != '') {
                                                                                      if (int.parse(l[al][color]) == value) {
                                                                                        var alu = this.alumnos!.firstWhere((element) => element.code == al);
                                                                                        return alu.nombre + " " + alu.apellidos;
                                                                                      }

                                                                                    }
                                                                                  }

                                                                                }

                                                                                return '';
                                                                              }

                                                                              String return_text(l, value) {
                                                                                for (var al in l.keys) {
                                                                                  for (var color in l[al].keys) {
                                                                                    if (l[al][color] != '') {
                                                                                      if (int.parse(l[al][color]) == value) {
                                                                                        return al;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                }
                                                                                return '';
                                                                              }

                                                                              String getNombre(amigo) {
                                                                                var alu = this.alumnos!.firstWhere((element) => element.code == amigo);
                                                                                return alu.nombre + " " + alu.apellidos;
                                                                              }
                                                                            }