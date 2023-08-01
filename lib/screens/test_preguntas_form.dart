import 'dart:convert';

import 'package:atopa_app_flutter/api/models/pregunta.dart';
import 'package:atopa_app_flutter/api/preguntaAPI.dart';
import 'package:atopa_app_flutter/api/testAPI.dart';
import 'package:atopa_app_flutter/api/models/test.dart';
import 'package:atopa_app_flutter/breadcrumb_navigator.dart';
import 'package:atopa_app_flutter/providers/language_provider.dart';
import 'package:atopa_app_flutter/themes/custom_theme.dart';
import 'package:atopa_app_flutter/themes/input_decorations.dart';
import 'package:atopa_app_flutter/widgets/custom_app_bar.dart';
import 'package:atopa_app_flutter/widgets/custom_footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TestPreguntasFormScreen extends StatefulWidget {
  const TestPreguntasFormScreen({
    Key ? key
  }): super(key: key);

  @override
  State < TestPreguntasFormScreen > createState() => _TestPreguntasFormState();
}

class _TestPreguntasFormState extends State < TestPreguntasFormScreen > {
  final _formKey = GlobalKey < FormState > ();
  Test ? test;
  Test ? copyTest;
  int ? lang;
  List < dynamic > ? oldPreguntas;
  TestAPI _testAPI = TestAPI();
  PreguntaAPI _preguntaAPI = PreguntaAPI();
  late bool _enableBtn = false;

  final List<GlobalKey<FormFieldState>> fieldKeys = [GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>(),
  GlobalKey<FormFieldState>(), GlobalKey<FormFieldState>()];
  List<bool>? validados;

  int? rol;
  int? evaluacion;

  Map<String, List<Pregunta>>? preguntas;

