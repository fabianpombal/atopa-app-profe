import 'dart:convert';
import 'dart:html';
import 'dart:js_util';
import 'dart:math';
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
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/card_container.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../wrappers/visjs.dart';

class VisPage extends StatefulWidget {
  const VisPage({
    Key ? key
  }): super(key: key);

  @override
  _VisPageState createState() => _VisPageState();
}

class _VisPageState extends State < VisPage > {
  late List < DivElement > networkContainer = [];
  late Network network1;
  late Network network2;
  late Network network3;
  late Network network4;
  bool _dataLoaded = false;
  late List < List > _nodes = [
    [],
    [],
    [],
    []
  ];
  late List < List > _edges = [
    [],
    [],
    [],
    []
  ];
  late Map _options;

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
  dynamic > ? sn;
  Map < String,
  dynamic > ? ip;
  Map < String,
  dynamic > ? iN;

  Map < String,
  dynamic > ? alumnosNames;

  late List < dynamic > nodesFilterValues;

  late List < dynamic > filtersEdge;

  List < dynamic > ? preguntas;

  List<MultiSelectItem<String>> alumnosSelect = [];
  List<List<String>> selectedAlumnos = [[],[],[],[]];

  Preferencias? preferencias;
  AuthAPI _authAPI = AuthAPI();
  User? user;
  int? rol;
  int? evaluacion;

  LanguageProvider? provLang;
  var f;

