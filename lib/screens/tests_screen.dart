import 'dart:convert';
import 'package:atopa_app_flutter/api/models/clase.dart';
import 'package:atopa_app_flutter/api/models/pregunta.dart';
import 'package:atopa_app_flutter/api/testAPI.dart';
import 'package:atopa_app_flutter/api/models/test.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TestScreen extends StatefulWidget {
  const TestScreen({
    Key ? key
  }): super(key: key);

  @override
  State < TestScreen > createState() => _TestScreenState();
}

class _TestScreenState extends State < TestScreen > {
  Future < List < Test >> ? tests;
  TestAPI _testAPI = TestAPI();

  Year ? year;
  Clase ? clase;

  int ? lang;
  int? rol;
  int? evaluacion;
  
  LanguageProvider? provLang;
  var f;

  @override
  void initState() {
    super.initState();
    this.provLang = Provider.of < LanguageProvider > (context, listen: false);
    this.lang = this.provLang!.currentIndex;
    this.f = () { 
      this.lang = this.provLang!.currentIndex;
      if (mounted)
      setState(() {
      if (this.year != null && this.clase != null)
        this.tests = _testAPI.getTestsSearch({
          'Test.year': this.year?.id,
          'Test.clase': this.clase?.id,
          'idioma': this.lang
        });
      else if (this.year != null) {
        this.tests = _testAPI.getTestsSearch({
          'Test.year': this.year?.id,
          'idioma': this.lang
        });
      } else if (this.clase != null) {
        this.tests = _testAPI.getTestsSearch({
          'Test.clase': this.clase?.id,
          'idioma': this.lang
        });
      } else
        this.tests = _testAPI.getTests(this.lang!);
    });};
    this.provLang!.addListener(this.f);
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      setState(() {
        Map < String, dynamic > ? args = ModalRoute.of(context) !.settings.arguments as Map < String, dynamic > ? ;
        if (args != null) {
          if (args.containsKey('year')) {
            this.year = args['year'];
          }
          if (args.containsKey('clase')) {
            this.clase = args['clase'];
          }
        }
        if (this.year != null && this.clase != null)
          this.tests = _testAPI.getTestsSearch({
            'Test.year': this.year?.id,
            'Test.clase': this.clase?.id,
            'idioma': this.lang
          });
        else if (this.year != null) {
          this.tests = _testAPI.getTestsSearch({
            'Test.year': this.year?.id,
            'idioma': this.lang
          });
        } else if (this.clase != null) {
          this.tests = _testAPI.getTestsSearch({
            'Test.clase': this.clase?.id,
            'idioma': this.lang
          });
        } else
          this.tests = _testAPI.getTests(this.lang!);
      });
    });

  }

  @override
  void dispose() {
    this.provLang!.removeListener(this.f);
    super.dispose();
  }

  void _confirm(BuildContext context, Test test, int type) {
    var t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(t!.confirm),
            content: Text((type == 0 ? t.confirmTest_delete : type == 1 ? t.confirmTest_open : 
            type == 2 ? t.confirmTest_close : t.confirmTest_follow) + 
            test.nombre + '?' + (type == 0 && test.first == null ? t.confirmTest_delete2 : type == 1 ? t.confirmTest_open2 : 
            type == 2 ? t.confirmTest_close2: '')),
            actions: [
              // The "Yes" button
              TextButton(
                onPressed: () async {
                  // Remove the box
                  http.Response value; 
                  switch (type) {
                    case 0:
                      value = await _testAPI.deleteTest(test);
                      break;
                    case 1:
                      value = await _testAPI.openTest(test);
                      break;
                    case 2:
                      value = await _testAPI.closeTest(test);
                      break;
                    case 3:
                      value = await _testAPI.followUp(test);
                      break;
                    default:
                      value = await _testAPI.deleteTest(test);
                      break;
                  }
                  
                    if (value.statusCode == 200) {
                      setState(() {
                        if (this.year != null && this.clase != null)
                          this.tests = _testAPI.getTestsSearch({
                            'Test.year': this.year?.id,
                            'Test.clase': this.clase?.id,
                            'idioma': this.lang
                          });
                        else if (this.year != null) {
                          this.tests = _testAPI.getTestsSearch({
                            'Test.year': this.year?.id,
                            'idioma': this.lang
                          });
                        } else if (this.clase != null) {
                          this.tests = _testAPI.getTestsSearch({
                            'Test.clase': this.clase?.id,
                            'idioma': this.lang
                          });
                        } else
                          this.tests = _testAPI.getTests(this.lang!);
                        Navigator.of(context).pop();
                      });

                    } else {
                      showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(t.errorTitle),
                        content: Text(json.decode(value.body)['message']),
                        actions: <Widget>[
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
                  
                  // Close the dialog
                },
                child: Text(t.yes)),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: Text(t.no))
            ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
      body:
      FutureBuilder < List < Test >> (future: tests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            if (snapshot.hasData) {
              List < Test > data = snapshot.data!;
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
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Tooltip(
                            message: this.year!.current == 0 ? t!.not_active : '',
                            textStyle: TextStyle(fontSize: 12, color: Colors.white), 
                            child: ElevatedButton.icon(
                            onPressed: this.year!.current == 0 ? null : () {
                              this.provLang!.removeListener(this.f);
                              Navigator.pushNamed(context, 'new-test',
                                arguments: {
                                  'year': year,
                                  'class': clase,
                                  'menu': t!.new_test
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
                              t!.new_test,
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
                        SizedBox(width: 15,),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Tooltip(
                            message: '',
                            textStyle: TextStyle(fontSize: 12, color: Colors.white), 
                            child: ElevatedButton.icon(
                            onPressed: () {
                              this.provLang!.removeListener(this.f);
                              Navigator.pushNamed(context, 'preguntas',
                                arguments: {
                                  'menu': t.questions
                                }).then((value) {
                                  this.provLang!.addListener(this.f);
                                  this.f();
                              });
                            },
                            icon: Icon(
                              Icons.format_list_numbered,
                              color: Colors.white,
                              size: 30,
                            ),
                            label: Text(
                              t.questions,
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
                          )),
                        ),
                      ],
                    ),
                    SizedBox(height: 10, ),
                    data.isEmpty ?
                    Center(child: Column(children: [
                      SizedBox(height: 25,),
                      Container(
                        width: 2*MediaQuery.of(context).size.width/3,
                            decoration: BoxDecoration(
                              color: CustomTheme.atopaGrey,
                              border: Border.all(color: CustomTheme.atopaGreyDark, width: 2),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(t.noTests, style: TextStyle(fontSize: 20))]),),
                      ],)):
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
                                    item.nombre,
                                    style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  Row(children: [
                                    if (this.evaluacion == 1 && ((item.first == null && item.survey1 == 0) || item.first != null && item.survey2 == 0))
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : item.first == null ? t.survey1 : t.survey2,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.rate_review, size: 25, )]),
                                        onPressed: this.year!.current == 0 ? null : () {
                                          this.provLang!.removeListener(this.f);
                                          if (item.first == null) {
                                            Navigator.pushNamed(context, 'survey2',
                                              arguments: {
                                                'test': item,
                                                'menu': t.survey1 + " " + item.nombre
                                              }).then((value) {
                                                this.provLang!.addListener(this.f);
                                                this.f();
                                            });
                                          } else {
                                            Navigator.pushNamed(context, 'survey3',
                                              arguments: {
                                                'test': item,
                                                'menu': t.survey2 + " " + item.nombre
                                              }).then((value) {
                                                this.provLang!.addListener(this.f);
                                                this.f();
                                            });
                                          }
                                          
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 15.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                            primary: CustomTheme.graphOrange
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : item.uploaded == 0 && item.closed == 0 ? t.open_test : item.closed == 1 ? t.open_test2 : t.open_test3,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.open_in_browser, size: 25, )]),
                                        onPressed: item.uploaded == 1 || item.closed == 1 || this.year!.current == 0 ? null : () => _confirm(context, item, 1),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 15.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                            primary: CustomTheme.atopaBlueDark
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: (item.uploaded == 1 && item.closed == 0) ? t.close_test : (item.uploaded == 0 && item.closed == 0) ? t.close_test2 : t.close_test3,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.close, size: 25, )]),
                                        onPressed: (item.uploaded == 0 || item.closed == 1) ? null : () => _confirm(context, item, 2),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 15.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                            primary: CustomTheme.atopaBlueDark
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: item.uploaded == 1 ? t.down_codes : t.close_test2,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.download, size: 25, )]),
                                        onPressed: item.uploaded == 0 ? null : () async {
                                          // int lang = this.provLang!.currentIndex;
                                          showDialog(
                                            context: context,
                                            builder: (context) => Center(
                                              child: CircularProgressIndicator(
                                                color: CustomTheme.atopaBlue,
                                              ),
                                            ),
                                            barrierDismissible: false);
                                          Response res = await _testAPI.downloadCodes(item, this.lang!);
                                          Navigator.pop(context);
                                          if (res.statusCode == 200) {
                                            js.context.callMethod("webSaveAs", [html.Blob([res.data]), item.nombre + "-codes.pdf"]);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(t.errorCodes),
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
                                    
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: item.uploaded == 1 ? t.down_all : t.close_test2,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.file_copy, size: 25, )]),
                                        onPressed: item.uploaded == 0 ? null : () async {
                                          // int lang = Provider.of < LanguageProvider > (context, listen: false).currentIndex;
                                          showDialog(
                                            context: context,
                                            builder: (context) => Center(
                                              child: CircularProgressIndicator(
                                                color: CustomTheme.atopaBlue,
                                              ),
                                            ),
                                            barrierDismissible: false);
                                          Response res = await _testAPI.downloadAllPdf(item, this.lang!);
                                          Navigator.pop(context);
                                          if (res.statusCode == 200) {
                                            js.context.callMethod("webSaveAs", [html.Blob([res.data]), item.nombre + "-Informe_Alumnos.pdf"]);
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
                                            primary: CustomTheme.atopaPink
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
                                    
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: item.uploaded == 1 ? t.down_class : t.close_test2,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.insert_drive_file, size: 25, )]),
                                        onPressed: item.uploaded == 0 ? null : () async {
                                          // int lang = Provider.of < LanguageProvider > (context, listen: false).currentIndex;
                                          showDialog(
                                            context: context,
                                            builder: (context) => Center(
                                              child: CircularProgressIndicator(
                                                color: CustomTheme.atopaBlue,
                                              ),
                                            ),
                                            barrierDismissible: false);
                                          Response res = await _testAPI.downloadTestPdf(item, this.lang!);
                                          Navigator.pop(context);
                                          if (res.statusCode == 200) {
                                            js.context.callMethod("webSaveAs", [html.Blob([res.data]), item.nombre + "-Informe_Clase.pdf"]);
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
                                            primary: CustomTheme.atopaGreenLight
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
                                    
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: item.uploaded == 1 ? t.view_res : t.close_test2,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.preview, size: 25, )]),
                                        onPressed: item.uploaded == 0 ? null : () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Center(
                                              child: CircularProgressIndicator(
                                                color: CustomTheme.atopaBlue,
                                              ),
                                            ),
                                            barrierDismissible: false);
                                          http.Response res = await _testAPI.checkAnswers(item);
                                          Navigator.pop(context);
                                          if (res.statusCode == 200) {
                                            this.provLang!.removeListener(this.f);
                                            Navigator.pushNamed(context, 'results-graph',
                                            arguments: {
                                              'year': this.year,
                                              'test': item,
                                              'menu': t.results + ' ' + item.nombre
                                            }).then((value) {
                                              this.f();
                                              this.provLang!.addListener(this.f);
                                            }
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(t.errorResults),
                                                  content: Text(json.decode(res.body)['message']),
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
                                            primary: CustomTheme.atopaGreenDark
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : (item.closed == 1 && item.followUp ==0) ? t.create_follow : item.closed == 0 ? t.close_follow : t.create_follow2,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.question_answer, size: 25, )]),
                                        onPressed: !(item.closed == 1 && item.followUp ==0) || this.year!.current == 0 ? null : () => _confirm(context, item, 3),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 15.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                            primary: CustomTheme.atopaYellow
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : item.uploaded == 0 ? t.edit_test : t.edit_open,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.edit, size: 25, )]),
                                        onPressed: item.uploaded == 1 || this.year!.current == 0 ? null : () {
                                          this.provLang!.removeListener(this.f);
                                          Navigator.pushNamed(context, 'new-test',
                                            arguments: {
                                              'test': item,
                                              'year': this.year,
                                              'menu': t.edit_test
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
                                      )),
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : (item.fin == 0 && (item.uploaded == 0 || item.closed == 1)) ? t.delete_test: item.closed == 0 && item.uploaded == 1 ? t.delete_open: t.delete_follow,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.delete, size: 25, )]),
                                        onPressed: !(item.fin == 0 && (item.uploaded == 0 || item.closed == 1)) || this.year!.current == 0 ? null :() => _confirm(context, item, 0),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 15.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                            primary: Colors.red
                                          // textStyle:
                                          //     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                      )),
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
                                // width: (2 * MediaQuery.of(context).size.width) / 3,
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                child:
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
                                      crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                      children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                            children: < TextSpan > [
                                              TextSpan(text: t.class_name + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: item.clase_nombre!),
                                            ],
                                        )),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                            children: < TextSpan > [
                                              TextSpan(text: t.structure + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: item.estructura_nombre!),
                                            ],
                                        )),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                            children: < TextSpan > [
                                              TextSpan(text: t.age_group + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: item.grupo_edad_nombre!),
                                            ],
                                        )),
                                    ]),
                                    Divider(
                                      height: 30,
                                      color: Colors.black
                                    ),
                                    Column(children: [
                                      for (int i = 0; i < item.preguntas!.length; i++) Column(
                                        children: [
                                          Row(children: [
                                            Flexible(child:RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                            children: < TextSpan > [
                                              TextSpan(text: t.question + ' ' + (i + 1).toString() + " (" + (i == 0 ? 'PGP' : i == 1 ? 'PGN' : i == 2 ? 'PPP' : i == 3 ? 'PPN' : i == 4 ? 'AAP' : 'AAN') + ")" + ": ", style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: item.preguntas![i] is Pregunta ? item.preguntas![i].pregunta: ''),
                                            ],
                                        )))]),
                                        SizedBox(height: 8,) 
                                        ], ),
                                    ], ),
                                  ]),

                              )
                            ])),
                          isExpanded: item.isExpanded!,
                        ),
                      )
                      .toList(),
                    ),
                    SizedBox(height: 40, ),
                  ],
                ),
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