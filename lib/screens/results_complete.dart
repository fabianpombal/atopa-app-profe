import 'dart:convert';
import 'dart:ui'
as ui;
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
import 'package:atopa_app_flutter/extensions.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultsCompleteScreen extends StatefulWidget {
  const ResultsCompleteScreen({
    Key ? key
  }): super(key: key);

  @override
  _ResultsCompleteScreenState createState() => _ResultsCompleteScreenState();
}

class _ResultsCompleteScreenState extends State < ResultsCompleteScreen > {
  bool _dataLoaded = false;

  Test ? test;
  Year ? year;

  int ? lang;

  TestAPI _testAPI = new TestAPI();

  Map < String,
  dynamic > ? jsonObj;

  Map < String,
  dynamic > ? respuestas;
  Map < String,
  dynamic > ? recomendaciones;
  List < dynamic > ? alumnos;
  Map < String,
  dynamic > ? ic;
  Map < String,
  dynamic > ? id;
  Map < String,
  dynamic > ? iap;
  Map < String,
  dynamic > ? ian;

  Map < String,
  dynamic > ? sp;
  Map < String,
  dynamic > ? spval;
  Map < String,
  dynamic > ? np;
  Map < String,
  dynamic > ? sn;
  Map < String,
  dynamic > ? snval;
  Map < String,
  dynamic > ? nn;
  Map < String,
  dynamic > ? ip;
  Map < String,
  dynamic > ? ipval;
  Map < String,
  dynamic > ? imp;
  Map < String,
  dynamic > ? iN;
  Map < String,
  dynamic > ? inval;
  Map < String,
  dynamic > ? imn;
  Map < String,
  dynamic > ? ipp;
  Map < String,
  dynamic > ? ipn;

  Map < String,
  dynamic > ? data1;
  Map < String,
  dynamic > ? data2;
  Map < String,
  dynamic > ? data3;
  Map < String,
  dynamic > ? data4;

  Map < String,
  dynamic > ? title_matrix12;
  Map < String,
  dynamic > ? title_matrix34;
  Map < String,
  dynamic > ? matrix12;
  Map < String,
  dynamic > ? matrix34;

  double ? spValue;
  double ? snValue;
  double ? ipValue;
  double ? inValue;

  int ? mutual;
  int ? reject;
  int ? os;
  int ? believe;
  int ? believeNo;
  int ? oip;
  int ? oin;

  List < dynamic > ? initials;

  List < dynamic > ? preguntas;