  @override
  void dispose() {
    this.provLang!.removeListener(this.f);
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    this.filtersEdge = [{
      'mutual': true,
      'os': true,
      'normal': true
    }, {
      'reject': true,
      'os': true,
      'normal': true
    }, {
      'believe': true,
      'oip': true,
      'normal': true
    }, {
      'believeNo': true,
      'oin': true,
      'normal': true
    }];
    this.nodesFilterValues = [{}, {}, {}, {}];
    // call remote function to return network data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var t = AppLocalizations.of(context);
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      this.provLang = Provider.of < LanguageProvider > (context, listen: false);
      this.lang = this.provLang!.currentIndex;
      this.f = () async {
        this.lang = this.provLang!.currentIndex;
        _dataLoaded = false;
        this.jsonObj = await _testAPI.getResults(this.test!.id!, this.lang!);
        if (mounted)
        setState(() {
          
          this.alumnosNames = jsonDecode(jsonObj ? ['alumnos']);
          this.alumnosSelect = [];
          this.alumnosNames?.forEach((key, value) { 
            this.alumnosSelect.add(new MultiSelectItem(value.toString(), key.toString()));
          });
          this.selectedAlumnos[0] = this.alumnosSelect.map((e) => e.value).toList();
          this.selectedAlumnos[1] = this.alumnosSelect.map((e) => e.value).toList();
          this.selectedAlumnos[2] = this.alumnosSelect.map((e) => e.value).toList();
          this.selectedAlumnos[3] = this.alumnosSelect.map((e) => e.value).toList();
          this.alumnos = jsonObj ? ['alumnosQuery'];
          this.respuestas = jsonDecode(jsonObj ? ['respuestas']);
          this.sp = jsonDecode(jsonObj ? ['sp']);
          this.sn = jsonDecode(jsonObj ? ['sn']);
          this.ip = jsonDecode(jsonObj ? ['ip']);
          this.iN = jsonDecode(jsonObj ? ['iN']);
          this.ic = jsonObj ? ['ic'];
          this.id = jsonObj ? ['id'];
          this.iap = jsonObj ? ['iap'];
          this.ian = jsonObj ? ['ian'];
          this.recomendaciones = jsonObj ? ['recomendaciones'];
          this.preguntas = jsonObj ? ['preguntas'].map((data) => new Pregunta.fromJson(data)).toList();

          getGraphs('', t);

          _dataLoaded = true;
      });
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
      this.jsonObj = await _testAPI.getResults(this.test!.id!, this.lang!);
      _options = {
        'height': '70%',
        'interaction': {
          'navigationButtons': true,
          'keyboard': true,
          'hover': true
        },
        'edges': {
          'scaling': {
            'min': 1,
            'max': 2,
            //   'customScalingFunction': (min, max, total, value) {
            //   return (value / 5.0 - 0.2) * 10.0;
            // }
          }
        },
        'nodes': {
          'shape': "dot",
          'shadow': true
        },
        'physics': {
          'barnesHut': {
            'gravitationalConstant': -2000,
            'centralGravity': 0.3,
            'springLength': 300,
            'springConstant': 0.04,
            'damping': 0.09,
            'avoidOverlap': 0
          },
          'forceAtlas2Based': {
            'gravitationalConstant': -50,
            'centralGravity': 0.01,
            'springConstant': 0.08,
            'springLength': 300,
            'damping': 0.4,
            'avoidOverlap': 0
          },
          'repulsion': {
            'centralGravity': 0.2,
            'springLength': 500,
            'springConstant': 0.05,
            'nodeDistance': 500,
            'damping': 0.09
          },
          'hierarchicalRepulsion': {
            'centralGravity': 0.0,
            'springLength': 500,
            'springConstant': 0.01,
            'nodeDistance': 500,
            'damping': 0.09,
            'avoidOverlap': 0
          }
        }
      };
      // _options = jsify(_options);
      setState(() {
        this.alumnosNames = jsonDecode(jsonObj ? ['alumnos']);
        this.alumnosNames?.forEach((key, value) { 
          this.alumnosSelect.add(new MultiSelectItem(value.toString(), key.toString()));
        });
        this.selectedAlumnos[0] = this.alumnosSelect.map((e) => e.value).toList();
        this.selectedAlumnos[1] = this.alumnosSelect.map((e) => e.value).toList();
        this.selectedAlumnos[2] = this.alumnosSelect.map((e) => e.value).toList();
        this.selectedAlumnos[3] = this.alumnosSelect.map((e) => e.value).toList();
        this.alumnos = jsonObj ? ['alumnosQuery'];
        this.respuestas = jsonDecode(jsonObj ? ['respuestas']);
        this.sp = jsonDecode(jsonObj ? ['sp']);
        this.sn = jsonDecode(jsonObj ? ['sn']);
        this.ip = jsonDecode(jsonObj ? ['ip']);
        this.iN = jsonDecode(jsonObj ? ['iN']);
        this.ic = jsonObj ? ['ic'];
        this.id = jsonObj ? ['id'];
        this.iap = jsonObj ? ['iap'];
        this.ian = jsonObj ? ['ian'];
        this.recomendaciones = jsonObj ? ['recomendaciones'];
        this.preguntas = jsonObj ? ['preguntas'].map((data) => new Pregunta.fromJson(data)).toList();

        getGraphs('', t);

        _dataLoaded = true;

      });
    });
  }

  void getGraphs(String ? current, var t) {
    for (String num in this.respuestas!.keys) {
      if (int.parse(num) != 5 && int.parse(num) != 6 && (current == num || current == '')) {
        var students = [];
        for (var user in this.alumnosNames!.keys) {
          var aux = {};
          if (!nodesFilterValues[int.parse(num) - 1].containsKey(this.alumnosNames?[user.toString()])) {
            nodesFilterValues[int.parse(num) - 1][this.alumnosNames?[user.toString()]] = true;
          } else {
            if (!nodesFilterValues[int.parse(num) - 1][this.alumnosNames?[user.toString()]]) {
              continue;
            }
          }
          
          aux['id'] = this.alumnosNames ? [user.toString()];
          aux['label'] = user.toString();
          aux['font'] = {
            'strokeWidth': 3,
            'strokeColor': "#ffffff"
          };

          if (int.parse(num) == 1) {
            aux['value'] = this.sp ? [this.alumnosNames ? [user.toString()]];
          } else if (int.parse(num) == 2) {
            aux['value'] = this.sn ? [this.alumnosNames ? [user.toString()]];
          } else if (int.parse(num) == 3) {
            aux['value'] = this.ip ? [this.alumnosNames ? [user.toString()]];
          } else if (int.parse(num) == 4) {
            aux['value'] = this.iN ? [this.alumnosNames ? [user.toString()]];
          }
          students.add(aux);
        }
        _nodes[int.parse(num) - 1] = students;

        var relations = [];
        var relationsDone = {};
        for (var student1 in respuestas ? [num].keys) {
          for (var student2 in respuestas ? [num][student1].keys) {
            var aux = {};
            aux['from'] = student1;
            for (var color in respuestas ? [num][student1][student2].keys) {
              if (respuestas ? [num][student1][student2][color] != '' && !relationsDone.containsKey(student2.toString() + student1.toString())) {
                aux['to'] = student2;
                aux['value'] = 1 / ((log(int.parse(respuestas?[num][student1][student2][color]) / 5)) * -5 + 0.5) + 1.5;
                aux['color'] = {
                  'color': color,
                  'highlight': color,
                  'hover': color
                };
                if (color == '#d6c22b') {
                  aux['title'] = t.mutual;
                  aux['relation'] = "mutual";
                  if (!this.filtersEdge[0]['mutual']) {
                    continue;
                  }
                } else if (color == "#e05ab8") {
                  aux['title'] = t.os;
                  aux['relation'] = "os";
                  if (!this.filtersEdge[int.parse(num) - 1]['os']) {
                    continue;
                  }
                } else if (color == "#0da863") {
                  aux['title'] = t.reject;
                  aux['relation'] = "reject";
                  if (!this.filtersEdge[1]['reject']) {
                    continue;
                  }
                } else if (color == "#349beb") {
                  aux['title'] = t.reject;
                  aux['relation'] = "believe";
                  if (!this.filtersEdge[2]['believe']) {
                    continue;
                  }
                } else if (color == "#ed3e46") {
                  aux['title'] = t.oip;
                  aux['relation'] = "oip";
                  if (!this.filtersEdge[2]['oip']) {
                    continue;
                  }
                } else if (color == "#eb8034") {
                  aux['title'] = t.believeNo;
                  aux['relation'] = "believeNo";
                  if (!this.filtersEdge[3]['believeNo']) {
                    continue;
                  }
                } else if (color == "#9646e0") {
                  aux['title'] = t.oin;
                  aux['relation'] = "oin";
                  if (!this.filtersEdge[3]['oin']) {
                    continue;
                  }
                } else {
                  aux['relation'] = "normal";
                  if (!this.filtersEdge[int.parse(num) - 1]['normal']) {
                    continue;
                  }
                }
                if (respuestas ? [num].containsKey(student2)) {
                  if (respuestas ? [num][student2].containsKey(student1)) {
                    for (var color2 in respuestas ? [num][student2][student1].keys) {
                      if (respuestas ? [num][student2][student1][color2] != '' && int.parse(num) != 3 && int.parse(num) != 4) {
                        aux['arrows'] = 'to, from';
                        relationsDone[student1.toString() + student2.toString()] = 1;
                        if ((int.parse(respuestas ? [num][student2][student1][color2]) == 5 || int.parse(respuestas ? [num][student2][student1][color2]) == 4) &&
                          (int.parse(respuestas ? [num][student1][student2][color]) == 5 || int.parse(respuestas ? [num][student1][student2][color]) == 4)) {
                          aux['value'] = 1 / ((log(5 / 5)) * -5 + 0.5) + 1.5;
                        } else if (int.parse(respuestas ? [num][student2][student1][color2]) == 3 || int.parse(respuestas ? [num][student1][student2][color]) == 3 || (int.parse(respuestas ? [num][student1][student2][color]) == 2 &&
                            int.parse(respuestas ? [num][student2][student1][color2]) == 4) || (int.parse(respuestas ? [num][student2][student1][color2]) == 2 && int.parse(respuestas ? [num][student1][student2][color]) == 4)) {
                          aux['value'] = 1 / ((log(3 / 5)) * -5 + 0.5) + 1.5;
                        } else if ((int.parse(respuestas ? [num][student1][student2][color]) - int.parse(respuestas ? [num][student2][student1][color2])).abs() >= 2) {
                          aux['value'] = 1 / ((log(3 / 5)) * -5 + 0.5) + 1.5;
                          aux['dashes'] = true;
                          aux['title'] = aux['title'] + "\n" + t.rel_des;
                        } else {
                          aux['value'] = 1 / ((log(1 / 5)) * -5 + 0.5) + 1.5;
                        }
                      } else {
                        aux['arrows'] = 'to';
                      }
                    }
                  }
                } else {
                  aux['arrows'] = 'to';
                }
                relations.add(aux);
              }
            }

          }
        }
        // create an array with edges
        _edges[int.parse(num) - 1] = relations;

        _registerContainer(int.parse(num));
        _createNetwork(int.parse(num));
      }
    }
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
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      this.provLang!.removeListener(this.f);
                      Navigator.pushNamed(context, 'results-complete',
                                arguments: {
                                  'year': this.year,
                                  'test': this.test,
                                  'menu': t!.results + ' ' + this.test!.nombre + t.complete
                                }).then((value) {
                                  this.provLang!.addListener(this.f);
                                  this.f();
                                } );
                    },
                    icon: Icon(
                      Icons.preview,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                      t!.view_res_com,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: CustomTheme.atopaBlueDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 15.0,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                  ),
                ),
                SizedBox(width: 15, ),
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
                      Icons.insert_drive_file,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: Text(
                      t.down_class,
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
                    DataCell(Text(this.alumnos ? [i]['nombre'] + " " + this.alumnos ? [i]['apellidos'], style : TextStyle(fontSize: 18), )),
                    DataCell(this.alumnos ? [i]['answer'] == 1 ? Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Tooltip(
                          message: t.view_res + " " + this.alumnos ? [i]['nombre'] + " " + this.alumnos ? [i]['apellidos'],
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
                                  'student': new Alumno.fromJson(this.alumnos ? [i]),
                                  'menu': t.results + ' ' + this.test!.nombre + ": " + this.alumnos ? [i]['nombre'] + " " + this.alumnos ? [i]['apellidos']
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
                          message: t.down_al + this.alumnos ? [i]['nombre'] + " " + this.alumnos ? [i]['apellidos'],
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
                              Response res = await _testAPI.downloadStudentPdf(this.alumnos?[i]['code'], this.test!, this.lang!);
                              Navigator.pop(context);
                              if (res.statusCode == 200) {
                                js.context.callMethod("webSaveAs", [html.Blob([res.data]), this.test!.nombre + "-Informe_" + this.alumnos ? [i]['nombre'] + "_" + this.alumnos ? [i]['apellidos'] + ".pdf"]);
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
                  t.questions,
                  style: Theme.of(context).textTheme.headline5,
                ), Expanded(child: Divider(
                  height: 30,
                  color: Colors.black
                )),
              ], ),
            SizedBox(height: 20, ),
            for (String num in this.respuestas!.keys)
              if (num != '5' && num != '6') Column(children: [
                  Text(
                    t.question + " " + num + " (" + (num == '1' ? 'PGP' : num == '2' ? 'PGN' : num == '3' ? 'PPP' : num == '4' ? 'PPN' : num == '5' ? 'AAP' : 'AAN') + "): " + this.preguntas![int.parse(num) - 1].pregunta,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  if (num == '1')
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                            children: < TextSpan > [
                              TextSpan(text: t.mutual1),
                              TextSpan(text: t.mutual2, style: const TextStyle(color: CustomTheme.graphYellow)),
                            ],
                        )), //Text
                      SizedBox(width: 5), //SizedBox
                      Checkbox(
                        value: this.filtersEdge[int.parse(num) - 1]['mutual'],
                        onChanged: (bool ? value) {
                          setState(() {
                            this.filtersEdge[int.parse(num) - 1]['mutual'] = value;
                            getGraphs(num, t);
                          });
                        },
                      ),
                      SizedBox(width: 30),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                            children: < TextSpan > [
                              TextSpan(text: t.os1, style: const TextStyle(color: CustomTheme.graphPink)),
                              TextSpan(text: t.os2),
                            ],
                        )), //Text
                      SizedBox(width: 5), //SizedBox
                      Checkbox(
                        value: this.filtersEdge[int.parse(num) - 1]['os'],
                        onChanged: (bool ? value) {
                          setState(() {
                            this.filtersEdge[int.parse(num) - 1]['os'] = value;
                            getGraphs(num, t);
                          });
                        },
                      ),
                      SizedBox(width: 30),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                            children: < TextSpan > [
                              TextSpan(text: t.others),
                            ],
                        )), //Text
                      SizedBox(width: 5), //SizedBox
                      Checkbox(
                        value: this.filtersEdge[int.parse(num) - 1]['normal'],
                        onChanged: (bool ? value) {
                          setState(() {
                            this.filtersEdge[int.parse(num) - 1]['normal'] = value;
                            getGraphs(num, t);
                          });
                        },
                      ),
                    ], ),
                    if (num == '2')
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              children: < TextSpan > [
                                TextSpan(text: t.reject1),
                                TextSpan(text: t.mutual2, style: const TextStyle(color: CustomTheme.graphGreen)),
                              ],
                          )), //Text
                        SizedBox(width: 5), //SizedBox
                        Checkbox(
                          value: this.filtersEdge[int.parse(num) - 1]['reject'],
                          onChanged: (bool ? value) {
                            setState(() {
                              this.filtersEdge[int.parse(num) - 1]['reject'] = value;
                              getGraphs(num, t);
                            });
                          },
                        ),
                        SizedBox(width: 30),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              children: < TextSpan > [
                                TextSpan(text: t.os1, style: const TextStyle(color: CustomTheme.graphPink)),
                                TextSpan(text: t.os2),
                              ],
                          )), //Text
                        SizedBox(width: 5), //SizedBox
                        Checkbox(
                          value: this.filtersEdge[int.parse(num) - 1]['os'],
                          onChanged: (bool ? value) {
                            setState(() {
                              this.filtersEdge[int.parse(num) - 1]['os'] = value;
                              getGraphs(num, t);
                            });
                          },
                        ),
                        SizedBox(width: 30),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              children: < TextSpan > [
                                TextSpan(text: t.others),
                              ],
                          )), //Text
                        SizedBox(width: 5), //SizedBox
                        Checkbox(
                          value: this.filtersEdge[int.parse(num) - 1]['normal'],
                          onChanged: (bool ? value) {
                            setState(() {
                              this.filtersEdge[int.parse(num) - 1]['normal'] = value;
                              getGraphs(num, t);
                            });
                          },
                        ),
                      ], ),
                      if (num == '3')
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                children: < TextSpan > [
                                  TextSpan(text: t.believe1),
                                  TextSpan(text: t.believe2, style: const TextStyle(color: CustomTheme.graphBlue)),
                                ],
                            )), //Text
                          SizedBox(width: 5), //SizedBox
                          Checkbox(
                            value: this.filtersEdge[int.parse(num) - 1]['believe'],
                            onChanged: (bool ? value) {
                              setState(() {
                                this.filtersEdge[int.parse(num) - 1]['believe'] = value;
                                getGraphs(num, t);
                              });
                            },
                          ),
                          SizedBox(width: 30),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                children: < TextSpan > [
                                  TextSpan(text: t.oip1),
                                  TextSpan(text: t.oip2, style: const TextStyle(color: CustomTheme.graphRed)),
                                  TextSpan(text: t.oip3),
                                ],
                            )), //Text
                          SizedBox(width: 5), //SizedBox
                          Checkbox(
                            value: this.filtersEdge[int.parse(num) - 1]['oip'],
                            onChanged: (bool ? value) {
                              setState(() {
                                this.filtersEdge[int.parse(num) - 1]['oip'] = value;
                                getGraphs(num, t);
                              });
                            },
                          ),
                          SizedBox(width: 30),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                                children: < TextSpan > [
                                  TextSpan(text: t.others),
                                ],
                            )), //Text
                          SizedBox(width: 5), //SizedBox
                          Checkbox(
                            value: this.filtersEdge[int.parse(num) - 1]['normal'],
                            onChanged: (bool ? value) {
                              setState(() {
                                this.filtersEdge[int.parse(num) - 1]['normal'] = value;
                                getGraphs(num, t);
                              });
                            },
                          ),
                        ], ),
                        if (num == '4')
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                  children: < TextSpan > [
                                    TextSpan(text: t.believe1),
                                    TextSpan(text: t.believeNo1, style: const TextStyle(color: CustomTheme.graphOrange)),
                                  ],
                              )), //Text
                            SizedBox(width: 5), //SizedBox
                            Checkbox(
                              value: this.filtersEdge[int.parse(num) - 1]['believeNo'],
                              onChanged: (bool ? value) {
                                setState(() {
                                  this.filtersEdge[int.parse(num) - 1]['believeNo'] = value;
                                  getGraphs(num, t);
                                });
                              },
                            ),
                            SizedBox(width: 30),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                  children: < TextSpan > [
                                    TextSpan(text: t.oip1),
                                    TextSpan(text: t.oin1, style: const TextStyle(color: CustomTheme.graphViolet)),
                                    TextSpan(text: t.oin2),
                                  ],
                              )), //Text
                            SizedBox(width: 5), //SizedBox
                            Checkbox(
                              value: this.filtersEdge[int.parse(num) - 1]['oin'],
                              onChanged: (bool ? value) {
                                setState(() {
                                  this.filtersEdge[int.parse(num) - 1]['oin'] = value;
                                  getGraphs(num, t);
                                });
                              },
                            ),
                            SizedBox(width: 30),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                  children: < TextSpan > [
                                    TextSpan(text: t.others),
                                  ],
                              )), //Text
                            SizedBox(width: 5), //SizedBox
                            Checkbox(
                              value: this.filtersEdge[int.parse(num) - 1]['normal'],
                              onChanged: (bool ? value) {
                                setState(() {
                                  this.filtersEdge[int.parse(num) - 1]['normal'] = value;
                                  getGraphs(num, t);
                                });
                              },
                            ),
                          ], ),
                          SizedBox(height: 10),
                          SizedBox(width: 7*MediaQuery.of(context).size.width/8,child:MultiSelectDialogField(
                            searchable: true,
                            cancelText: Text(t.close, style: TextStyle(fontSize: 18),),
                            confirmText: Text(t.ok, style: TextStyle(fontSize: 18)),
                            items: this.alumnosSelect,
                            itemsTextStyle: TextStyle(fontSize: 18),
                            title: Text(t.students),
                            searchHintStyle: TextStyle(fontSize: 16),
                            searchHint: t.search,
                            dialogHeight: MediaQuery.of(context).size.height/2,
                            initialValue: this.selectedAlumnos[int.parse(num)-1],
                            selectedColor: CustomTheme.atopaBlue,
                            decoration: BoxDecoration(
                              color: CustomTheme.atopaBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              border: Border.all(
                                color: CustomTheme.atopaBlue,
                                width: 2,
                              ),
                            ),
                            buttonIcon: Icon(
                              Icons.person,
                              color: CustomTheme.atopaBlue,
                            ),
                            buttonText: Text(
                              t.change_students,
                              style: TextStyle(
                                color: CustomTheme.atopaBlueDark,
                                fontSize: 16,
                              ),
                            ),
                            onConfirm: (results) {
                              this.selectedAlumnos[int.parse(num)-1] = results as List<String>;
                              for(String a in this.nodesFilterValues[int.parse(num)-1].keys) {
                                this.nodesFilterValues[int.parse(num)-1][a] = false;
                              }
                              this.selectedAlumnos[int.parse(num)-1].forEach((element) { 
                                this.nodesFilterValues[int.parse(num)-1][element] = true;
                              });
                              setState(() {
                                getGraphs(num, t);
                              });
                            },
                          ),),
                          
                          SizedBox(height: 10),
                          SizedBox(
                            height: 500,
                            width: 3 * MediaQuery.of(context).size.width / 4,
                            child: _renderNetwork(int.parse(num))
                          ),
                          SizedBox(height: 10),
                ], ),
                if (this.preferencias!.ic == 1)
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child: Divider(
                      height: 30,
                      color: Colors.black
                    )),
                    Text(
                      t.group_var,
                      style: Theme.of(context).textTheme.headline5,
                    ), Expanded(child: Divider(
                      height: 30,
                      color: Colors.black
                    )),
                  ], ),
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
                        children: [Flexible(child:Text(
                          t.ic,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ))]), )),
                    DataColumn(label: Container(
                      width: 400,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Flexible(child:Text(
                          t.id,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ))]))),
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
                        children: [Flexible(child:Text(
                          t.iap,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ))]))),
                    DataColumn(label: Container(
                      width: 400,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Flexible(child:Text(
                          t.ian,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ))]))),
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
                          if (vari.key == "IC" || vari.key == "ID")
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
                                                      child: Text(areaIn.key.toString() + ": "),
                                                      style: TextButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                          textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                                      ),
                                                    )),
                                                  for (int m = 0; m < (ans.value as List).length; m++)
                                                    if (m >= 2)
                                                      if (ans.value[m] != '')
                                                        Flexible(child: Text(ans.value[m], style: TextStyle(fontSize: 16), )),
                                                ], ),

                                              ], )

                                      ], )
                              ], ),
                      ]),
                  ))]),

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


  Widget _renderNetwork(int num) {
    // if (networkContainer == null) {
    //   _registerContainer();
    //   _createNetwork();
    // }
    return HtmlElementView(viewType: 'network' + num.toString());
  }

  void _registerContainer(int num) {
    networkContainer.add(DivElement()..id = "network" + num.toString());
    ui.platformViewRegistry.registerViewFactory('network' + num.toString(), (int viewId) => networkContainer[num - 1]);
  }

  void _createNetwork(int num) {
    DataSet nodes = DataSet(
      jsify(_nodes[num - 1]),
    );

    DataSet edges = DataSet(
      jsify(_edges[num - 1]),
    );

    Map data = {
      'nodes': nodes,
      'edges': edges
    };
    if (num == 1)
      this.network1 = Network(networkContainer[num - 1], jsify(data), jsify(_options));
    if (num == 2)
      this.network2 = Network(networkContainer[num - 1], jsify(data), jsify(_options));
    if (num == 3)
      this.network3 = Network(networkContainer[num - 1], jsify(data), jsify(_options));
    if (num == 4)
      this.network4 = Network(networkContainer[num - 1], jsify(data), jsify(_options));
  }
}