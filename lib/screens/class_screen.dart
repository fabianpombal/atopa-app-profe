import 'package:atopa_app_flutter/api/alumnoAPI.dart';
import 'package:atopa_app_flutter/api/claseAPI.dart';
import 'package:atopa_app_flutter/api/models/alumno.dart';
import 'package:atopa_app_flutter/api/models/clase.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ClassScreen extends StatefulWidget {
  const ClassScreen({
    Key ? key
  }): super(key: key);

  @override
  State < ClassScreen > createState() => _ClassScreenState();
}

class _ClassScreenState extends State < ClassScreen > {
  Future < List < Clase >>? clases;
  ClaseAPI _claseAPI = ClaseAPI();
  AlumnoAPI _alumnoAPI = AlumnoAPI();
  Year ? year;
  int? rol;
  int? evaluacion;

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
          this.clases = _claseAPI.getClasesSearch({
            'Clase.year': this.year?.id,
            'test': false
          });
        else
          this.clases = _claseAPI.getClases();
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  void _delete(BuildContext context, Clase clase) {
    var t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(t!.confirm),
            content: Text(t.confirm_class + clase.nombre + t.confirm_class2),
            actions: [
              // The "Yes" button
              TextButton(
                onPressed: () async {
                  // Remove the box
                  Response value = await _claseAPI.deleteClase(clase);
                    if (value.statusCode == 200) {
                      setState(() {
                        if (this.year != null)
                          this.clases = _claseAPI.getClasesSearch({
                            'Clase.year': this.year?.id,
                            'test': false
                          });
                        else
                          this.clases = _claseAPI.getClases();
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

  void _deleteFromClass(BuildContext context, Alumno alumno, Clase clase) {
    var t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(t!.confirm),
            content: Text(t.confirm_student + alumno.nombre + t.confirm_student3 + clase.nombre + '?'),
            actions: [
              // The "Yes" button
              TextButton(
                onPressed: () async {
                  // Remove the box
                  Response value = await _claseAPI.updateClase({
                    'alumnos': clase.alumnos!.where((element) => element.id != alumno.id).toList()
                  }, clase.id!);
                    if (value.statusCode == 200) {
                      setState(() {
                        if (this.year != null)
                          this.clases = _claseAPI.getClasesSearch({
                            'Clase.year': this.year?.id,
                            'test': false
                          });
                        else
                          this.clases = _claseAPI.getClases();
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
      FutureBuilder < List < Clase >> (future: clases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            if (snapshot.hasData) {
              List < Clase > data = snapshot.data!;
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
                            child: ElevatedButton.icon(
                            onPressed: this.year!.current == 0 ? null : () async {
                              Navigator.pushNamed(context, 'new-class',
                                arguments: {
                                  'year': year,
                                  'menu': t!.new_class,
                                  'import': true
                                }).then((value) {
                                setState(() {
                                  if (this.year != null)
                                    this.clases = _claseAPI.getClasesSearch({
                                      'Clase.year': this.year?.id,
                                      'test': false
                                    });
                                  else
                                    this.clases = _claseAPI.getClases();
                                });
                              });
                            },
                            icon: Icon(
                              Icons.file_present_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            label: Text(
                              t!.import_class,
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
                            child: ElevatedButton.icon(
                            onPressed: this.year!.current == 0 ? null : () {
                              Navigator.pushNamed(context, 'new-class',
                                arguments: {
                                  'year': year,
                                  'menu': t.new_class,
                                  'import': false
                                }).then((value) {
                                setState(() {
                                  if (this.year != null)
                                    this.clases = _claseAPI.getClasesSearch({
                                      'Clase.year': this.year?.id,
                                      'test': false
                                    });
                                  else
                                    this.clases = _claseAPI.getClases();
                                });
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                            label: Text(
                              t.new_class,
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
                        // const _CustomIconButton(icono: Icons.edit),
                        // const _CustomIconButton(
                        //   icono: Icons.remove_circle_sharp,
                        // ),
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
                          children: [Text(t.noClasses, style: TextStyle(fontSize: 20))]),),
                      ],)) :
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
                                    Tooltip(
                                      message: t.tests,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.edit_note, size: 25, )]),
                                        onPressed: () {
                                          Navigator.pushNamed(context, 'tests', arguments: {
                                            'year': year,
                                            'clase': item,
                                            'menu': t.tests
                                          }).then((value) {
                                            setState(() {
                                              if (this.year != null)
                                                this.clases = _claseAPI.getClasesSearch({
                                                  'Clase.year': this.year?.id,
                                                  'test': false
                                                });
                                              else
                                                this.clases = _claseAPI.getClases();
                                            });
                                          });
                                        },
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
                                      ),
                                    ),
                                    SizedBox(width: 10, ),
                                    Tooltip(
                                      message: this.year!.current == 0 ? t.not_active : item.modify == 1 ? t.edit_class : t.noEditClass,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.edit, size: 25, )]),
                                        onPressed: item.modify == 0 || this.year!.current == 0 ? null : () {
                                          Navigator.pushNamed(context, 'new-class',
                                            arguments: {
                                              'class': item,
                                              'year': year,
                                              'menu': t.edit_class,
                                              'import': false
                                            }).then((value) {
                                            setState(() {
                                              if (this.year != null)
                                                this.clases = _claseAPI.getClasesSearch({
                                                  'Clase.year': this.year?.id,
                                                  'test': false
                                                });
                                              else
                                                this.clases = _claseAPI.getClases();
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
                                      message: this.year!.current == 0 ? t.not_active : t.delete_class,
                                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                      child:
                                      ElevatedButton(
                                        child: Row(children: [Icon(Icons.delete, size: 25, )]),
                                        onPressed: this.year!.current == 0 ? null : () => _delete(context, item),
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
                                      ), ),
                                  ], )
                                ]
                              ))])
                            );
                          },
                          body: Container(
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: CustomTheme.atopaGreyDark, width: 2),
                                bottom: BorderSide(color: CustomTheme.atopaGreyDark, width: 1))
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: item.alumnos!.isEmpty ?
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
                                children: [Text(t.no_students, style: TextStyle(fontSize: 20))]),),
                            ],)) :
                            ExpansionPanelList(
                              elevation: 3,
                              // Controlling the expansion behavior
                              expansionCallback: (index, isExpanded) {
                                setState(() {
                                  item.alumnos![index].isExpanded = !isExpanded;
                                });
                              },
                              animationDuration: Duration(milliseconds: 600),
                              children: item.alumnos!
                              .map(
                                (itemAl) => ExpansionPanel(
                                  canTapOnHeader: true,
                                  backgroundColor:
                                  itemAl.isExpanded == true ? CustomTheme.atopaGrey : Colors.white,
                                  headerBuilder: (context, isExpanded) {
                                    return Container(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                      child: Column(children: [Center(child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //Center Row contents horizontally,
                                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                        children: [
                                          Text(
                                            itemAl.nombre + " " + itemAl.apellidos,
                                            style: const TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          Row(children: [
                                            Tooltip(
                                              message: t.edit_student,
                                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                              child:
                                              ElevatedButton(
                                                child: Row(children: [Icon(Icons.edit, size: 25, )]),
                                                onPressed: () {
                                                  Navigator.pushNamed(context, 'new-student',
                                                    arguments: {
                                                      'student': itemAl,
                                                      'year': year,
                                                      'menu': t.new_student
                                                    }).then((value) {
                                                    setState(() {
                                                      if (this.year != null)
                                                        this.clases = _claseAPI.getClasesSearch({
                                                          'Clase.year': this.year?.id,
                                                          'test': false
                                                        });
                                                      else
                                                        this.clases = _claseAPI.getClases();
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
                                              message: item.modify == 1 ? t.delete_studentClass : t.noEditClass,
                                              textStyle: TextStyle(fontSize: 12, color: Colors.white),
                                              child:
                                              ElevatedButton(
                                                child: Row(children: [Icon(Icons.delete, size: 25, )]),
                                                onPressed: item.modify == 0 ? null : () => _deleteFromClass(context, itemAl, item),
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
                                              ), ),
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
                                                        TextSpan(text: t.alias + ': ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                        TextSpan(text: itemAl.alias),
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
                                                        TextSpan(text: itemAl.sexo == 'H' ? t.man : t.woman),
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
                                                      TextSpan(text: itemAl.DNI),
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
                                                      TextSpan(text: itemAl.fecha_nacimiento),
                                                    ],
                                                )),
                                            ], crossAxisAlignment: CrossAxisAlignment.start, ),
                                          ]),
                                      )
                                    ])
                                  ),
                                  isExpanded: itemAl.isExpanded!,
                                ),
                              )
                              .toList(),
                            ), ),
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