  User ? user;
  Preferencias ? preferencias;
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
    this.jsonObj = await _testAPI.getResultsComplete(this.test!.id!, this.lang!);
    if (mounted)
      setState(() {
        this.initials = jsonObj ? ['initials'];
        this.alumnos = jsonObj ? ['alumnos'].map((data) => new Alumno.fromJson(data)).toList();
        this.respuestas = jsonObj ? ['respuestasNum'];
        this.sp = jsonObj ? ['sp'];
        this.spval = jsonObj ? ['spval'];
        this.np = jsonObj ? ['np'];
        this.sn = jsonObj ? ['sn'];
        this.snval = jsonObj ? ['snval'];
        this.nn = jsonObj ? ['nn'];
        this.ip = jsonObj ? ['ip'];
        this.ipval = jsonObj ? ['ipval'];
        this.imp = jsonObj ? ['imp'];
        this.iN = jsonObj ? ['in'];
        this.inval = jsonObj ? ['inval'];
        this.imn = jsonObj ? ['imn'];
        this.ipp = jsonObj ? ['ipp'];
        this.ipn = jsonObj ? ['ipn'];
        this.ic = jsonObj ? ['ic'];
        this.id = jsonObj ? ['id'];
        this.iap = jsonObj ? ['iap'];
        this.ian = jsonObj ? ['ian'];
        this.spValue = jsonObj ? ['spValue'];
        this.snValue = jsonObj ? ['snValue'];
        this.ipValue = jsonObj ? ['ipValue'];
        this.inValue = jsonObj ? ['inValue'];
        this.data1 = jsonObj ? ['data1'];
        this.data2 = jsonObj ? ['data2'];
        this.data3 = jsonObj ? ['data3'];
        this.data4 = jsonObj ? ['data4'];
        this.title_matrix12 = jsonObj ? ['title_matrix12'];
        this.title_matrix34 = jsonObj ? ['title_matrix34'];
        this.matrix12 = jsonObj ? ['matrix12'];
        this.matrix34 = jsonObj ? ['matrix34'];
        this.mutual = jsonObj ? ['mutual'];
        this.reject = jsonObj ? ['reject'];
        this.os = jsonObj ? ['os'];
        this.believe = jsonObj ? ['believe'];
        this.believeNo = jsonObj ? ['believeNo'];
        this.oin = jsonObj ? ['oin'];
        this.oip = jsonObj ? ['oip'];
        this.recomendaciones = jsonObj ? ['recomendaciones'];
        this.preguntas = jsonObj ? ['preguntas'].map((data) => new Pregunta.fromJson(data)).toList();

        this._dataLoaded = true;

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
      }
      this.user = await this._authAPI.getLoggedIn();
      this.preferencias = await this._authAPI.getPreferencias(this.user!.user!);
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
                      Response res = await _testAPI.downloadTestPdf(this.test!, this.lang!);
                      Navigator.pop(context);
                      if (res.statusCode == 200) {
                        js.context.callMethod("webSaveAs", [html.Blob([res.data]), this.test!.nombre + "-Informe_Clase.pdf"]);
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
                      t!.down_class,
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
                      t.code,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    )],
                    mainAxisAlignment: MainAxisAlignment.center, ), )),
                DataColumn(label: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Row(children: [Text(
                      t.test_students,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    )],
                    mainAxisAlignment: MainAxisAlignment.center, ), )),
                DataColumn(label: ElevatedButton.icon(
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
                    Response res = await _testAPI.downloadAllPdf(this.test!, this.lang!);
                    Navigator.pop(context);
                    if (res.statusCode == 200) {
                      js.context.callMethod("webSaveAs", [html.Blob([res.data]), this.test!.nombre + "-Informe_Clase.pdf"]);
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(t.errorResults),
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
                    Icons.file_copy,
                    color: Colors.white,
                    size: 30,
                  ),
                  label: Text(
                    t.down_all,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: CustomTheme.atopaPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 15.0,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ), )
              ],
              rows: [
                for (int i = 0; i < this.alumnos!.length; i++)
                  DataRow(cells: [
                    DataCell(Text(this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [i].code)).keys.first, style: TextStyle(fontSize: 18), )),
                    DataCell(Text(this.alumnos ? [i].nombre + " " + this.alumnos ? [i].apellidos, style : TextStyle(fontSize: 18), )),
                    DataCell(this.alumnos ? [i].answer == 1 ? Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Tooltip(
                          message: t.view_res + " " + this.alumnos ? [i].nombre + " " + this.alumnos ? [i].apellidos,
                          textStyle : TextStyle(fontSize: 12, color: Colors.white),
                          child :
                          ElevatedButton(
                            child: Row(children: [Icon(Icons.remove_red_eye, size: 25, )]),
                            onPressed: () {
                              this.provLang!.removeListener(this.f);
                              Navigator.pushNamed(context, 'results-student',
                                arguments: {
                                  'year': this.year,
                                  'test': this.test,
                                  'student': this.alumnos?[i],
                                  'menu': t.results + ' ' + this.test!.nombre + ": " + this.alumnos ? [i].nombre + " " + this.alumnos ? [i].apellidos
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
                                primary: CustomTheme.atopaGreenDark
                              // textStyle:
                              //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                          )),
                        SizedBox(width: 30, ),
                        Tooltip(
                          message: t.down_al + this.alumnos ? [i].nombre + " " + this.alumnos ? [i].apellidos,
                          textStyle : TextStyle(fontSize: 12, color: Colors.white),
                          child :
                          ElevatedButton(
                            child: Row(children: [Icon(Icons.download, size: 25, )]),
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
                              Response res = await _testAPI.downloadStudentPdf(this.alumnos ? [i].code, this.test!, this.lang!);
                              Navigator.pop(context);
                              if (res.statusCode == 200) {
                                js.context.callMethod("webSaveAs", [html.Blob([res.data]), this.test!.nombre + "-Informe_" + this.alumnos ? [i].nombre + "_" + this.alumnos ? [i].apellidos + ".pdf"]);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(t.errorResults),
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
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 15.0,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                primary: CustomTheme.atopaViolet
                              // textStyle:
                              //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                          )),
                      ], ) : Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(t.no_answer, style: TextStyle(fontSize: 18))])),
                  ]),
              ],
            ),
            SizedBox(height: 30, ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [Expanded(child: Divider(
                  height: 30,
                  color: Colors.black
                )),
                Text(
                  t.legend,
                  style: Theme.of(context).textTheme.headline5,
                ), Expanded(child: Divider(
                  height: 30,
                  color: Colors.black
                )),
              ], ),
            SizedBox(height: 20, ),
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
                        t.meaning,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      )]), )),
                  DataColumn(label: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(
                        t.color,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      )]), )),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(t.mutual, style: TextStyle(fontStyle: ui.FontStyle.italic, fontSize: 16))),
                    DataCell(Container(
                      color: CustomTheme.graphYellow,
                      child: Row(
                        children: < Widget > [
                          Expanded(
                            child: Text('', ),
                          )
                        ],
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(t.os1 + t.os2, style: TextStyle(fontStyle: ui.FontStyle.italic, fontSize: 16))),
                    DataCell(Container(
                      color: CustomTheme.graphPink,
                      child: Row(
                        children: < Widget > [
                          Expanded(
                            child: Text('', ),
                          )
                        ],
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(t.reject, style: TextStyle(fontStyle: ui.FontStyle.italic, fontSize: 16))),
                    DataCell(Container(
                      color: CustomTheme.graphGreen,
                      child: Row(
                        children: < Widget > [
                          Expanded(
                            child: Text('', ),
                          )
                        ],
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(t.believe, style: TextStyle(fontStyle: ui.FontStyle.italic, fontSize: 16))),
                    DataCell(Container(
                      color: CustomTheme.graphBlue,
                      child: Row(
                        children: < Widget > [
                          Expanded(
                            child: Text('', ),
                          )
                        ],
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(t.oip1 + t.oip2 + t.oip3, style: TextStyle(fontStyle: ui.FontStyle.italic, fontSize: 16))),
                    DataCell(Container(
                      color: CustomTheme.graphRed,
                      child: Row(
                        children: < Widget > [
                          Expanded(
                            child: Text('', ),
                          )
                        ],
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(t.believeNo, style: TextStyle(fontStyle: ui.FontStyle.italic, fontSize: 16))),
                    DataCell(Container(
                      color: CustomTheme.graphOrange,
                      child: Row(
                        children: < Widget > [
                          Expanded(
                            child: Text('', ),
                          )
                        ],
                      ),
                    )),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(t.oip1 + t.oin1 + t.oin2, style: TextStyle(fontStyle: ui.FontStyle.italic, fontSize: 16))),
                    DataCell(Container(
                      color: CustomTheme.graphViolet,
                      child: Row(
                        children: < Widget > [
                          Expanded(
                            child: Text('', ),
                          )
                        ],
                      ),
                    )),
                  ]),
                ],
              ), ]),
            SizedBox(height: 30, ),
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
              for (var key in this.respuestas![num].keys)
                Column(children: [
                  Text(
                    t.question + " " + num + " " + key,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),

                  DataTable(
                    headingRowHeight: 100,
                    headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                    border: TableBorder.all(
                      width: 2.0,
                      color: CustomTheme.atopaGreyDark,
                      borderRadius: BorderRadius.circular(10)),
                    columns: [
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                        child: Row(children: [Text(
                            num + "#",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        DataColumn(label: Container(
                          width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                          child: Row(children: [Text(
                              this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            )],
                            mainAxisAlignment: MainAxisAlignment.center, ), )),

                    ],
                    rows: [
                      for (int index = 0; index < this.alumnos!.length; index++)
                        DataRow(cells: [
                          DataCell(Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))], ))),
                          for (var alumno_respo in this.respuestas![num][key][this.alumnos ? [index].code].keys)
                            for (int index2 = 0; index2 < this.alumnos!.length; index2++)
                              if (this.alumnos ? [index2].code == alumno_respo)
                                for (String element in this.respuestas![num][key][this.alumnos ? [index].code][alumno_respo].keys)
                                  DataCell(Container(
                                    color: element != "#ffffff" ? element.toColor() : null,
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(this.respuestas![num][key][this.alumnos ? [index].code][alumno_respo][element], style: TextStyle(fontSize: 18))
                                      ], ), )),
                        ]),
                    ]),
                  SizedBox(height: 30, ),

                ], ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child: Divider(
                      height: 30,
                      color: Colors.black
                    )),
                    Text(
                      t.calculate,
                      style: Theme.of(context).textTheme.headline5,
                    ), Expanded(child: Divider(
                      height: 30,
                      color: Colors.black
                    )),
                  ], ),

                SizedBox(height: 30),
                if (this.preferencias!.sp == 1)
                Text(
                  t.matrix1,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.sp == 1)
                SizedBox(height: 20),
                if (this.preferencias!.sp == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (int index = 0; index < this.alumnos!.length; index++)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                        child: Row(children: [Text(
                            this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('SP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.sp!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.sp![user].toString(), style: TextStyle(color: this.sp![user] < this.spValue ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('SP val', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.spval!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.spval![user].toString(), style: TextStyle(fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('NP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.np!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.np![user].toString() + "%", style: TextStyle(color: this.np![user] <= 25 ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                  ]),
                  if (this.preferencias!.sp == 1)
                SizedBox(height: 30, ),
                if (this.preferencias!.sp == 1 && this.preferencias!.data == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.variable,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.value,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    for (var x in this.data1!.keys)
                      for (var name in this.data1![x].keys)
                        DataRow(cells: [
                          DataCell(Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(name.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                            ))),
                          DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(this.data1![x][name].toStringAsFixed(2), style: TextStyle(fontSize: 18), )])),
                        ]),
                  ]),
                  if (this.preferencias!.sp == 1 && this.preferencias!.data == 1)
                SizedBox(height: 30, ),

                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.graphYellow),
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(children: [Text(
                          t.mutual,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Text(''))

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(mutual.toString(), style: TextStyle(fontSize: 20))],
                        ))),
                      DataCell(Text(''))
                    ]),
                  ]),
                SizedBox(height: 50, ),
                if (this.preferencias!.sp == 1)
                Text(
                  t.matrix2,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.sp == 1)
                SizedBox(height: 20),
                if (this.preferencias!.sp == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (int index = 0; index < this.alumnos!.length; index++)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                        child: Row(children: [Text(
                            this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('SN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.sn!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.sn![user].toString(), style: TextStyle(color: this.sn![user] >= this.snValue ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('SN val', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.snval!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.snval![user].toString(), style: TextStyle(fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('NN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.nn!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.nn![user].toString() + "%", style: TextStyle(color: this.nn![user] >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                  ]),
                  if (this.preferencias!.sp == 1)
                SizedBox(height: 30, ),
                if (this.preferencias!.sp == 1 && this.preferencias!.data == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.variable,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.value,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    for (var x in this.data2!.keys)
                      for (var name in this.data2![x].keys)
                        DataRow(cells: [
                          DataCell(Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(name.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                            ))),
                          DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(this.data2![x][name].toStringAsFixed(2), style: TextStyle(fontSize: 18), )])),
                        ]),
                  ]),
                  if (this.preferencias!.sp == 1 && this.preferencias!.data == 1)
                SizedBox(height: 30, ),

                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.graphGreen),
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(children: [Text(
                          t.reject,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Text(''))

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(reject.toString(), style: TextStyle(fontSize: 20))],
                        ))),
                      DataCell(Text(''))
                    ]),
                  ]),
                SizedBox(height: 50, ),
                if (this.preferencias!.ep == 1)
                Text(
                  t.matrix12,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.ep == 1)
                SizedBox(height: 20),
                if (this.preferencias!.ep == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.title_matrix12!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (var index in this.title_matrix12!.keys)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.title_matrix12!.length + 2),
                        child: Row(children: [Text(
                            this.title_matrix12![index],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    for (int index = 0; index < this.alumnos!.length; index++)
                    DataRow(cells: [
                        DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      
                          for (var num in this.title_matrix12!.keys)
                          for (var name in this.matrix12![this.alumnos ? [index].code].keys)
                            if (this.title_matrix12![num] == name)
                            name == 'EP' ? DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.matrix12![this.alumnos ? [index].code][name].toString() + "%", style: TextStyle(color: this.matrix12![this.alumnos ? [index].code][name] <= 25 ? Colors.red : Colors.black, fontSize: 18), )])) : name == 'EN' ? 
                              DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.matrix12![this.alumnos ? [index].code][name].toString() + "%", style: TextStyle(color: this.matrix12![this.alumnos ? [index].code][name] >= 75 ? Colors.red : Colors.black, fontSize: 18), )])) :
                              DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.matrix12![this.alumnos ? [index].code][name].toString(), style: TextStyle(fontSize: 18), )])),
                    ]),
                  ]),
                  if (this.preferencias!.ep == 1)
                SizedBox(height: 30, ),
                if (this.preferencias!.os == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.graphPink),
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(children: [Text(
                          t.os1,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Text(''))

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(os.toString(), style: TextStyle(fontSize: 20))],
                        ))),
                      DataCell(Text(''))
                    ]),
                  ]),
                  if (this.preferencias!.os == 1)
                SizedBox(height: 50, ),
                if (this.preferencias!.ic == 1)
                Text(
                  t.group_var,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.ic == 1)
                SizedBox(height: 20),
                if (this.preferencias!.ic == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: 400,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(
                            t.ic,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )]), )),
                    DataColumn(label: Container(
                      width: 400,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(
                          t.id,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )]))),
                  ],
                  rows: [

                    DataRow(cells: [
                      for (MapEntry e in this.id!.entries)
                        DataCell(Container(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(e.key.toString() + "%  -  " + e.value.toString(), style: TextStyle(color: int.parse(e.key) <= 44 ? Colors.red : Colors.black, fontSize: 18), )]))),
                        for (MapEntry e in this.iap!.entries)
                          DataCell(Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(e.key.toString() + "%  -  " + e.value.toString(), style: TextStyle(color: int.parse(e.key) >= 45 ? Colors.red : Colors.black, fontSize: 18), )]))),

                    ]),
                  ],
                ),
                if (this.preferencias!.ic == 1)
                SizedBox(height: 20, ),
                if (this.preferencias!.ic == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: 400,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(
                          t.iap,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )]))),
                    DataColumn(label: Container(
                      width: 400,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(
                          t.ian,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )]))),
                  ],
                  rows: [

                    DataRow(cells: [
                      for (MapEntry e in this.ian!.entries)
                        DataCell(Container(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(e.key.toString() + "%  -  " + e.value.toString(), style: TextStyle(color: int.parse(e.key) < 25 ? Colors.red : Colors.black, fontSize: 18), )]))),
                        for (MapEntry e in this.ic!.entries)
                          DataCell(Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(e.key.toString() + "%  -  " + e.value.toString(), style: TextStyle(color: int.parse(e.key) >= 75 ? Colors.red : Colors.black, fontSize: 18), )]))),
                    ]),
                  ],
                ),
                if (this.preferencias!.ic == 1)
                SizedBox(height: 50),

                if (this.preferencias!.ip == 1)
                Text(
                  t.matrix3,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.ip == 1)
                SizedBox(height: 20),
                if (this.preferencias!.ip == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (int index = 0; index < this.alumnos!.length; index++)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                        child: Row(children: [Text(
                            this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('IP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.ip!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.ip![user].toString(), style: TextStyle(color: this.ip![user] < this.ipValue ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('IP val', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.ipval!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.ipval![user].toString(), style: TextStyle(fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Imp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.imp!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.imp![user].toString() + "%", style: TextStyle(color: this.imp![user] >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                  ]),
                  if (this.preferencias!.ip == 1)
                SizedBox(height: 30, ),
                if (this.preferencias!.ip == 1 && this.preferencias!.data == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.variable,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.value,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    for (var x in this.data3!.keys)
                      for (var name in this.data3![x].keys)
                        DataRow(cells: [
                          DataCell(Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(name.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                            ))),
                          DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(this.data3![x][name].toStringAsFixed(2), style: TextStyle(fontSize: 18), )])),
                        ]),
                  ]),
                  if (this.preferencias!.ip == 1 && this.preferencias!.data == 1)
                SizedBox(height: 50, ),
                if (this.preferencias!.ip == 1)
                Text(
                  t.matrix4,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.ip == 1)
                SizedBox(height: 20),
                if (this.preferencias!.ip == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (int index = 0; index < this.alumnos!.length; index++)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                        child: Row(children: [Text(
                            this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('IN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.iN!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.iN![user].toString(), style: TextStyle(color: this.iN![user] >= this.inValue ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('IN val', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.inval!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.inval![user].toString(), style: TextStyle(fontSize: 18), )])),
                    ]),
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Imn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.imn!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.imn![user].toString() + "%", style: TextStyle(color: this.imn![user] >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                  ]),

                  if (this.preferencias!.ip == 1)
                SizedBox(height: 30, ),
                if (this.preferencias!.ip == 1 && this.preferencias!.data == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.variable,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Row(children: [Text(
                          t.value,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    for (var x in this.data4!.keys)
                      for (var name in this.data4![x].keys)
                        DataRow(cells: [
                          DataCell(Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(name.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                            ))),
                          DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(this.data4![x][name].toStringAsFixed(2), style: TextStyle(fontSize: 18), )])),
                        ]),
                  ]),
                  if (this.preferencias!.ip == 1 && this.preferencias!.data == 1)
                SizedBox(height: 50, ),

                if (this.preferencias!.pp == 1)
                Text(
                  t.matrix34,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.pp == 1)
                SizedBox(height: 20),
                if (this.preferencias!.pp == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.title_matrix34!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (var index in this.title_matrix34!.keys)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.title_matrix34!.length + 2),
                        child: Row(children: [Text(
                            this.title_matrix34![index],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    for (int index = 0; index < this.alumnos!.length; index++)
                    DataRow(cells: [
                        DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      
                        
                          for (var num in this.title_matrix34!.keys)
                          for (var name in this.matrix34![this.alumnos ? [index].code].keys)
                            if (this.title_matrix34![num] == name)
                            name == 'PP' ? DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.matrix34![this.alumnos ? [index].code][name].toString() + "%", style: TextStyle(color: this.matrix34![this.alumnos ? [index].code][name] <= 25 ? Colors.red : Colors.black, fontSize: 18), )])) : (name == 'PN' ? 
                              DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.matrix34![this.alumnos ? [index].code][name].toString() + "%", style: TextStyle(color: this.matrix34![this.alumnos ? [index].code][name] >= 75 ? Colors.red : Colors.black, fontSize: 18), )])) :
                              DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.matrix34![this.alumnos ? [index].code][name].toString(), style: TextStyle(color: Colors.black,fontSize: 18), )]))),
                    ]),
                  ]),
                  if (this.preferencias!.pp == 1)
                SizedBox(height: 30, ),
                if (this.preferencias!.oip == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.graphBlue),
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(children: [Text(
                          t.believe,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Text(''))

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(believe.toString(), style: TextStyle(fontSize: 20))],
                        ))),
                      DataCell(Text(''))
                    ]),
                  ]),
                  if (this.preferencias!.oip == 1)
                SizedBox(height: 50, ),
                if (this.preferencias!.oip == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.graphRed),
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(children: [Text(
                          t.oip1 + t.oip2,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Text(''))

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(oip.toString(), style: TextStyle(fontSize: 20))],
                        ))),
                      DataCell(Text(''))
                    ]),
                  ]),
                  if (this.preferencias!.oip == 1)
                SizedBox(height: 50, ),
                if (this.preferencias!.oip == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.graphOrange),
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(children: [Text(
                          t.believeNo,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Text(''))

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(believeNo.toString(), style: TextStyle(fontSize: 20))],
                        ))),
                      DataCell(Text(''))
                    ]),
                  ]),
                  if (this.preferencias!.oip == 1)
                SizedBox(height: 50, ),
                if (this.preferencias!.oip == 1)
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.graphViolet),
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
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(children: [Text(
                          t.oip1 + t.oin1,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    DataColumn(label: Text(''))

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(oin.toString(), style: TextStyle(fontSize: 20))],
                        ))),
                      DataCell(Text(''))
                    ]),
                  ]),
                  if (this.preferencias!.oip == 1)
                SizedBox(height: 50, ),

                if (this.preferencias!.ipp == 1)
                Text(
                  t.matrix5,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.ipp == 1)
                SizedBox(height: 20),
                if (this.preferencias!.ipp == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (int index = 0; index < this.alumnos!.length; index++)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                        child: Row(children: [Text(
                            this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('IPP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.ipp!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.ipp![user].toString() + "%", style: TextStyle(color: this.ipp![user] >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                  ]),
                  if (this.preferencias!.ipp == 1)
                SizedBox(height: 50, ),
                if (this.preferencias!.ipp == 1)
                Text(
                  t.matrix6,
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (this.preferencias!.ipp == 1)
                SizedBox(height: 20),
                if (this.preferencias!.ipp == 1)
                DataTable(
                  headingRowHeight: 100,
                  headingRowColor: MaterialStateColor.resolveWith((states) => CustomTheme.atopaGreyTrans),
                  border: TableBorder.all(
                    width: 2.0,
                    color: CustomTheme.atopaGreyDark,
                    borderRadius: BorderRadius.circular(10)),
                  columns: [
                    DataColumn(label: Container(
                      width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                      child: Row(children: [Text(
                          "#",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )],
                        mainAxisAlignment: MainAxisAlignment.center, ), )),
                    for (int index = 0; index < this.alumnos!.length; index++)
                      DataColumn(label: Container(
                        width: MediaQuery.of(context).size.width / (this.alumnos!.length + 2),
                        child: Row(children: [Text(
                            this.initials!.firstWhere((element) => element.containsValue(this.alumnos ? [index].code)).keys.first,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                          )],
                          mainAxisAlignment: MainAxisAlignment.center, ), )),

                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('IPN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))],
                        ))),
                      for (int index = 0; index < this.alumnos!.length; index++)
                        for (var user in this.ipn!.keys)
                          if (user.toString() == this.alumnos ? [index].code)
                            DataCell(Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(this.ipn![user].toString() + "%", style: TextStyle(color: this.ipn![user] >= 75 ? Colors.red : Colors.black, fontSize: 18), )])),
                    ]),
                  ]),
                SizedBox(height: 50, ),


          ])
        )
      ) : Column(
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

}