  LanguageProvider? provLang;
  var f;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.rol = await prefs.getInt('rol') ?? 2;
      this.evaluacion = await prefs.getInt('evaluacion') ?? 0;
      this.provLang = Provider.of < LanguageProvider > (context, listen: false);
      this.lang = this.provLang!.currentIndex;
      this.f = () async { 
        this.lang = this.provLang!.currentIndex;
        if (mounted) {
          this.preguntas = null;
          if (this.test?.preguntas is List<Pregunta>) {
            List<dynamic>? aux = this.test?.preguntas; 
              this.test?.preguntas = [];
              aux?.forEach((element) {
                  if (element is Pregunta) {
                    this.test?.preguntas?.add(element.id);
                  } else {
                    this.test?.preguntas?.add(element);
                  }
              });
              this.copyTest = this.test?.copy();
              this.oldPreguntas = this.test?.preguntas?.map((i)=>i).toList();
          }
          await getPreguntasDrop();
          setState(() {
            });
        }
        
      };
      this.provLang!.addListener(this.f);
      Map < String, dynamic > ? args = ModalRoute.of(context) !.settings.arguments as Map < String, dynamic > ? ;
      if (args != null) {
        if (args.containsKey('test')) {
          this.test = args['test'];
          if (this.test?.id != null) {
            List<dynamic>? aux = this.test?.preguntas; 
            this.test?.preguntas = [];
            aux?.forEach((element) {
                if (element is Pregunta) {
                  this.test?.preguntas?.add(element.id);
                } else {
                  this.test?.preguntas?.add(element);
                }
            });
            this.copyTest = this.test?.copy();
            this.oldPreguntas = this.test?.preguntas?.map((i)=>i).toList();
            this._enableBtn = true;
            this.validados = [true, true, true, true, true, true];
          } else {
            this.validados = [false, false, false, false, false, false];
          }
        } else {
            this.validados = [false, false, false, false, false, false];
          }
      } else {
        this.validados = [false, false, false, false, false, false];
      }
      this.preguntas = null;
      await getPreguntasDrop();
      setState(() {});
    });

  }

  Future getPreguntasDrop() async {
    this.preguntas = await _preguntaAPI.getPreguntasTestSearch({
      'tipo_estructura': this.test?.estructura,
      'grupo_edad': this.test?.grupo_edad,
      'idioma': this.lang
    });
  }

  @override
  void dispose() {
    this.provLang!.removeListener(this.f);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(rol: this.rol, evaluacion: this.evaluacion,),
      body: (this.preguntas != null) ? SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(height: 10, ),
            Row(children: [BreadCrumbNavigator()],
              mainAxisAlignment: MainAxisAlignment.start, ),
            SizedBox(height: 10, ),
            CardContainer(
              color: Colors.white38,
              width: 3 * MediaQuery.of(context).size.width / 4,
              child: Column(
                children: [
                  const SizedBox(
                      height: 10,
                    ),
                    Text(
                      this.test?.id != null ? t!.edit_questions : t!.add_questions,
                      style : Theme.of(context).textTheme.headline5,
                    ),
                    if (this.preguntas!.containsKey('preguntas1') && this.preguntas!.containsKey('preguntas2') && this.preguntas!.containsKey('preguntas3') && this.preguntas!.containsKey('preguntas4') && this.preguntas!.containsKey('preguntas5') && this.preguntas!.containsKey('preguntas6')) Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              DropdownButtonFormField(
                                key: this.fieldKeys[0],
                                isExpanded: true,
                                value: this.test != null ? this.test?.preguntas![0] : null,
                                items : this.preguntas!['preguntas1']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta, style: this.test?.preguntas![0] == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id,);
                                      }).toList(),
                                validator : (value) => value == null ? t.required : null,
                                onChanged: (value) {
                                  setState(() {
                                    this.test?.preguntas![0] = value as int;
                                    this.validados![0] = this.fieldKeys[0].currentState!.validate();
                                    print(this.validados);
                                    int aux = this.validados!.where((element) => element == false).length;
                                    this._enableBtn = aux == 0;
                                  });
                                },
                                selectedItemBuilder: (BuildContext context) {
                                        return this.preguntas!['preguntas1']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta), value: e.id,);
                                      }).toList();
                                      },
                                decoration: InputDecorations.authInputDecoration(hint: '', label: t.question1, helperText: t.required,icono: Icons.looks_one),

                              ),
                              const SizedBox(
                                  height: 20,
                                ),
                                DropdownButtonFormField(
                                  key: this.fieldKeys[1],
                                  isExpanded: true,
                                  value: this.test != null ? this.test?.preguntas![1] : null,
                                  items : this.preguntas!['preguntas2']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta, style: this.test?.preguntas![1] == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id,);
                                      }).toList(),
                                  validator : (value) => value == null ? t.required : null,
                                  onChanged: (value) {
                                    setState(() {
                                      this.test?.preguntas![1] = value as int;
                                      this.validados![1] = this.fieldKeys[1].currentState!.validate();
                                      print(this.validados);
                                      int aux = this.validados!.where((element) => element == false).length;
                                      this._enableBtn = aux == 0;
                                    });
                                  },
                                  selectedItemBuilder: (BuildContext context) {
                                        return this.preguntas!['preguntas2']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta), value: e.id,);
                                      }).toList();
                                      },
                                  decoration: InputDecorations.authInputDecoration(hint: '', label: t.question2, helperText: t.required, icono: Icons.looks_two),

                                ),
                                const SizedBox(
                                    height: 20,
                                  ),
                                  DropdownButtonFormField(
                                    key: this.fieldKeys[2],
                                    isExpanded: true,
                                    value: this.test != null ? this.test?.preguntas![2] : null,
                                    items : this.preguntas!['preguntas3']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta, style: this.test?.preguntas![2] == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id,);
                                      }).toList(),
                                    validator : (value) => value == null ? t.required : null,
                                    onChanged: (value) {
                                      setState(() {
                                        this.test?.preguntas![2] = value as int;
                                        this.validados![2] = this.fieldKeys[2].currentState!.validate();
                                        print(this.validados);
                                        int aux = this.validados!.where((element) => element == false).length;
                                        this._enableBtn = aux == 0;
                                      });
                                    },
                                    selectedItemBuilder: (BuildContext context) {
                                        return this.preguntas!['preguntas3']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta), value: e.id,);
                                      }).toList();
                                      },
                                    decoration: InputDecorations.authInputDecoration(hint: '', label: t.question3, helperText: t.required, icono: Icons.looks_3),

                                  ),
                                  const SizedBox(
                                      height: 20,
                                    ),
                                    DropdownButtonFormField(
                                      key: this.fieldKeys[3],
                                      isExpanded: true,
                                      value: this.test != null ? this.test?.preguntas![3] : null,
                                      items : this.preguntas!['preguntas4']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta, style: this.test?.preguntas![3] == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id,);
                                      }).toList(),
                                      validator : (value) => value == null ? t.required : null,
                                      onChanged: (value) {
                                        setState(() {
                                          this.test?.preguntas![3] = value as int;
                                          this.validados![3] = this.fieldKeys[3].currentState!.validate();
                                          print(this.validados);
                                          int aux = this.validados!.where((element) => element == false).length;
                                          this._enableBtn = aux == 0;
                                        });
                                      },
                                      selectedItemBuilder: (BuildContext context) {
                                        return this.preguntas!['preguntas4']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta), value: e.id,);
                                      }).toList();
                                      },
                                      decoration: InputDecorations.authInputDecoration(hint: '', label: t.question4, helperText: t.required, icono: Icons.looks_4),
                                    ),
                                    const SizedBox(
                                        height: 20,
                                      ),
                                      DropdownButtonFormField(
                                        key: this.fieldKeys[4],
                                        isExpanded: true,
                                        value: this.test != null ? this.test?.preguntas![4] : null,
                                        items : this.preguntas!['preguntas5']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta, style: this.test?.preguntas![4] == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id,);
                                      }).toList(),
                                        validator : (value) => value == null ? t.required : null,
                                        onChanged: (value) {
                                          setState(() {
                                            this.test?.preguntas![4] = value as int;
                                            this.validados![4] = this.fieldKeys[4].currentState!.validate();
                                            print(this.validados);
                                            int aux = this.validados!.where((element) => element == false).length;
                                            this._enableBtn = aux == 0;
                                          });
                                        },
                                        selectedItemBuilder: (BuildContext context) {
                                        return this.preguntas!['preguntas5']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta), value: e.id,);
                                      }).toList();
                                      },
                                        decoration: InputDecorations.authInputDecoration(hint: '', label: t.question5, helperText: t.required, icono: Icons.looks_5),
                                      ),
                                      
                                      const SizedBox(
                                          height: 20,
                                        ),
                                        DropdownButtonFormField(
                                          key: this.fieldKeys[5],
                                          isExpanded: true,
                                          value: this.test != null ? this.test?.preguntas![5] : null,
                                          items : this.preguntas!['preguntas6']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta, style: this.test?.preguntas![5] == e.id ? TextStyle(color: CustomTheme.atopaBlue) : null), value: e.id,);
                                      }).toList(),
                                          validator : (value) => value == null ? t.required : null,
                                          onChanged: (value) {
                                            setState(() {
                                              this.test?.preguntas![5] = value as int;
                                              this.validados![5] = this.fieldKeys[5].currentState!.validate();
                                              print(this.validados);
                                              int aux = this.validados!.where((element) => element == false).length;
                                              this._enableBtn = aux == 0;
                                            });
                                          },
                                          selectedItemBuilder: (BuildContext context) {
                                        return this.preguntas!['preguntas6']!.map((e) {
                                        return DropdownMenuItem<int>(child: Text(e.pregunta), value: e.id,);
                                      }).toList();
                                      },
                                          decoration: InputDecorations.authInputDecoration(hint: '', label: t.question6, helperText: t.required, icono: Icons.looks_6),
                                        ),
                                        const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [ElevatedButton(
                                          onPressed: () {
                                            if (this.test?.id == null) {
                                              this.test?.preguntas = [null, null, null, null, null, null];
                                              this._enableBtn = false;
                                              this.validados = [false, false, false, false, false, false];
                                            } else {
                                              this.test!.preguntas = this.oldPreguntas!.map((e) => e).toList();
                                              this._enableBtn = true;
                                              this.validados = [true, true, true, true, true, true];
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
                                            height: 30,
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
                                                  if (this.test?.id != null) {
                                                    Map < String, Object ? > jsonOriginal = this.copyTest!.toJson();
                                                    Map < String, dynamic > body = {};
                                                    this.test?.toJson().forEach((key, value) {
                                                      if (key != 'preguntas') {
                                                        if (jsonOriginal[key] != value) {
                                                            body[key] = value;
                                                        }
                                                      }
                                                        
                                                      else {
                                                          for (int i = 0; i < this.oldPreguntas!.length; i++) {
                                                            if (this.oldPreguntas?[i] != (value as List)[i]) {
                                                              body[key] = value;
                                                              break;
                                                            }
                                                          }
                                                        }
                                                      
                                                    });
                                                    if (body.isNotEmpty) {
                                                      Response value = await _testAPI.updateTest(body, this.test!.id!);
                                                        Navigator.pop(context);
                                                        if (value.statusCode == 200) {
                                                          this.provLang!.removeListener(this.f);
                                                          Navigator.pop(context);
                                                        } else if (value.statusCode == 400) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              title: Text(t.errorTestUp),
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
                                                      this.provLang!.removeListener(this.f);
                                                      Navigator.pop(context);
                                                    }

                                                  } else {
                                                    Response value = await _testAPI.newTest(this.test!);
                                                    Navigator.pop(context);
                                                      if (value.statusCode == 200) {
                                                        this.test!.id = int.parse(json.decode(value.body)['id']);
                                                        this.provLang!.removeListener(this.f);
                                                        Navigator.pop(context);
                                                      } else if (value.statusCode == 400) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (ctx) => AlertDialog(
                                                            title: Text(t.errorTestCreate),
                                                              content: Text(json.decode(value.body)['message']),
                                                              actions: < Widget > [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(ctx).pop();
                                                                  },
                                                                  child: Container(
                                                                    color: CustomTheme.atopaBlue,
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
                                                    if (this.test?.id != null) {
                                                      print(this.oldPreguntas);
                                                      this.test!.preguntas = this.oldPreguntas!.map((e) => e).toList();
                                                    }
                                                    this.provLang!.removeListener(this.f);
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

                    ),
                ])
            ),
            SizedBox(height: 40, ),
          ])
        )) : Column(
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
}