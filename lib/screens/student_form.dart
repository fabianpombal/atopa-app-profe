import 'dart:convert';

import 'package:atopa_app_flutter/api/alumnoAPI.dart';
import 'package:atopa_app_flutter/api/models/alumno.dart';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/themes/input_decorations.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({
    Key ? key
  }): super(key: key);

  @override
  State < StudentFormScreen > createState() => _StudentFormState();
}

class _StudentFormState extends State < StudentFormScreen > {
  final _formKey = GlobalKey < FormState > ();
  Alumno ? alumno;
  Alumno ? copyAlumno;
  Year ? year;
  AlumnoAPI _alumnoAPI = AlumnoAPI();
  late bool _enableBtn = false;
  // late List < FocusNode > focusNodes = [];

  final List<GlobalKey<FormFieldState>> fieldKeys = [GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(),
  GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>()];
  List<bool>? validados;
  List<TextEditingController>? controllers;
  int? rol;
  int? evaluacion;

  @override
  void initState() {
    super.initState();
    // for (int i = 0; i < 5; i++) {
    //   FocusNode focusNode = new FocusNode();
    //   focusNode.addListener(() {
    //     if (!focusNode.hasFocus) {
    //       setState(() {
    //         _enableBtn = _formKey.currentState!.validate();
    //       });
    //     }
    //   });
    //   focusNodes.add(focusNode);
    // }


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
          if (args.containsKey('student')) {
            this.alumno = args['student'];
            this.copyAlumno = this.alumno?.copy();
            this._enableBtn = true;
            this.validados = [true, true, true, true, true, true];
          } else {
            this.alumno = new Alumno(nombre: '', apellidos: '', alias: null, DNI: null, fecha_nacimiento: '', sexo: null);
            this.validados = [false, false, true, true, false, false];
          }
          
        } else {
            this.alumno = new Alumno(nombre: '', apellidos: '', alias: null, DNI: null, fecha_nacimiento: '', sexo: null);
            this.validados = [false, false, true, true, false, false];
        }
        
