import 'dart:convert';
import 'dart:typed_data';
import 'package:atopa_app_flutter/api/alumnoAPI.dart';
import 'package:atopa_app_flutter/api/models/alumno.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
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

import 'package:shared_preferences/shared_preferences.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({
    Key ? key
  }): super(key: key);

  @override
  State < StudentScreen > createState() => _StudentScreenState();
}

class _StudentScreenState extends State < StudentScreen > {
  Future < List < Alumno >> ? alumnos;
  // late List<Alumno> alumnosObj;
  AlumnoAPI _alumnoAPI = AlumnoAPI();

  Year ? year;

  List < int > ? _selectedFile;
  Uint8List ? _bytesData;

  int? rol;
  int? evaluacion;

  bool activo = true;

  @override
  void initState() {
    super.initState();
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
        }
        if (this.year != null)
          this.alumnos = _alumnoAPI.getAlumnosSearch({
            'year': this.year?.id,
            'activo': this.activo ? 1 : 0
          });
        else
          this.alumnos = _alumnoAPI.getAlumnos();
      });
      // refreshAlumnos();
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  void _delete(BuildContext context, Alumno alumno) {
    var t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(t!.confirm),
            content: Text((this.activo ? t.confirm_student_act : t.confirm_student_act2) + alumno.nombre + " " + alumno.apellidos + (this.activo ? t.confirm_student2_act : t.confirm_student2_act2)),
            actions: [
              // The "Yes" button
              TextButton(
                onPressed: () async {
                  // Remove the box
                  Response value = await _alumnoAPI.updateAlumno({'activo': this.activo ? 0 : 1}, alumno.id!);

                  if (value.statusCode == 200) {
                    setState(() {
                      if (this.year != null)
                        this.alumnos = _alumnoAPI.getAlumnosSearch({
                          'year': this.year?.id,
                          'activo': this.activo ? 1 : 0
                        });
                      else
                        this.alumnos = _alumnoAPI.getAlumnos();
                      Navigator.of(context).pop();
                    });
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
      FutureBuilder < List < Alumno >> (future: alumnos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            
            if (snapshot.hasData) {
              List < Alumno > data = snapshot.data!;
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
                          textDirection: TextDirection.rtl,
                          child: Tooltip(
                            message: this.year!.current == 0 ? t!.not_active : '',
                            textStyle: TextStyle(fontSize: 12, color: Colors.white), 
                            child:ElevatedButton.icon(
                            onPressed: this.year!.current == 0 ? null : () async {
                              await startWebFilePicker(t);
                            },
                            icon: Icon(
                              Icons.file_present_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            label: Text(
                              t!.import,
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
                        SizedBox(width: 15, ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Tooltip(
                            message: this.year!.current == 0 ? t.not_active : '',
                            textStyle: TextStyle(fontSize: 12, color: Colors.white), 
                            child:ElevatedButton.icon(
                            onPressed: this.year!.current == 0 ? null : () {
                              Navigator.pushNamed(context, 'new-student',
                                arguments: {
                                  'year': year,
                                  'menu': t.new_student
                                }).then((value) {
                                setState(() {
                                  if (this.year != null)
                                    this.alumnos = _alumnoAPI.getAlumnosSearch({
                                      'year': this.year?.id,
                                      'activo': this.activo ? 1 : 0
                                    });
                                  else
                                    this.alumnos = _alumnoAPI.getAlumnos();
                                });
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                            label: Text(
                              t.new_student,
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
                        SizedBox(width: 15, ),
                        Switch(
                              value: this.activo,
                              onChanged: (bool ? value) {
                                setState(() {
                                  this.activo = value!;
                                  if (this.year != null)
                                    this.alumnos = _alumnoAPI.getAlumnosSearch({
                                      'year': this.year?.id,
                                      'activo': this.activo ? 1 : 0
                                    });
                                  else
                                    this.alumnos = _alumnoAPI.getAlumnos();
                                });
                              },
                            ),
                        SizedBox(width: 5, ),
                        Text(t.activo, style:TextStyle(fontSize: 18))
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
                          children: [Text(t.no_students, style: TextStyle(fontSize: 20))]), ),
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
                                    item.nombre + " " + item.apellidos,
                                    style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  Row(children: [
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : t.edit_student,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child: ElevatedButton(
                                        child: Row(children: [Icon(Icons.edit, size: 25, )]),
                                        onPressed: this.year!.current == 0 ? null : () {
                                          Navigator.pushNamed(context, 'new-student',
                                            arguments: {
                                              'student': item,
                                              'year': year,
                                              'menu': t.edit_student
                                            }).then((value) {
                                            setState(() {
                                              if (this.year != null)
                                                this.alumnos = _alumnoAPI.getAlumnosSearch({
                                                  'year': this.year?.id,
                                                  'activo': this.activo ? 1 : 0
                                                });
                                              else
                                                this.alumnos = _alumnoAPI.getAlumnos();
                                            });
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
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : this.activo ? t.delete_student_act : t.delete_student_act2,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(this.activo ? Icons.delete : Icons.delete_forever, size: 25, )]),
                                        onPressed: this.year!.current == 0 ? null : () => _delete(context, item),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          elevation: 15.0,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                            primary: this.activo ? Colors.red : CustomTheme.atopaGreenDark
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
                                                TextSpan(text: t.class_name + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: item.clase_nombre ?? t.none),
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
                                                TextSpan(text: t.alias + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: item.alias),
                                              ],
                                          )),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                              children: < TextSpan > [
                                                TextSpan(text: t.sex + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                TextSpan(text: item.sexo == 'H' ? t.man : t.woman),
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
                                              TextSpan(text: t.dni + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: item.DNI),
                                            ],
                                        )),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                            children: < TextSpan > [
                                              TextSpan(text: t.date_birth + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: item.fecha_nacimiento),
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
  startWebFilePicker(var t) async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = ".xlsx,.xls";
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.length == 1) {
        final file = files[0];
        final reader = new html.FileReader();
        reader.onLoadEnd.listen((e) {
          _handleResult(reader.result!, t);
        });
        reader.readAsDataUrl(file);
      }
    });
  }

  void _handleResult(Object result, var t) async {
    _bytesData = Base64Decoder().convert(result.toString().split(",").last);
    _selectedFile = _bytesData;

    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: CustomTheme.atopaBlue,
        ),
      ),
      barrierDismissible: false);
    StreamedResponse res = await _alumnoAPI.uploadExcel(this._selectedFile!, 0);
    Navigator.pop(context);
    if (res.statusCode == 200) {
      setState(() {
        if (this.year != null)
          this.alumnos = _alumnoAPI.getAlumnosSearch({
            'year': this.year?.id,
            'activo': this.activo ? 1 : 0
          });
        else
          this.alumnos = _alumnoAPI.getAlumnos();
      });
    } else {
      Response response = await http.Response.fromStream(res);
      String msg = json.decode(response.body)['message'];
      var blob = html.Blob([msg], 'text/plain', 'native');
      js.context.callMethod("webSaveAs", [blob, "alumnos-no-importados.txt"]);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(t.errorUp),
            content: Text(msg),
            actions: < Widget > [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                    child: Text(t!.ok),
                ),
              ),
            ],
        ),
      );
      setState(() {
        if (this.year != null)
          this.alumnos = _alumnoAPI.getAlumnosSearch({
            'year': this.year?.id,
            'activo': this.activo ? 1 : 0
          });
        else
          this.alumnos = _alumnoAPI.getAlumnos();
      });
    }
  }
}