        this.controllers = [TextEditingController(text: this.alumno!.nombre),TextEditingController(text: this.alumno!.apellidos),TextEditingController(text:this.alumno!.alias),
    TextEditingController(text:this.alumno!.DNI),TextEditingController(text:this.alumno!.fecha_nacimiento),];
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(height: 10, ),
            Row(children: [BreadCrumbNavigator()],
              mainAxisAlignment: MainAxisAlignment.start, ),
            SizedBox(height: 10, ),
            CardContainer(
              color: Colors.white38,
              width: 2 * MediaQuery.of(context).size.width / 3,
              child: Column(
                children: [
                  const SizedBox(
                      height: 10,
                    ),
                    Text(
                      alumno?.id != null ? t!.edit_student : t!.create_student,
                      style : Theme.of(context).textTheme.headline5,
                    ),
                    this.controllers != null ? Form(
                      key: _formKey,
                      // onChanged: () => setState(() => this._enableBtn = _formKey.currentState!.validate()),
                      child:
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              CustomInputField(
                                controller: this.controllers![0],
                                keyField: this.fieldKeys[0],
                                icono: Icons.person,
                                hintText : '',
                                labelText: t.name,
                                helperText: t.required,
                                // focusNode: this.focusNodes[0],
                                validation: (value) {
                                  if (value == null) return t.required;
                                  else if (value.length < 2) {
                                    return t.min_characters(2);
                                  } else {
                                    return null;
                                  }
                                },
                                callback: (name) {
                                  setState(() {
                                  this.alumno?.nombre = name;
                                  this.validados![0] = this.fieldKeys[0].currentState!.validate();
                                  int aux = this.validados!.where((element) => element == false).length;
                                  this._enableBtn = aux == 0;
                                  });

                                },
                              ),
                              const SizedBox(
                                  height: 20,
                                ),
                                CustomInputField(
                                  controller: this.controllers![1],
                                  keyField: this.fieldKeys[1],
                                  icono: Icons.person_outline,
                                  hintText : '',
                                  labelText: t.surnames,
                                  helperText: t.required,
                                  // focusNode: this.focusNodes[1],
                                  validation: (value) {
                                    if (value == null) return t.required;
                                    else if (value.length < 2) {
                                      return t.min_characters(2);
                                    } else {
                                      return null;
                                    }
                                  },
                                  callback: (apellidos) {
                                    setState(() {
                                      this.alumno?.apellidos = apellidos;
                                      this.validados![1] = this.fieldKeys[1].currentState!.validate();
                                      int aux = this.validados!.where((element) => element == false).length;
                                      this._enableBtn = aux == 0;
                                  
                                    });
                                    

                                  },
                                ),
                                const SizedBox(
                                    height: 20,
                                  ),
                                  CustomInputField(
                                    controller: this.controllers![2],
                                    keyField: this.fieldKeys[2],
                                    icono: Icons.person_pin,
                                    hintText : '',
                                    labelText: t.alias,
                                    helperText: '',
                                    // focusNode: this.focusNodes[2],
                                    validation: (value) {
                                      if (value == null) return null;
                                      else if (value.length < 2 && value.length > 0) {
                                        return t.min_characters(2);
                                      } else {
                                        return null;
                                      }
                                    },
                                    callback: (alias) {
                                      setState(() {
                                        this.alumno?.alias = alias;
                                        this.validados![2] = this.fieldKeys[2].currentState!.validate();
                                      int aux = this.validados!.where((element) => element == false).length;
                                      this._enableBtn = aux == 0;
                                      });
                                      

                                    },
                                  ),
                                  const SizedBox(
                                      height: 20,
                                    ),
                                    CustomInputField(
                                      controller: this.controllers![3],
                                      keyField: this.fieldKeys[3],
                                      icono: Icons.card_membership,
                                      hintText : '',
                                      labelText: t.dni,
                                      helperText: '',
                                      // focusNode: this.focusNodes[3],
                                      validation: (value) {
                                        if (value == null) return null;
                                        else if (value.length < 9 && value.length > 0) {
                                          return t.min_characters(9);
                                        } else {
                                          return null;
                                        }
                                      },
                                      callback: (dni) {
                                        setState(() {
                                          this.alumno?.DNI = dni;
                                          this.validados![3] = this.fieldKeys[3].currentState!.validate();
                                      int aux = this.validados!.where((element) => element == false).length;
                                      this._enableBtn = aux == 0;
                                        });
                                        

                                      },
                                    ),
                                    const SizedBox(
                                        height: 20,
                                      ),
                                      CustomInputField(
                                        controller: this.controllers![4],
                                        keyField: this.fieldKeys[4],
                                        icono: Icons.calendar_month,
                                        hintText : 'dd-mm-yyyy',
                                        labelText: t.date_birth,
                                        helperText: t.required,
                                        // focusNode: this.focusNodes[4],
                                        validation: (value) {
                                          final regex = RegExp(r'[0-9]{2}-[0-9]{2}-[0-9]{4}');
                                          if (value == null) return t.required;
                                          else if (!regex.hasMatch(value)) {
                                            return t.validDate;
                                          } else {
                                            DateFormat format = DateFormat('dd-MM-yyyy');
                                            try {
                                              String md = value;
                                              format.parseStrict(md);
                                            } catch (error) {
                                              return t.validDate;
                                            }
                                            return null;
                                          }
                                        },
                                        inputType: TextInputType.datetime,
                                        callback: (fecha) {
                                          setState(() {
                                            this.alumno?.fecha_nacimiento = fecha;
                                            this.validados![4] = this.fieldKeys[4].currentState!.validate();
                                      int aux = this.validados!.where((element) => element == false).length;
                                      this._enableBtn = aux == 0;
                                          });
                                          

                                        },
                                      ),
                                      const SizedBox(
                                          height: 20,
                                        ),
                                        DropdownButtonFormField < String > (
                                          key: this.fieldKeys[5],
                                          value: this.alumno != null ? this.alumno?.sexo : null,
                                          items : [
                                            DropdownMenuItem(
                                              child: Text(t.man, style: this.alumno?.sexo == 'H' ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 'H'),
                                            DropdownMenuItem(child: Text(t.woman, style: this.alumno?.sexo == 'M' ? TextStyle(color: CustomTheme.atopaBlue) : null), value: 'M'),
                                          ],
                                          validator: (value) => value == null ? t.required : null,
                                          onChanged: (value) async {
                                            setState(() {
                                              this.alumno?.sexo = value.toString();
                                              this.validados![5] = this.fieldKeys[5].currentState!.validate();
                                              int aux = this.validados!.where((element) => element == false).length;
                                              this._enableBtn = aux == 0;
                                            });

                                          },
                                          selectedItemBuilder: (BuildContext context) {
                                            return [
                                            DropdownMenuItem(
                                              child: Text(t.man), value: 'H'),
                                            DropdownMenuItem(child: Text(t.woman), value: 'M'),
                                          ];
                                          },
                                          decoration: InputDecorations.authInputDecoration(hint: '', label: t.sex, helperText: t.required, icono: Icons.account_box),
                                        ),
                                        const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [ElevatedButton(
                                              onPressed: () {
                                                if (this.alumno?.id == null) {
                                                  this.alumno = new Alumno(nombre: '', apellidos: '', alias: null, DNI: null, fecha_nacimiento: '', sexo: null);
                                                  this._enableBtn = false;
                                                  this.validados = [false, false, true, true, false, false];
                                                  for (int i = 0; i < this.controllers!.length; i++) {
                                                    this.controllers![i].clear();
                                                  }
                                                } else {
                                                  this.alumno = this.copyAlumno?.copy();
                                                  this._enableBtn = true;
                                                  this.validados = [true, true, true, true, true, true];
                                                  this.controllers![0].text = this.alumno!.nombre;
                                                  this.controllers![1].text = this.alumno!.apellidos;
                                                  this.controllers![2].text = this.alumno!.alias!;
                                                  this.controllers![3].text = this.alumno!.DNI!;
                                                  this.controllers![4].text = this.alumno!.fecha_nacimiento;
                                                
                                                }
                                                
                                                setState(() {
                                                  
                                                });
                                              },
                                              child: Text(t.clean),
                                                style: ElevatedButton.styleFrom(
                                                  primary: CustomTheme.atopaBlueDark,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  elevation: 15.0,
                                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                    textStyle:
                                                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                                ),
                                            ), ], ),
                                          const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: !this._enableBtn ? null : () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => Center(
                                                        child: CircularProgressIndicator(
                                                          color: CustomTheme.atopaBlue,
                                                        ),
                                                      ),
                                                      barrierDismissible: false);
                                                    if (this.alumno?.id != null) {
                                                      Map < String, Object ? > jsonOriginal = this.copyAlumno!.toJson();
                                                      Map < String, dynamic > body = {};
                                                      this.alumno?.toJson().forEach((key, value) {
                                                        if (jsonOriginal[key] != value) {
                                                          body[key] = value;
                                                        }
                                                      });
                                                      if (body.isNotEmpty) {
                                                        Response value = await _alumnoAPI.updateAlumno(body, this.alumno!.id!);
                                                        Navigator.pop(context);
                                                        if (value.statusCode == 200) {
                                                          Navigator.pop(context);
                                                        } else if (value.statusCode == 400) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              title: Text(t.errorStudentUp),
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

                                                      } else {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      }

                                                    } else {
                                                      Response value = await _alumnoAPI.newAlumno(this.alumno!);
                                                      Navigator.pop(context);
                                                        if (value.statusCode == 200) {
                                                          Navigator.pop(context);
                                                        } else if (value.statusCode == 400) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              title: Text(t.errorStudentCreate),
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
                                                      
                                                    }
                                                  },
                                                  child: Text(t.save),
                                                    style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      elevation: 15.0,
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                        textStyle:
                                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                                    ),
                                                ),
                                                const SizedBox(
                                                    width: 20,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(t.close),
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        elevation: 15.0,
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                          textStyle:
                                                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                                      ),
                                                  ),

                                              ], ),

                            ],
                          ),
                      ),

                    ) : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(
                        child: CircularProgressIndicator(),
                      )],
                    ),
                ],
              ),
            ),
            SizedBox(height: 40,),
          ])
        ),
      ),
      persistentFooterButtons: const [
        CustomFooterBar()
      ],
    );
  }
}